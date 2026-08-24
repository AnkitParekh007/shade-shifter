import 'dart:async';
import 'dart:math';

import '../../core/ble/device_transport.dart';
import '../../core/ble/protocol.dart';
import '../../core/errors/app_error.dart';
import '../../core/logging/app_logger.dart';
import '../../core/result/result.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/device_state.dart';

/// A complete virtual Shade Shifter frame implementing [DeviceTransport].
///
/// It models realistic connect/disconnect, per-command latency + acknowledgement,
/// slow battery drain, temperature drift and (optional) fault injection, so the
/// entire app — and the automated test suite — runs with no hardware. It is
/// always surfaced in the UI as a clearly-labelled simulated device.
class SimulatorTransport implements DeviceTransport {
  SimulatorTransport({
    Random? random,
    this.commandLatency = const Duration(milliseconds: 220),
    this.connectLatency = const Duration(milliseconds: 900),
    bool telemetryTicking = true,
  })  : _random = random ?? Random(),
        _telemetryTicking = telemetryTicking;

  static const _log = AppLogger('SimulatorTransport');

  final Random _random;
  final Duration commandLatency;
  final Duration connectLatency;
  final bool _telemetryTicking;

  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _telemetryController = StreamController<DeviceTelemetry>.broadcast();
  final _ackController = StreamController<CommandAck>.broadcast();

  ConnectionStatus _status = ConnectionStatus.disconnected;
  DeviceCapabilities? _capabilities;
  DeviceTelemetry _telemetry = const DeviceTelemetry();
  Timer? _telemetryTimer;
  int _sequence = 0;
  bool _disposed = false;

  // ---- Fault injection hooks (used by tests / a hidden dev menu) ----
  /// When set, the next [send] resolves with this status instead of ok.
  AckStatus? injectNextAckStatus;

  /// When true, the next [send] never acknowledges (exercises timeout/retry).
  bool dropNextAck = false;

  /// When true, the next [connect] fails with a timeout.
  bool failNextConnect = false;

  /// Simulated device shown in scan results.
  static const DeviceRef device = DeviceRef(
    id: 'simulator-0001',
    name: 'ShadeShifter Simulator',
    isSimulator: true,
    rssi: -48,
  );

  @override
  Stream<ConnectionStatus> get connectionStatus => _statusController.stream;
  @override
  Stream<DeviceTelemetry> get telemetry => _telemetryController.stream;
  @override
  Stream<CommandAck> get acks => _ackController.stream;
  @override
  ConnectionStatus get currentStatus => _status;
  @override
  DeviceCapabilities? get capabilities => _capabilities;

  void _setStatus(ConnectionStatus s) {
    _status = s;
    if (!_disposed) _statusController.add(s);
  }

  @override
  Future<Result<List<DeviceRef>>> scan({Duration timeout = const Duration(seconds: 4)}) async {
    _setStatus(ConnectionStatus.scanning);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _setStatus(ConnectionStatus.disconnected);
    return const Result.ok([device]);
  }

  @override
  Future<void> stopScan() async {
    if (_status == ConnectionStatus.scanning) {
      _setStatus(ConnectionStatus.disconnected);
    }
  }

  @override
  Future<Result<DeviceCapabilities>> connect(DeviceRef device) async {
    _setStatus(ConnectionStatus.connecting);
    await Future<void>.delayed(connectLatency);

    if (failNextConnect) {
      failNextConnect = false;
      _setStatus(ConnectionStatus.error);
      return const Result.err(
        AppError(AppErrorKind.connectionTimeout, code: 'SIM_CONNECT_TIMEOUT'),
      );
    }

    _setStatus(ConnectionStatus.negotiating);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    _capabilities = DeviceCapabilities.revA;
    _telemetry = DeviceTelemetry(
      batteryPercent: 87,
      charging: false,
      temperatureCelsius: 31,
      rssi: -48,
      firmwareVersion: '0.9.0-poc',
      lastSyncAt: DateTime.now(),
    );
    _setStatus(ConnectionStatus.connected);
    _telemetryController.add(_telemetry);
    _startTelemetry();
    _log.info('Simulator connected', data: _capabilities!.hardwareRevision);
    return Result.ok(_capabilities!);
  }

  @override
  Future<Result<DeviceCapabilities>> reconnect(DeviceRef device) =>
      connect(device);

  @override
  Future<void> disconnect() async {
    _telemetryTimer?.cancel();
    if (_status != ConnectionStatus.disconnected) {
      _setStatus(ConnectionStatus.disconnected);
    }
  }

  @override
  Future<Result<CommandAck>> send(DeviceCommand command) async {
    if (_status != ConnectionStatus.connected) {
      return const Result.err(
        AppError(AppErrorKind.unexpectedDisconnect, code: 'SIM_NOT_CONNECTED'),
      );
    }
    final commandId = ++_sequence & 0xFFFF;

    // Simulate transmission + processing latency with mild jitter.
    final jitter = _random.nextInt(120);
    await Future<void>.delayed(commandLatency + Duration(milliseconds: jitter));

    if (dropNextAck) {
      dropNextAck = false;
      _log.warning('Simulator dropped ack for command $commandId');
      return const Result.err(
        AppError(AppErrorKind.commandTimeout, code: 'SIM_DROPPED_ACK'),
      );
    }

    final status = injectNextAckStatus ?? AckStatus.ok;
    injectNextAckStatus = null;

    // Illumination-off nudges temperature down; effects nudge it up a touch.
    if (command is IlluminationOffCommand) {
      _telemetry = _telemetry.copyWith(
        temperatureCelsius: (_telemetry.temperatureCelsius ?? 30) - 1,
        lastSyncAt: DateTime.now(),
      );
      _telemetryController.add(_telemetry);
    }

    final ack = CommandAck(
      commandId: commandId,
      type: command.type,
      status: status,
      telemetry: _telemetry.copyWith(lastSyncAt: DateTime.now()),
    );
    if (!_disposed) _ackController.add(ack);

    if (!status.isOk) {
      final kind = switch (status) {
        AckStatus.rejectedUnsafe => AppErrorKind.commandRejected,
        AckStatus.rejectedUnsupported => AppErrorKind.unsupportedFirmware,
        AckStatus.malformed => AppErrorKind.malformedPayload,
        AckStatus.busy => AppErrorKind.deviceBusyElsewhere,
        AckStatus.protocolMismatch => AppErrorKind.protocolMismatch,
        AckStatus.ok => AppErrorKind.unknown,
      };
      return Result.err(AppError(kind, code: 'SIM_ACK_${status.name}'));
    }
    return Result.ok(ack);
  }

  void _startTelemetry() {
    if (!_telemetryTicking) return;
    _telemetryTimer?.cancel();
    _telemetryTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_status != ConnectionStatus.connected) return;
      final battery = _telemetry.batteryPercent ?? 87;
      final charging = _telemetry.charging;
      final nextBattery = charging
          ? min(100, battery + 1)
          : max(0, battery - (_random.nextInt(2)));
      final temp = (_telemetry.temperatureCelsius ?? 31) +
          (_random.nextDouble() - 0.45);
      _telemetry = _telemetry.copyWith(
        batteryPercent: nextBattery,
        temperatureCelsius: double.parse(temp.clamp(24, 60).toStringAsFixed(1)),
        rssi: -45 - _random.nextInt(20),
        lastSyncAt: DateTime.now(),
      );
      if (!_disposed) _telemetryController.add(_telemetry);
    });
  }

  /// Test/dev helper: force a battery level and emit telemetry.
  void debugSetBattery(int percent, {bool charging = false}) {
    _telemetry = _telemetry.copyWith(batteryPercent: percent, charging: charging);
    _telemetryController.add(_telemetry);
  }

  /// Test/dev helper: trip the thermal alarm.
  void debugTripThermalAlarm() {
    _telemetry = _telemetry.copyWith(
      temperatureCelsius: (_capabilities ?? DeviceCapabilities.revA)
          .thermalShutdownCelsius,
      thermalAlarm: true,
    );
    _telemetryController.add(_telemetry);
  }

  /// Test/dev helper: simulate an unexpected disconnect.
  void debugDropConnection() {
    _telemetryTimer?.cancel();
    _setStatus(ConnectionStatus.error);
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      if (!_disposed) _setStatus(ConnectionStatus.disconnected);
    });
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _telemetryTimer?.cancel();
    await _statusController.close();
    await _telemetryController.close();
    await _ackController.close();
  }
}

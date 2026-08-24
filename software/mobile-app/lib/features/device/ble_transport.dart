import 'dart:async';

import '../../core/ble/ble_ids.dart';
import '../../core/ble/device_transport.dart';
import '../../core/ble/protocol.dart';
import '../../core/errors/app_error.dart';
import '../../core/logging/app_logger.dart';
import '../../core/result/result.dart';
import '../../shared/models/appearance.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/device_state.dart';
import '../../shared/models/rgb_color.dart';
import '../../shared/models/zone.dart';
import 'ble_backend.dart';

/// [DeviceTransport] for a **physical Rev-A frame**, speaking the contract the
/// bench firmware actually implements (`shade_shifter_bench.ino`): a single
/// service with one whole-frame color characteristic that accepts exactly three
/// bytes R,G,B. See documentation/mobile-app/BLE-PROTOCOL.md ("Rev-A legacy").
///
/// What that hardware does NOT have, and how this class stays honest about it:
///  - **No capability characteristic** → [DeviceCapabilities.revALegacy] is
///    applied statically; nothing is negotiated.
///  - **No ack characteristic** → a write-with-response (ATT-level confirmation
///    from the peripheral) is treated as [AckStatus.ok]. Safety-critical writes
///    are additionally read back and compared, which is meaningful because the
///    firmware stores the written value and serves it on READ.
///  - **No telemetry characteristic** → battery/temperature stay `null` so the
///    UI renders "Not supported" rather than inventing numbers. Link-layer RSSI
///    is real and is polled.
///  - **No brightness command** → brightness is fixed firmware-side at 32/255.
///    See [_scaled] for the one lever the app actually has.
///
/// All BLE package calls go through [BleBackend]; this class is pure Dart and
/// is covered by `test/ble_transport_test.dart` with no radio present.
class BleTransport implements DeviceTransport {
  BleTransport(
    this.backend, {
    this.rssiInterval = const Duration(seconds: 10),
    this.connectTimeout = const Duration(seconds: 12),
    this.writeTimeout = const Duration(seconds: 2),
  });

  static const _log = AppLogger('BleTransport');

  /// Firmware ignores any payload that is not exactly this many bytes.
  static const int kColorPayloadBytes = 3;

  final BleBackend backend;
  final Duration rssiInterval;
  final Duration connectTimeout;
  final Duration writeTimeout;

  final _statusController = StreamController<ConnectionStatus>.broadcast();
  final _telemetryController = StreamController<DeviceTelemetry>.broadcast();
  final _ackController = StreamController<CommandAck>.broadcast();

  ConnectionStatus _status = ConnectionStatus.disconnected;
  DeviceCapabilities? _capabilities;
  DeviceTelemetry _telemetry = const DeviceTelemetry();
  StreamSubscription<bool>? _connectionSub;
  Timer? _rssiTimer;
  int _commandId = 0;
  bool _disposed = false;

  /// Last color written, so a brightness-only change can be re-expressed as a
  /// new RGB write (the frame has no separate brightness command).
  RgbColor _lastColor = RgbColor.black;

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
    if (_disposed || _status == s) return;
    _status = s;
    _statusController.add(s);
  }

  void _emitTelemetry(DeviceTelemetry t) {
    _telemetry = t;
    if (!_disposed) _telemetryController.add(t);
  }

  // ---------------------------------------------------------------- scanning

  @override
  Future<Result<List<DeviceRef>>> scan({
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final ready = await backend.ensureReady();
    if (ready.isErr) return Result.err(ready.errorOrNull!);

    _setStatus(ConnectionStatus.scanning);
    final result = await backend.scan(
      serviceUuids: const [BleIds.serviceRevA],
      namePrefix: BleIds.deviceNamePrefix,
      timeout: timeout,
    );
    if (_status == ConnectionStatus.scanning) {
      _setStatus(ConnectionStatus.disconnected);
    }
    return result.fold(
      (devices) {
        if (devices.isEmpty) {
          return const Result.err(
            AppError(AppErrorKind.noDevicesFound, code: 'BLE_NO_DEVICES'),
          );
        }
        _log.info('Scan found ${devices.length} frame(s)');
        return Result.ok(devices);
      },
      (error) => Result<List<DeviceRef>>.err(error),
    );
  }

  @override
  Future<void> stopScan() async {
    await backend.stopScan();
    if (_status == ConnectionStatus.scanning) {
      _setStatus(ConnectionStatus.disconnected);
    }
  }

  // -------------------------------------------------------------- connecting

  @override
  Future<Result<DeviceCapabilities>> connect(DeviceRef device) =>
      _open(device, ConnectionStatus.connecting);

  @override
  Future<Result<DeviceCapabilities>> reconnect(DeviceRef device) =>
      _open(device, ConnectionStatus.reconnecting);

  Future<Result<DeviceCapabilities>> _open(
    DeviceRef device,
    ConnectionStatus initial,
  ) async {
    if (device.isSimulator) {
      return const Result.err(
        AppError(
          AppErrorKind.unknown,
          code: 'BLE_SIMULATOR_REF',
          message: 'BleTransport cannot connect to a simulator device.',
        ),
      );
    }

    final ready = await backend.ensureReady();
    if (ready.isErr) {
      _setStatus(ConnectionStatus.error);
      return Result.err(ready.errorOrNull!);
    }

    _setStatus(initial);
    final connected =
        await backend.connect(device.id, timeout: connectTimeout);
    if (connected.isErr) {
      _setStatus(ConnectionStatus.error);
      return Result.err(connected.errorOrNull!);
    }

    // There is nothing to negotiate — but we still verify the peripheral really
    // exposes the Rev-A profile before claiming a usable session.
    _setStatus(ConnectionStatus.negotiating);
    final discovered = await backend.discover(
      service: BleIds.serviceRevA,
      characteristics: const [BleIds.charRevAColor],
    );
    if (discovered.isErr) {
      await backend.disconnect();
      _setStatus(ConnectionStatus.error);
      return Result.err(discovered.errorOrNull!);
    }

    _capabilities = DeviceCapabilities.revALegacy;
    _listenForDisconnects();

    // Seed the cached color from the frame's current value so a later
    // brightness-only change has a real base to scale.
    final current = await backend.read(
      service: BleIds.serviceRevA,
      characteristic: BleIds.charRevAColor,
    );
    final bytes = current.valueOrNull;
    if (bytes != null && bytes.length == kColorPayloadBytes) {
      _lastColor = RgbColor(bytes[0], bytes[1], bytes[2]);
    }

    _setStatus(ConnectionStatus.connected);
    _emitTelemetry(
      DeviceTelemetry(
        rssi: device.rssi,
        lastSyncAt: DateTime.now(),
        // battery / temperature / firmwareVersion intentionally null: Rev-A
        // exposes no characteristic for them.
      ),
    );
    _startRssiPolling();
    _log.info(
      'Connected to Rev-A frame',
      data: AppLogger.redactId(device.id),
    );
    return Result.ok(_capabilities!);
  }

  void _listenForDisconnects() {
    _connectionSub?.cancel();
    _connectionSub = backend.connectionEvents.listen((isConnected) {
      if (isConnected || _disposed) return;
      _rssiTimer?.cancel();
      if (_status == ConnectionStatus.connected) {
        _log.warning('Unexpected disconnect from Rev-A frame');
        _setStatus(ConnectionStatus.error);
      }
      _setStatus(ConnectionStatus.disconnected);
    });
  }

  void _startRssiPolling() {
    _rssiTimer?.cancel();
    if (rssiInterval <= Duration.zero) return;
    _rssiTimer = Timer.periodic(rssiInterval, (_) async {
      if (_status != ConnectionStatus.connected || _disposed) return;
      final rssi = await backend.readRssi();
      if (rssi == null) return;
      _emitTelemetry(_telemetry.copyWith(rssi: rssi, lastSyncAt: DateTime.now()));
    });
  }

  @override
  Future<void> disconnect() async {
    _rssiTimer?.cancel();
    await _connectionSub?.cancel();
    _connectionSub = null;
    await backend.disconnect();
    _capabilities = null;
    _setStatus(ConnectionStatus.disconnected);
  }

  // ----------------------------------------------------------------- sending

  @override
  Future<Result<CommandAck>> send(DeviceCommand command) async {
    if (_status != ConnectionStatus.connected) {
      return const Result.err(
        AppError(AppErrorKind.unexpectedDisconnect, code: 'BLE_NOT_CONNECTED'),
      );
    }
    final commandId = _commandId = (_commandId + 1) & 0xFFFF;

    switch (command) {
      // Rev-A has no negotiation surface; these are answered by the app itself
      // and generate no BLE traffic.
      case HandshakeCommand():
      case ReadCapabilitiesCommand():
      case ReadCurrentStateCommand():
        return _ack(commandId, command.type, AckStatus.ok);

      // Liveness: a READ that round-trips proves the link is alive.
      case PingCommand():
        final read = await backend.read(
          service: BleIds.serviceRevA,
          characteristic: BleIds.charRevAColor,
        );
        return read.isOk
            ? _ack(commandId, command.type, AckStatus.ok)
            : Result<CommandAck>.err(read.errorOrNull!);

      // Whole-frame off. Safety-critical, so it is verified by read-back.
      case IlluminationOffCommand():
        return _writeColor(
          commandId,
          command.type,
          RgbColor.black,
          verify: true,
        );

      case SetZoneSolidColorCommand(:final zone, :final color, :final intensity):
        if (!_supports(zone)) {
          return _reject(commandId, command.type, 'zone_${zone.name}');
        }
        return _writeColor(
          commandId,
          command.type,
          _scaled(color, intensity),
          base: color,
        );

      // The frame cannot render a gradient. The SafetyGovernor already warns
      // the user that it "renders gradients as a solid blend", so honour that
      // contract by blending rather than rejecting a command the UI allowed.
      case SetZoneGradientCommand(
          :final zone,
          :final start,
          :final end,
          :final intensity
        ):
        if (!_supports(zone)) {
          return _reject(commandId, command.type, 'zone_${zone.name}');
        }
        final blended = _blend(start, end);
        return _writeColor(
          commandId,
          command.type,
          _scaled(blended, intensity),
          base: blended,
        );

      // No brightness command exists — re-express it as an RGB write of the
      // last color at the new level.
      case SetZoneIntensityCommand(:final zone, :final intensity):
        if (!_supports(zone)) {
          return _reject(commandId, command.type, 'zone_${zone.name}');
        }
        return _writeColor(
          commandId,
          command.type,
          _scaled(_lastColor, intensity),
          base: _lastColor,
        );

      // Static is the frame's only mode, so selecting it is a no-op success;
      // anything animated is genuinely unsupported.
      case SetEffectCommand(:final effect):
        return effect == EffectType.static
            ? _ack(commandId, command.type, AckStatus.ok)
            : _reject(commandId, command.type, 'effect_${effect.name}');

      case ApplyLookCommand(:final appearance):
        final zone = appearance.zone(ZoneId.front);
        final color = zone.mode == AppearanceMode.gradient
            ? _blend(zone.gradientStart, zone.gradientEnd)
            : zone.solidColor;
        return _writeColor(
          commandId,
          command.type,
          _scaled(color, zone.intensity),
          base: color,
        );

      case RenameDeviceCommand():
        return _reject(commandId, command.type, 'rename');
    }
  }

  bool _supports(ZoneId zone) =>
      (_capabilities ?? DeviceCapabilities.revALegacy).supportsZone(zone);

  /// Writes the mandatory 3-byte R,G,B payload.
  ///
  /// [base] is the un-scaled color to remember for a later brightness-only
  /// change; when omitted the written color is remembered as-is.
  Future<Result<CommandAck>> _writeColor(
    int commandId,
    CommandType type,
    RgbColor color, {
    RgbColor? base,
    bool verify = false,
  }) async {
    final payload = [color.r, color.g, color.b];
    assert(payload.length == kColorPayloadBytes, 'Rev-A payload must be 3 bytes');

    final write = await backend
        .write(
          service: BleIds.serviceRevA,
          characteristic: BleIds.charRevAColor,
          value: payload,
        )
        .timeout(
          writeTimeout,
          onTimeout: () => const Result<void>.err(
            AppError(AppErrorKind.commandTimeout, code: 'BLE_WRITE_TIMEOUT'),
          ),
        );
    if (write.isErr) return Result.err(write.errorOrNull!);

    if (verify) {
      final read = await backend.read(
        service: BleIds.serviceRevA,
        characteristic: BleIds.charRevAColor,
      );
      final echoed = read.valueOrNull;
      final matches = echoed != null &&
          echoed.length == kColorPayloadBytes &&
          echoed[0] == payload[0] &&
          echoed[1] == payload[1] &&
          echoed[2] == payload[2];
      if (!matches) {
        _log.warning('Rev-A write not confirmed by read-back');
        return const Result.err(
          AppError(
            AppErrorKind.commandRejected,
            code: 'BLE_WRITE_UNCONFIRMED',
            message: 'Frame did not echo the written color.',
          ),
        );
      }
    }

    _lastColor = base ?? color;
    return _ack(commandId, type, AckStatus.ok);
  }

  Result<CommandAck> _ack(int commandId, CommandType type, AckStatus status) {
    final ack = CommandAck(
      commandId: commandId,
      type: type,
      status: status,
      telemetry: _telemetry.copyWith(lastSyncAt: DateTime.now()),
    );
    if (!_disposed) _ackController.add(ack);
    return Result.ok(ack);
  }

  /// The frame cannot do this. Emitted as an ack *and* an error so the studio's
  /// apply-state machine lands on "rejected" rather than "timed out".
  Result<CommandAck> _reject(int commandId, CommandType type, String detail) {
    _ack(commandId, type, AckStatus.rejectedUnsupported);
    return Result.err(
      AppError(
        AppErrorKind.unsupportedFirmware,
        code: 'BLE_UNSUPPORTED',
        message: detail,
      ),
    );
  }

  /// Rev-A fixes global brightness in firmware at 32/255 and takes no intensity
  /// byte, so scaling the RGB channels is the *only* way the app can dim the
  /// frame. [intensity] is expressed as a fraction of the firmware ceiling, so
  /// a request at the ceiling writes full-scale channels (still rendered at the
  /// firmware's 12.5%) and a request of zero writes black.
  ///
  /// This deliberately differs from packet-v1, where intensity is a separate
  /// byte and must never be premultiplied — see BLE-PROTOCOL.md.
  RgbColor _scaled(RgbColor color, double intensity) {
    final ceiling = (_capabilities ?? DeviceCapabilities.revALegacy).maxIntensity;
    if (ceiling <= 0) return RgbColor.black;
    final scale = (intensity / ceiling).clamp(0.0, 1.0);
    int channel(int v) => (v * scale).round().clamp(0, 255);
    return RgbColor(channel(color.r), channel(color.g), channel(color.b));
  }

  /// Midpoint of a gradient — the closest a single-color frame can get.
  RgbColor _blend(RgbColor start, RgbColor end) => RgbColor(
        (start.r + end.r) ~/ 2,
        (start.g + end.g) ~/ 2,
        (start.b + end.b) ~/ 2,
      );

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _rssiTimer?.cancel();
    await _connectionSub?.cancel();
    await backend.dispose();
    await _statusController.close();
    await _telemetryController.close();
    await _ackController.close();
  }
}

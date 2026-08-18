import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_transport.dart';
import '../../core/ble/protocol.dart';
import '../../core/di/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/logging/app_logger.dart';
import '../../core/result/result.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/device_state.dart';
import 'transport_factory.dart';

/// Immutable session state exposed to the UI. Never references the BLE package.
class DeviceSession {
  const DeviceSession({
    this.status = ConnectionStatus.disconnected,
    this.device,
    this.capabilities,
    this.telemetry = const DeviceTelemetry(),
    this.lastError,
  });

  final ConnectionStatus status;
  final DeviceRef? device;
  final DeviceCapabilities? capabilities;
  final DeviceTelemetry telemetry;
  final AppError? lastError;

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isSimulator => device?.isSimulator ?? false;

  DeviceSession copyWith({
    ConnectionStatus? status,
    DeviceRef? device,
    DeviceCapabilities? capabilities,
    DeviceTelemetry? telemetry,
    AppError? lastError,
    bool clearError = false,
  }) =>
      DeviceSession(
        status: status ?? this.status,
        device: device ?? this.device,
        capabilities: capabilities ?? this.capabilities,
        telemetry: telemetry ?? this.telemetry,
        lastError: clearError ? null : (lastError ?? this.lastError),
      );
}

/// Owns the active transport's lifecycle and the command send pipeline
/// (timeout + bounded retry). This is the app's sole entry point for talking to
/// a frame; UI and other controllers depend on this, not on any transport.
class DeviceController extends Notifier<DeviceSession> {
  static const _log = AppLogger('DeviceController');
  static const _commandTimeout = Duration(seconds: 3);
  static const _maxRetries = 2;

  DeviceTransport? _transport;
  StreamSubscription<ConnectionStatus>? _statusSub;
  StreamSubscription<DeviceTelemetry>? _telemetrySub;

  @override
  DeviceSession build() {
    ref.onDispose(_teardown);
    return const DeviceSession();
  }

  Future<void> _teardown() async {
    await _statusSub?.cancel();
    await _telemetrySub?.cancel();
    await _transport?.dispose();
    _transport = null;
  }

  void _bind(DeviceTransport transport) {
    _statusSub = transport.connectionStatus.listen((status) {
      state = state.copyWith(status: status);
      if (status == ConnectionStatus.error) {
        state = state.copyWith(
          lastError: const AppError(AppErrorKind.unexpectedDisconnect),
        );
      }
    });
    _telemetrySub = transport.telemetry.listen((t) {
      state = state.copyWith(telemetry: t);
    });
  }

  /// Connects to the simulator via the "Try Simulator" flow.
  Future<Result<DeviceCapabilities>> connectSimulator() =>
      connect(SimulatorReference.device);

  /// Connects to any device, replacing any existing session.
  Future<Result<DeviceCapabilities>> connect(DeviceRef device) async {
    await _teardown();
    state = DeviceSession(status: ConnectionStatus.connecting, device: device);

    final transport = ref.read(transportFactoryProvider).createFor(device);
    _transport = transport;
    _bind(transport);

    final result = await transport.connect(device);
    return result.fold(
      (caps) async {
        state = state.copyWith(
          status: ConnectionStatus.connected,
          capabilities: caps,
          telemetry: transport.capabilities == null
              ? state.telemetry
              : state.telemetry,
          clearError: true,
        );
        await ref
            .read(secureDeviceStoreProvider)
            .saveAuthorizedDevice(device);
        _log.info('Connected', data: AppLogger.redactId(device.id));
        return Result.ok(caps);
      },
      (err) {
        state = state.copyWith(status: ConnectionStatus.error, lastError: err);
        return Result.err(err);
      },
    );
  }

  /// Attempts to reconnect to the last authorized device on app resume/start.
  Future<Result<DeviceCapabilities>> reconnectLast() async {
    final device = await ref.read(secureDeviceStoreProvider).readAuthorizedDevice();
    if (device == null) {
      return const Result.err(AppError(AppErrorKind.noDevicesFound));
    }
    return connect(device);
  }

  Future<void> disconnect() async {
    await _transport?.disconnect();
    await _teardown();
    state = const DeviceSession();
  }

  Future<void> forget() async {
    await ref.read(secureDeviceStoreProvider).forget();
    await disconnect();
  }

  /// Sends a command with a timeout and bounded retry. All Shade Shifter
  /// commands are idempotent (they set absolute state), so retrying a
  /// timed-out command is safe. See BLE-PROTOCOL.md (retry / idempotency).
  Future<Result<CommandAck>> send(DeviceCommand command) async {
    final transport = _transport;
    if (transport == null || !state.isConnected) {
      return const Result.err(
        AppError(AppErrorKind.unexpectedDisconnect, code: 'NOT_CONNECTED'),
      );
    }

    AppError lastError = const AppError(AppErrorKind.commandTimeout);
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      final result = await _sendOnce(transport, command);
      if (result.isOk) return result;
      lastError = result.errorOrNull!;
      // Only retry transient failures.
      final transient = lastError.kind == AppErrorKind.commandTimeout ||
          lastError.kind == AppErrorKind.deviceBusyElsewhere;
      if (!transient) return result;
      _log.warning('Retrying ${command.type.name} (attempt ${attempt + 1})');
      await Future<void>.delayed(Duration(milliseconds: 150 * (attempt + 1)));
    }
    return Result.err(lastError);
  }

  Future<Result<CommandAck>> _sendOnce(
    DeviceTransport transport,
    DeviceCommand command,
  ) async {
    try {
      return await transport.send(command).timeout(
            _commandTimeout,
            onTimeout: () => const Result.err(
              AppError(AppErrorKind.commandTimeout, code: 'CLIENT_TIMEOUT'),
            ),
          );
    } on Object catch (e) {
      return Result.err(
        AppError(AppErrorKind.unknown, code: 'SEND_EXCEPTION', cause: e),
      );
    }
  }
}

/// Stable simulator reference, decoupled from the transport implementation.
class SimulatorReference {
  const SimulatorReference._();
  static const DeviceRef device = DeviceRef(
    id: 'simulator-0001',
    name: 'ShadeShifter Simulator',
    isSimulator: true,
    rssi: -48,
  );
}

final deviceControllerProvider =
    NotifierProvider<DeviceController, DeviceSession>(DeviceController.new);

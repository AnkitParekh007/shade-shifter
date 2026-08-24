import 'dart:async';

import 'package:shade_shifter/core/ble/device_transport.dart';
import 'package:shade_shifter/core/ble/protocol.dart';
import 'package:shade_shifter/core/errors/app_error.dart';
import 'package:shade_shifter/core/result/result.dart';
import 'package:shade_shifter/shared/models/device_capabilities.dart';
import 'package:shade_shifter/shared/models/device_state.dart';

/// A programmable [DeviceTransport] for BLE contract tests. Scripts scenarios
/// like delayed/duplicate acks, dropped packets and mid-apply disconnects
/// without any real hardware or timing dependence.
class FakeTransport implements DeviceTransport {
  FakeTransport({this.capabilitiesOverride});

  final DeviceCapabilities? capabilitiesOverride;

  final _status = StreamController<ConnectionStatus>.broadcast();
  final _telemetry = StreamController<DeviceTelemetry>.broadcast();
  final _acks = StreamController<CommandAck>.broadcast();

  ConnectionStatus _current = ConnectionStatus.disconnected;
  DeviceCapabilities? _caps;
  int _seq = 0;

  final List<DeviceCommand> sentCommands = [];

  // Scripting hooks.
  AckStatus nextAckStatus = AckStatus.ok;
  bool dropNextAck = false;
  bool duplicateNextAck = false;
  bool failConnect = false;
  bool disconnectOnNextSend = false;

  @override
  Stream<ConnectionStatus> get connectionStatus => _status.stream;
  @override
  Stream<DeviceTelemetry> get telemetry => _telemetry.stream;
  @override
  Stream<CommandAck> get acks => _acks.stream;
  @override
  ConnectionStatus get currentStatus => _current;
  @override
  DeviceCapabilities? get capabilities => _caps;

  void _set(ConnectionStatus s) {
    _current = s;
    _status.add(s);
  }

  @override
  Future<Result<List<DeviceRef>>> scan(
      {Duration timeout = const Duration(seconds: 2)}) async {
    return const Result.ok([
      DeviceRef(id: 'fake-1', name: 'ShadeShifter Fake', isSimulator: false),
    ]);
  }

  @override
  Future<void> stopScan() async {}

  @override
  Future<Result<DeviceCapabilities>> connect(DeviceRef device) async {
    if (failConnect) {
      _set(ConnectionStatus.error);
      return const Result.err(AppError(AppErrorKind.connectionTimeout));
    }
    _set(ConnectionStatus.connecting);
    _set(ConnectionStatus.negotiating);
    _caps = capabilitiesOverride ?? DeviceCapabilities.revA;
    _set(ConnectionStatus.connected);
    return Result.ok(_caps!);
  }

  @override
  Future<Result<DeviceCapabilities>> reconnect(DeviceRef device) =>
      connect(device);

  @override
  Future<void> disconnect() async => _set(ConnectionStatus.disconnected);

  @override
  Future<Result<CommandAck>> send(DeviceCommand command) async {
    sentCommands.add(command);
    final commandId = ++_seq & 0xFFFF;

    if (disconnectOnNextSend) {
      disconnectOnNextSend = false;
      _set(ConnectionStatus.error);
      return const Result.err(AppError(AppErrorKind.unexpectedDisconnect));
    }
    if (dropNextAck) {
      dropNextAck = false;
      return const Result.err(AppError(AppErrorKind.commandTimeout));
    }

    final ack = CommandAck(
      commandId: commandId,
      type: command.type,
      status: nextAckStatus,
    );
    _acks.add(ack);
    if (duplicateNextAck) {
      duplicateNextAck = false;
      _acks.add(ack); // Duplicate — pipeline must tolerate this.
    }

    if (!nextAckStatus.isOk) {
      return Result.err(
        AppError(AppErrorKind.commandRejected, code: nextAckStatus.name),
      );
    }
    return Result.ok(ack);
  }

  @override
  Future<void> dispose() async {
    await _status.close();
    await _telemetry.close();
    await _acks.close();
  }
}

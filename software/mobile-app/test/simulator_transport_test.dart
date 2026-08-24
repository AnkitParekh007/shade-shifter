import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/ble/protocol.dart';
import 'package:shade_shifter/core/errors/app_error.dart';
import 'package:shade_shifter/features/device/device_controller.dart';
import 'package:shade_shifter/features/simulator/simulator_transport.dart';
import 'package:shade_shifter/shared/models/device_state.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';

SimulatorTransport _fast() => SimulatorTransport(
      random: Random(1),
      commandLatency: Duration.zero,
      connectLatency: Duration.zero,
      telemetryTicking: false,
    );

const _cmd = SetZoneSolidColorCommand(
  zone: ZoneId.front,
  color: RgbColor(10, 20, 30),
  intensity: 0.5,
);

void main() {
  test('connect negotiates Rev-A capabilities and reports connected', () async {
    final sim = _fast();
    addTearDown(sim.dispose);
    final result = await sim.connect(SimulatorReference.device);
    expect(result.isOk, isTrue);
    expect(sim.currentStatus, ConnectionStatus.connected);
    expect(sim.capabilities?.hardwareRevision, 'Rev-A');
  });

  test('failing connect surfaces a timeout error', () async {
    final sim = _fast()..failNextConnect = true;
    addTearDown(sim.dispose);
    final result = await sim.connect(SimulatorReference.device);
    expect(result.isErr, isTrue);
    expect(result.errorOrNull?.kind, AppErrorKind.connectionTimeout);
  });

  test('send returns a correlated ok ack', () async {
    final sim = _fast();
    addTearDown(sim.dispose);
    await sim.connect(SimulatorReference.device);
    final result = await sim.send(_cmd);
    expect(result.isOk, isTrue);
    expect(result.valueOrNull?.type, CommandType.setZoneSolidColor);
  });

  test('dropped ack yields a command timeout', () async {
    final sim = _fast()..dropNextAck = true;
    addTearDown(sim.dispose);
    await sim.connect(SimulatorReference.device);
    final result = await sim.send(_cmd);
    expect(result.errorOrNull?.kind, AppErrorKind.commandTimeout);
  });

  test('injected rejection maps to a rejected error', () async {
    final sim = _fast()..injectNextAckStatus = AckStatus.rejectedUnsafe;
    addTearDown(sim.dispose);
    await sim.connect(SimulatorReference.device);
    final result = await sim.send(_cmd);
    expect(result.errorOrNull?.kind, AppErrorKind.commandRejected);
  });

  test('sending while disconnected is rejected', () async {
    final sim = _fast();
    addTearDown(sim.dispose);
    final result = await sim.send(_cmd);
    expect(result.isErr, isTrue);
  });

  test('thermal alarm is emitted on telemetry', () async {
    final sim = _fast();
    addTearDown(sim.dispose);
    await sim.connect(SimulatorReference.device);
    final future = sim.telemetry.firstWhere((t) => t.thermalAlarm);
    sim.debugTripThermalAlarm();
    final telemetry = await future;
    expect(telemetry.thermalAlarm, isTrue);
  });
}

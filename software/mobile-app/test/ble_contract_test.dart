import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/ble/protocol.dart';
import 'package:shade_shifter/core/errors/app_error.dart';
import 'package:shade_shifter/shared/models/device_state.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';

import 'fakes/fake_transport.dart';

const _cmd = SetZoneSolidColorCommand(
  zone: ZoneId.front,
  color: RgbColor(1, 2, 3),
  intensity: 0.5,
);

void main() {
  const device =
      DeviceRef(id: 'fake-1', name: 'ShadeShifter Fake', isSimulator: false);

  test('valid handshake reaches connected with capabilities', () async {
    final t = FakeTransport();
    addTearDown(t.dispose);
    final result = await t.connect(device);
    expect(result.isOk, isTrue);
    expect(t.currentStatus, ConnectionStatus.connected);
  });

  test('unsupported protocol version is rejected on the command path', () async {
    final t = FakeTransport()..nextAckStatus = AckStatus.protocolMismatch;
    addTearDown(t.dispose);
    await t.connect(device);
    final result = await t.send(_cmd);
    expect(result.isErr, isTrue);
  });

  test('dropped packet surfaces as a command timeout', () async {
    final t = FakeTransport()..dropNextAck = true;
    addTearDown(t.dispose);
    await t.connect(device);
    final result = await t.send(_cmd);
    expect(result.errorOrNull?.kind, AppErrorKind.commandTimeout);
  });

  test('duplicate acknowledgement does not break the send result', () async {
    final t = FakeTransport()..duplicateNextAck = true;
    addTearDown(t.dispose);
    await t.connect(device);
    final acks = <CommandAck>[];
    final sub = t.acks.listen(acks.add);
    final result = await t.send(_cmd);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(result.isOk, isTrue);
    expect(acks.length, 2); // pipeline must tolerate the duplicate
  });

  test('disconnection during apply is reported', () async {
    final t = FakeTransport()..disconnectOnNextSend = true;
    addTearDown(t.dispose);
    await t.connect(device);
    final result = await t.send(_cmd);
    expect(result.errorOrNull?.kind, AppErrorKind.unexpectedDisconnect);
    expect(t.currentStatus, ConnectionStatus.error);
  });

  test('commands are recorded for inspection', () async {
    final t = FakeTransport();
    addTearDown(t.dispose);
    await t.connect(device);
    await t.send(_cmd);
    expect(t.sentCommands.single.type, CommandType.setZoneSolidColor);
  });
}

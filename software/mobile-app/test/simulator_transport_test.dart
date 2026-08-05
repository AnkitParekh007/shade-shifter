import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/src/core/models.dart';
import 'package:shade_shifter/src/device/data/simulator_transport_v2.dart';

void main() {
  test('simulator implements the transport contract', () async {
    final transport = SimulatorTransport();
    final statuses = <FrameDeviceStatus>[];
    final capabilities = <DeviceCapabilities>[];
    final a = transport.status.listen(statuses.add);
    final b = transport.capabilities.listen(capabilities.add);
    final connected = transport.status
        .firstWhere((value) => value.phase == ConnectionPhase.connected);
    await transport.connect();
    await connected;
    expect(statuses.last.phase, ConnectionPhase.connected);
    expect(capabilities.single.independentZones, isTrue);
    expect(await transport.applyAppearance(FrameAppearance.safeDefault), 1);
    await a.cancel();
    await b.cancel();
    await transport.dispose();
  });
  test('disconnected simulator rejects writes', () async {
    final transport = SimulatorTransport();
    expect(transport.applyAppearance(FrameAppearance.safeDefault),
        throwsStateError);
    await transport.dispose();
  });
}

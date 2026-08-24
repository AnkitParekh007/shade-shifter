import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/ble/protocol.dart';
import 'package:shade_shifter/core/errors/app_error.dart';
import 'package:shade_shifter/features/device/ble_transport.dart';
import 'package:shade_shifter/shared/models/appearance.dart';
import 'package:shade_shifter/shared/models/device_capabilities.dart';
import 'package:shade_shifter/shared/models/device_state.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';

import 'fakes/fake_ble_backend.dart';

/// Verifies the Rev-A `BleTransport` against a fake that behaves like the bench
/// firmware. No radio, no plugin — so this runs in CI on every push.
void main() {
  const frame = DeviceRef(
    id: 'AA:BB:CC:DD:EE:FF',
    name: 'ShadeShifter-POC',
    isSimulator: false,
    rssi: -57,
  );

  /// Brand violet #7C5CFF — the same color as the protocol test vector.
  const violet = RgbColor(124, 92, 255);

  /// The Rev-A firmware ceiling; a request at this level writes full-scale
  /// channels, which the frame then renders at its fixed 12.5% brightness.
  const ceiling = 0.125;

  late FakeBleBackend backend;
  late BleTransport transport;

  setUp(() {
    backend = FakeBleBackend();
    // rssiInterval zero disables the poll timer so tests leave no pending timers.
    transport = BleTransport(backend, rssiInterval: Duration.zero);
  });

  tearDown(() async => transport.dispose());

  Future<void> connect() async {
    final result = await transport.connect(frame);
    expect(result.isOk, isTrue, reason: 'fixture should connect cleanly');
  }

  group('connection', () {
    test('applies the revALegacy profile statically, without negotiating', () async {
      await connect();

      expect(transport.capabilities, same(DeviceCapabilities.revALegacy));
      expect(transport.currentStatus, ConnectionStatus.connected);
      // Discovery happens (we verify the profile exists) but nothing is read
      // from a capability characteristic — there isn't one.
      expect(backend.discoverCalls, 1);
    });

    test('walks connecting → negotiating → connected', () async {
      final seen = <ConnectionStatus>[];
      transport.connectionStatus.listen(seen.add);

      await connect();
      await Future<void>.delayed(Duration.zero);

      expect(
        seen,
        containsAllInOrder(const [
          ConnectionStatus.connecting,
          ConnectionStatus.negotiating,
          ConnectionStatus.connected,
        ]),
      );
    });

    test('refuses a simulator reference', () async {
      const sim = DeviceRef(id: 'sim', name: 'Sim', isSimulator: true);

      final result = await transport.connect(sim);

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.code, 'BLE_SIMULATOR_REF');
    });

    test('a non-Rev-A peripheral fails discovery and drops the link', () async {
      backend.discoverError =
          const AppError(AppErrorKind.unsupportedFirmware, code: 'NO_SERVICE');

      final result = await transport.connect(frame);

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.unsupportedFirmware);
      expect(transport.currentStatus, ConnectionStatus.error);
      expect(backend.isConnected, isFalse, reason: 'must not hold a bad link');
    });

    test('an unexpected disconnect surfaces as error then disconnected', () async {
      await connect();
      final seen = <ConnectionStatus>[];
      transport.connectionStatus.listen(seen.add);

      backend.dropConnection();
      await Future<void>.delayed(Duration.zero);

      expect(seen, [ConnectionStatus.error, ConnectionStatus.disconnected]);
    });
  });

  group('telemetry', () {
    test('reports RSSI but never invents battery or temperature', () async {
      final seen = <DeviceTelemetry>[];
      transport.telemetry.listen(seen.add);

      await connect();
      await Future<void>.delayed(Duration.zero);

      expect(seen, isNotEmpty);
      final t = seen.last;
      expect(t.rssi, -57);
      expect(t.batteryPercent, isNull, reason: 'Rev-A has no battery report');
      expect(t.temperatureCelsius, isNull);
      expect(t.firmwareVersion, isNull);
    });
  });

  group('color writes', () {
    test('always writes exactly three bytes', () async {
      await connect();

      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: ceiling,
        ),
      );
      await transport.send(const IlluminationOffCommand());

      expect(backend.writes, isNotEmpty);
      for (final payload in backend.writes) {
        expect(payload.length, BleTransport.kColorPayloadBytes,
            reason: 'firmware ignores any payload that is not 3 bytes');
      }
    });

    test('a request at the ceiling writes full-scale channels', () async {
      await connect();

      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: ceiling,
        ),
      );

      expect(backend.writes.single, [124, 92, 255]);
    });

    test('half the ceiling halves the channels', () async {
      await connect();

      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: ceiling / 2,
        ),
      );

      // Scaling RGB is the only dimming lever: brightness is fixed in firmware.
      expect(backend.writes.single, [62, 46, 128]);
    });

    test('zero intensity actually goes dark', () async {
      await connect();

      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: 0,
        ),
      );

      expect(backend.writes.single, [0, 0, 0]);
    });

    test('never exceeds the firmware ceiling even if asked to', () async {
      await connect();

      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: 1.0, // far above revALegacy.maxIntensity
        ),
      );

      // Clamped to full-scale channels, which the frame still renders at 12.5%.
      expect(backend.writes.single, [124, 92, 255]);
    });

    test('a gradient is blended to a solid rather than rejected', () async {
      await connect();

      final result = await transport.send(
        const SetZoneGradientCommand(
          zone: ZoneId.front,
          start: RgbColor(255, 0, 0),
          end: RgbColor(0, 0, 255),
          direction: GradientDirection.leftToRight,
          intensity: ceiling,
        ),
      );

      // Matches the SafetyGovernor's promise that the frame "renders gradients
      // as a solid blend" — rejecting here would contradict the UI.
      expect(result.isOk, isTrue);
      expect(backend.writes.single, [127, 0, 127]);
    });

    test('brightness-only change re-sends the last color scaled', () async {
      await connect();
      await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.front,
          color: violet,
          intensity: ceiling,
        ),
      );

      await transport.send(
        const SetZoneIntensityCommand(
          zone: ZoneId.front,
          intensity: ceiling / 2,
        ),
      );

      expect(backend.writes.last, [62, 46, 128]);
    });
  });

  group('illumination off', () {
    test('writes black and confirms it by read-back', () async {
      await connect();
      final readsBefore = backend.readCalls;

      final result = await transport.send(const IlluminationOffCommand());

      expect(result.isOk, isTrue);
      expect(backend.writes.single, [0, 0, 0]);
      expect(backend.readCalls, greaterThan(readsBefore),
          reason: 'safety-critical write must be verified');
    });

    test('fails loudly when the frame does not echo the write', () async {
      await connect();
      backend.echoWrites = false; // frame silently dropped the payload

      final result = await transport.send(const IlluminationOffCommand());

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.code, 'BLE_WRITE_UNCONFIRMED');
    });
  });

  group('unsupported features are refused, not faked', () {
    test('animated effects are rejected', () async {
      await connect();

      final result = await transport.send(
        const SetEffectCommand(
          zone: ZoneId.front,
          effect: EffectType.gentlePulse,
          speed: 0.4,
        ),
      );

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.unsupportedFirmware);
      expect(backend.writes, isEmpty);
    });

    test('the static effect is a no-op success', () async {
      await connect();

      final result = await transport.send(
        const SetEffectCommand(
          zone: ZoneId.front,
          effect: EffectType.static,
          speed: 0,
        ),
      );

      expect(result.isOk, isTrue);
      expect(backend.writes, isEmpty);
    });

    test('temple zones are rejected — the frame is whole-frame only', () async {
      await connect();

      final result = await transport.send(
        const SetZoneSolidColorCommand(
          zone: ZoneId.leftTemple,
          color: violet,
          intensity: ceiling,
        ),
      );

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.unsupportedFirmware);
      expect(backend.writes, isEmpty);
    });

    test('rename is rejected', () async {
      await connect();

      final result = await transport.send(const RenameDeviceCommand('Nova'));

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.unsupportedFirmware);
    });
  });

  group('commands answered without BLE traffic', () {
    test('handshake and capability reads generate no writes or reads', () async {
      await connect();
      final readsAfterConnect = backend.readCalls;

      final handshake = await transport.send(const HandshakeCommand());
      final caps = await transport.send(const ReadCapabilitiesCommand());

      expect(handshake.isOk, isTrue);
      expect(caps.isOk, isTrue);
      expect(backend.writes, isEmpty);
      expect(backend.readCalls, readsAfterConnect,
          reason: 'there is nothing on the frame to negotiate with');
    });

    test('ping round-trips a read as a liveness check', () async {
      await connect();
      final readsBefore = backend.readCalls;

      final result = await transport.send(const PingCommand());

      expect(result.isOk, isTrue);
      expect(backend.readCalls, readsBefore + 1);
    });
  });

  group('guards', () {
    test('sending before connecting fails rather than throwing', () async {
      final result = await transport.send(const IlluminationOffCommand());

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.unexpectedDisconnect);
    });

    test('scan reports no devices found rather than an empty success', () async {
      backend.scanResults = const [];

      final result = await transport.scan();

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.noDevicesFound);
    });

    test('scan surfaces a denied permission', () async {
      backend.readyError =
          const AppError(AppErrorKind.permissionDenied, code: 'DENIED');

      final result = await transport.scan();

      expect(result.isErr, isTrue);
      expect(result.errorOrNull!.kind, AppErrorKind.permissionDenied);
    });

    test('dispose is idempotent and releases the backend', () async {
      await connect();

      await transport.dispose();
      await transport.dispose();

      expect(backend.disposed, isTrue);
    });
  });
}

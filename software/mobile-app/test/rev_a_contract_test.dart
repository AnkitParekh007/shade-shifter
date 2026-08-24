import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/ble/ble_ids.dart';
import 'package:shade_shifter/shared/models/appearance.dart';
import 'package:shade_shifter/shared/models/device_capabilities.dart';
import 'package:shade_shifter/shared/models/zone.dart';

/// Pins the Rev-A legacy BLE contract to what the bench firmware actually
/// implements (hardware/blueprint-plan/firmware/shade_shifter_bench.ino).
/// If firmware and app drift apart, this test fails.
void main() {
  group('Rev-A legacy BLE identifiers', () {
    test('service + color UUIDs match firmware', () {
      expect(BleIds.serviceRevA, '7f4a0001-9d45-4d9e-b890-9f132c08a001');
      expect(BleIds.charRevAColor, '7f4a0002-9d45-4d9e-b890-9f132c08a001');
    });

    test('name prefix matches the advertised ShadeShifter-POC', () {
      expect('ShadeShifter-POC'.startsWith(BleIds.deviceNamePrefix), isTrue);
    });
  });

  group('Rev-A legacy capability profile', () {
    const caps = DeviceCapabilities.revALegacy;

    test('is whole-frame solid only', () {
      expect(caps.zones, [ZoneId.front]);
      expect(caps.supportsGradient, isFalse);
      expect(caps.supportedEffects, [EffectType.static]);
      expect(caps.supportsWarmCool, isFalse);
      expect(caps.supportsFindMyFrame, isFalse);
    });

    test('brightness is firmware-fixed at ~12.5% (32/255)', () {
      expect(caps.maxIntensity, closeTo(32 / 255, 0.001));
      expect(caps.safeDefaultIntensity, caps.maxIntensity);
    });

    test('thermal gates match the documented 38/40 C', () {
      expect(caps.thermalWarningCelsius, 38);
      expect(caps.thermalShutdownCelsius, 40);
    });

    test('rich simulator profile is distinct and more capable', () {
      expect(DeviceCapabilities.revA.supportsGradient, isTrue);
      expect(DeviceCapabilities.revA.zones.length, greaterThan(caps.zones.length));
    });
  });
}

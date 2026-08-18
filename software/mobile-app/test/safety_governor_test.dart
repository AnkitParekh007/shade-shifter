import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/safety/safety_governor.dart';
import 'package:shade_shifter/shared/models/appearance.dart';
import 'package:shade_shifter/shared/models/device_capabilities.dart';
import 'package:shade_shifter/shared/models/device_state.dart';
import 'package:shade_shifter/shared/models/zone.dart';

void main() {
  const governor = SafetyGovernor();
  const caps = DeviceCapabilities.revA; // maxIntensity 0.85

  test('clamps intensity to the firmware ceiling', () {
    expect(governor.clampIntensity(1.0, caps), caps.maxIntensity);
    expect(governor.clampIntensity(0.4, caps), 0.4);
  });

  test('safe first-connection intensity never exceeds max', () {
    expect(governor.safeFirstConnectionIntensity(caps),
        lessThanOrEqualTo(caps.maxIntensity));
  });

  test('sanitize clamps an over-bright zone and reports it', () {
    final appearance = FrameAppearance.initial().updateZones(
      ZoneId.values,
      (a) => a.copyWith(intensity: 1.0),
    );
    final decision =
        governor.sanitize(appearance, caps, const DeviceTelemetry());
    expect(decision.appearance.zone(ZoneId.front).intensity,
        caps.maxIntensity);
    expect(decision.notices.any((n) => n.code == 'intensity_clamped'), isTrue);
  });

  test('thermal alarm suspends animated effects', () {
    final appearance = FrameAppearance.initial().updateZones(
      [ZoneId.front],
      (a) => a.copyWith(effect: EffectType.gentlePulse),
    );
    final decision = governor.sanitize(
      appearance,
      caps,
      const DeviceTelemetry(thermalAlarm: true),
    );
    expect(decision.appearance.zone(ZoneId.front).effect, EffectType.static);
    expect(decision.notices.any((n) => n.code == 'thermal_suspend'), isTrue);
  });

  test('unsupported effect falls back to static', () {
    final noEffects = DeviceCapabilities(
      protocolVersion: 1,
      capabilityVersion: 1,
      hardwareRevision: 'Rev-A',
      zones: const [ZoneId.front],
      supportsGradient: false,
      supportedEffects: const [EffectType.static],
      supportsWarmCool: false,
      supportsFindMyFrame: false,
      maxIntensity: 0.8,
      safeDefaultIntensity: 0.4,
      thermalWarningCelsius: 45,
      thermalShutdownCelsius: 55,
    );
    final appearance = FrameAppearance({
      ZoneId.front: const ZoneAppearance(effect: EffectType.breathing),
    });
    final decision =
        governor.sanitize(appearance, noEffects, const DeviceTelemetry());
    expect(decision.appearance.zone(ZoneId.front).effect, EffectType.static);
  });
}

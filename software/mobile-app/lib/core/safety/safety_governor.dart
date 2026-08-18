import '../../shared/models/appearance.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/device_state.dart';

/// A named safety adjustment applied to a requested appearance, surfaced to the
/// user so nothing is silently altered.
class SafetyNotice {
  const SafetyNotice(this.code, this.message);
  final String code;
  final String message;
}

/// Result of running an appearance through the governor.
class SafetyDecision {
  const SafetyDecision(this.appearance, this.notices);
  final FrameAppearance appearance;
  final List<SafetyNotice> notices;
  bool get adjusted => notices.isNotEmpty;
}

/// App-level protective layer. It NEVER bypasses firmware limits — it only
/// clamps *toward* safe values before a command is sent, and reports what it
/// changed. Firmware remains the authoritative safety enforcer.
class SafetyGovernor {
  const SafetyGovernor();

  /// The intensity forced on first connection until the user opts higher.
  double safeFirstConnectionIntensity(DeviceCapabilities caps) =>
      caps.safeDefaultIntensity.clamp(0.0, caps.maxIntensity);

  /// Clamps a single requested intensity to the firmware ceiling.
  double clampIntensity(double requested, DeviceCapabilities caps) =>
      requested.clamp(0.0, caps.maxIntensity);

  /// Sanitizes a full frame appearance against capabilities + live telemetry.
  SafetyDecision sanitize(
    FrameAppearance appearance,
    DeviceCapabilities caps,
    DeviceTelemetry telemetry,
  ) {
    final notices = <SafetyNotice>[];
    final thermalSuspend = telemetry.thermalAlarm ||
        (telemetry.temperatureCelsius != null &&
            telemetry.temperatureCelsius! >= caps.thermalShutdownCelsius);

    final next = appearance.zones.map((zone, a) {
      var adjusted = a;

      // 1. Intensity ceiling.
      if (adjusted.intensity > caps.maxIntensity) {
        adjusted = adjusted.copyWith(intensity: caps.maxIntensity);
        notices.add(SafetyNotice('intensity_clamped',
            'Brightness limited to ${(caps.maxIntensity * 100).round()}% by the frame.'));
      }

      // 2. Unsupported effect → static.
      if (adjusted.effect.isAnimated && !caps.supportsEffect(adjusted.effect)) {
        adjusted = adjusted.copyWith(effect: EffectType.static);
        notices.add(const SafetyNotice('effect_unsupported',
            'This frame does not support that effect; using static.'));
      }

      // 3. Thermal suspension of animated effects.
      if (thermalSuspend && adjusted.effect.isAnimated) {
        adjusted = adjusted.copyWith(effect: EffectType.static);
        notices.add(const SafetyNotice('thermal_suspend',
            'Frame is hot — animated effects are paused until it cools.'));
      }

      // 4. Cap effect speed to avoid rapid flashing near the eyes.
      if (adjusted.effectSpeed > kMaxSafeEffectSpeed) {
        adjusted = adjusted.copyWith(effectSpeed: kMaxSafeEffectSpeed);
        notices.add(const SafetyNotice('speed_capped',
            'Effect speed capped to avoid rapid flashing.'));
      }

      // 5. Gradient not renderable → warn (kept, hardware falls back).
      if (adjusted.mode == AppearanceMode.gradient && !caps.supportsGradient) {
        notices.add(const SafetyNotice('gradient_unsupported',
            'This frame renders gradients as a solid blend.'));
      }

      return MapEntry(zone, adjusted);
    });

    // De-duplicate notices by code.
    final seen = <String>{};
    final unique =
        notices.where((n) => seen.add(n.code)).toList(growable: false);
    return SafetyDecision(FrameAppearance(next), unique);
  }

  /// Upper bound on animated-effect speed (0..1) enforced app-side.
  static const double kMaxSafeEffectSpeed = 0.7;
}

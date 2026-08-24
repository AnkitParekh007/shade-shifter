import 'appearance.dart';
import 'zone.dart';

/// Negotiated device capabilities. The UI is driven entirely by this — features
/// the device does not advertise are shown as "Not supported", never faked.
class DeviceCapabilities {
  const DeviceCapabilities({
    required this.protocolVersion,
    required this.capabilityVersion,
    required this.hardwareRevision,
    required this.zones,
    required this.supportsGradient,
    required this.supportedEffects,
    required this.supportsWarmCool,
    required this.supportsFindMyFrame,
    required this.maxIntensity,
    required this.safeDefaultIntensity,
    required this.thermalWarningCelsius,
    required this.thermalShutdownCelsius,
  });

  final int protocolVersion;

  /// Monotonic version of the capability *shape*, stored with saved looks so we
  /// can warn when re-applying a look created for different hardware.
  final int capabilityVersion;

  final String hardwareRevision;

  /// Physically controllable zones on this unit.
  final List<ZoneId> zones;

  final bool supportsGradient;
  final List<EffectType> supportedEffects;
  final bool supportsWarmCool;
  final bool supportsFindMyFrame;

  /// Firmware-declared ceiling (0..1). The app must never command above this.
  final double maxIntensity;

  /// Safe intensity forced on first connection (0..1).
  final double safeDefaultIntensity;

  final double thermalWarningCelsius;
  final double thermalShutdownCelsius;

  bool supportsEffect(EffectType e) => supportedEffects.contains(e);
  bool supportsZone(ZoneId z) => zones.contains(z);

  Map<String, Object?> toJson() => {
        'protocolVersion': protocolVersion,
        'capabilityVersion': capabilityVersion,
        'hardwareRevision': hardwareRevision,
        'zones': zones.map((z) => z.name).toList(),
        'supportsGradient': supportsGradient,
        'supportedEffects': supportedEffects.map((e) => e.name).toList(),
        'supportsWarmCool': supportsWarmCool,
        'supportsFindMyFrame': supportsFindMyFrame,
        'maxIntensity': maxIntensity,
        'safeDefaultIntensity': safeDefaultIntensity,
        'thermalWarningCelsius': thermalWarningCelsius,
        'thermalShutdownCelsius': thermalShutdownCelsius,
      };

  factory DeviceCapabilities.fromJson(Map<String, Object?> json) =>
      DeviceCapabilities(
        protocolVersion: (json['protocolVersion'] as num).toInt(),
        capabilityVersion: (json['capabilityVersion'] as num).toInt(),
        hardwareRevision: json['hardwareRevision'] as String,
        zones: (json['zones'] as List)
            .map((e) => ZoneId.values.byName(e as String))
            .toList(),
        supportsGradient: json['supportsGradient'] as bool,
        supportedEffects: (json['supportedEffects'] as List)
            .map((e) => EffectType.values.byName(e as String))
            .toList(),
        supportsWarmCool: json['supportsWarmCool'] as bool,
        supportsFindMyFrame: json['supportsFindMyFrame'] as bool,
        maxIntensity: (json['maxIntensity'] as num).toDouble(),
        safeDefaultIntensity: (json['safeDefaultIntensity'] as num).toDouble(),
        thermalWarningCelsius: (json['thermalWarningCelsius'] as num).toDouble(),
        thermalShutdownCelsius:
            (json['thermalShutdownCelsius'] as num).toDouble(),
      );

  /// Rev-A reference profile used by the simulator and as a conservative default.
  static const DeviceCapabilities revA = DeviceCapabilities(
    protocolVersion: 1,
    capabilityVersion: 1,
    hardwareRevision: 'Rev-A',
    zones: [ZoneId.front, ZoneId.leftTemple, ZoneId.rightTemple],
    supportsGradient: true,
    supportedEffects: [
      EffectType.static,
      EffectType.gentlePulse,
      EffectType.colorShift,
      EffectType.breathing,
    ],
    supportsWarmCool: true,
    supportsFindMyFrame: true,
    maxIntensity: 0.85,
    safeDefaultIntensity: 0.5,
    thermalWarningCelsius: 45,
    thermalShutdownCelsius: 55,
  );
}

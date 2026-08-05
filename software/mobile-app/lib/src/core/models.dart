import 'dart:ui';

enum FrameZone { whole, front, leftTemple, rightTemple }

enum AppearanceMode { solid, gradient }

enum FrameEffect { none, breathe, pulse }

enum GradientDirection { horizontal, vertical, diagonal }

enum ProtocolProfile { simulator, legacyRevA, packetV1 }

enum ConnectionPhase { disconnected, scanning, connecting, connected, failed }

enum SafetyState { normal, warning, shutdown }

class ZoneAppearance {
  const ZoneAppearance({
    required this.primary,
    this.secondary,
    this.mode = AppearanceMode.solid,
    this.direction = GradientDirection.horizontal,
    this.effect = FrameEffect.none,
    this.effectSpeed = .5,
  });
  final Color primary;
  final Color? secondary;
  final AppearanceMode mode;
  final GradientDirection direction;
  final FrameEffect effect;
  final double effectSpeed;

  ZoneAppearance copyWith(
          {Color? primary,
          Color? secondary,
          AppearanceMode? mode,
          GradientDirection? direction,
          FrameEffect? effect,
          double? effectSpeed}) =>
      ZoneAppearance(
          primary: primary ?? this.primary,
          secondary: secondary ?? this.secondary,
          mode: mode ?? this.mode,
          direction: direction ?? this.direction,
          effect: effect ?? this.effect,
          effectSpeed: (effectSpeed ?? this.effectSpeed).clamp(0, 1));

  Map<String, Object?> toJson() => {
        'primary': primary.toARGB32(),
        'secondary': secondary?.toARGB32(),
        'mode': mode.name,
        'direction': direction.name,
        'effect': effect.name,
        'effectSpeed': effectSpeed
      };
  factory ZoneAppearance.fromJson(Map<String, Object?> json) => ZoneAppearance(
      primary: Color(json['primary']! as int),
      secondary:
          json['secondary'] == null ? null : Color(json['secondary']! as int),
      mode: AppearanceMode.values.byName(json['mode']! as String),
      direction: GradientDirection.values.byName(json['direction']! as String),
      effect: FrameEffect.values.byName(json['effect']! as String),
      effectSpeed: (json['effectSpeed']! as num).toDouble());
}

class FrameAppearance {
  const FrameAppearance(
      {required this.front,
      required this.leftTemple,
      required this.rightTemple,
      this.intensity = .35,
      this.linked = true,
      this.schemaVersion = 1});
  static const safeDefault = FrameAppearance(
      front: ZoneAppearance(primary: Color(0xff284b63)),
      leftTemple: ZoneAppearance(primary: Color(0xff284b63)),
      rightTemple: ZoneAppearance(primary: Color(0xff284b63)));
  final int schemaVersion;
  final ZoneAppearance front;
  final ZoneAppearance leftTemple;
  final ZoneAppearance rightTemple;
  final double intensity;
  final bool linked;
  FrameAppearance copyWith(
          {ZoneAppearance? front,
          ZoneAppearance? leftTemple,
          ZoneAppearance? rightTemple,
          double? intensity,
          bool? linked}) =>
      FrameAppearance(
          front: front ?? this.front,
          leftTemple: leftTemple ?? this.leftTemple,
          rightTemple: rightTemple ?? this.rightTemple,
          intensity: _safe(intensity ?? this.intensity),
          linked: linked ?? this.linked);
  static double _safe(double value) => value.isFinite ? value.clamp(0, .65) : 0;
  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'front': front.toJson(),
        'leftTemple': leftTemple.toJson(),
        'rightTemple': rightTemple.toJson(),
        'intensity': intensity,
        'linked': linked
      };
  factory FrameAppearance.fromJson(Map<String, Object?> j) => FrameAppearance(
      front: ZoneAppearance.fromJson(
          Map<String, Object?>.from(j['front']! as Map)),
      leftTemple: ZoneAppearance.fromJson(
          Map<String, Object?>.from(j['leftTemple']! as Map)),
      rightTemple: ZoneAppearance.fromJson(
          Map<String, Object?>.from(j['rightTemple']! as Map)),
      intensity: (j['intensity']! as num).toDouble(),
      linked: j['linked']! as bool);
}

class DeviceCapabilities {
  const DeviceCapabilities(
      {required this.profile,
      required this.independentZones,
      required this.gradients,
      required this.effects,
      required this.intensity,
      required this.battery,
      required this.temperature,
      required this.acknowledgements});
  final ProtocolProfile profile;
  final bool independentZones,
      gradients,
      effects,
      intensity,
      battery,
      temperature,
      acknowledgements;
  static const simulator = DeviceCapabilities(
      profile: ProtocolProfile.simulator,
      independentZones: true,
      gradients: true,
      effects: true,
      intensity: true,
      battery: true,
      temperature: true,
      acknowledgements: true);
  static const legacyRevA = DeviceCapabilities(
      profile: ProtocolProfile.legacyRevA,
      independentZones: false,
      gradients: false,
      effects: false,
      intensity: false,
      battery: false,
      temperature: false,
      acknowledgements: false);
}

class FrameDeviceStatus {
  const FrameDeviceStatus(
      {this.phase = ConnectionPhase.disconnected,
      this.name = 'No frame',
      this.firmware = 'Unknown',
      this.batteryPercent,
      this.temperatureCelsius,
      this.rssi,
      this.sequence = 0,
      this.simulator = true,
      this.error});
  final ConnectionPhase phase;
  final String name, firmware;
  final int? batteryPercent, rssi;
  final double? temperatureCelsius;
  final int sequence;
  final bool simulator;
  final String? error;
  SafetyState get safety => temperatureCelsius == null
      ? SafetyState.normal
      : temperatureCelsius! >= 40
          ? SafetyState.shutdown
          : temperatureCelsius! >= 38
              ? SafetyState.warning
              : SafetyState.normal;
}

class Look {
  const Look(
      {required this.id,
      required this.name,
      required this.appearance,
      required this.createdAt,
      required this.updatedAt,
      this.curated = false,
      this.schemaVersion = 1});
  final String id, name;
  final FrameAppearance appearance;
  final DateTime createdAt, updatedAt;
  final bool curated;
  final int schemaVersion;
}

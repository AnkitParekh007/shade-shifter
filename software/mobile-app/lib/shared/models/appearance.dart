import 'rgb_color.dart';
import 'zone.dart';

enum AppearanceMode { solid, gradient }

enum GradientDirection {
  leftToRight('Left → Right'),
  topToBottom('Top → Bottom'),
  diagonal('Diagonal');

  const GradientDirection(this.label);
  final String label;
}

/// Lighting effects — prototype RGB experience only. See the "prototype
/// lighting effect" labelling requirement; production electrochromic hardware
/// only advertises effects it can actually render via its capability response.
enum EffectType {
  static('Static', 0x00),
  gentlePulse('Gentle pulse', 0x01),
  colorShift('Color shift', 0x02),
  breathing('Breathing', 0x03);

  const EffectType(this.label, this.wire);
  final String label;
  final int wire;

  bool get isAnimated => this != EffectType.static;

  static EffectType fromWire(int wire) =>
      values.firstWhere((e) => e.wire == wire, orElse: () => EffectType.static);
}

/// Immutable appearance for a single physical [ZoneId]. Each zone owns its own
/// instance so recoloring the front never mutates temple colors.
class ZoneAppearance {
  const ZoneAppearance({
    this.mode = AppearanceMode.solid,
    this.solidColor = RgbColor.black,
    this.gradientStart = RgbColor.black,
    this.gradientEnd = RgbColor.white,
    this.gradientDirection = GradientDirection.leftToRight,
    this.intensity = 0.6,
    this.effect = EffectType.static,
    this.effectSpeed = 0.4,
  })  : assert(intensity >= 0 && intensity <= 1, 'intensity 0..1'),
        assert(effectSpeed >= 0 && effectSpeed <= 1, 'effectSpeed 0..1');

  final AppearanceMode mode;
  final RgbColor solidColor;
  final RgbColor gradientStart;
  final RgbColor gradientEnd;
  final GradientDirection gradientDirection;

  /// 0..1 zone brightness. Clamped against firmware max at command time.
  final double intensity;

  final EffectType effect;

  /// 0..1 animation speed for animated effects; capped for safety in the studio.
  final double effectSpeed;

  /// The single coherent base color for solid zones / 2D + 3D preview tint.
  RgbColor get representativeColor =>
      mode == AppearanceMode.solid ? solidColor : gradientStart;

  ZoneAppearance copyWith({
    AppearanceMode? mode,
    RgbColor? solidColor,
    RgbColor? gradientStart,
    RgbColor? gradientEnd,
    GradientDirection? gradientDirection,
    double? intensity,
    EffectType? effect,
    double? effectSpeed,
  }) {
    return ZoneAppearance(
      mode: mode ?? this.mode,
      solidColor: solidColor ?? this.solidColor,
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      gradientDirection: gradientDirection ?? this.gradientDirection,
      intensity: intensity ?? this.intensity,
      effect: effect ?? this.effect,
      effectSpeed: effectSpeed ?? this.effectSpeed,
    );
  }

  Map<String, Object?> toJson() => {
        'mode': mode.name,
        'solidColor': solidColor.toJson(),
        'gradientStart': gradientStart.toJson(),
        'gradientEnd': gradientEnd.toJson(),
        'gradientDirection': gradientDirection.name,
        'intensity': intensity,
        'effect': effect.name,
        'effectSpeed': effectSpeed,
      };

  factory ZoneAppearance.fromJson(Map<String, Object?> json) {
    RgbColor color(Object? v) =>
        RgbColor.fromJson((v as Map).cast<String, Object?>());
    return ZoneAppearance(
      mode: AppearanceMode.values.byName(json['mode'] as String? ?? 'solid'),
      solidColor: color(json['solidColor']),
      gradientStart: color(json['gradientStart']),
      gradientEnd: color(json['gradientEnd']),
      gradientDirection: GradientDirection.values
          .byName(json['gradientDirection'] as String? ?? 'leftToRight'),
      intensity: (json['intensity'] as num?)?.toDouble() ?? 0.6,
      effect: EffectType.values.byName(json['effect'] as String? ?? 'static'),
      effectSpeed: (json['effectSpeed'] as num?)?.toDouble() ?? 0.4,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ZoneAppearance &&
      other.mode == mode &&
      other.solidColor == solidColor &&
      other.gradientStart == gradientStart &&
      other.gradientEnd == gradientEnd &&
      other.gradientDirection == gradientDirection &&
      other.intensity == intensity &&
      other.effect == effect &&
      other.effectSpeed == effectSpeed;

  @override
  int get hashCode => Object.hash(mode, solidColor, gradientStart, gradientEnd,
      gradientDirection, intensity, effect, effectSpeed);
}

/// A full frame appearance: one [ZoneAppearance] per physical zone.
class FrameAppearance {
  const FrameAppearance(this.zones);

  final Map<ZoneId, ZoneAppearance> zones;

  factory FrameAppearance.initial() => const FrameAppearance({
        ZoneId.front: ZoneAppearance(),
        ZoneId.leftTemple: ZoneAppearance(),
        ZoneId.rightTemple: ZoneAppearance(),
      });

  ZoneAppearance zone(ZoneId id) => zones[id] ?? const ZoneAppearance();

  /// Returns a copy with [appearance] applied to every zone in [targets].
  FrameAppearance withZones(List<ZoneId> targets, ZoneAppearance appearance) {
    final next = Map<ZoneId, ZoneAppearance>.from(zones);
    for (final z in targets) {
      next[z] = appearance;
    }
    return FrameAppearance(next);
  }

  /// Applies a transform to each targeted zone independently, preserving others.
  FrameAppearance updateZones(
    List<ZoneId> targets,
    ZoneAppearance Function(ZoneAppearance current) transform,
  ) {
    final next = Map<ZoneId, ZoneAppearance>.from(zones);
    for (final z in targets) {
      next[z] = transform(next[z] ?? const ZoneAppearance());
    }
    return FrameAppearance(next);
  }

  Map<String, Object?> toJson() =>
      zones.map((k, v) => MapEntry(k.name, v.toJson()));

  factory FrameAppearance.fromJson(Map<String, Object?> json) {
    final map = <ZoneId, ZoneAppearance>{};
    for (final id in ZoneId.values) {
      final raw = json[id.name];
      if (raw is Map) {
        map[id] = ZoneAppearance.fromJson(raw.cast<String, Object?>());
      } else {
        map[id] = const ZoneAppearance();
      }
    }
    return FrameAppearance(map);
  }

  @override
  bool operator ==(Object other) {
    if (other is! FrameAppearance) return false;
    if (other.zones.length != zones.length) return false;
    for (final entry in zones.entries) {
      if (other.zones[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode =>
      Object.hashAll(zones.entries.map((e) => Object.hash(e.key, e.value)));
}

import '../../../shared/models/appearance.dart';
import '../../../shared/models/look.dart';
import '../../../shared/models/rgb_color.dart';
import '../../../shared/models/zone.dart';

/// Curated presets shipped with the app. Immutable and non-deletable.
class BuiltInLooks {
  const BuiltInLooks._();

  static final DateTime _epoch = DateTime.utc(2026, 1, 1);

  static Look _solid(String id, String name, RgbColor color,
      {double intensity = 0.6}) {
    final zone = ZoneAppearance(solidColor: color, intensity: intensity);
    return Look(
      id: id,
      name: name,
      appearance: FrameAppearance({
        ZoneId.front: zone,
        ZoneId.leftTemple: zone,
        ZoneId.rightTemple: zone,
      }),
      createdAt: _epoch,
      updatedAt: _epoch,
      deviceCapabilityVersion: 1,
      builtIn: true,
    );
  }

  static Look _gradient(
    String id,
    String name,
    RgbColor start,
    RgbColor end, {
    GradientDirection direction = GradientDirection.leftToRight,
    double intensity = 0.6,
  }) {
    final zone = ZoneAppearance(
      mode: AppearanceMode.gradient,
      gradientStart: start,
      gradientEnd: end,
      gradientDirection: direction,
      intensity: intensity,
    );
    return Look(
      id: id,
      name: name,
      appearance: FrameAppearance({
        ZoneId.front: zone,
        ZoneId.leftTemple: zone,
        ZoneId.rightTemple: zone,
      }),
      createdAt: _epoch,
      updatedAt: _epoch,
      deviceCapabilityVersion: 1,
      builtIn: true,
    );
  }

  static List<Look> all() => [
        _solid('builtin.obsidian', 'Obsidian', const RgbColor(18, 18, 22),
            intensity: 0.35),
        _solid('builtin.arctic_silver', 'Arctic Silver',
            const RgbColor(196, 202, 214)),
        _solid('builtin.electric_violet', 'Electric Violet',
            const RgbColor(124, 92, 255), intensity: 0.7),
        _gradient('builtin.ocean_fade', 'Ocean Fade',
            const RgbColor(28, 82, 148), const RgbColor(52, 224, 198)),
        _solid('builtin.rose_quartz', 'Rose Quartz',
            const RgbColor(232, 168, 184)),
        _gradient('builtin.sunset_gradient', 'Sunset Gradient',
            const RgbColor(255, 122, 69), const RgbColor(124, 46, 132),
            direction: GradientDirection.diagonal, intensity: 0.7),
        _solid('builtin.corporate_navy', 'Corporate Navy',
            const RgbColor(26, 42, 76), intensity: 0.5),
        _festivalSpectrum(),
      ];

  /// Distinct per-zone colors with a gentle animated effect — shows off
  /// independent zones and the prototype lighting experience.
  static Look _festivalSpectrum() => Look(
        id: 'builtin.festival_spectrum',
        name: 'Festival Spectrum',
        appearance: const FrameAppearance({
          ZoneId.front: ZoneAppearance(
            solidColor: RgbColor(124, 92, 255),
            intensity: 0.7,
            effect: EffectType.colorShift,
            effectSpeed: 0.4,
          ),
          ZoneId.leftTemple: ZoneAppearance(
            solidColor: RgbColor(52, 224, 198),
            intensity: 0.7,
            effect: EffectType.gentlePulse,
          ),
          ZoneId.rightTemple: ZoneAppearance(
            solidColor: RgbColor(255, 122, 69),
            intensity: 0.7,
            effect: EffectType.gentlePulse,
          ),
        }),
        createdAt: _epoch,
        updatedAt: _epoch,
        deviceCapabilityVersion: 1,
        builtIn: true,
      );
}

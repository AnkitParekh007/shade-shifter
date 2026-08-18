import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/utils/color_utils.dart';
import 'package:shade_shifter/shared/models/appearance.dart';
import 'package:shade_shifter/shared/models/look.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';

void main() {
  group('RgbColor', () {
    test('hex round-trips', () {
      expect(const RgbColor(124, 92, 255).hex, '#7C5CFF');
      expect(RgbColor.fromHex('#7C5CFF'), const RgbColor(124, 92, 255));
      expect(RgbColor.fromHex('fff'), const RgbColor(255, 255, 255));
    });

    test('rejects malformed hex', () {
      expect(() => RgbColor.fromHex('#12'), throwsFormatException);
    });

    test('json round-trips', () {
      const c = RgbColor(10, 20, 30);
      expect(RgbColor.fromJson(c.toJson()), c);
    });

    test('luminance orders black < grey < white', () {
      expect(RgbColor.black.luminance, lessThan(const RgbColor(128, 128, 128).luminance));
      expect(const RgbColor(128, 128, 128).luminance, lessThan(RgbColor.white.luminance));
    });
  });

  group('ColorUtils', () {
    test('HSV round-trips within tolerance', () {
      const original = RgbColor(200, 120, 40);
      final (h, s, v) = ColorUtils.toHsv(original);
      final back = ColorUtils.fromHsv(h, s, v);
      expect((back.r - original.r).abs(), lessThanOrEqualTo(2));
      expect((back.g - original.g).abs(), lessThanOrEqualTo(2));
      expect((back.b - original.b).abs(), lessThanOrEqualTo(2));
    });

    test('darker shades reduce luminance monotonically', () {
      const base = RgbColor(180, 180, 180);
      final shades = ColorUtils.darker(base, count: 3);
      expect(shades.first.luminance, greaterThan(shades.last.luminance));
    });

    test('contrast ratio of black on white is ~21', () {
      final ratio = ColorUtils.contrastRatio(RgbColor.black, RgbColor.white);
      expect(ratio, closeTo(21, 0.5));
    });
  });

  group('FrameAppearance', () {
    test('editing one zone leaves the others untouched', () {
      final base = FrameAppearance.initial();
      final edited = base.updateZones(
        [ZoneId.front],
        (a) => a.copyWith(solidColor: const RgbColor(255, 0, 0)),
      );
      expect(edited.zone(ZoneId.front).solidColor, const RgbColor(255, 0, 0));
      expect(edited.zone(ZoneId.leftTemple), base.zone(ZoneId.leftTemple));
      expect(edited.zone(ZoneId.rightTemple), base.zone(ZoneId.rightTemple));
    });

    test('json round-trips per-zone config', () {
      final appearance = FrameAppearance.initial().updateZones(
        [ZoneId.leftTemple],
        (a) => a.copyWith(
            mode: AppearanceMode.gradient,
            gradientEnd: const RgbColor(1, 2, 3)),
      );
      final restored = FrameAppearance.fromJson(appearance.toJson());
      expect(restored, appearance);
    });
  });

  group('SelectionTarget', () {
    test('resolves to supported zones only', () {
      expect(
        SelectionTarget.bothTemples.resolve([ZoneId.front, ZoneId.leftTemple]),
        [ZoneId.leftTemple],
      );
      expect(
        SelectionTarget.wholeFrame.resolve(ZoneId.values).length,
        ZoneId.values.length,
      );
    });
  });

  group('Look', () {
    test('json round-trips', () {
      final look = Look(
        id: 'x',
        name: 'Test',
        appearance: FrameAppearance.initial(),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
        deviceCapabilityVersion: 1,
        favorite: true,
      );
      final restored = Look.fromJson(look.toJson());
      expect(restored.id, look.id);
      expect(restored.favorite, isTrue);
      expect(restored.appearance, look.appearance);
    });
  });
}

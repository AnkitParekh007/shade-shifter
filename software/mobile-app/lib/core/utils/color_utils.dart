import 'dart:math' as math;

import '../../shared/models/rgb_color.dart';

/// Pure color math for the studio: shade/tint generation, warm–cool bias, and
/// HSV conversion. Kept transport- and Flutter-widget-independent so it is
/// trivially unit-testable.
class ColorUtils {
  const ColorUtils._();

  /// Returns [count] progressively lighter tints of [base] (excludes base).
  static List<RgbColor> lighter(RgbColor base, {int count = 4}) {
    return List.generate(count, (i) {
      final t = (i + 1) / (count + 1);
      return _mix(base, RgbColor.white, t);
    });
  }

  /// Returns [count] progressively darker shades of [base] (excludes base).
  static List<RgbColor> darker(RgbColor base, {int count = 4}) {
    return List.generate(count, (i) {
      final t = (i + 1) / (count + 1);
      return _mix(base, RgbColor.black, t);
    });
  }

  /// Biases a color warm (amount > 0, toward amber) or cool (amount < 0, toward
  /// blue). [amount] in -1..1.
  static RgbColor warmCool(RgbColor base, double amount) {
    final a = amount.clamp(-1.0, 1.0);
    final shift = (a.abs() * 60).round();
    if (a >= 0) {
      return RgbColor(
        (base.r + shift).clamp(0, 255),
        (base.g + (shift * 0.4).round()).clamp(0, 255),
        (base.b - shift).clamp(0, 255),
      );
    }
    return RgbColor(
      (base.r - shift).clamp(0, 255),
      (base.g + (shift * 0.2).round()).clamp(0, 255),
      (base.b + shift).clamp(0, 255),
    );
  }

  static RgbColor _mix(RgbColor a, RgbColor b, double t) {
    int c(int x, int y) => (x + (y - x) * t).round().clamp(0, 255);
    return RgbColor(c(a.r, b.r), c(a.g, b.g), c(a.b, b.b));
  }

  /// Converts RGB to HSV. Returns (hue 0..360, sat 0..1, value 0..1).
  static (double, double, double) toHsv(RgbColor color) {
    final r = color.r / 255, g = color.g / 255, b = color.b / 255;
    final max = math.max(r, math.max(g, b));
    final min = math.min(r, math.min(g, b));
    final delta = max - min;

    double hue;
    if (delta == 0) {
      hue = 0;
    } else if (max == r) {
      hue = 60 * (((g - b) / delta) % 6);
    } else if (max == g) {
      hue = 60 * (((b - r) / delta) + 2);
    } else {
      hue = 60 * (((r - g) / delta) + 4);
    }
    if (hue < 0) hue += 360;
    final sat = max == 0 ? 0.0 : delta / max;
    return (hue, sat, max);
  }

  /// Converts HSV (hue 0..360, sat 0..1, value 0..1) to RGB.
  static RgbColor fromHsv(double hue, double sat, double value) {
    final h = (hue % 360) / 60;
    final c = value * sat;
    final x = c * (1 - (h % 2 - 1).abs());
    final m = value - c;
    double r = 0, g = 0, b = 0;
    if (h < 1) {
      r = c;
      g = x;
    } else if (h < 2) {
      r = x;
      g = c;
    } else if (h < 3) {
      g = c;
      b = x;
    } else if (h < 4) {
      g = x;
      b = c;
    } else if (h < 5) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }
    int ch(double v) => ((v + m) * 255).round().clamp(0, 255);
    return RgbColor(ch(r), ch(g), ch(b));
  }

  /// WCAG contrast ratio between two colors (1..21).
  static double contrastRatio(RgbColor a, RgbColor b) {
    final la = a.luminance, lb = b.luminance;
    final hi = math.max(la, lb), lo = math.min(la, lb);
    return (hi + 0.05) / (lo + 0.05);
  }
}

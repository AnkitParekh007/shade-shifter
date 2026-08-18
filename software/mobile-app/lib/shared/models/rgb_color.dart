import 'dart:math' as math;
import 'dart:ui' show Color;

import 'package:meta/meta.dart';

/// Device-facing color: three 8-bit channels, transport-independent.
///
/// The BLE protocol serializes zone color as three bytes R,G,B (see
/// BLE-PROTOCOL.md, "Color representation"). Intensity is a *separate* zone
/// control and is intentionally NOT baked into these channels.
@immutable
class RgbColor {
  const RgbColor(this.r, this.g, this.b)
      : assert(r >= 0 && r <= 255, 'r out of range'),
        assert(g >= 0 && g <= 255, 'g out of range'),
        assert(b >= 0 && b <= 255, 'b out of range');

  final int r;
  final int g;
  final int b;

  static const RgbColor black = RgbColor(0, 0, 0);
  static const RgbColor white = RgbColor(255, 255, 255);

  factory RgbColor.fromHex(String hex) {
    var value = hex.trim().replaceAll('#', '');
    if (value.length == 3) {
      value = value.split('').map((c) => '$c$c').join();
    }
    if (value.length != 6) {
      throw FormatException('Invalid hex color: $hex');
    }
    final n = int.parse(value, radix: 16);
    return RgbColor((n >> 16) & 0xFF, (n >> 8) & 0xFF, n & 0xFF);
  }

  /// Uppercase `#RRGGBB`.
  String get hex =>
      '#${_h(r)}${_h(g)}${_h(b)}';

  static String _h(int v) => v.toRadixString(16).padLeft(2, '0').toUpperCase();

  /// Fully-opaque Flutter [Color] for rendering.
  Color toColor() => Color.fromARGB(0xFF, r, g, b);

  Map<String, Object?> toJson() => {'r': r, 'g': g, 'b': b};

  factory RgbColor.fromJson(Map<String, Object?> json) => RgbColor(
        (json['r'] as num).toInt(),
        (json['g'] as num).toInt(),
        (json['b'] as num).toInt(),
      );

  /// Relative luminance (WCAG 2.x, sRGB) in 0..1.
  double get luminance {
    double lin(int c) {
      final s = c / 255.0;
      return s <= 0.03928 ? s / 12.92 : math.pow((s + 0.055) / 1.055, 2.4) as double;
    }

    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b);
  }

  @override
  bool operator ==(Object other) =>
      other is RgbColor && other.r == r && other.g == g && other.b == b;

  @override
  int get hashCode => Object.hash(r, g, b);

  @override
  String toString() => 'RgbColor($hex)';
}

import 'package:flutter/widgets.dart';

/// Shade Shifter design tokens — the single source of truth for color, spacing,
/// radius, elevation, motion and typography scale. Widgets reference these
/// rather than hard-coded values so the visual language stays coherent.
class ShadeTokens {
  const ShadeTokens._();

  // ---- Brand / surface palette (obsidian → graphite → neutral) ----
  static const Color obsidian = Color(0xFF0B0B0F);
  static const Color graphite = Color(0xFF16161C);
  static const Color slate = Color(0xFF23232B);
  static const Color mist = Color(0xFF3A3A44);
  static const Color fog = Color(0xFFB9B9C4);
  static const Color porcelain = Color(0xFFF4F4F7);

  // Spectral accent used sparingly.
  static const Color spectral = Color(0xFF7C5CFF);
  static const Color spectralAlt = Color(0xFF34E0C6);
  static const Color warning = Color(0xFFF2B84B);
  static const Color danger = Color(0xFFFF5C6C);
  static const Color success = Color(0xFF4BD6A0);

  // ---- Spacing scale (4pt grid) ----
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double space7 = 48;
  static const double space8 = 64;

  // ---- Radius ----
  static const double radiusSm = 10;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusPill = 999;

  // ---- Elevation (logical, mapped to subtle shadows) ----
  static const double elevationCard = 2;
  static const double elevationSheet = 8;

  // ---- Motion durations ----
  static const Duration motionFast = Duration(milliseconds: 150);
  static const Duration motionBase = Duration(milliseconds: 260);
  static const Duration motionSlow = Duration(milliseconds: 420);

  // ---- Debounce for continuous controls feeding BLE ----
  static const Duration bleControlDebounce = Duration(milliseconds: 120);
}

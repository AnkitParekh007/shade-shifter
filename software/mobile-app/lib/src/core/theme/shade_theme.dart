import 'package:flutter/material.dart';

abstract final class ShadeTheme {
  static const _ink = Color(0xFF111318);
  static const _champagne = Color(0xFFD6B36A);
  static const _ivory = Color(0xFFF7F3EA);

  static ThemeData get light =>
      _theme(brightness: Brightness.light, surface: _ivory, foreground: _ink);

  static ThemeData get dark => _theme(
    brightness: Brightness.dark,
    surface: const Color(0xFF15171C),
    foreground: const Color(0xFFF4F0E8),
  );

  static ThemeData _theme({
    required Brightness brightness,
    required Color surface,
    required Color foreground,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _champagne,
      brightness: brightness,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      textTheme: Typography.material2021().black.apply(
        bodyColor: foreground,
        displayColor: foreground,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _champagne,
        thumbColor: _champagne,
        overlayColor: _champagne.withValues(alpha: 0.16),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}

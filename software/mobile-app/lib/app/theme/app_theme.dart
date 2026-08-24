import 'package:flutter/material.dart';

import 'design_tokens.dart';

/// Builds the Shade Shifter Material 3 light/dark themes from [ShadeTokens].
class AppTheme {
  const AppTheme._();

  static ThemeData dark() => _build(Brightness.dark);
  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: ShadeTokens.spectral,
      brightness: brightness,
    ).copyWith(
      surface: isDark ? ShadeTokens.graphite : ShadeTokens.porcelain,
      primary: ShadeTokens.spectral,
      secondary: ShadeTokens.spectralAlt,
      error: ShadeTokens.danger,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? ShadeTokens.obsidian : ShadeTokens.porcelain,
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, isDark),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? ShadeTokens.graphite : Colors.white,
        elevation: ShadeTokens.elevationCard,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShadeTokens.radiusMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShadeTokens.radiusPill),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? ShadeTokens.graphite : Colors.white,
        indicatorColor: ShadeTokens.spectral.withValues(alpha: 0.18),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 68,
      ),
      dividerTheme: DividerThemeData(
        color: (isDark ? ShadeTokens.mist : ShadeTokens.fog)
            .withValues(alpha: 0.3),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShadeTokens.radiusSm),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, bool isDark) {
    final onSurface = isDark ? ShadeTokens.porcelain : ShadeTokens.obsidian;
    final muted = isDark ? ShadeTokens.fog : ShadeTokens.mist;
    return base
        .apply(bodyColor: onSurface, displayColor: onSurface)
        .copyWith(
          displaySmall: base.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: base.bodyMedium?.copyWith(color: muted, height: 1.4),
          labelLarge: base.labelLarge?.copyWith(letterSpacing: 0.3),
        );
  }
}

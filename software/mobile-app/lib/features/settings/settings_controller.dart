import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../core/persistence/preferences_store.dart';

/// User-facing app settings (non-sensitive, stored in preferences).
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.reducedMotion = false,
    this.userMaxBrightness = 0.85,
    this.onboardingComplete = false,
  });

  final ThemeMode themeMode;
  final bool reducedMotion;

  /// Additional app-side brightness cap (0..1) layered under firmware max.
  final double userMaxBrightness;

  final bool onboardingComplete;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? reducedMotion,
    double? userMaxBrightness,
    bool? onboardingComplete,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        userMaxBrightness: userMaxBrightness ?? this.userMaxBrightness,
        onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      );
}

class SettingsController extends Notifier<AppSettings> {
  PreferencesStore get _prefs => ref.read(preferencesStoreProvider);

  @override
  AppSettings build() {
    final themeName = _prefs.getString(PreferencesStore.keyThemeMode);
    return AppSettings(
      themeMode: ThemeMode.values.firstWhere(
        (m) => m.name == themeName,
        orElse: () => ThemeMode.dark,
      ),
      reducedMotion: _prefs.getBool(PreferencesStore.keyReducedMotion) ?? false,
      userMaxBrightness:
          _prefs.getDouble(PreferencesStore.keyUserMaxBrightness) ?? 0.85,
      onboardingComplete:
          _prefs.getBool(PreferencesStore.keyOnboardingComplete) ?? false,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs.setString(PreferencesStore.keyThemeMode, mode.name);
  }

  Future<void> setReducedMotion(bool value) async {
    state = state.copyWith(reducedMotion: value);
    await _prefs.setBool(PreferencesStore.keyReducedMotion, value);
  }

  Future<void> setUserMaxBrightness(double value) async {
    state = state.copyWith(userMaxBrightness: value);
    await _prefs.setDouble(PreferencesStore.keyUserMaxBrightness, value);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingComplete: true);
    await _prefs.setBool(PreferencesStore.keyOnboardingComplete, true);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

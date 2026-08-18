import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin typed wrapper over [SharedPreferences] for simple, non-sensitive
/// preferences and local JSON documents (looks, last-applied appearance).
/// Sensitive device authorization data goes to the secure store instead.
class PreferencesStore {
  const PreferencesStore(this._prefs);

  final SharedPreferences _prefs;

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  Map<String, Object?>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    return decoded is Map ? decoded.cast<String, Object?>() : null;
  }

  Future<void> setJson(String key, Map<String, Object?> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<Map<String, Object?>> getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => e.cast<String, Object?>())
        .toList();
  }

  Future<void> setJsonList(String key, List<Map<String, Object?>> value) =>
      _prefs.setString(key, jsonEncode(value));

  // Preference keys.
  static const keyOnboardingComplete = 'onboarding_complete';
  static const keyThemeMode = 'theme_mode';
  static const keyReducedMotion = 'reduced_motion';
  static const keyUserMaxBrightness = 'user_max_brightness';
  static const keySavedLooks = 'saved_looks';
  static const keyLastAppliedAppearance = 'last_applied_appearance';
}

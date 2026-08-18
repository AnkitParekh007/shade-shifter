import '../../../core/persistence/preferences_store.dart';
import '../../../shared/models/appearance.dart';
import '../../../shared/models/look.dart';
import 'built_in_looks.dart';

/// Local-first store for looks. Built-in presets are always present; user looks
/// and the last-applied appearance persist in preferences (POC storage; a Drift
/// migration is documented in ADR 0004).
class LooksRepository {
  const LooksRepository(this._prefs);

  final PreferencesStore _prefs;

  List<Look> builtIn() => BuiltInLooks.all();

  List<Look> userLooks() {
    return _prefs
        .getJsonList(PreferencesStore.keySavedLooks)
        .map(Look.fromJson)
        .toList();
  }

  /// All looks, built-ins first.
  List<Look> all() => [...builtIn(), ...userLooks()];

  Future<void> _persist(List<Look> looks) => _prefs.setJsonList(
        PreferencesStore.keySavedLooks,
        looks.map((l) => l.toJson()).toList(),
      );

  Future<List<Look>> upsert(Look look) async {
    final looks = userLooks();
    final idx = looks.indexWhere((l) => l.id == look.id);
    if (idx >= 0) {
      looks[idx] = look;
    } else {
      looks.add(look);
    }
    await _persist(looks);
    return looks;
  }

  Future<List<Look>> delete(String id) async {
    final looks = userLooks()..removeWhere((l) => l.id == id);
    await _persist(looks);
    return looks;
  }

  Future<List<Look>> setFavorite(String id, bool favorite) async {
    final looks = userLooks();
    final idx = looks.indexWhere((l) => l.id == id);
    if (idx >= 0) {
      looks[idx] = looks[idx].copyWith(favorite: favorite);
      await _persist(looks);
    }
    return looks;
  }

  // ---- Last-applied appearance (restored on app restart) ----
  Future<void> saveLastApplied(FrameAppearance appearance) =>
      _prefs.setJson(
          PreferencesStore.keyLastAppliedAppearance, appearance.toJson());

  FrameAppearance? readLastApplied() {
    final json = _prefs.getJson(PreferencesStore.keyLastAppliedAppearance);
    return json == null ? null : FrameAppearance.fromJson(json);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../../core/models.dart';

/// Drift-backed store. SQL is explicit so the schema remains usable even when
/// source generation is unavailable on a contributor's machine.
class AppDatabase extends GeneratedDatabase {
  AppDatabase() : super(driftDatabase(name: 'shade_shifter'));
  final _changes = StreamController<void>.broadcast();
  @override
  int get schemaVersion => 1;
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => const [];
  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (m) async {
        await customStatement('''CREATE TABLE IF NOT EXISTS looks (
      id TEXT PRIMARY KEY NOT NULL, name TEXT NOT NULL CHECK(length(name) BETWEEN 1 AND 60),
      appearance_json TEXT NOT NULL, curated INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, schema_version INTEGER NOT NULL DEFAULT 1)''');
      });

  Future<void> seed() async {
    await customStatement('''CREATE TABLE IF NOT EXISTS looks (
      id TEXT PRIMARY KEY NOT NULL, name TEXT NOT NULL CHECK(length(name) BETWEEN 1 AND 60),
      appearance_json TEXT NOT NULL, curated INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, schema_version INTEGER NOT NULL DEFAULT 1)''');
    final now = DateTime.utc(2026, 1, 1);
    const seeds = [
      ('midnight', 'Midnight', 0xff17213a),
      ('champagne', 'Champagne', 0xffd6b36a),
      ('forest', 'Forest', 0xff315c47),
      ('ruby', 'Ruby', 0xff8f2533)
    ];
    for (final seed in seeds) {
      final zone = ZoneAppearance(primary: Color(seed.$3));
      await _upsert(
          Look(
              id: 'curated-${seed.$1}',
              name: seed.$2,
              appearance: FrameAppearance(
                  front: zone, leftTemple: zone, rightTemple: zone),
              curated: true,
              createdAt: now,
              updatedAt: now),
          ignore: true);
    }
  }

  Stream<List<Look>> watchLooks({String query = ''}) async* {
    yield await _read(query);
    await for (final _ in _changes.stream) {
      yield await _read(query);
    }
  }

  Future<List<Look>> _read(String query) async {
    final q = query.trim().toLowerCase();
    final rows = await customSelect(
        'SELECT * FROM looks WHERE lower(name) LIKE ? ORDER BY curated DESC, updated_at DESC',
        variables: [Variable<String>('%$q%')]).get();
    final output = <Look>[];
    for (final row in rows) {
      try {
        output.add(Look(
            id: row.read<String>('id'),
            name: row.read<String>('name'),
            appearance: FrameAppearance.fromJson(Map<String, Object?>.from(
                jsonDecode(row.read<String>('appearance_json')) as Map)),
            curated: row.read<int>('curated') == 1,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
                row.read<int>('created_at'),
                isUtc: true),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(
                row.read<int>('updated_at'),
                isUtc: true),
            schemaVersion: row.read<int>('schema_version')));
      } catch (_) {
        /* Skip malformed local rows; healthy looks remain usable. */
      }
    }
    return output;
  }

  Future<void> saveLook(Look look) async {
    await _upsert(look);
    _changes.add(null);
  }

  Future<void> _upsert(Look look, {bool ignore = false}) => customStatement(
          '''INSERT ${ignore ? 'OR IGNORE' : ''} INTO looks
    (id,name,appearance_json,curated,created_at,updated_at,schema_version) VALUES (?,?,?,?,?,?,?)
    ON CONFLICT(id) DO UPDATE SET name=excluded.name, appearance_json=excluded.appearance_json,
    curated=excluded.curated, updated_at=excluded.updated_at, schema_version=excluded.schema_version''',
          [
            look.id,
            look.name.trim(),
            jsonEncode(look.appearance.toJson()),
            look.curated ? 1 : 0,
            look.createdAt.millisecondsSinceEpoch,
            look.updatedAt.millisecondsSinceEpoch,
            look.schemaVersion
          ]);
  Future<void> deleteLook(String id) async {
    await customStatement(
        'DELETE FROM looks WHERE id = ? AND curated = 0', [id]);
    _changes.add(null);
  }

  @override
  Future<void> close() async {
    await _changes.close();
    await super.close();
  }
}

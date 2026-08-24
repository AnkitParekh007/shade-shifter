import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/providers.dart';
import '../../shared/models/appearance.dart';
import '../../shared/models/look.dart';
import 'data/looks_repository.dart';

/// Manages the combined built-in + user look collection.
class LooksController extends Notifier<List<Look>> {
  LooksRepository get _repo => ref.read(looksRepositoryProvider);

  @override
  List<Look> build() => _repo.all();

  void _refresh() => state = _repo.all();

  Future<Look> saveCurrent({
    required String name,
    required FrameAppearance appearance,
    required int capabilityVersion,
  }) async {
    final now = DateTime.now();
    final look = Look(
      id: 'user.${now.microsecondsSinceEpoch}',
      name: name.trim().isEmpty ? 'Untitled look' : name.trim(),
      appearance: appearance,
      createdAt: now,
      updatedAt: now,
      deviceCapabilityVersion: capabilityVersion,
    );
    await _repo.upsert(look);
    _refresh();
    return look;
  }

  Future<void> rename(Look look, String name) async {
    if (look.builtIn) return;
    await _repo.upsert(
      look.copyWith(name: name.trim(), updatedAt: DateTime.now()),
    );
    _refresh();
  }

  Future<Look> duplicate(Look look) async {
    final now = DateTime.now();
    final copy = Look(
      id: 'user.${now.microsecondsSinceEpoch}',
      name: '${look.name} copy',
      appearance: look.appearance,
      createdAt: now,
      updatedAt: now,
      deviceCapabilityVersion: look.deviceCapabilityVersion,
    );
    await _repo.upsert(copy);
    _refresh();
    return copy;
  }

  Future<void> toggleFavorite(Look look) async {
    if (look.builtIn) return; // Built-ins are not user-favoritable in the POC.
    await _repo.setFavorite(look.id, !look.favorite);
    _refresh();
  }

  Future<void> delete(Look look) async {
    if (look.builtIn) return;
    await _repo.delete(look.id);
    _refresh();
  }
}

final looksControllerProvider =
    NotifierProvider<LooksController, List<Look>>(LooksController.new);

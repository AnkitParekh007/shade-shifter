import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/di/providers.dart';
import 'app.dart';

/// Async composition root: resolves platform singletons (SharedPreferences),
/// installs Riverpod overrides and mounts the app. Kept separate from `main`
/// so tests can drive the same bootstrap with fakes.
Future<Widget> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const ShadeShifterApp(),
  );
}

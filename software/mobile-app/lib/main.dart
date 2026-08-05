import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app_v2.dart';
import 'src/looks/data/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  await database.seed();
  runApp(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const ShadeShifterApp()));
}

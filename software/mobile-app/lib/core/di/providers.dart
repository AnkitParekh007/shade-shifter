import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/looks/data/looks_repository.dart';
import '../persistence/preferences_store.dart';
import '../persistence/secure_device_store.dart';
import '../safety/safety_governor.dart';

/// Overridden in bootstrap with the resolved instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider not overridden'),
);

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ),
);

final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => PreferencesStore(ref.watch(sharedPreferencesProvider)),
);

final secureDeviceStoreProvider = Provider<SecureDeviceStore>(
  (ref) => SecureDeviceStore(ref.watch(secureStorageProvider)),
);

final looksRepositoryProvider = Provider<LooksRepository>(
  (ref) => LooksRepository(ref.watch(preferencesStoreProvider)),
);

final safetyGovernorProvider = Provider<SafetyGovernor>(
  (ref) => const SafetyGovernor(),
);

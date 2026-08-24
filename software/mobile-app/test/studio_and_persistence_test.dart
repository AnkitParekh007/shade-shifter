import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/di/providers.dart';
import 'package:shade_shifter/features/frame_control/studio_controller.dart';
import 'package:shade_shifter/features/looks/data/looks_repository.dart';
import 'package:shade_shifter/features/looks/looks_controller.dart';
import 'package:shade_shifter/shared/models/appearance.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> _container() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const red = RgbColor(255, 0, 0);
  const green = RgbColor(0, 255, 0);

  group('StudioController — independent zones', () {
    test('recoloring the front does not touch temple colors', () async {
      final container = await _container();
      addTearDown(container.dispose);
      final studio = container.read(studioControllerProvider.notifier);

      studio.setSelection(SelectionTarget.front);
      studio.setSolidColor(red);

      final state = container.read(studioControllerProvider);
      expect(state.appearance.zone(ZoneId.front).solidColor, red);
      expect(state.appearance.zone(ZoneId.leftTemple).solidColor,
          isNot(red));
      expect(state.appearance.zone(ZoneId.rightTemple).solidColor,
          isNot(red));
    });

    test('temple edits are isolated from the front', () async {
      final container = await _container();
      addTearDown(container.dispose);
      final studio = container.read(studioControllerProvider.notifier);

      studio.setSelection(SelectionTarget.front);
      studio.setSolidColor(red);
      studio.setSelection(SelectionTarget.leftTemple);
      studio.setSolidColor(green);

      final state = container.read(studioControllerProvider);
      expect(state.appearance.zone(ZoneId.front).solidColor, red);
      expect(state.appearance.zone(ZoneId.leftTemple).solidColor, green);
      expect(state.appearance.zone(ZoneId.rightTemple).solidColor,
          isNot(green));
    });

    test('intensity is clamped to the capability ceiling', () async {
      final container = await _container();
      addTearDown(container.dispose);
      final studio = container.read(studioControllerProvider.notifier);
      studio.setSelection(SelectionTarget.wholeFrame);
      studio.setIntensity(1.0);
      final state = container.read(studioControllerProvider);
      expect(state.appearance.zone(ZoneId.front).intensity,
          lessThanOrEqualTo(0.85));
    });
  });

  group('Looks persistence', () {
    test('last-applied appearance round-trips', () async {
      final container = await _container();
      addTearDown(container.dispose);
      final repo = container.read(looksRepositoryProvider);
      final appearance = FrameAppearance.initial().updateZones(
        [ZoneId.front],
        (a) => a.copyWith(solidColor: red),
      );
      await repo.saveLastApplied(appearance);

      // Fresh repository over the same persisted store (simulates a restart).
      final restored =
          LooksRepository(container.read(preferencesStoreProvider))
              .readLastApplied();
      expect(restored?.zone(ZoneId.front).solidColor, red);
    });

    test('saving a look persists it alongside built-ins', () async {
      final container = await _container();
      addTearDown(container.dispose);
      final looks = container.read(looksControllerProvider.notifier);
      final builtInCount = container.read(looksControllerProvider).length;

      await looks.saveCurrent(
        name: 'My Look',
        appearance: FrameAppearance.initial(),
        capabilityVersion: 1,
      );

      final all = container.read(looksControllerProvider);
      expect(all.length, builtInCount + 1);
      expect(all.any((l) => l.name == 'My Look'), isTrue);
    });
  });
}

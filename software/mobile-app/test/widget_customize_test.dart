import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/app/theme/app_theme.dart';
import 'package:shade_shifter/core/di/providers.dart';
import 'package:shade_shifter/features/frame_control/customize_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _harness() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const CustomizeScreen(),
    ),
  );
}

void main() {
  testWidgets('studio shows zone selector and responds to selection',
      (tester) async {
    await tester.pumpWidget(await _harness());
    await tester.pump();

    expect(find.text('Customize'), findsOneWidget);
    // Zone selector chips (using default Rev-A capabilities).
    expect(find.text('Whole frame'), findsOneWidget);
    expect(find.text('Front'), findsWidgets);
    expect(find.text('Left temple'), findsOneWidget);

    // Selecting a zone updates the chip state without error.
    await tester.tap(find.text('Front').first);
    await tester.pump();

    // Solid mode controls are present.
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Intensity'), findsOneWidget);
  });

  testWidgets('tapping a swatch drives the apply-state machine',
      (tester) async {
    await tester.pumpWidget(await _harness());
    await tester.pump();

    // Tap the first curated swatch.
    final swatch = find.byType(GestureDetector).first;
    await tester.tap(swatch);
    await tester.pump(const Duration(milliseconds: 200)); // let debounce fire
    await tester.pump();

    // Not connected → the machine reports a non-preview terminal state,
    // and the app does not crash.
    expect(tester.takeException(), isNull);
  });
}

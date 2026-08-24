import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shade_shifter/app/app.dart';
import 'package:shade_shifter/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end: first launch → onboarding → Try Simulator → customize.
/// Runs against the simulator transport, so no hardware is required.
///
/// NOTE: we use explicit `pump(duration)` rather than `pumpAndSettle` because
/// the splash progress indicator and the simulator's periodic telemetry are
/// continuous animations/timers that never "settle".
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first launch to simulator customization', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const ShadeShifterApp(),
      ),
    );

    // Splash → (900ms) → onboarding.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(milliseconds: 500));

    // Skip onboarding → pairing.
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Try the simulator.
    expect(find.text('Try the simulator'), findsOneWidget);
    await tester.tap(find.text('Try the simulator'));

    // Connect (~1.25s) + route transition.
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));

    // We reach the Home shell on the Customize tab.
    expect(find.text('Customize'), findsWidgets);
  });
}

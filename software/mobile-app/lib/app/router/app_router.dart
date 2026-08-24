import 'package:go_router/go_router.dart';

import '../../features/device_pairing/pairing_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/splash_screen.dart';

/// App route names, referenced by screens for navigation.
class Routes {
  const Routes._();
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const pairing = '/pairing';
  static const home = '/home';
}

GoRouter buildRouter() => GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(
          path: Routes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: Routes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: Routes.pairing,
          builder: (context, state) => const PairingScreen(),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomeShell(),
        ),
      ],
    );

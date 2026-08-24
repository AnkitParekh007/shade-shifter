import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/settings_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// Root widget. Wires the router, themes and honors the user's reduced-motion
/// and theme-mode settings.
class ShadeShifterApp extends ConsumerStatefulWidget {
  const ShadeShifterApp({super.key});

  @override
  ConsumerState<ShadeShifterApp> createState() => _ShadeShifterAppState();
}

class _ShadeShifterAppState extends ConsumerState<ShadeShifterApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp.router(
      title: 'Shade Shifter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: _router,
      builder: (context, child) {
        // Respect OS reduced-motion and the app's own toggle.
        final disableAnimations = settings.reducedMotion ||
            MediaQuery.maybeOf(context)?.disableAnimations == true;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: disableAnimations,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

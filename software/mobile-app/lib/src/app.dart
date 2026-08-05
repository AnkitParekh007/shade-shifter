import 'package:flutter/material.dart';

import 'core/theme/shade_theme.dart';
import 'device/application/frame_controller.dart';
import 'onboarding/presentation/onboarding_screen.dart';

class ShadeShifterApp extends StatelessWidget {
  const ShadeShifterApp({required this.controller, super.key});

  final FrameController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shade Shifter',
      debugShowCheckedModeBanner: false,
      theme: ShadeTheme.light,
      darkTheme: ShadeTheme.dark,
      themeMode: ThemeMode.system,
      home: OnboardingScreen(controller: controller),
    );
  }
}

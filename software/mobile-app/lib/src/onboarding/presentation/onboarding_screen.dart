import 'package:flutter/material.dart';

import '../../device/application/frame_controller.dart';
import '../../device/presentation/frame_studio_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({required this.controller, super.key});

  final FrameController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                'SHADE SHIFTER',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 18),
              Text(
                'One frame.\nEvery expression.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.03,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Discover color-changing eyewear with a complete simulator - no account or physical frame required.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => FrameStudioScreen(controller: controller),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Explore in simulator'),
              ),
              const SizedBox(height: 12),
              Text(
                'Guest mode keeps your first experience private and immediate.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

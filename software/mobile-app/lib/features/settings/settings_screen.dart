import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/design_tokens.dart';
import '../../shared/widgets/ui_kit.dart';
import '../device/device_controller.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ShadeTokens.space5),
          children: [
            const SectionHeader('Appearance'),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => controller.setThemeMode(s.first),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reduce motion'),
              subtitle: const Text('Minimise animations across the app.'),
              value: settings.reducedMotion,
              onChanged: controller.setReducedMotion,
            ),
            const SizedBox(height: ShadeTokens.space4),
            const SectionHeader('Safety'),
            const GlassCard(
              child: Row(children: [
                Icon(Icons.shield_outlined, color: ShadeTokens.warning),
                SizedBox(width: ShadeTokens.space3),
                Expanded(
                  child: Text(
                    'Shade Shifter is experimental hardware worn near the eyes. '
                    'The frame enforces its own safety limits; this app adds an '
                    'extra brightness ceiling.',
                  ),
                ),
              ]),
            ),
            const SizedBox(height: ShadeTokens.space3),
            Text('App brightness ceiling: ${(settings.userMaxBrightness * 100).round()}%',
                style: Theme.of(context).textTheme.labelLarge),
            Slider(
              value: settings.userMaxBrightness,
              min: 0.2,
              max: 1.0,
              divisions: 16,
              onChanged: controller.setUserMaxBrightness,
            ),
            const SizedBox(height: ShadeTokens.space4),
            const SectionHeader('Privacy'),
            const GlassCard(
              child: Text(
                'No account required. Your looks are stored on this device. '
                'Bluetooth is only used while pairing or controlling a frame, '
                'device identifiers are redacted from logs, and no advertising '
                'identifiers or location data are collected.',
              ),
            ),
            const SizedBox(height: ShadeTokens.space5),
            const SectionHeader('Device'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_outline,
                  color: ShadeTokens.danger),
              title: const Text('Forget paired device',
                  style: TextStyle(color: ShadeTokens.danger)),
              onTap: () =>
                  ref.read(deviceControllerProvider.notifier).forget(),
            ),
            const SizedBox(height: ShadeTokens.space5),
            Center(
              child: Text('Shade Shifter · POC 0.1.0',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: ShadeTokens.space6),
          ],
        ),
      ),
    );
  }
}

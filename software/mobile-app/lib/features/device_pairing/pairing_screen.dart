import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/theme/design_tokens.dart';
import '../../shared/widgets/ui_kit.dart';
import '../device/device_controller.dart';
import '../settings/settings_controller.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _trySimulator() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result =
        await ref.read(deviceControllerProvider.notifier).connectSimulator();
    if (!mounted) return;
    await ref.read(settingsControllerProvider.notifier).completeOnboarding();
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (_) => context.go(Routes.home),
      (err) => setState(() => _error = 'Could not start the simulator.'),
    );
  }

  Future<void> _pairFrame() async {
    // Physical BLE scanning/permissions land in Phase 3 (see
    // IMPLEMENTATION-STATUS.md). Until then this routes users to the simulator
    // rather than presenting a non-functional scan.
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _PairComingSoonSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pair your frame')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(ShadeTokens.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GlassCard(
                child: Row(
                  children: [
                    Icon(Icons.bluetooth_outlined,
                        color: ShadeTokens.spectral),
                    SizedBox(width: ShadeTokens.space3),
                    Expanded(
                      child: Text(
                        'Shade Shifter frames are controlled over Bluetooth. '
                        'We only request Bluetooth access when you choose to '
                        'pair — never in the background.',
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Center(
                child: Text('EXPERIMENTAL HARDWARE — POC',
                    style: TextStyle(
                        color: ShadeTokens.warning,
                        letterSpacing: 1.5,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: ShadeTokens.space4),
              FilledButton.icon(
                onPressed: _busy ? null : _pairFrame,
                icon: const Icon(Icons.bluetooth_searching),
                label: const Text('Pair a frame'),
              ),
              const SizedBox(height: ShadeTokens.space3),
              OutlinedButton.icon(
                onPressed: _busy ? null : _trySimulator,
                icon: _busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.smart_toy_outlined),
                label: Text(_busy ? 'Starting simulator…' : 'Try the simulator'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(64, 52),
                  shape: const StadiumBorder(),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: ShadeTokens.space3),
                Text(_error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: ShadeTokens.danger)),
              ],
              const SizedBox(height: ShadeTokens.space4),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairComingSoonSheet extends StatelessWidget {
  const _PairComingSoonSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ShadeTokens.space5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Physical pairing',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: ShadeTokens.space3),
          const Text(
            'Live BLE scanning and permission handling arrive with the Phase 3 '
            'transport. The full customization experience is available today '
            'through the simulator, which mirrors real device behaviour.',
          ),
          const SizedBox(height: ShadeTokens.space5),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ),
        ],
      ),
    );
  }
}

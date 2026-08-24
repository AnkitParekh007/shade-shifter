import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/theme/design_tokens.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_presentation.dart';
import '../../shared/models/device_state.dart';
import '../../shared/widgets/ui_kit.dart';
import '../device/device_controller.dart';
import '../device/transport_factory.dart';
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
    // Live BLE scan. Bluetooth permission is requested here — on an explicit
    // user action — and never at startup (see PRIVACY-NOTES.md).
    final connected = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _ScanSheet(),
    );
    if (connected != true || !mounted) return;
    await ref.read(settingsControllerProvider.notifier).completeOnboarding();
    if (!mounted) return;
    context.go(Routes.home);
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

/// Live scan + connect. Pops `true` once a frame is connected.
class _ScanSheet extends ConsumerStatefulWidget {
  const _ScanSheet();

  @override
  ConsumerState<_ScanSheet> createState() => _ScanSheetState();
}

class _ScanSheetState extends ConsumerState<_ScanSheet> {
  bool _scanning = false;
  String? _connectingId;
  List<DeviceRef> _devices = const [];
  AppError? _error;

  @override
  void initState() {
    super.initState();
    // Scan as soon as the sheet opens — opening it *is* the user's consent.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scan());
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _error = null;
      _devices = const [];
    });
    final result =
        await ref.read(deviceControllerProvider.notifier).scanForFrames();
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _devices = result.valueOrNull ?? const [];
      _error = result.errorOrNull;
    });
  }

  Future<void> _connect(DeviceRef device) async {
    setState(() {
      _connectingId = device.id;
      _error = null;
    });
    final result =
        await ref.read(deviceControllerProvider.notifier).connect(device);
    if (!mounted) return;
    setState(() => _connectingId = null);
    final error = result.errorOrNull;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(true);
  }

  Future<void> _recover(ErrorPresentation presentation) async {
    if (presentation.opensSettings) {
      await ref.read(transportFactoryProvider).openSystemSettings();
      return;
    }
    await _scan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final error = _error;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          ShadeTokens.space5,
          0,
          ShadeTokens.space5,
          ShadeTokens.space5,
        ),
        // Scrollable so a long result list (or a small screen) never overflows.
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Row(
              children: [
                Expanded(
                  child: Text('Nearby frames',
                      style: theme.textTheme.titleLarge),
                ),
                if (_scanning)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: ShadeTokens.space3),
            Text(
              _scanning
                  ? 'Looking for frames in range…'
                  : 'Make sure your frame is powered on and nearby.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: ShadeTokens.space4),
            if (error != null) ...[
              _ErrorNotice(
                presentation: ErrorPresentation.of(error),
                onAction: _recover,
              ),
              const SizedBox(height: ShadeTokens.space4),
            ],
            ..._devices.map(
              (device) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.bluetooth_outlined,
                    color: ShadeTokens.spectral),
                title: Text(device.name),
                subtitle: Text(device.rssi == null
                    ? 'Signal unknown'
                    : 'Signal ${device.rssi} dBm'),
                trailing: _connectingId == device.id
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap:
                    _connectingId == null ? () => _connect(device) : null,
              ),
            ),
            if (!_scanning && _devices.isEmpty && error == null) ...[
              const Text('No frames found yet.'),
              const SizedBox(height: ShadeTokens.space3),
            ],
            const SizedBox(height: ShadeTokens.space3),
              OutlinedButton.icon(
                onPressed: _scanning || _connectingId != null ? null : _scan,
                icon: const Icon(Icons.refresh),
                label: const Text('Scan again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A recoverable error with its one suggested next step.
class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.presentation, required this.onAction});

  final ErrorPresentation presentation;
  final Future<void> Function(ErrorPresentation) onAction;

  @override
  Widget build(BuildContext context) {
    final label = presentation.actionLabel;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(presentation.message),
          if (label != null) ...[
            const SizedBox(height: ShadeTokens.space3),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: () => onAction(presentation),
                child: Text(label),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

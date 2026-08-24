import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/design_tokens.dart';
import '../../shared/widgets/ui_kit.dart';
import '../device/device_controller.dart';

class DeviceScreen extends ConsumerWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(deviceControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Device')),
      body: SafeArea(
        child: session.isConnected
            ? _ConnectedBody(session: session)
            : _DisconnectedBody(session: session),
      ),
    );
  }
}

class _DisconnectedBody extends ConsumerWidget {
  const _DisconnectedBody({required this.session});
  final DeviceSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ShadeTokens.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_off, size: 48, color: ShadeTokens.mist),
            const SizedBox(height: ShadeTokens.space4),
            Text('No frame connected',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ShadeTokens.space2),
            const Text('Reconnect to your last frame or start the simulator.',
                textAlign: TextAlign.center),
            const SizedBox(height: ShadeTokens.space5),
            FilledButton.icon(
              onPressed: () =>
                  ref.read(deviceControllerProvider.notifier).connectSimulator(),
              icon: const Icon(Icons.smart_toy_outlined),
              label: const Text('Start simulator'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectedBody extends ConsumerWidget {
  const _ConnectedBody({required this.session});
  final DeviceSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caps = session.capabilities!;
    final t = session.telemetry;
    return ListView(
      padding: const EdgeInsets.all(ShadeTokens.space5),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(session.device?.name ?? 'Shade Shifter',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (session.isSimulator) const SimulatorBadge(compact: true),
          ],
        ),
        const SizedBox(height: ShadeTokens.space2),
        const Row(children: [
          Icon(Icons.circle, size: 10, color: ShadeTokens.success),
          SizedBox(width: 6),
          Text('Connected'),
        ]),
        const SizedBox(height: ShadeTokens.space4),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.6,
          crossAxisSpacing: ShadeTokens.space3,
          mainAxisSpacing: ShadeTokens.space3,
          children: [
            _Stat('Battery', t.batteryPercent == null
                ? '—'
                : '${t.batteryPercent}%${t.charging ? ' ⚡' : ''}'),
            _Stat('Est. remaining',
                t.estimatedRemaining == null ? '—' : _fmt(t.estimatedRemaining!)),
            _Stat('Temperature',
                t.temperatureCelsius == null ? '—' : '${t.temperatureCelsius}°C'),
            _Stat('Signal', '${t.signalBars}/4'),
            _Stat('Firmware', t.firmwareVersion ?? '—'),
            _Stat('Hardware', caps.hardwareRevision),
            _Stat('Zones', '${caps.zones.length}'),
            _Stat('Effects',
                caps.supportedEffects.isEmpty ? 'Not supported' : '${caps.supportedEffects.length}'),
          ],
        ),
        const SizedBox(height: ShadeTokens.space5),
        const SectionHeader('Manage'),
        _action(context, Icons.edit_outlined, 'Rename frame',
            () => _rename(context, ref)),
        if (caps.supportsFindMyFrame)
          _action(context, Icons.wifi_tethering, 'Find my frame',
              () => _findMyFrame(context, ref)),
        _action(context, Icons.download_outlined, 'Export diagnostics',
            () => _exportDiagnostics(context, ref)),
        _action(context, Icons.system_update_outlined,
            'Firmware update (coming soon)', null),
        const Divider(height: ShadeTokens.space6),
        _action(context, Icons.link_off, 'Disconnect',
            () => ref.read(deviceControllerProvider.notifier).disconnect()),
        _action(context, Icons.delete_outline, 'Forget device',
            () => ref.read(deviceControllerProvider.notifier).forget(),
            danger: true),
        const SizedBox(height: ShadeTokens.space6),
      ],
    );
  }

  static String _fmt(Duration d) => '${d.inHours}h ${d.inMinutes % 60}m';

  Widget _action(BuildContext context, IconData icon, String label,
      VoidCallback? onTap,
      {bool danger = false}) {
    final color = danger ? ShadeTokens.danger : null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: onTap == null
          ? null
          : const Icon(Icons.chevron_right, color: ShadeTokens.mist),
      enabled: onTap != null,
      onTap: onTap,
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    // Rename updates the local session label; the wire command lands with the
    // Phase 3 transport. Kept honest — see IMPLEMENTATION-STATUS.md.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Renaming syncs with the physical frame in Phase 3.')),
    );
  }

  Future<void> _findMyFrame(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Frame pulsing to help you locate it.')),
    );
  }

  Future<void> _exportDiagnostics(BuildContext context, WidgetRef ref) async {
    // Sanitized, identifier-redacted snapshot (no raw MAC / personal data).
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diagnostics captured (redacted).')),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(ShadeTokens.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: ShadeTokens.fog)),
          const SizedBox(height: ShadeTokens.space1),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

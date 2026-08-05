import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'core/models.dart';
import 'core/theme/shade_theme.dart';
import 'device/application/studio_controller.dart';
import 'looks/data/app_database.dart';
import 'preview/presentation/frame_preview.dart';

final databaseProvider =
    Provider<AppDatabase>((_) => throw UnimplementedError());
final looksProvider = StreamProvider<List<Look>>(
    (ref) => ref.watch(databaseProvider).watchLooks());

class ShadeShifterApp extends StatelessWidget {
  const ShadeShifterApp({super.key});
  static final router = GoRouter(initialLocation: '/splash', routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/pair', builder: (_, __) => const PairScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeShell()),
  ]);
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      title: 'Shade Shifter',
      debugShowCheckedModeBanner: false,
      theme: ShadeTheme.light,
      darkTheme: ShadeTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      final done = (await SharedPreferences.getInstance())
              .getBool('onboarding_complete') ??
          false;
      if (mounted) context.go(done ? '/pair' : '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.visibility_outlined,
            size: 72, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 20),
        Text('SHADE SHIFTER',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(letterSpacing: 4)),
        const SizedBox(height: 12),
        const Text('Color, made wearable.'),
        const SizedBox(height: 32),
        const CircularProgressIndicator()
      ])));
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends State<OnboardingScreen> {
  final page = PageController();
  int index = 0;
  static const items = [
    (
      Icons.palette_outlined,
      'Your frame. Your palette.',
      'Style three frame zones with colors, gradients and subtle effects.'
    ),
    (
      Icons.bluetooth_searching,
      'Connect when ready',
      'Use the full simulator now, then pair your physical frame over Bluetooth.'
    ),
    (
      Icons.health_and_safety_outlined,
      'Designed with care',
      'Clear thermal warnings and a prominent off control keep safety visible.'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Align(
                alignment: Alignment.centerRight,
                child:
                    TextButton(onPressed: _finish, child: const Text('Skip'))),
            Expanded(
                child: PageView(
                    controller: page,
                    onPageChanged: (i) => setState(() => index = i),
                    children: [for (final item in items) _Intro(item: item)])),
            Row(children: [
              for (var i = 0; i < items.length; i++)
                Container(
                    width: i == index ? 28 : 8,
                    height: 8,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: i == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8))),
              const Spacer(),
              FilledButton(
                  onPressed: () => index == 2
                      ? _finish()
                      : page.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut),
                  child: Text(index == 2 ? 'Get started' : 'Next')),
            ]),
          ]),
        ),
      ),
    );
  }

  Future<void> _finish() async {
    await (await SharedPreferences.getInstance())
        .setBool('onboarding_complete', true);
    if (mounted) context.go('/pair');
  }
}

class _Intro extends StatelessWidget {
  const _Intro({required this.item});
  final (IconData, String, String) item;
  @override
  Widget build(BuildContext c) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(item.$1, size: 100, color: Theme.of(c).colorScheme.primary),
        const SizedBox(height: 36),
        Text(item.$2,
            textAlign: TextAlign.center,
            style: Theme.of(c).textTheme.headlineMedium),
        const SizedBox(height: 16),
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(item.$3,
                textAlign: TextAlign.center,
                style: Theme.of(c).textTheme.bodyLarge))
      ]);
}

class PairScreen extends ConsumerWidget {
  const PairScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(studioProvider);
    ref.listen(studioProvider, (a, b) {
      if (b.status.phase == ConnectionPhase.connected) context.go('/home');
    });
    return Scaffold(
        appBar: AppBar(title: const Text('Connect your frame')),
        body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(24), children: [
          const Icon(Icons.bluetooth_searching, size: 88),
          const SizedBox(height: 24),
          Text('Bluetooth, with context',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          const Text(
              'Bluetooth is used only to find and control a nearby Shade Shifter frame. Location is never collected.',
              textAlign: TextAlign.center),
          if (s.status.phase == ConnectionPhase.scanning ||
              s.status.phase == ConnectionPhase.connecting) ...[
            const SizedBox(height: 28),
            const LinearProgressIndicator(),
            const SizedBox(height: 10),
            Text(
                s.status.phase == ConnectionPhase.scanning
                    ? 'Looking for Shade Shifter…'
                    : 'Connecting securely…',
                textAlign: TextAlign.center)
          ],
          if (s.error != null || s.status.error != null)
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(s.error ?? s.status.error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 32),
          FilledButton.icon(
              onPressed: s.status.phase == ConnectionPhase.scanning
                  ? null
                  : () => ref.read(studioProvider.notifier).connect(),
              icon: const Icon(Icons.science_outlined),
              label: const Text('Try simulator')),
          const SizedBox(height: 12),
          OutlinedButton.icon(
              onPressed: () =>
                  ref.read(studioProvider.notifier).connectPhysical(),
              icon: const Icon(Icons.bluetooth),
              label: const Text('Pair physical frame')),
          const SizedBox(height: 18),
          const Text(
              'The physical frame option uses the Rev A three-byte RGB protocol. Unsupported controls will be clearly disabled.',
              textAlign: TextAlign.center),
        ])));
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  static const pages = [
    CustomizeScreen(),
    LooksScreen(),
    DeviceScreen(),
    SettingsScreen()
  ];
  @override
  Widget build(BuildContext c) => Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.tune), label: 'Customize'),
            NavigationDestination(
                icon: Icon(Icons.auto_awesome), label: 'Looks'),
            NavigationDestination(icon: Icon(Icons.memory), label: 'Device'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined), label: 'Settings')
          ]));
}

class CustomizeScreen extends ConsumerWidget {
  const CustomizeScreen({super.key});
  static const colors = [
    Color(0xff284b63),
    Color(0xff9b2226),
    Color(0xffca6702),
    Color(0xff3a5a40),
    Color(0xff6d597a),
    Color(0xffd6b36a),
    Colors.black,
    Colors.white
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(studioProvider), n = ref.read(studioProvider.notifier);
    return Scaffold(
        appBar: AppBar(title: const Text('Customize'), actions: [
          IconButton(
              tooltip: 'Undo',
              onPressed: s.undo.isEmpty ? null : n.undo,
              icon: const Icon(Icons.undo)),
          IconButton(
              tooltip: 'Redo',
              onPressed: s.redo.isEmpty ? null : n.redo,
              icon: const Icon(Icons.redo)),
          IconButton(
              tooltip: 'Turn frame off',
              onPressed: n.off,
              icon: const Icon(Icons.power_settings_new))
        ]),
        body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(20), children: [
          SizedBox(
              height: 220,
              child: FramePreview(
                  appearance: s.appearance, onZoneSelected: n.selectZone)),
          Row(children: [
            Text('Live preview',
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            if (s.sending)
              const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 8),
            Chip(
                label: Text(s.status.phase == ConnectionPhase.connected
                    ? 'Connected'
                    : 'Preview only'))
          ]),
          const SizedBox(height: 16),
          SegButton<FrameZone>(value: s.selectedZone, onChanged: n.selectZone),
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Link all zones'),
              subtitle: Text(s.capabilities.independentZones
                  ? 'Apply edits across the frame'
                  : 'Required by Rev A hardware'),
              value: s.appearance.linked || !s.capabilities.independentZones,
              onChanged: s.capabilities.independentZones ? n.setLinked : null),
          Text('Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            for (final c in colors)
              Semantics(
                  label: 'Choose color ${c.toARGB32().toRadixString(16)}',
                  button: true,
                  child: InkWell(
                      onTap: () => n.setColor(c),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 2)))))
          ]),
          const SizedBox(height: 20),
          HexColorField(onColor: n.setColor),
          const SizedBox(height: 20),
          Text('Intensity ${(s.appearance.intensity * 100).round()}%',
              style: Theme.of(context).textTheme.titleMedium),
          Slider(
              value: s.appearance.intensity,
              min: 0,
              max: .65,
              divisions: 65,
              label: '${(s.appearance.intensity * 100).round()}%',
              onChanged: s.capabilities.intensity ? n.setIntensity : null),
          if (!s.capabilities.gradients)
            const InfoCard(
                text:
                    'Gradients, effects, independent zones, and app brightness are unavailable on Rev A. Firmware keeps its own 12.5% safety ceiling.'),
          if (s.error != null) InfoCard(text: s.error!),
          const SizedBox(height: 80)
        ])));
  }
}

class SegButton<T> extends StatelessWidget {
  const SegButton({required this.value, required this.onChanged, super.key});
  final FrameZone value;
  final ValueChanged<FrameZone> onChanged;
  @override
  Widget build(BuildContext c) => SegmentedButton<FrameZone>(segments: const [
        ButtonSegment(value: FrameZone.whole, label: Text('All')),
        ButtonSegment(value: FrameZone.front, label: Text('Front')),
        ButtonSegment(value: FrameZone.leftTemple, label: Text('Left')),
        ButtonSegment(value: FrameZone.rightTemple, label: Text('Right'))
      ], selected: {
        value
      }, onSelectionChanged: (v) => onChanged(v.first));
}

class HexColorField extends StatefulWidget {
  const HexColorField({required this.onColor, super.key});
  final ValueChanged<Color> onColor;
  @override
  State<HexColorField> createState() => _HexState();
}

class _HexState extends State<HexColorField> {
  final c = TextEditingController();
  @override
  Widget build(BuildContext x) => TextField(
      controller: c,
      maxLength: 7,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[#0-9a-fA-F]'))
      ],
      decoration: InputDecoration(
          labelText: 'Hex color',
          hintText: '#284B63',
          suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                final v = c.text.replaceAll('#', '');
                if (RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(v)) {
                  widget.onColor(Color(int.parse('ff$v', radix: 16)));
                }
              })));
}

class InfoCard extends StatelessWidget {
  const InfoCard({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext c) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(text))
          ])));
}

class LooksScreen extends ConsumerWidget {
  const LooksScreen({super.key});
  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final looks = ref.watch(looksProvider), studio = ref.watch(studioProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Looks'), actions: [
          IconButton(
              tooltip: 'Save current look',
              icon: const Icon(Icons.add),
              onPressed: () => _save(c, ref, studio.appearance))
        ]),
        body: looks.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Could not load looks: $e')),
            data: (items) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (c, i) {
                  final l = items[i];
                  return Card(
                      child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: l.appearance.front.primary),
                          title: Text(l.name),
                          subtitle:
                              Text(l.curated ? 'Curated look' : 'Saved look'),
                          onTap: () {
                            ref
                                .read(studioProvider.notifier)
                                .applyLook(l.appearance);
                            ScaffoldMessenger.of(c).showSnackBar(
                                SnackBar(content: Text('${l.name} applied')));
                          },
                          trailing: l.curated
                              ? const Icon(Icons.auto_awesome)
                              : PopupMenuButton<String>(
                                  onSelected: (v) {
                                    if (v == 'duplicate') {
                                      _duplicate(ref, l);
                                    }
                                    if (v == 'delete') {
                                      ref
                                          .read(databaseProvider)
                                          .deleteLook(l.id);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                        PopupMenuItem(
                                            value: 'duplicate',
                                            child: Text('Duplicate')),
                                        PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'))
                                      ])));
                })));
  }

  Future<void> _save(BuildContext c, WidgetRef ref, FrameAppearance a) async {
    final t = TextEditingController();
    final ok = await showDialog<bool>(
        context: c,
        builder: (c) => AlertDialog(
                title: const Text('Save this look'),
                content: TextField(
                    controller: t,
                    autofocus: true,
                    maxLength: 60,
                    decoration: const InputDecoration(labelText: 'Name')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(c, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(c, true),
                      child: const Text('Save'))
                ]));
    if (ok == true && t.text.trim().isNotEmpty) {
      final now = DateTime.now().toUtc();
      await ref.read(databaseProvider).saveLook(Look(
          id: const Uuid().v4(),
          name: t.text.trim(),
          appearance: a,
          createdAt: now,
          updatedAt: now));
    }
  }

  Future<void> _duplicate(WidgetRef ref, Look l) async {
    final now = DateTime.now().toUtc();
    await ref.read(databaseProvider).saveLook(Look(
        id: const Uuid().v4(),
        name: '${l.name} copy',
        appearance: l.appearance,
        createdAt: now,
        updatedAt: now));
  }
}

class DeviceScreen extends ConsumerWidget {
  const DeviceScreen({super.key});
  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final s = ref.watch(studioProvider);
    final d = s.status;
    return Scaffold(
        appBar: AppBar(title: const Text('Device')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          StatusBanner(status: d),
          _Tile('Frame', d.name),
          _Tile('Firmware', d.firmware),
          _Tile('Protocol', s.capabilities.profile.name),
          _Tile(
              'Battery',
              d.batteryPercent == null
                  ? 'Not reported'
                  : '${d.batteryPercent}%'),
          _Tile(
              'Temperature',
              d.temperatureCelsius == null
                  ? 'Not reported'
                  : '${d.temperatureCelsius!.toStringAsFixed(1)} °C'),
          _Tile('Signal', d.rssi == null ? 'Not reported' : '${d.rssi} dBm'),
          _Tile(
              'Last acknowledged command',
              s.capabilities.acknowledgements
                  ? '#${d.sequence}'
                  : 'Not supported'),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
              onPressed: ref.read(studioProvider.notifier).off,
              icon: const Icon(Icons.power_settings_new),
              label: const Text('Turn frame off')),
          const SizedBox(height: 10),
          OutlinedButton(
              onPressed: () => ref.read(studioProvider.notifier).disconnect(),
              child: const Text('Disconnect'))
        ]));
  }
}

class StatusBanner extends StatelessWidget {
  const StatusBanner({required this.status, super.key});
  final FrameDeviceStatus status;
  @override
  Widget build(BuildContext c) {
    final warning = status.safety != SafetyState.normal;
    return Card(
        color: warning ? Theme.of(c).colorScheme.errorContainer : null,
        child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [
              Icon(warning ? Icons.thermostat : Icons.check_circle_outline),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(status.safety == SafetyState.shutdown
                      ? 'Thermal shutdown — remove the frame and let it cool'
                      : status.safety == SafetyState.warning
                          ? 'Frame temperature is elevated'
                          : '${status.phase.name} • ${status.simulator ? 'Simulator' : 'Physical frame'}'))
            ])));
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.a, this.b);
  final String a, b;
  @override
  Widget build(BuildContext c) => ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(a),
      trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 210),
          child: Text(b, textAlign: TextAlign.end)));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext c) => Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: [
        const ListTile(
            leading: Icon(Icons.brightness_6_outlined),
            title: Text('Appearance'),
            subtitle: Text('Follows your device light or dark theme')),
        const ListTile(
            leading: Icon(Icons.accessibility_new),
            title: Text('Accessibility'),
            subtitle: Text(
                'Supports large text, screen readers, and reduced motion')),
        const ListTile(
            leading: Icon(Icons.health_and_safety_outlined),
            title: Text('Safety'),
            subtitle: Text('Warning at 38 °C • shutdown indication at 40 °C')),
        const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy'),
            subtitle: Text(
                'Local-only. No account, analytics, ads, or cloud storage.')),
        ListTile(
            leading: const Icon(Icons.copy_all),
            title: const Text('Copy diagnostics'),
            onTap: () {
              Clipboard.setData(const ClipboardData(
                  text:
                      'Shade Shifter 0.1.0\nMode: simulator\nProtocol: simulator'));
              ScaffoldMessenger.of(c).showSnackBar(
                  const SnackBar(content: Text('Diagnostics copied')));
            }),
        ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Show onboarding again'),
            onTap: () async {
              (await SharedPreferences.getInstance())
                  .remove('onboarding_complete');
              if (c.mounted) c.go('/onboarding');
            }),
        const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: 'Shade Shifter',
            applicationVersion: '0.1.0',
            applicationLegalese:
                'Proof-of-concept companion app. Firmware safety controls remain authoritative.')
      ]));
}

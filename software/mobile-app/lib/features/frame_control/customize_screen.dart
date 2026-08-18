import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/design_tokens.dart';
import '../../core/utils/color_utils.dart';
import '../../shared/models/appearance.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/rgb_color.dart';
import '../../shared/models/zone.dart';
import '../../shared/widgets/frame_preview.dart';
import '../../shared/widgets/ui_kit.dart';
import '../device/device_controller.dart';
import '../looks/looks_controller.dart';
import 'studio_controller.dart';

/// Curated swatches inspired by premium frame finishes.
const _swatches = <RgbColor>[
  RgbColor(18, 18, 22), // Obsidian
  RgbColor(196, 202, 214), // Arctic silver
  RgbColor(124, 92, 255), // Electric violet
  RgbColor(52, 224, 198), // Aqua
  RgbColor(255, 122, 69), // Sunset
  RgbColor(232, 168, 184), // Rose quartz
  RgbColor(26, 42, 76), // Corporate navy
  RgbColor(240, 240, 245), // Porcelain
  RgbColor(212, 175, 55), // Gold
  RgbColor(80, 200, 120), // Emerald
  RgbColor(220, 60, 80), // Crimson
  RgbColor(40, 40, 48), // Graphite
];

class CustomizeScreen extends ConsumerWidget {
  const CustomizeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(deviceControllerProvider);
    final studio = ref.watch(studioControllerProvider);
    final controller = ref.read(studioControllerProvider.notifier);
    final caps = session.capabilities ?? DeviceCapabilities.revA;
    final current = studio.representativeForSelection(caps.zones);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: ShadeTokens.space4),
            child: Center(child: ApplyStatusChip(studio.phase)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: ShadeTokens.space5),
          children: [
            if (session.isSimulator)
              const Padding(
                padding: EdgeInsets.only(bottom: ShadeTokens.space3),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: SimulatorBadge(compact: true)),
              ),
            // ---- Preview ----
            AspectRatio(
              aspectRatio: 16 / 9,
              child: GlassCard(
                child: FramePreview(
                  appearance: studio.appearance,
                  supportedZones: caps.zones,
                  selection: studio.selection,
                  onSelectZone: controller.setSelection,
                ),
              ),
            ),
            const SizedBox(height: ShadeTokens.space4),
            _ZoneSelector(
              selection: studio.selection,
              supported: caps.zones,
              onChanged: controller.setSelection,
            ),
            if (studio.notices.isNotEmpty) ...[
              const SizedBox(height: ShadeTokens.space3),
              _SafetyNotices(studio.notices.map((n) => n.message).toList()),
            ],
            const SizedBox(height: ShadeTokens.space4),
            _ModeTabs(
              mode: current.mode,
              gradientSupported: caps.supportsGradient,
              onChanged: controller.setMode,
            ),
            const SizedBox(height: ShadeTokens.space4),
            if (current.mode == AppearanceMode.solid)
              _SolidControls(current: current, controller: controller)
            else
              _GradientControls(current: current, controller: controller),
            const SizedBox(height: ShadeTokens.space5),
            _IntensitySlider(
              value: current.intensity,
              max: caps.maxIntensity,
              onChanged: controller.setIntensity,
            ),
            const SizedBox(height: ShadeTokens.space5),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _saveLook(context, ref),
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text('Save look'),
                  ),
                ),
                const SizedBox(width: ShadeTokens.space3),
                IconButton.filledTonal(
                  onPressed: controller.emergencyOff,
                  tooltip: 'Turn illumination off',
                  icon: const Icon(Icons.power_settings_new),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        ShadeTokens.danger.withValues(alpha: 0.15),
                    foregroundColor: ShadeTokens.danger,
                    minimumSize: const Size(52, 52),
                  ),
                ),
              ],
            ),
            const SizedBox(height: ShadeTokens.space6),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLook(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save look'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Look name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name == null) return;
    final studio = ref.read(studioControllerProvider);
    final caps = ref.read(deviceControllerProvider).capabilities ??
        DeviceCapabilities.revA;
    await ref.read(looksControllerProvider.notifier).saveCurrent(
          name: name,
          appearance: studio.appearance,
          capabilityVersion: caps.capabilityVersion,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved "${name.isEmpty ? 'Untitled' : name}"')),
      );
    }
  }
}

class _ZoneSelector extends StatelessWidget {
  const _ZoneSelector({
    required this.selection,
    required this.supported,
    required this.onChanged,
  });
  final SelectionTarget selection;
  final List<ZoneId> supported;
  final ValueChanged<SelectionTarget> onChanged;

  @override
  Widget build(BuildContext context) {
    final targets = SelectionTarget.values
        .where((t) => t.resolve(supported).isNotEmpty)
        .toList();
    return Wrap(
      spacing: ShadeTokens.space2,
      runSpacing: ShadeTokens.space2,
      children: targets.map((t) {
        final selected = t == selection;
        return ChoiceChip(
          label: Text(t.label),
          selected: selected,
          onSelected: (_) => onChanged(t),
        );
      }).toList(),
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({
    required this.mode,
    required this.gradientSupported,
    required this.onChanged,
  });
  final AppearanceMode mode;
  final bool gradientSupported;
  final ValueChanged<AppearanceMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppearanceMode>(
      segments: const [
        ButtonSegment(
            value: AppearanceMode.solid,
            label: Text('Solid'),
            icon: Icon(Icons.circle)),
        ButtonSegment(
            value: AppearanceMode.gradient,
            label: Text('Gradient'),
            icon: Icon(Icons.gradient)),
      ],
      selected: {mode},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _SolidControls extends StatelessWidget {
  const _SolidControls({required this.current, required this.controller});
  final ZoneAppearance current;
  final StudioController controller;

  @override
  Widget build(BuildContext context) {
    final (hue, _, _) = ColorUtils.toHsv(current.solidColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SectionHeader('Color'),
            const Spacer(),
            Text(current.solidColor.hex,
                style: const TextStyle(
                    letterSpacing: 1, color: ShadeTokens.fog)),
          ],
        ),
        _SwatchGrid(
          selected: current.solidColor,
          onSelected: controller.setSolidColor,
        ),
        const SizedBox(height: ShadeTokens.space4),
        Text('Hue', style: Theme.of(context).textTheme.labelLarge),
        Slider(
          value: hue,
          max: 360,
          onChanged: (h) =>
              controller.setSolidColor(ColorUtils.fromHsv(h, 0.85, 0.95)),
        ),
        const SizedBox(height: ShadeTokens.space2),
        Text('Shades', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: ShadeTokens.space2),
        _ShadeRow(base: current.solidColor, onSelected: controller.setSolidColor),
      ],
    );
  }
}

class _GradientControls extends StatelessWidget {
  const _GradientControls({required this.current, required this.controller});
  final ZoneAppearance current;
  final StudioController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Start color'),
        _SwatchGrid(
          selected: current.gradientStart,
          onSelected: (c) => controller.setGradient(start: c),
        ),
        const SizedBox(height: ShadeTokens.space4),
        const SectionHeader('End color'),
        _SwatchGrid(
          selected: current.gradientEnd,
          onSelected: (c) => controller.setGradient(end: c),
        ),
        const SizedBox(height: ShadeTokens.space4),
        Text('Direction', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: ShadeTokens.space2),
        Wrap(
          spacing: ShadeTokens.space2,
          children: GradientDirection.values.map((d) {
            return ChoiceChip(
              label: Text(d.label),
              selected: current.gradientDirection == d,
              onSelected: (_) => controller.setGradient(direction: d),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SwatchGrid extends StatelessWidget {
  const _SwatchGrid({required this.selected, required this.onSelected});
  final RgbColor selected;
  final ValueChanged<RgbColor> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: ShadeTokens.space3,
      runSpacing: ShadeTokens.space3,
      children: _swatches.map((c) {
        final isSelected = c == selected;
        return GestureDetector(
          onTap: () => onSelected(c),
          child: Semantics(
            label: 'Color ${c.hex}',
            selected: isSelected,
            button: true,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.toColor(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ShadeTokens.spectral
                      : Colors.white.withValues(alpha: 0.15),
                  width: isSelected ? 3 : 1,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check,
                      size: 18,
                      color: c.luminance > 0.4
                          ? Colors.black
                          : Colors.white)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ShadeRow extends StatelessWidget {
  const _ShadeRow({required this.base, required this.onSelected});
  final RgbColor base;
  final ValueChanged<RgbColor> onSelected;

  @override
  Widget build(BuildContext context) {
    final shades = [
      ...ColorUtils.darker(base, count: 3).reversed,
      base,
      ...ColorUtils.lighter(base, count: 3),
    ];
    return Row(
      children: shades.map((c) {
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(c),
            child: Container(
              height: 34,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: c.toColor(),
                borderRadius: BorderRadius.circular(ShadeTokens.radiusSm),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _IntensitySlider extends StatelessWidget {
  const _IntensitySlider({
    required this.value,
    required this.max,
    required this.onChanged,
  });
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Intensity', style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            Text('${(value * 100).round()}%',
                style: const TextStyle(color: ShadeTokens.fog)),
          ],
        ),
        Slider(
          value: value.clamp(0.0, max),
          max: max,
          divisions: 20,
          label: '${(value * 100).round()}%',
          onChanged: onChanged,
        ),
        Text('Max ${(max * 100).round()}% (set by frame)',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SafetyNotices extends StatelessWidget {
  const _SafetyNotices(this.messages);
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ShadeTokens.space3),
      decoration: BoxDecoration(
        color: ShadeTokens.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ShadeTokens.radiusSm),
        border: Border.all(color: ShadeTokens.warning.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messages
            .map((m) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined,
                        size: 16, color: ShadeTokens.warning),
                    const SizedBox(width: ShadeTokens.space2),
                    Expanded(
                        child: Text(m,
                            style: const TextStyle(fontSize: 13))),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

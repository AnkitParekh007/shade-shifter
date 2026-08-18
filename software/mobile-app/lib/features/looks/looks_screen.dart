import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/design_tokens.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/look.dart';
import '../../shared/widgets/frame_preview.dart';
import '../device/device_controller.dart';
import '../frame_control/studio_controller.dart';
import 'looks_controller.dart';

class LooksScreen extends ConsumerWidget {
  const LooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final looks = ref.watch(looksControllerProvider);
    final caps = ref.watch(deviceControllerProvider).capabilities ??
        DeviceCapabilities.revA;
    final favorites = looks.where((l) => l.favorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Looks')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(ShadeTokens.space5),
          children: [
            if (favorites.isNotEmpty) ...[
              Text('Favourites',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: ShadeTokens.space3),
              _LooksGrid(looks: favorites, caps: caps),
              const SizedBox(height: ShadeTokens.space5),
            ],
            Text('All looks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: ShadeTokens.space3),
            _LooksGrid(looks: looks, caps: caps),
            const SizedBox(height: ShadeTokens.space6),
          ],
        ),
      ),
    );
  }
}

class _LooksGrid extends ConsumerWidget {
  const _LooksGrid({required this.looks, required this.caps});
  final List<Look> looks;
  final DeviceCapabilities caps;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.82,
        crossAxisSpacing: ShadeTokens.space3,
        mainAxisSpacing: ShadeTokens.space3,
      ),
      itemCount: looks.length,
      itemBuilder: (context, i) => _LookCard(look: looks[i], caps: caps),
    );
  }
}

class _LookCard extends ConsumerWidget {
  const _LookCard({required this.look, required this.caps});
  final Look look;
  final DeviceCapabilities caps;

  Future<void> _apply(BuildContext context, WidgetRef ref) async {
    await ref
        .read(studioControllerProvider.notifier)
        .applyLook(look.appearance);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied "${look.name}"')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(looksControllerProvider.notifier);
    final mismatch = look.deviceCapabilityVersion != caps.capabilityVersion;
    return InkWell(
      borderRadius: BorderRadius.circular(ShadeTokens.radiusMd),
      onTap: () => _apply(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(ShadeTokens.radiusMd),
          border: Border.all(
              color: ShadeTokens.mist.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(ShadeTokens.space3),
                child: FramePreview(
                  appearance: look.appearance,
                  supportedZones: caps.zones,
                  showSelectionHighlight: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(ShadeTokens.space3, 0,
                  ShadeTokens.space1, ShadeTokens.space1),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(look.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        Text(
                          look.builtIn ? 'Curated' : 'Saved',
                          style: TextStyle(
                              fontSize: 11,
                              color: mismatch
                                  ? ShadeTokens.warning
                                  : ShadeTokens.fog),
                        ),
                      ],
                    ),
                  ),
                  _LookMenu(look: look, controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LookMenu extends StatelessWidget {
  const _LookMenu({required this.look, required this.controller});
  final Look look;
  final LooksController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        look.favorite ? Icons.star : Icons.more_vert,
        size: 20,
        color: look.favorite ? ShadeTokens.warning : null,
      ),
      onSelected: (value) async {
        switch (value) {
          case 'favorite':
            await controller.toggleFavorite(look);
          case 'duplicate':
            await controller.duplicate(look);
          case 'rename':
            await _rename(context);
          case 'delete':
            await _confirmDelete(context);
        }
      },
      itemBuilder: (context) => [
        if (!look.builtIn)
          PopupMenuItem(
            value: 'favorite',
            child: Text(look.favorite ? 'Unfavourite' : 'Favourite'),
          ),
        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
        if (!look.builtIn)
          const PopupMenuItem(value: 'rename', child: Text('Rename')),
        if (!look.builtIn)
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }

  Future<void> _rename(BuildContext context) async {
    final field = TextEditingController(text: look.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename look'),
        content: TextField(controller: field, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, field.text),
              child: const Text('Save')),
        ],
      ),
    );
    if (name != null) await controller.rename(look, name);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete look?'),
        content: Text('"${look.name}" will be permanently removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ShadeTokens.danger),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await controller.delete(look);
  }
}

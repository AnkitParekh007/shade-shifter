import 'package:flutter/material.dart';

import '../application/frame_controller.dart';
import '../domain/frame_device.dart';
import '../domain/frame_zone.dart';
import 'frame_preview.dart';

class FrameStudioScreen extends StatefulWidget {
  const FrameStudioScreen({required this.controller, super.key});

  final FrameController controller;

  @override
  State<FrameStudioScreen> createState() => _FrameStudioScreenState();
}

class _FrameStudioScreenState extends State<FrameStudioScreen> {
  static const palette = <Color>[
    Color(0xFF284B63),
    Color(0xFF9B2226),
    Color(0xFFCA6702),
    Color(0xFF3A5A40),
    Color(0xFF6D597A),
    Color(0xFFE9D8A6),
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.connect();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Frame studio'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(
                    controller.status.connection ==
                            FrameConnectionState.connected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_searching,
                    size: 18,
                  ),
                  label: Text(
                    controller.status.simulator ? 'Simulator' : 'Frame',
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: FramePreview(appearance: controller.appearance),
                ),
              ),
              const SizedBox(height: 18),
              SegmentedButton<FrameZone>(
                segments: FrameZone.values
                    .map(
                      (zone) =>
                          ButtonSegment(value: zone, label: Text(zone.label)),
                    )
                    .toList(),
                selected: {controller.selectedZone},
                onSelectionChanged: (zones) =>
                    controller.selectZone(zones.first),
              ),
              const SizedBox(height: 24),
              Text(
                'Curated shades',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: palette
                    .map(
                      (color) => Semantics(
                        button: true,
                        label:
                            'Apply color ${color.toARGB32().toRadixString(16)}',
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => controller.setColor(color),
                          child: Ink(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Text(
                    'Intensity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    '${(controller.appearance.intensity * 100).round()}% safe limit',
                  ),
                ],
              ),
              Slider(
                value: controller.appearance.intensity,
                max: FrameController.safeIntensityLimit,
                divisions: 13,
                label: '${(controller.appearance.intensity * 100).round()}%',
                onChanged: controller.setIntensity,
              ),
              const SizedBox(height: 18),
              _StatusCard(controller: controller),
              if (controller.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Could not synchronize: ${controller.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});

  final FrameController controller;

  @override
  Widget build(BuildContext context) {
    final status = controller.status;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Battery ${status.batteryPercent}%  •  ${status.temperatureCelsius.toStringAsFixed(1)} °C',
            ),
            Text(
              'Firmware ${status.firmwareVersion}  •  Ack ${status.lastAcknowledgedSequence}',
            ),
            if (status.thermalWarning)
              Text(
                'Thermal warning: output has been restricted.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (controller.sending) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interactive_3d/interactive_3d.dart';
import '../../core/models.dart';

class FramePreviewController {
  final Interactive3dController native = Interactive3dController();
  Future<void> reset() => native.setCameraZoomLevel(1);
}

class FramePreview extends StatefulWidget {
  const FramePreview(
      {required this.appearance, required this.onZoneSelected, super.key});
  final FrameAppearance appearance;
  final ValueChanged<FrameZone> onZoneSelected;
  @override
  State<FramePreview> createState() => _FramePreviewState();
}

class _FramePreviewState extends State<FramePreview> {
  final controller = FramePreviewController();
  @override
  void didUpdateWidget(covariant FramePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _apply();
  }

  List<double> _rgba(Color c) => [c.r, c.g, c.b, 1];
  Future<void> _apply() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    try {
      await controller.native.setEntityMaterials([
        MaterialOverride(
            name: 'front', color: _rgba(widget.appearance.front.primary)),
        MaterialOverride(
            name: 'left_temple',
            color: _rgba(widget.appearance.leftTemple.primary)),
        MaterialOverride(
            name: 'right_temple',
            color: _rgba(widget.appearance.rightTemple.primary)),
      ]);
    } catch (_) {
      /* Native view may still be attaching; initial overrides cover it. */
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return Semantics(
          label: 'Interactive 3D preview of the Shade Shifter frame',
          image: true,
          child: Interactive3d(
              controller: controller.native,
              modelPath: 'assets/models/shade_shifter_poc.glb',
              solidBackgroundColor: const [0, 0, 0, 0],
              backgroundColor: Colors.transparent,
              defaultZoom: 1,
              initialMaterialOverrides: [
                MaterialOverride(
                    name: 'front',
                    color: _rgba(widget.appearance.front.primary)),
                MaterialOverride(
                    name: 'left_temple',
                    color: _rgba(widget.appearance.leftTemple.primary)),
                MaterialOverride(
                    name: 'right_temple',
                    color: _rgba(widget.appearance.rightTemple.primary)),
              ],
              onSelectionChanged: (entities) {
                if (entities.isEmpty) return;
                final name = entities.last.name;
                widget.onZoneSelected(name == 'front'
                    ? FrameZone.front
                    : name == 'left_temple'
                        ? FrameZone.leftTemple
                        : FrameZone.rightTemple);
              }));
    }
    return Semantics(
        label: 'Two-dimensional fallback preview of the Shade Shifter frame',
        image: true,
        child: CustomPaint(
            painter: _Painter(widget.appearance),
            child: const SizedBox.expand()));
  }
}

class _Painter extends CustomPainter {
  const _Painter(this.a);
  final FrameAppearance a;
  @override
  void paint(Canvas canvas, Size s) {
    Paint p(Color c) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.height * .07
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(Colors.black, c, a.intensity)!;
    final front = p(a.front.primary),
        left = p(a.leftTemple.primary),
        right = p(a.rightTemple.primary);
    final l = Rect.fromLTWH(
            s.width * .12, s.height * .25, s.width * .31, s.height * .48),
        r = Rect.fromLTWH(
            s.width * .57, s.height * .25, s.width * .31, s.height * .48);
    canvas.drawOval(l, front);
    canvas.drawOval(r, front);
    canvas.drawLine(Offset(s.width * .43, s.height * .48),
        Offset(s.width * .57, s.height * .48), front);
    canvas.drawLine(Offset(s.width * .12, s.height * .4),
        Offset(s.width * .01, s.height * .17), left);
    canvas.drawLine(Offset(s.width * .88, s.height * .4),
        Offset(s.width * .99, s.height * .17), right);
  }

  @override
  bool shouldRepaint(covariant _Painter old) => old.a != a;
}

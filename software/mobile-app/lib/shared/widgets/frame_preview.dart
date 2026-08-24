import 'package:flutter/material.dart';

import '../../app/theme/design_tokens.dart';
import '../models/appearance.dart';
import '../models/rgb_color.dart';
import '../models/zone.dart';

/// A realistic, optical-proportioned eyewear preview rendered with [CustomPaint].
///
/// Each physical [ZoneId] is drawn with its own material color and intensity, so
/// front vs. temple selections are visually unmistakable and independent. This
/// is the dependable default preview and the graceful fallback for the 3D view
/// (see documentation/mobile-app/ARCHITECTURE.md, "3D preview").
class FramePreview extends StatelessWidget {
  const FramePreview({
    super.key,
    required this.appearance,
    required this.supportedZones,
    this.selection,
    this.onSelectZone,
    this.showSelectionHighlight = true,
  });

  final FrameAppearance appearance;
  final List<ZoneId> supportedZones;
  final SelectionTarget? selection;
  final ValueChanged<SelectionTarget>? onSelectZone;
  final bool showSelectionHighlight;

  @override
  Widget build(BuildContext context) {
    final selectedZones =
        selection?.resolve(supportedZones) ?? const <ZoneId>[];
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapUp: onSelectZone == null
              ? null
              : (details) => _handleTap(details, constraints.biggest),
          child: Semantics(
            label: 'Eyewear frame preview',
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _FramePainter(
                appearance: appearance,
                supportedZones: supportedZones,
                selectedZones:
                    showSelectionHighlight ? selectedZones : const [],
                brightness: Theme.of(context).brightness,
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(TapUpDetails details, Size size) {
    final x = details.localPosition.dx / size.width;
    final SelectionTarget target;
    if (x < 0.28) {
      target = SelectionTarget.leftTemple;
    } else if (x > 0.72) {
      target = SelectionTarget.rightTemple;
    } else {
      target = SelectionTarget.front;
    }
    onSelectZone?.call(target);
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter({
    required this.appearance,
    required this.supportedZones,
    required this.selectedZones,
    required this.brightness,
  });

  final FrameAppearance appearance;
  final List<ZoneId> supportedZones;
  final List<ZoneId> selectedZones;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    // Optical proportions derived from the available width.
    final lensW = w * 0.30;
    final lensH = lensW * 0.72;
    final bridge = w * 0.06;
    final lensGap = bridge;
    final leftCenter = Offset(cx - lensGap / 2 - lensW / 2, cy);
    final rightCenter = Offset(cx + lensGap / 2 + lensW / 2, cy);
    final rimStroke = lensW * 0.11;

    // ---- Temples (drawn first, behind the front) ----
    _paintTemple(canvas, leftCenter, lensW, lensH, ZoneId.leftTemple, true);
    _paintTemple(canvas, rightCenter, lensW, lensH, ZoneId.rightTemple, false);

    // ---- Lenses (subtle, neutral studio tint) ----
    _paintLens(canvas, leftCenter, lensW, lensH);
    _paintLens(canvas, rightCenter, lensW, lensH);

    // ---- Front: two rims + bridge ----
    _paintRim(canvas, leftCenter, lensW, lensH, rimStroke);
    _paintRim(canvas, rightCenter, lensW, lensH, rimStroke);
    _paintBridge(canvas, leftCenter, rightCenter, lensW, rimStroke);

    // ---- Hinges (metal hardware) ----
    _paintHinge(canvas, Offset(leftCenter.dx - lensW / 2, cy));
    _paintHinge(canvas, Offset(rightCenter.dx + lensW / 2, cy));
  }

  Color _zoneColor(ZoneId zone) {
    if (!supportedZones.contains(zone)) {
      return brightness == Brightness.dark
          ? ShadeTokens.slate
          : ShadeTokens.fog;
    }
    final a = appearance.zone(zone);
    final base = a.representativeColor;
    // Blend the material color over a dark base by intensity for realism.
    final baseline = brightness == Brightness.dark
        ? const RgbColor(20, 20, 26)
        : const RgbColor(70, 70, 80);
    final t = 0.35 + a.intensity * 0.65;
    int mix(int c, int b) => (b + (c - b) * t).round().clamp(0, 255);
    return Color.fromARGB(
      255,
      mix(base.r, baseline.r),
      mix(base.g, baseline.g),
      mix(base.b, baseline.b),
    );
  }

  bool _selected(ZoneId zone) => selectedZones.contains(zone);

  void _paintRim(
      Canvas canvas, Offset center, double lensW, double lensH, double stroke) {
    final rect = Rect.fromCenter(center: center, width: lensW, height: lensH);
    final rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(lensH * 0.34));
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeJoin = StrokeJoin.round
      ..color = _zoneColor(ZoneId.front);

    if (_selected(ZoneId.front)) {
      _paintGlow(canvas, rrect, stroke);
    }
    canvas.drawRRect(rrect, paint);

    // Subtle top highlight for dimensionality.
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke * 0.3
        ..color = Colors.white.withValues(alpha: 0.08),
    );
  }

  void _paintBridge(Canvas canvas, Offset left, Offset right, double lensW,
      double stroke) {
    final y = left.dy - lensW * 0.16;
    final start = Offset(left.dx + lensW / 2 - stroke * 0.3, y);
    final end = Offset(right.dx - lensW / 2 + stroke * 0.3, y);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        start.dx + (end.dx - start.dx) * 0.3, y - lensW * 0.12,
        start.dx + (end.dx - start.dx) * 0.7, y - lensW * 0.12,
        end.dx, end.dy,
      );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = _zoneColor(ZoneId.front),
    );
  }

  void _paintTemple(Canvas canvas, Offset lensCenter, double lensW,
      double lensH, ZoneId zone, bool isLeft) {
    final stroke = lensW * 0.09;
    final hingeX =
        isLeft ? lensCenter.dx - lensW / 2 : lensCenter.dx + lensW / 2;
    final dir = isLeft ? -1 : 1;
    final start = Offset(hingeX, lensCenter.dy);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(hingeX + dir * lensW * 0.55, lensCenter.dy - lensH * 0.16)
      ..lineTo(hingeX + dir * lensW * 0.72, lensCenter.dy + lensH * 0.55);

    if (_selected(zone)) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke * 2.4
          ..strokeCap = StrokeCap.round
          ..color = ShadeTokens.spectral.withValues(alpha: 0.45)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = _zoneColor(zone),
    );
  }

  void _paintLens(Canvas canvas, Offset center, double lensW, double lensH) {
    final rect = Rect.fromCenter(
        center: center, width: lensW * 0.92, height: lensH * 0.92);
    final rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(lensH * 0.30));
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            Colors.white.withValues(alpha: 0.02),
          ],
        ).createShader(rect),
    );
  }

  void _paintHinge(Canvas canvas, Offset at) {
    canvas.drawCircle(
      at,
      3.2,
      Paint()..color = ShadeTokens.fog.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      at,
      1.3,
      Paint()..color = ShadeTokens.obsidian,
    );
  }

  void _paintGlow(Canvas canvas, RRect rrect, double stroke) {
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke * 2.2
        ..color = ShadeTokens.spectral.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
  }

  @override
  bool shouldRepaint(_FramePainter old) =>
      old.appearance != appearance ||
      old.selectedZones != selectedZones ||
      old.brightness != brightness ||
      old.supportedZones != supportedZones;
}

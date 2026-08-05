import 'package:flutter/material.dart';

import '../domain/frame_appearance.dart';

class FramePreview extends StatelessWidget {
  const FramePreview({required this.appearance, super.key});

  final FrameAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Interactive preview of the Shade Shifter frame',
      image: true,
      child: AspectRatio(
        aspectRatio: 1.7,
        child: CustomPaint(painter: _FramePainter(appearance)),
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  const _FramePainter(this.appearance);

  final FrameAppearance appearance;

  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    final front = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.065
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(
        Colors.black,
        appearance.front,
        appearance.intensity,
      )!;
    final temples = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.055
      ..strokeCap = StrokeCap.round
      ..color = Color.lerp(
        Colors.black,
        appearance.leftTemple,
        appearance.intensity,
      )!;
    final left = Rect.fromLTWH(
      size.width * 0.13,
      size.height * 0.23,
      size.width * 0.3,
      size.height * 0.48,
    );
    final right = Rect.fromLTWH(
      size.width * 0.57,
      size.height * 0.23,
      size.width * 0.3,
      size.height * 0.48,
    );
    canvas.drawOval(left.translate(0, size.height * 0.05), shadow);
    canvas.drawOval(right.translate(0, size.height * 0.05), shadow);
    canvas.drawOval(left, front);
    canvas.drawOval(right, front);
    canvas.drawLine(
      Offset(size.width * 0.43, size.height * 0.45),
      Offset(size.width * 0.57, size.height * 0.45),
      front,
    );
    canvas.drawLine(
      Offset(size.width * 0.13, size.height * 0.38),
      Offset(size.width * 0.015, size.height * 0.18),
      temples,
    );
    canvas.drawLine(
      Offset(size.width * 0.87, size.height * 0.38),
      Offset(size.width * 0.985, size.height * 0.18),
      temples,
    );
  }

  @override
  bool shouldRepaint(_FramePainter oldDelegate) =>
      oldDelegate.appearance != appearance;
}

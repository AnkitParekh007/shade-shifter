import 'dart:ui';
import 'package:flutter/foundation.dart';

@immutable
class FrameAppearance {
  const FrameAppearance({
    required this.front,
    required this.leftTemple,
    required this.rightTemple,
    this.secondary,
    this.intensity = 0.35,
    this.effect = FrameEffect.solid,
  });

  static const safeDefault = FrameAppearance(
    front: Color(0xFF284B63),
    leftTemple: Color(0xFF284B63),
    rightTemple: Color(0xFF284B63),
  );

  final Color front;
  final Color leftTemple;
  final Color rightTemple;
  final Color? secondary;
  final double intensity;
  final FrameEffect effect;

  FrameAppearance copyWith({
    Color? front,
    Color? leftTemple,
    Color? rightTemple,
    Color? secondary,
    double? intensity,
    FrameEffect? effect,
  }) {
    return FrameAppearance(
      front: front ?? this.front,
      leftTemple: leftTemple ?? this.leftTemple,
      rightTemple: rightTemple ?? this.rightTemple,
      secondary: secondary ?? this.secondary,
      intensity: intensity ?? this.intensity,
      effect: effect ?? this.effect,
    );
  }
}

enum FrameEffect { solid, gradient, breathe, pulse }

import 'package:flutter/material.dart';

import '../../app/theme/design_tokens.dart';
import '../models/apply_state.dart';

/// Small, reusable presentation widgets that express the design system.

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: ShadeTokens.space3, top: ShadeTokens.space2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(ShadeTokens.space4),
      decoration: BoxDecoration(
        color: (isDark ? ShadeTokens.graphite : Colors.white)
            .withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(ShadeTokens.radiusMd),
        border: Border.all(
          color: (isDark ? ShadeTokens.mist : ShadeTokens.fog)
              .withValues(alpha: 0.35),
        ),
      ),
      child: child,
    );
  }
}

/// Prominent, clearly-labelled banner shown whenever the active device is the
/// simulator — required so a simulated frame is never mistaken for hardware.
class SimulatorBadge extends StatelessWidget {
  const SimulatorBadge({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ShadeTokens.space3,
        vertical: compact ? ShadeTokens.space1 : ShadeTokens.space2,
      ),
      decoration: BoxDecoration(
        color: ShadeTokens.spectralAlt.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(ShadeTokens.radiusPill),
        border: Border.all(
            color: ShadeTokens.spectralAlt.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.smart_toy_outlined,
              size: 16, color: ShadeTokens.spectralAlt),
          const SizedBox(width: ShadeTokens.space2),
          Text(
            'Simulated device',
            style: TextStyle(
              color: ShadeTokens.spectralAlt,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact status chip reflecting the apply-state machine.
class ApplyStatusChip extends StatelessWidget {
  const ApplyStatusChip(this.phase, {super.key});
  final ApplyPhase phase;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (phase) {
      ApplyPhase.previewing => (ShadeTokens.fog, Icons.visibility_outlined),
      ApplyPhase.pendingTransmission =>
        (ShadeTokens.warning, Icons.schedule_outlined),
      ApplyPhase.sending => (ShadeTokens.spectral, Icons.upload_outlined),
      ApplyPhase.acknowledged =>
        (ShadeTokens.spectralAlt, Icons.done_outlined),
      ApplyPhase.applied => (ShadeTokens.success, Icons.check_circle_outline),
      ApplyPhase.timedOut => (ShadeTokens.warning, Icons.timer_off_outlined),
      ApplyPhase.rejected => (ShadeTokens.danger, Icons.block_outlined),
      ApplyPhase.reverted => (ShadeTokens.fog, Icons.undo_outlined),
    };
    return Semantics(
      label: 'Apply status: ${phase.label}',
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: ShadeTokens.space3, vertical: ShadeTokens.space1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(ShadeTokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: ShadeTokens.space2),
            Text(
              phase.label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

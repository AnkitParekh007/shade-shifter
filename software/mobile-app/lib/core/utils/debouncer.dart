import 'dart:async';

/// Coalesces rapid calls (color-wheel drags, slider scrubs) into at most one
/// action per [duration], so continuous UI controls never flood the BLE link.
/// Local visual feedback stays immediate; only the transmitted command is
/// rate-limited. See CustomizationStudio + BLE-PROTOCOL.md (retry/rate policy).
class Debouncer {
  Debouncer(this.duration);

  final Duration duration;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// True while a call is pending.
  bool get isActive => _timer?.isActive ?? false;

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() => cancel();
}

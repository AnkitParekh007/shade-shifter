import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models.dart';
import '../data/selectable_transport.dart';
import '../domain/frame_transport_v2.dart';

class StudioState {
  const StudioState(
      {this.appearance = FrameAppearance.safeDefault,
      this.selectedZone = FrameZone.whole,
      this.status = const FrameDeviceStatus(),
      this.capabilities = DeviceCapabilities.simulator,
      this.sending = false,
      this.error,
      this.undo = const [],
      this.redo = const []});
  final FrameAppearance appearance;
  final FrameZone selectedZone;
  final FrameDeviceStatus status;
  final DeviceCapabilities capabilities;
  final bool sending;
  final String? error;
  final List<FrameAppearance> undo, redo;
  StudioState copyWith(
          {FrameAppearance? appearance,
          FrameZone? selectedZone,
          FrameDeviceStatus? status,
          DeviceCapabilities? capabilities,
          bool? sending,
          String? error,
          bool clearError = false,
          List<FrameAppearance>? undo,
          List<FrameAppearance>? redo}) =>
      StudioState(
          appearance: appearance ?? this.appearance,
          selectedZone: selectedZone ?? this.selectedZone,
          status: status ?? this.status,
          capabilities: capabilities ?? this.capabilities,
          sending: sending ?? this.sending,
          error: clearError ? null : error ?? this.error,
          undo: undo ?? this.undo,
          redo: redo ?? this.redo);
}

final transportProvider = Provider<FrameTransport>((ref) {
  final value = SelectableTransport();
  ref.onDispose(value.dispose);
  return value;
});
final studioProvider =
    NotifierProvider<StudioController, StudioState>(StudioController.new);

class StudioController extends Notifier<StudioState> {
  Timer? _debounce;
  @override
  StudioState build() {
    final transport = ref.watch(transportProvider);
    final a = transport.status
        .listen((value) => state = state.copyWith(status: value));
    final b = transport.capabilities
        .listen((value) => state = state.copyWith(capabilities: value));
    ref.onDispose(() {
      _debounce?.cancel();
      a.cancel();
      b.cancel();
    });
    return const StudioState();
  }

  Future<void> connect() async {
    state = state.copyWith(clearError: true);
    try {
      await ref.read(transportProvider).connect();
    } catch (e) {
      state = state.copyWith(error: '$e');
    }
  }

  Future<void> connectPhysical() async {
    state = state.copyWith(clearError: true);
    try {
      final transport = ref.read(transportProvider) as SelectableTransport;
      await transport.usePhysical();
      await transport.connect();
    } catch (error) {
      state = state.copyWith(error: '$error');
    }
  }

  Future<void> disconnect() => ref.read(transportProvider).disconnect();
  void selectZone(FrameZone value) =>
      state = state.copyWith(selectedZone: value);
  void setLinked(bool value) => state =
      state.copyWith(appearance: state.appearance.copyWith(linked: value));
  void setColor(Color color) {
    final old = state.appearance;
    ZoneAppearance changed(ZoneAppearance z) => z.copyWith(primary: color);
    var next = old;
    if (old.linked || state.selectedZone == FrameZone.whole) {
      next = old.copyWith(
          front: changed(old.front),
          leftTemple: changed(old.leftTemple),
          rightTemple: changed(old.rightTemple));
    } else {
      next = switch (state.selectedZone) {
        FrameZone.front => old.copyWith(front: changed(old.front)),
        FrameZone.leftTemple =>
          old.copyWith(leftTemple: changed(old.leftTemple)),
        FrameZone.rightTemple =>
          old.copyWith(rightTemple: changed(old.rightTemple)),
        FrameZone.whole => old
      };
    }
    state = state.copyWith(
        appearance: next,
        undo: [...state.undo.take(19), old],
        redo: const [],
        clearError: true);
    _scheduleSend();
  }

  void setIntensity(double value) {
    final old = state.appearance;
    state = state.copyWith(
        appearance: old.copyWith(intensity: value),
        undo: [...state.undo.take(19), old],
        redo: const []);
    _scheduleSend();
  }

  void applyLook(FrameAppearance value) {
    state = state.copyWith(
        appearance: value,
        undo: [...state.undo, state.appearance],
        redo: const []);
    _scheduleSend();
  }

  void undo() {
    if (state.undo.isEmpty) {
      return;
    }
    final previous = state.undo.last;
    state = state.copyWith(
        appearance: previous,
        undo: state.undo.sublist(0, state.undo.length - 1),
        redo: [...state.redo, state.appearance]);
    _scheduleSend();
  }

  void redo() {
    if (state.redo.isEmpty) {
      return;
    }
    final next = state.redo.last;
    state = state.copyWith(
        appearance: next,
        redo: state.redo.sublist(0, state.redo.length - 1),
        undo: [...state.undo, state.appearance]);
    _scheduleSend();
  }

  void _scheduleSend() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 140), _send);
  }

  Future<void> _send() async {
    if (state.status.phase != ConnectionPhase.connected ||
        state.status.safety == SafetyState.shutdown) {
      return;
    }
    state = state.copyWith(sending: true, clearError: true);
    try {
      await ref.read(transportProvider).applyAppearance(state.appearance);
    } catch (e) {
      state = state.copyWith(error: '$e');
    } finally {
      state = state.copyWith(sending: false);
    }
  }

  Future<void> off() async {
    state = state.copyWith(appearance: state.appearance.copyWith(intensity: 0));
    await ref.read(transportProvider).off();
  }
}

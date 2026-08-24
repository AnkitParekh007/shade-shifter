import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/design_tokens.dart';
import '../../core/ble/protocol.dart';
import '../../core/di/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/safety/safety_governor.dart';
import '../../core/utils/debouncer.dart';
import '../../shared/models/appearance.dart';
import '../../shared/models/apply_state.dart';
import '../../shared/models/device_capabilities.dart';
import '../../shared/models/rgb_color.dart';
import '../../shared/models/zone.dart';
import '../device/device_controller.dart';

/// Working state of the customization studio.
class StudioState {
  const StudioState({
    required this.appearance,
    required this.confirmed,
    this.selection = SelectionTarget.wholeFrame,
    this.phase = ApplyPhase.previewing,
    this.notices = const [],
  });

  /// Live local working copy (immediate visual feedback).
  final FrameAppearance appearance;

  /// Last device-confirmed appearance (revert target).
  final FrameAppearance confirmed;

  final SelectionTarget selection;
  final ApplyPhase phase;
  final List<SafetyNotice> notices;

  /// The appearance shared by every currently-selected zone, if consistent,
  /// else the first selected zone's — drives the controls' displayed values.
  ZoneAppearance representativeForSelection(List<ZoneId> supported) {
    final zones = selection.resolve(supported);
    if (zones.isEmpty) return appearance.zone(ZoneId.front);
    return appearance.zone(zones.first);
  }

  StudioState copyWith({
    FrameAppearance? appearance,
    FrameAppearance? confirmed,
    SelectionTarget? selection,
    ApplyPhase? phase,
    List<SafetyNotice>? notices,
  }) =>
      StudioState(
        appearance: appearance ?? this.appearance,
        confirmed: confirmed ?? this.confirmed,
        selection: selection ?? this.selection,
        phase: phase ?? this.phase,
        notices: notices ?? this.notices,
      );
}

class StudioController extends Notifier<StudioState> {
  final Debouncer _debouncer = Debouncer(ShadeTokens.bleControlDebounce);

  @override
  StudioState build() {
    ref.onDispose(_debouncer.dispose);
    final last = ref.read(looksRepositoryProvider).readLastApplied() ??
        FrameAppearance.initial();
    return StudioState(appearance: last, confirmed: last);
  }

  DeviceCapabilities get _caps =>
      ref.read(deviceControllerProvider).capabilities ??
      DeviceCapabilities.revA;

  List<ZoneId> get _selectedZones => state.selection.resolve(_caps.zones);

  void setSelection(SelectionTarget target) =>
      state = state.copyWith(selection: target);

  // ---- Editing (immediate local preview + debounced transmit) ----

  void _editSelected(ZoneAppearance Function(ZoneAppearance) transform) {
    final next = state.appearance.updateZones(_selectedZones, transform);
    state = state.copyWith(
      appearance: next,
      phase: ApplyPhase.previewing,
    );
    _debouncer.run(_transmitSelected);
  }

  void setSolidColor(RgbColor color) => _editSelected(
        (a) => a.copyWith(mode: AppearanceMode.solid, solidColor: color),
      );

  void setIntensity(double intensity) {
    final clamped =
        ref.read(safetyGovernorProvider).clampIntensity(intensity, _caps);
    _editSelected((a) => a.copyWith(intensity: clamped));
  }

  void setMode(AppearanceMode mode) =>
      _editSelected((a) => a.copyWith(mode: mode));

  void setGradient({
    RgbColor? start,
    RgbColor? end,
    GradientDirection? direction,
  }) =>
      _editSelected((a) => a.copyWith(
            mode: AppearanceMode.gradient,
            gradientStart: start,
            gradientEnd: end,
            gradientDirection: direction,
          ));

  void setEffect(EffectType effect, {double? speed}) =>
      _editSelected((a) => a.copyWith(effect: effect, effectSpeed: speed));

  // ---- Transmission + apply-state machine ----

  Future<void> _transmitSelected() => _transmit(_selectedZones);

  /// Explicit "Apply" — transmits every zone.
  Future<void> applyAll() => _transmit(_caps.zones);

  Future<void> _transmit(List<ZoneId> zones) async {
    if (zones.isEmpty) return;
    final governor = ref.read(safetyGovernorProvider);
    final device = ref.read(deviceControllerProvider);
    final decision = governor.sanitize(
      state.appearance,
      _caps,
      device.telemetry,
    );

    // Reflect any safety clamping back into the working appearance so the UI
    // can never present an unsafe value as applied.
    state = state.copyWith(
      appearance: decision.appearance,
      notices: decision.notices,
      phase: ApplyPhase.pendingTransmission,
    );

    if (!device.isConnected) {
      state = state.copyWith(phase: ApplyPhase.timedOut);
      return;
    }

    state = state.copyWith(phase: ApplyPhase.sending);
    final controller = ref.read(deviceControllerProvider.notifier);

    for (final zone in zones) {
      final a = decision.appearance.zone(zone);
      final command = _commandForZone(zone, a);
      final result = await controller.send(command);
      if (result.isErr) {
        final kind = result.errorOrNull!.kind;
        final rejected = kind == AppErrorKind.commandRejected ||
            kind == AppErrorKind.unsupportedFirmware ||
            kind == AppErrorKind.malformedPayload;
        state = state.copyWith(
          phase: rejected ? ApplyPhase.rejected : ApplyPhase.timedOut,
        );
        return;
      }
      // Effect is a second command when animated + supported.
      if (a.effect.isAnimated && _caps.supportsEffect(a.effect)) {
        await controller.send(
          SetEffectCommand(zone: zone, effect: a.effect, speed: a.effectSpeed),
        );
      }
    }

    state = state.copyWith(phase: ApplyPhase.acknowledged);
    final confirmed = decision.appearance;
    state = state.copyWith(confirmed: confirmed, phase: ApplyPhase.applied);
    await ref.read(looksRepositoryProvider).saveLastApplied(confirmed);
  }

  DeviceCommand _commandForZone(ZoneId zone, ZoneAppearance a) {
    if (a.mode == AppearanceMode.gradient) {
      return SetZoneGradientCommand(
        zone: zone,
        start: a.gradientStart,
        end: a.gradientEnd,
        direction: a.gradientDirection,
        intensity: a.intensity,
      );
    }
    return SetZoneSolidColorCommand(
      zone: zone,
      color: a.solidColor,
      intensity: a.intensity,
    );
  }

  /// Reverts local state to the last device-confirmed appearance.
  void revert() => state = state.copyWith(
        appearance: state.confirmed,
        phase: ApplyPhase.reverted,
        notices: const [],
      );

  /// Emergency: turn all illumination off immediately.
  Future<void> emergencyOff() async {
    _debouncer.cancel();
    final dark = state.appearance.updateZones(
      _caps.zones,
      (a) => a.copyWith(intensity: 0, effect: EffectType.static),
    );
    state = state.copyWith(appearance: dark, phase: ApplyPhase.sending);
    final controller = ref.read(deviceControllerProvider.notifier);
    final result = await controller.send(const IlluminationOffCommand());
    state = state.copyWith(
      phase: result.isOk ? ApplyPhase.applied : ApplyPhase.timedOut,
      confirmed: result.isOk ? dark : state.confirmed,
    );
    if (result.isOk) {
      await ref.read(looksRepositoryProvider).saveLastApplied(dark);
    }
  }

  /// Loads a saved look into the studio and applies it.
  Future<void> applyLook(FrameAppearance appearance) async {
    // Constrain to zones this device supports.
    final constrained = FrameAppearance({
      for (final z in _caps.zones) z: appearance.zone(z),
    });
    state = state.copyWith(appearance: constrained);
    await applyAll();
  }
}

final studioControllerProvider =
    NotifierProvider<StudioController, StudioState>(StudioController.new);

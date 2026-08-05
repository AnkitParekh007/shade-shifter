import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/frame_appearance.dart';
import '../domain/frame_device.dart';
import '../domain/frame_transport.dart';
import '../domain/frame_zone.dart';

class FrameController extends ChangeNotifier {
  FrameController({required FrameTransport transport})
      : _transport = transport {
    _subscription = _transport.status.listen(_onStatus);
  }

  static const safeIntensityLimit = 0.65;

  final FrameTransport _transport;
  late final StreamSubscription<FrameDeviceStatus> _subscription;
  FrameAppearance _appearance = FrameAppearance.safeDefault;
  FrameDeviceStatus _status = const FrameDeviceStatus.disconnected();
  FrameZone _selectedZone = FrameZone.wholeFrame;
  bool _sending = false;
  Object? _error;

  FrameAppearance get appearance => _appearance;
  FrameDeviceStatus get status => _status;
  FrameZone get selectedZone => _selectedZone;
  bool get sending => _sending;
  Object? get error => _error;

  Future<void> connect() async {
    _error = null;
    notifyListeners();
    try {
      await _transport.connect();
    } on Object catch (error) {
      _error = error;
      notifyListeners();
    }
  }

  void selectZone(FrameZone zone) {
    _selectedZone = zone;
    notifyListeners();
  }

  Future<void> setColor(Color color) async {
    _appearance = switch (_selectedZone) {
      FrameZone.wholeFrame => _appearance.copyWith(
          front: color,
          leftTemple: color,
          rightTemple: color,
        ),
      FrameZone.front => _appearance.copyWith(front: color),
      FrameZone.temples => _appearance.copyWith(
          leftTemple: color,
          rightTemple: color,
        ),
    };
    await _send();
  }

  Future<void> setIntensity(double value) async {
    _appearance = _appearance.copyWith(
      intensity: value.clamp(0, safeIntensityLimit),
    );
    await _send();
  }

  Future<void> _send() async {
    _sending = true;
    _error = null;
    notifyListeners();
    try {
      await _transport.applyAppearance(_appearance);
    } on Object catch (error) {
      _error = error;
    } finally {
      _sending = false;
      notifyListeners();
    }
  }

  void _onStatus(FrameDeviceStatus value) {
    _status = value;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    unawaited(_transport.dispose());
    super.dispose();
  }
}

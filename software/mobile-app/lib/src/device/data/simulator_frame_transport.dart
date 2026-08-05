import 'dart:async';

import '../domain/frame_appearance.dart';
import '../domain/frame_device.dart';
import '../domain/frame_transport.dart';

class SimulatorFrameTransport implements FrameTransport {
  final _status = StreamController<FrameDeviceStatus>.broadcast();
  int _sequence = 0;
  bool _connected = false;

  @override
  Stream<FrameDeviceStatus> get status => _status.stream;

  @override
  Future<void> connect() async {
    _emit(FrameConnectionState.scanning);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    _emit(FrameConnectionState.connecting);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _connected = true;
    _emit(FrameConnectionState.connected);
  }

  @override
  Future<int> applyAppearance(FrameAppearance appearance) async {
    if (!_connected) {
      throw StateError('The simulated frame is not connected.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 90));
    _sequence = (_sequence + 1) & 0xFFFF;
    _emit(FrameConnectionState.connected);
    return _sequence;
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _emit(FrameConnectionState.disconnected);
  }

  void _emit(FrameConnectionState connection) {
    _status.add(
      FrameDeviceStatus(
        connection: connection,
        batteryPercent: _connected ? 82 : 0,
        temperatureCelsius: _connected ? 31.4 : 0,
        firmwareVersion: _connected ? 'sim-1.0.0' : 'Unknown',
        simulator: true,
        lastAcknowledgedSequence: _sequence,
      ),
    );
  }

  @override
  Future<void> dispose() => _status.close();
}

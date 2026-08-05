import 'dart:async';
import '../../core/models.dart';
import '../domain/frame_transport_v2.dart';

class SimulatorTransport implements FrameTransport {
  final _status = StreamController<FrameDeviceStatus>.broadcast();
  final _capabilities = StreamController<DeviceCapabilities>.broadcast();
  int _sequence = 0;
  FrameDeviceStatus _current = const FrameDeviceStatus();
  @override
  Stream<FrameDeviceStatus> get status => _status.stream;
  @override
  Stream<DeviceCapabilities> get capabilities => _capabilities.stream;
  void _emit(FrameDeviceStatus value) {
    _current = value;
    _status.add(value);
  }

  @override
  Future<void> connect() async {
    _emit(const FrameDeviceStatus(phase: ConnectionPhase.scanning));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _emit(const FrameDeviceStatus(
        phase: ConnectionPhase.connecting, name: 'ShadeShifter-Simulator'));
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _capabilities.add(DeviceCapabilities.simulator);
    _emit(const FrameDeviceStatus(
        phase: ConnectionPhase.connected,
        name: 'ShadeShifter-Simulator',
        firmware: 'sim-1.0.0',
        batteryPercent: 82,
        temperatureCelsius: 31.4,
        rssi: -46));
  }

  @override
  Future<int> applyAppearance(FrameAppearance appearance) async {
    if (_current.phase != ConnectionPhase.connected) {
      throw StateError('Frame is disconnected.');
    }
    if (_current.safety == SafetyState.shutdown) {
      throw StateError('Thermal shutdown is active.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 75));
    _sequence = (_sequence + 1) & 0xffff;
    _emit(FrameDeviceStatus(
        phase: ConnectionPhase.connected,
        name: _current.name,
        firmware: _current.firmware,
        batteryPercent: _current.batteryPercent,
        temperatureCelsius: _current.temperatureCelsius,
        rssi: _current.rssi,
        sequence: _sequence));
    return _sequence;
  }

  @override
  Future<void> off() =>
      applyAppearance(FrameAppearance.safeDefault.copyWith(intensity: 0));
  @override
  Future<void> disconnect() async => _emit(const FrameDeviceStatus());
  @override
  Future<void> forget() => disconnect();
  void setTemperature(double value) => _emit(FrameDeviceStatus(
      phase: _current.phase,
      name: _current.name,
      firmware: _current.firmware,
      batteryPercent: _current.batteryPercent,
      temperatureCelsius: value,
      rssi: _current.rssi,
      sequence: _current.sequence));
  @override
  Future<void> dispose() async {
    await _status.close();
    await _capabilities.close();
  }
}

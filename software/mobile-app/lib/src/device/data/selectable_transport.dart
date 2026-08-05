import 'dart:async';
import '../../core/models.dart';
import '../domain/frame_transport_v2.dart';
import 'ble_frame_transport.dart';
import 'simulator_transport_v2.dart';

class SelectableTransport implements FrameTransport {
  FrameTransport _active = SimulatorTransport();
  final _status = StreamController<FrameDeviceStatus>.broadcast();
  final _capabilities = StreamController<DeviceCapabilities>.broadcast();
  StreamSubscription<FrameDeviceStatus>? _statusSub;
  StreamSubscription<DeviceCapabilities>? _capabilitySub;
  SelectableTransport() {
    _relay();
  }
  void _relay() {
    _statusSub = _active.status.listen(_status.add);
    _capabilitySub = _active.capabilities.listen(_capabilities.add);
  }

  Future<void> usePhysical() => _replace(BleFrameTransport());
  Future<void> useSimulator() async {
    if (_active is! SimulatorTransport) await _replace(SimulatorTransport());
  }

  Future<void> _replace(FrameTransport next) async {
    await _statusSub?.cancel();
    await _capabilitySub?.cancel();
    await _active.dispose();
    _active = next;
    _relay();
  }

  @override
  Stream<FrameDeviceStatus> get status => _status.stream;
  @override
  Stream<DeviceCapabilities> get capabilities => _capabilities.stream;
  @override
  Future<void> connect() => _active.connect();
  @override
  Future<void> disconnect() => _active.disconnect();
  @override
  Future<void> forget() => _active.forget();
  @override
  Future<int> applyAppearance(FrameAppearance appearance) =>
      _active.applyAppearance(appearance);
  @override
  Future<void> off() => _active.off();
  @override
  Future<void> dispose() async {
    await _statusSub?.cancel();
    await _capabilitySub?.cancel();
    await _active.dispose();
    await _status.close();
    await _capabilities.close();
  }
}

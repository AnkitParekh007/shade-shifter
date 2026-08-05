import '../../core/models.dart';

abstract interface class FrameTransport {
  Stream<FrameDeviceStatus> get status;
  Stream<DeviceCapabilities> get capabilities;
  Future<void> connect();
  Future<void> disconnect();
  Future<void> forget();
  Future<int> applyAppearance(FrameAppearance appearance);
  Future<void> off();
  Future<void> dispose();
}

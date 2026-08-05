import 'frame_appearance.dart';
import 'frame_device.dart';

abstract interface class FrameTransport {
  Stream<FrameDeviceStatus> get status;

  Future<void> connect();
  Future<void> disconnect();
  Future<int> applyAppearance(FrameAppearance appearance);
  Future<void> dispose();
}

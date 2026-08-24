import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared/models/device_state.dart';

/// Securely persists the last authorized device reference (for reconnect) and
/// any bonding/authorization metadata. Kept out of plain preferences and normal
/// logs — see PRIVACY-NOTES.md and SECURITY-THREAT-MODEL.md.
class SecureDeviceStore {
  const SecureDeviceStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _keyLastDeviceId = 'last_device_id';
  static const _keyLastDeviceName = 'last_device_name';
  static const _keyLastDeviceSim = 'last_device_is_sim';

  Future<void> saveAuthorizedDevice(DeviceRef device) async {
    await _storage.write(key: _keyLastDeviceId, value: device.id);
    await _storage.write(key: _keyLastDeviceName, value: device.name);
    await _storage.write(
        key: _keyLastDeviceSim, value: device.isSimulator.toString());
  }

  Future<DeviceRef?> readAuthorizedDevice() async {
    final id = await _storage.read(key: _keyLastDeviceId);
    if (id == null) return null;
    return DeviceRef(
      id: id,
      name: await _storage.read(key: _keyLastDeviceName) ?? 'Shade Shifter',
      isSimulator:
          (await _storage.read(key: _keyLastDeviceSim)) == 'true',
    );
  }

  Future<void> forget() async {
    await _storage.delete(key: _keyLastDeviceId);
    await _storage.delete(key: _keyLastDeviceName);
    await _storage.delete(key: _keyLastDeviceSim);
  }
}

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../core/models.dart';
import '../domain/frame_transport_v2.dart';

class BleFrameTransport implements FrameTransport {
  static final serviceUuid = Guid('7f4a0001-9d45-4d9e-b890-9f132c08a001');
  static final colorUuid = Guid('7f4a0002-9d45-4d9e-b890-9f132c08a001');
  final _status = StreamController<FrameDeviceStatus>.broadcast();
  final _capabilities = StreamController<DeviceCapabilities>.broadcast();
  BluetoothDevice? _device;
  BluetoothCharacteristic? _color;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;
  int _sequence = 0;
  Future<void> _writeQueue = Future<void>.value();
  @override
  Stream<FrameDeviceStatus> get status => _status.stream;
  @override
  Stream<DeviceCapabilities> get capabilities => _capabilities.stream;

  @override
  Future<void> connect() async {
    if (await FlutterBluePlus.isSupported == false) {
      _status.add(const FrameDeviceStatus(
          phase: ConnectionPhase.failed,
          simulator: false,
          error: 'Bluetooth LE is unavailable.'));
      return;
    }
    _status.add(const FrameDeviceStatus(
        phase: ConnectionPhase.scanning, simulator: false));
    final found = Completer<BluetoothDevice>();
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        if (!found.isCompleted) found.complete(result.device);
      }
    });
    await FlutterBluePlus.startScan(
        withServices: [serviceUuid], timeout: const Duration(seconds: 8));
    BluetoothDevice device;
    try {
      device = await found.future.timeout(const Duration(seconds: 9));
    } on TimeoutException {
      _status.add(const FrameDeviceStatus(
          phase: ConnectionPhase.failed,
          simulator: false,
          error: 'No compatible frame found.'));
      return;
    }
    await FlutterBluePlus.stopScan();
    _device = device;
    _status.add(FrameDeviceStatus(
        phase: ConnectionPhase.connecting,
        name: device.platformName,
        simulator: false));
    await device.connect(timeout: const Duration(seconds: 12));
    _connectionSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _status.add(FrameDeviceStatus(
            phase: ConnectionPhase.disconnected,
            name: device.platformName,
            simulator: false,
            error: 'Frame disconnected. Your edits are retained.'));
      }
    });
    final services = await device.discoverServices();
    final service = services.where((s) => s.uuid == serviceUuid).firstOrNull;
    _color =
        service?.characteristics.where((c) => c.uuid == colorUuid).firstOrNull;
    if (_color == null) {
      await disconnect();
      throw StateError('Frame has an incompatible BLE service.');
    }
    _capabilities.add(DeviceCapabilities.legacyRevA);
    _status.add(FrameDeviceStatus(
        phase: ConnectionPhase.connected,
        name: device.platformName.isEmpty
            ? 'ShadeShifter-POC'
            : device.platformName,
        firmware: 'Rev A (legacy RGB)',
        simulator: false));
  }

  @override
  Future<int> applyAppearance(FrameAppearance appearance) async {
    final characteristic = _color;
    if (characteristic == null) throw StateError('Frame is not connected.');
    final color = appearance.front.primary;
    final payload = [
      (color.r * 255).round(),
      (color.g * 255).round(),
      (color.b * 255).round()
    ];
    final operation = _writeQueue.then((_) =>
        characteristic.write(payload, withoutResponse: false, timeout: 8));
    _writeQueue = operation;
    await operation;
    return ++_sequence;
  }

  @override
  Future<void> off() async {
    final c = _color;
    if (c != null) await c.write([0, 0, 0], withoutResponse: false);
  }

  @override
  Future<void> disconnect() async {
    await _device?.disconnect();
    _color = null;
  }

  @override
  Future<void> forget() async {
    await disconnect();
    _device = null;
  }

  @override
  Future<void> dispose() async {
    await _scanSubscription?.cancel();
    await _connectionSubscription?.cancel();
    await disconnect();
    await _status.close();
    await _capabilities.close();
  }
}

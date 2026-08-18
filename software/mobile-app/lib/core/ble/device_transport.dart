import '../../shared/models/device_capabilities.dart';
import '../../shared/models/device_state.dart';
import '../result/result.dart';
import 'protocol.dart';

/// The single seam between business/UI logic and any concrete transport.
///
/// Simulator, fake (tests) and physical BLE all implement this identical
/// contract, so the app never imports `flutter_blue_plus` outside the BLE
/// implementation. This is what satisfies acceptance criterion #8.
abstract interface class DeviceTransport {
  /// Broadcast stream of connection lifecycle changes.
  Stream<ConnectionStatus> get connectionStatus;

  /// Broadcast stream of telemetry snapshots (battery, temp, rssi, …).
  Stream<DeviceTelemetry> get telemetry;

  /// Broadcast stream of correlated command acknowledgements.
  Stream<CommandAck> get acks;

  ConnectionStatus get currentStatus;

  /// Negotiated capabilities, or `null` until a device is connected.
  DeviceCapabilities? get capabilities;

  /// Scans for compatible frames. Only ever called after explicit user action.
  Future<Result<List<DeviceRef>>> scan({Duration timeout});

  /// Stops an in-progress scan and releases scan resources.
  Future<void> stopScan();

  /// Connects, discovers services and negotiates capabilities.
  Future<Result<DeviceCapabilities>> connect(DeviceRef device);

  /// Attempts to reconnect to a previously authorized device by id.
  Future<Result<DeviceCapabilities>> reconnect(DeviceRef device);

  Future<void> disconnect();

  /// Sends a command and resolves with its correlated acknowledgement (or an
  /// error on timeout/rejection). The transport owns commandId assignment,
  /// sequencing, retries and idempotency — see BLE-PROTOCOL.md.
  Future<Result<CommandAck>> send(DeviceCommand command);

  /// Releases all subscriptions and BLE resources. Idempotent.
  Future<void> dispose();
}

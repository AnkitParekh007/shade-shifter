import '../../core/result/result.dart';
import '../../shared/models/device_state.dart';

/// A narrow, plugin-agnostic view of the platform BLE stack.
///
/// This is the app's *second* isolation seam. `DeviceTransport` already keeps
/// UI and business logic away from BLE; this keeps the Rev-A protocol logic
/// (command → bytes, lifecycle, error mapping) away from `flutter_blue_plus`
/// itself, so that logic is unit-testable on a machine with no BLE radio and
/// no native plugin — which is how CI verifies it (ADR 0003).
///
/// Exactly one implementation may import `flutter_blue_plus`:
/// `FlutterBluePlusBackend`. Tests use `FakeBleBackend`.
///
/// Every method reports failure as a [Result]; implementations must not throw.
abstract interface class BleBackend {
  /// Requests the permissions BLE needs and verifies the adapter is usable.
  /// Called before any scan, never implicitly at startup.
  Future<Result<void>> ensureReady();

  /// Scans for peripherals advertising any of [serviceUuids] whose advertised
  /// name starts with [namePrefix]. Resolves when [timeout] elapses.
  Future<Result<List<DeviceRef>>> scan({
    required List<String> serviceUuids,
    required String namePrefix,
    required Duration timeout,
  });

  Future<void> stopScan();

  /// Connects to [deviceId] (an opaque platform remote id).
  Future<Result<void>> connect(String deviceId, {required Duration timeout});

  /// Emits `true` on connect and `false` on every disconnect, including
  /// unexpected ones (out of range, powered off).
  Stream<bool> get connectionEvents;

  bool get isConnected;

  /// Discovers services and verifies [service] exposes every characteristic in
  /// [characteristics]. Fails with `AppErrorKind.unsupportedFirmware` when the
  /// peripheral does not match the expected profile.
  Future<Result<void>> discover({
    required String service,
    required List<String> characteristics,
  });

  /// Writes [value] to a characteristic. When [withoutResponse] is false the
  /// peripheral's ATT layer confirms receipt — the only delivery guarantee a
  /// Rev-A frame offers, since it has no application-level ack characteristic.
  Future<Result<void>> write({
    required String service,
    required String characteristic,
    required List<int> value,
    bool withoutResponse = false,
  });

  Future<Result<List<int>>> read({
    required String service,
    required String characteristic,
  });

  /// Link-layer signal strength, or `null` when unavailable. This is the only
  /// telemetry a Rev-A frame can provide — it reports no battery or temperature.
  Future<int?> readRssi();

  Future<void> disconnect();

  /// Releases subscriptions and platform resources. Idempotent.
  Future<void> dispose();
}

import 'dart:async';

import 'package:shade_shifter/core/errors/app_error.dart';
import 'package:shade_shifter/core/result/result.dart';
import 'package:shade_shifter/features/device/ble_backend.dart';
import 'package:shade_shifter/shared/models/device_state.dart';

/// A scriptable [BleBackend] that models the Rev-A bench firmware closely
/// enough to test the transport against it: it stores the last written value
/// and serves it on read (NimBLE does the same), and it *ignores* any payload
/// that is not exactly three bytes — exactly like `shade_shifter_bench.ino`.
class FakeBleBackend implements BleBackend {
  FakeBleBackend();

  /// Every payload handed to [write], in order.
  final List<List<int>> writes = [];

  /// The characteristic's stored value. Seeded with the firmware's boot value
  /// (`\0\0\x10` — dim blue) so tests exercise the real starting state.
  List<int> stored = [0, 0, 16];

  /// When false, writes are accepted but not stored — models a frame that
  /// silently drops the payload, which read-back verification must catch.
  bool echoWrites = true;

  AppError? readyError;
  AppError? connectError;
  AppError? discoverError;
  AppError? writeError;
  AppError? readError;
  AppError? scanError;

  List<DeviceRef> scanResults = const [
    DeviceRef(
      id: 'AA:BB:CC:DD:EE:FF',
      name: 'ShadeShifter-POC',
      isSimulator: false,
      rssi: -57,
    ),
  ];

  int? rssi = -57;
  bool disposed = false;
  bool scanStopped = false;
  int discoverCalls = 0;
  int readCalls = 0;

  final _connection = StreamController<bool>.broadcast();
  bool _connected = false;

  @override
  Stream<bool> get connectionEvents => _connection.stream;

  @override
  bool get isConnected => _connected;

  /// Simulates the frame going out of range / powering off.
  void dropConnection() {
    _connected = false;
    _connection.add(false);
  }

  @override
  Future<Result<void>> ensureReady() async =>
      readyError == null ? const Result.ok(null) : Result.err(readyError!);

  @override
  Future<Result<List<DeviceRef>>> scan({
    required List<String> serviceUuids,
    required String namePrefix,
    required Duration timeout,
  }) async {
    if (scanError != null) return Result.err(scanError!);
    return Result.ok(scanResults);
  }

  @override
  Future<void> stopScan() async => scanStopped = true;

  @override
  Future<Result<void>> connect(
    String deviceId, {
    required Duration timeout,
  }) async {
    if (connectError != null) return Result.err(connectError!);
    _connected = true;
    _connection.add(true);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> discover({
    required String service,
    required List<String> characteristics,
  }) async {
    discoverCalls++;
    return discoverError == null
        ? const Result.ok(null)
        : Result.err(discoverError!);
  }

  @override
  Future<Result<void>> write({
    required String service,
    required String characteristic,
    required List<int> value,
    bool withoutResponse = false,
  }) async {
    if (writeError != null) return Result.err(writeError!);
    writes.add(List<int>.unmodifiable(value));
    // Firmware: `if (value.size() != 3) return;`
    if (echoWrites && value.length == 3) stored = List<int>.from(value);
    return const Result.ok(null);
  }

  @override
  Future<Result<List<int>>> read({
    required String service,
    required String characteristic,
  }) async {
    readCalls++;
    return readError == null
        ? Result.ok(List<int>.unmodifiable(stored))
        : Result.err(readError!);
  }

  @override
  Future<int?> readRssi() async => rssi;

  @override
  Future<void> disconnect() async {
    if (_connected) {
      _connected = false;
      _connection.add(false);
    }
  }

  @override
  Future<void> dispose() async {
    if (disposed) return;
    disposed = true;
    await _connection.close();
  }
}

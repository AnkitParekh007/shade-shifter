import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/errors/app_error.dart';
import '../../core/logging/app_logger.dart';
import '../../core/result/result.dart';
import '../../shared/models/device_state.dart';
import 'ble_backend.dart';

/// The **only** file in the app permitted to import `flutter_blue_plus` or
/// `permission_handler`.
///
/// It is deliberately thin — permissions, scan, connect, discover, read/write —
/// with no Shade Shifter protocol knowledge, so that everything worth testing
/// lives in `BleTransport` where it can run without a radio. Keeping this file
/// small is also what keeps the un-runnable-locally surface small: it is
/// verified by the Android/iOS compile jobs in CI (ADR 0003).
class FlutterBluePlusBackend implements BleBackend {
  FlutterBluePlusBackend();

  static const _log = AppLogger('BleBackend');

  /// Opens the OS app-settings page for the permanently-denied permission flow.
  /// This only *navigates* there — the user makes the change themselves.
  static Future<void> openSystemSettings() => openAppSettings();

  final _connectionController = StreamController<bool>.broadcast();

  BluetoothDevice? _device;
  List<BluetoothService> _services = const [];
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<ScanResult>>? _scanSub;
  bool _disposed = false;

  @override
  Stream<bool> get connectionEvents => _connectionController.stream;

  @override
  bool get isConnected => _device?.isConnected ?? false;

  // ------------------------------------------------------------ readiness

  @override
  Future<Result<void>> ensureReady() async {
    try {
      if (!await FlutterBluePlus.isSupported) {
        return const Result.err(
          AppError(
            AppErrorKind.bluetoothDisabled,
            code: 'BLE_UNSUPPORTED_DEVICE',
            message: 'This device has no Bluetooth Low Energy radio.',
          ),
        );
      }

      final permission = await _requestPermissions();
      if (permission.isErr) return permission;

      final state = await _settledAdapterState();
      if (state != BluetoothAdapterState.on) {
        // We never turn the radio on for the user — that is a system setting.
        return const Result.err(
          AppError(
            AppErrorKind.bluetoothDisabled,
            code: 'BLE_ADAPTER_OFF',
            message: 'Bluetooth is turned off.',
          ),
        );
      }
      return const Result.ok(null);
    } on Object catch (e) {
      return _failure(AppErrorKind.unknown, 'BLE_READY_FAILED', e);
    }
  }

  Future<Result<void>> _requestPermissions() async {
    final needed = <Permission>[
      if (Platform.isAndroid) ...[
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ],
      if (Platform.isIOS) Permission.bluetooth,
    ];
    for (final permission in needed) {
      final status = await permission.request();
      if (status.isPermanentlyDenied) {
        return const Result.err(
          AppError(
            AppErrorKind.permissionPermanentlyDenied,
            code: 'BLE_PERMISSION_PERMANENT',
          ),
        );
      }
      if (!status.isGranted) {
        return const Result.err(
          AppError(AppErrorKind.permissionDenied, code: 'BLE_PERMISSION_DENIED'),
        );
      }
    }
    return const Result.ok(null);
  }

  /// The adapter reports `unknown` briefly at cold start; wait for a real value
  /// before deciding Bluetooth is off.
  Future<BluetoothAdapterState> _settledAdapterState() async {
    final now = FlutterBluePlus.adapterStateNow;
    if (now != BluetoothAdapterState.unknown) return now;
    try {
      return await FlutterBluePlus.adapterState
          .where((s) => s != BluetoothAdapterState.unknown)
          .first
          .timeout(const Duration(seconds: 3));
    } on Object {
      return BluetoothAdapterState.unknown;
    }
  }

  // ---------------------------------------------------------------- scanning

  @override
  Future<Result<List<DeviceRef>>> scan({
    required List<String> serviceUuids,
    required String namePrefix,
    required Duration timeout,
  }) async {
    final found = <String, DeviceRef>{};
    try {
      await _scanSub?.cancel();
      _scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          final advertised = r.advertisementData.advName;
          final name = advertised.isNotEmpty
              ? advertised
              : (r.device.platformName.isNotEmpty
                  ? r.device.platformName
                  : '$namePrefix frame');
          found[r.device.remoteId.str] = DeviceRef(
            id: r.device.remoteId.str,
            name: name,
            isSimulator: false,
            rssi: r.rssi,
          );
        }
      });

      // Filter in the platform stack by service UUID. iOS requires this to
      // discover peripherals advertising a vendor service, and it is the only
      // field the Rev-A advertisement is guaranteed to carry (a 128-bit UUID
      // plus "ShadeShifter-POC" does not fit one legacy advertising packet, so
      // the name may arrive only in the scan response).
      await FlutterBluePlus.startScan(
        withServices: serviceUuids.map(Guid.new).toList(),
        timeout: timeout,
      );
      await Future<void>.delayed(timeout);
      await stopScan();
      return Result.ok(found.values.toList(growable: false));
    } on Object catch (e) {
      await stopScan();
      return _failure(AppErrorKind.unknown, 'BLE_SCAN_FAILED', e);
    }
  }

  @override
  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    try {
      if (FlutterBluePlus.isScanningNow) await FlutterBluePlus.stopScan();
    } on Object catch (e) {
      _log.warning('stopScan failed', data: e.runtimeType);
    }
  }

  // -------------------------------------------------------------- connecting

  @override
  Future<Result<void>> connect(
    String deviceId, {
    required Duration timeout,
  }) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      _device = device;

      await _connectionSub?.cancel();
      _connectionSub = device.connectionState.listen((state) {
        if (_disposed) return;
        _connectionController.add(state == BluetoothConnectionState.connected);
      });

      await device.connect(timeout: timeout);
      return const Result.ok(null);
    } on Object catch (e) {
      return _failure(AppErrorKind.connectionTimeout, 'BLE_CONNECT_FAILED', e);
    }
  }

  @override
  Future<Result<void>> discover({
    required String service,
    required List<String> characteristics,
  }) async {
    final device = _device;
    if (device == null) {
      return const Result.err(
        AppError(AppErrorKind.unexpectedDisconnect, code: 'BLE_NO_DEVICE'),
      );
    }
    try {
      _services = await device.discoverServices();
      final target = Guid(service);
      BluetoothService? match;
      for (final s in _services) {
        if (s.uuid == target) {
          match = s;
          break;
        }
      }
      if (match == null) {
        return const Result.err(
          AppError(
            AppErrorKind.unsupportedFirmware,
            code: 'BLE_SERVICE_MISSING',
            message: 'Frame does not expose the Rev-A service.',
          ),
        );
      }
      for (final uuid in characteristics) {
        final wanted = Guid(uuid);
        final present = match.characteristics.any((c) => c.uuid == wanted);
        if (!present) {
          return const Result.err(
            AppError(
              AppErrorKind.unsupportedFirmware,
              code: 'BLE_CHARACTERISTIC_MISSING',
            ),
          );
        }
      }
      return const Result.ok(null);
    } on Object catch (e) {
      return _failure(
        AppErrorKind.unsupportedFirmware,
        'BLE_DISCOVER_FAILED',
        e,
      );
    }
  }

  // ------------------------------------------------------------------- io

  BluetoothCharacteristic? _characteristic(String service, String uuid) {
    final s = Guid(service);
    final c = Guid(uuid);
    for (final svc in _services) {
      if (svc.uuid != s) continue;
      for (final chr in svc.characteristics) {
        if (chr.uuid == c) return chr;
      }
    }
    return null;
  }

  @override
  Future<Result<void>> write({
    required String service,
    required String characteristic,
    required List<int> value,
    bool withoutResponse = false,
  }) async {
    final target = _characteristic(service, characteristic);
    if (target == null) {
      return const Result.err(
        AppError(
          AppErrorKind.unsupportedFirmware,
          code: 'BLE_CHARACTERISTIC_MISSING',
        ),
      );
    }
    try {
      await target.write(value, withoutResponse: withoutResponse);
      return const Result.ok(null);
    } on Object catch (e) {
      return _failure(AppErrorKind.commandTimeout, 'BLE_WRITE_FAILED', e);
    }
  }

  @override
  Future<Result<List<int>>> read({
    required String service,
    required String characteristic,
  }) async {
    final target = _characteristic(service, characteristic);
    if (target == null) {
      return const Result.err(
        AppError(
          AppErrorKind.unsupportedFirmware,
          code: 'BLE_CHARACTERISTIC_MISSING',
        ),
      );
    }
    try {
      return Result.ok(await target.read());
    } on Object catch (e) {
      return _failure(AppErrorKind.commandTimeout, 'BLE_READ_FAILED', e);
    }
  }

  @override
  Future<int?> readRssi() async {
    final device = _device;
    if (device == null || !device.isConnected) return null;
    try {
      return await device.readRssi();
    } on Object {
      return null;
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _device?.disconnect();
    } on Object catch (e) {
      _log.warning('disconnect failed', data: e.runtimeType);
    }
    await _connectionSub?.cancel();
    _connectionSub = null;
    _services = const [];
    _device = null;
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await stopScan();
    await disconnect();
    await _connectionController.close();
  }

  /// Maps a platform exception to an [AppError] without leaking identifiers
  /// into logs — see PRIVACY-NOTES.md.
  Result<T> _failure<T>(AppErrorKind kind, String code, Object cause) {
    _log.warning(code, data: cause.runtimeType);
    return Result<T>.err(AppError(kind, code: code, cause: cause));
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_transport.dart';
import '../../shared/models/device_state.dart';
import '../simulator/simulator_transport.dart';
import 'ble_backend.dart';
import 'ble_transport.dart';
import 'flutter_blue_plus_backend.dart';

/// Creates the correct [DeviceTransport] for a chosen device: simulator devices
/// get a [SimulatorTransport], physical devices get a [BleTransport] speaking
/// the Rev-A legacy contract. Keeping this behind a factory means the rest of
/// the app never branches on transport type.
class TransportFactory {
  const TransportFactory({BleBackend Function()? backendBuilder})
      : _backendBuilder = backendBuilder;

  /// Injection seam for tests; defaults to the real `flutter_blue_plus` stack.
  final BleBackend Function()? _backendBuilder;

  DeviceTransport createFor(DeviceRef device) =>
      device.isSimulator ? SimulatorTransport() : createBle();

  /// A fresh simulator transport for the "Try Simulator" entry point.
  DeviceTransport createSimulator() => SimulatorTransport();

  /// A physical transport. Discovery and connection each build their own, which
  /// is fine: the platform BLE stack is a process-wide singleton.
  DeviceTransport createBle() =>
      BleTransport((_backendBuilder ?? FlutterBluePlusBackend.new)());

  /// Deep-links to this app's OS settings page so the user can grant a
  /// permanently-denied permission themselves. We never change it for them.
  Future<void> openSystemSettings() =>
      FlutterBluePlusBackend.openSystemSettings();
}

final transportFactoryProvider =
    Provider<TransportFactory>((ref) => const TransportFactory());

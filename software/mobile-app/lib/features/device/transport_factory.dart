import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/ble/device_transport.dart';
import '../../shared/models/device_state.dart';
import '../simulator/simulator_transport.dart';

/// Creates the correct [DeviceTransport] for a chosen device. Simulator devices
/// get a [SimulatorTransport]; physical devices will get a `BleTransport`
/// (Phase 3 — see IMPLEMENTATION-STATUS.md). Keeping this behind a factory means
/// the rest of the app never branches on transport type.
class TransportFactory {
  const TransportFactory();

  DeviceTransport createFor(DeviceRef device) {
    if (device.isSimulator) {
      return SimulatorTransport();
    }
    // Phase 3: return BleTransport(device). Until the physical transport is
    // implemented and hardware-validated, fall back to the simulator so the
    // app never hard-crashes on a stale paired reference.
    return SimulatorTransport();
  }

  /// A fresh simulator transport for the "Try Simulator" entry point.
  DeviceTransport createSimulator() => SimulatorTransport();
}

final transportFactoryProvider =
    Provider<TransportFactory>((ref) => const TransportFactory());

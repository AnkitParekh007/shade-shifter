# Hardware Integration

How the app meets the Rev-A ESP32 frame, and the exact next task to go from
simulator to silicon.

## Current state
- Protocol drafted and **simulator-validated** (`SimulatorTransport`,
  `FakeTransport`, `CommandCodec` + test vectors).
- `DeviceTransport` seam ready; nothing above it knows about BLE.
- **`BleTransport` is not yet implemented** — deliberately kept out of the
  compiled tree so CI stays green without a device/SDK (ADR 0003).

## The next hardware task (single, concrete)
Implement `lib/features/device/ble_transport.dart` as a `DeviceTransport` using
`flutter_blue_plus`, then register it in `TransportFactory.createFor` for
non-simulator devices. Steps:

1. **Permissions**: gate `scan()` behind `permission_handler` (Android 12+
   scan/connect; iOS usage descriptions already applied by the bootstrap script).
2. **Scan**: `FlutterBluePlus.startScan` filtered to the service UUID /
   `ShadeShifter` name prefix; map results to `DeviceRef` (id, name, rssi); stop
   on selection/timeout.
3. **Connect + discover**: connect, discover the vendor service
   (`BleIds.service`) and its characteristics.
4. **Negotiate**: read `charCapabilities`; parse into `DeviceCapabilities`;
   `handshake` and verify `protocolVersion` (→ `protocolMismatch` on mismatch).
5. **Command path**: encode via `CommandCodec.encode`, write to
   `charCommandWrite`; correlate notifications on `charCommandAck` by
   `commandId`; surface `CommandAck`.
6. **Telemetry**: subscribe to `charTelemetry` / `charCurrentState`; decode into
   `DeviceTelemetry`.
7. **Lifecycle**: handle disconnect, backgrounding/resume, reconnect to the
   secure-stored device; cancel every subscription in `dispose()`.

The `DeviceController` pipeline (timeout, bounded retry, idempotency) and the
`SafetyGovernor` already sit above this — no changes needed there.

## Validation checklist against real firmware (Phase 7)
- [ ] Confirm/replace all **UUIDs** (`ble_ids.dart`) jointly with firmware.
- [ ] Verify byte order, payload sizes, checksum and status codes vs. firmware.
- [ ] Record real BLE behaviour (MTU, notify cadence, ack latency).
- [ ] Test disconnection during apply → reconnection → **state reconciliation**.
- [ ] Validate command rate the frame tolerates; tune the 120 ms debounce.
- [ ] Validate safe brightness ceiling and thermal warning/shutdown thresholds
      match firmware capabilities.
- [ ] Document every deviation from this spec before changing the contract.

## Capability mapping
`DeviceCapabilities.revA` is the reference profile the simulator uses and the
conservative default. Real units must return their own capability blob; the UI is
driven entirely by it (zones, effects, `maxIntensity`, `safeDefaultIntensity`,
thermal thresholds, gradient/warm-cool/find-my-frame support).

## Firmware coordination
No firmware exists under `software/firmware/` or `hardware/` yet. If/when it
does, treat its implemented contract as authoritative and reconcile this spec to
it (preserve compatibility; document mismatches first).

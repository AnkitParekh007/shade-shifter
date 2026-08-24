# Hardware Integration

How the app meets the Rev-A ESP32 frame, and the exact next task to go from
simulator to silicon.

## Current state
- Protocol drafted and **simulator-validated** (`SimulatorTransport`,
  `FakeTransport`, `CommandCodec` + test vectors).
- `DeviceTransport` seam ready; nothing above it knows about BLE.
- **Rev-A bench firmware EXISTS** at
  `hardware/blueprint-plan/firmware/shade_shifter_bench.ino` and defines a
  concrete, minimal BLE contract (see BLE-PROTOCOL.md "Rev-A legacy"). The app
  now models it as `DeviceCapabilities.revALegacy` +
  `BleIds.serviceRevA`/`charRevAColor`.
- **`BleTransport` is not yet implemented** — deliberately kept out of the
  compiled tree so CI stays green without a device/SDK (ADR 0003).

## The next hardware task (single, concrete): Rev-A legacy transport
Implement `lib/features/device/ble_transport.dart` as a `DeviceTransport` using
`flutter_blue_plus`, targeting the **Rev-A legacy** contract first (raw 3-byte
RGB — far simpler than packet-v1), then register it in
`TransportFactory.createFor` for non-simulator devices. Steps:

1. **Permissions**: gate `scan()` behind `permission_handler` (Android 12+
   scan/connect; iOS usage descriptions already applied by the bootstrap script).
2. **Scan**: `FlutterBluePlus.startScan` filtered to `BleIds.serviceRevA` /
   `ShadeShifter` name prefix (`ShadeShifter-POC`); map to `DeviceRef`; stop on
   selection/timeout.
3. **Connect + discover**: connect, discover `BleIds.serviceRevA` and its
   `charRevAColor` characteristic. **No** capability/ack/telemetry chars exist.
4. **Apply the static profile**: assign `DeviceCapabilities.revALegacy` (no
   negotiation) so the UI degrades to whole-frame solid color.
5. **Command path**: for a whole-frame solid color, write the **3 bytes R,G,B**
   to `charRevAColor` (write, or write-with-response). There is no ack — treat a
   successful write (optionally read-back verified against the characteristic) as
   `CommandAck.ok`. Ignore intensity/gradient/effect (not supported).
6. **Telemetry**: none on Rev-A → leave `DeviceTelemetry` fields null ("Not
   supported"). Optionally poll `charRevAColor` READ for a liveness signal.
7. **Lifecycle**: handle disconnect, backgrounding/resume, reconnect to the
   secure-stored device; cancel every subscription in `dispose()`.

The `DeviceController` pipeline (timeout, bounded retry — retry the write on
timeout, safe because it's idempotent) and the `SafetyGovernor` already sit above
this — no changes needed there. Packet-v1 (negotiation, per-zone commands, acks,
telemetry) is a later firmware milestone; keep it behind capability checks.

## Validation checklist against real firmware (Phase 7)
- [x] Rev-A **UUIDs / payload confirmed** from `shade_shifter_bench.ino`
      (service `7f4a0001…`, color `7f4a0002…`, 3-byte RGB, 12.5% fixed).
- [ ] Bench-verify a live write actually recolors the 24-LED strip.
- [ ] Confirm packet-v1 UUIDs jointly with firmware once that milestone starts.
- [ ] Verify byte order, payload sizes, checksum and status codes vs. firmware.
- [ ] Record real BLE behaviour (MTU, notify cadence, ack latency).
- [ ] Test disconnection during apply → reconnection → **state reconciliation**.
- [ ] Validate command rate the frame tolerates; tune the 120 ms debounce.
- [ ] Validate safe brightness ceiling and thermal warning/shutdown thresholds
      match firmware capabilities.
- [ ] Document every deviation from this spec before changing the contract.

## Capability mapping
- `DeviceCapabilities.revA` is the rich **simulator / packet-v1 target** profile
  and the conservative default when nothing is connected.
- `DeviceCapabilities.revALegacy` is what the **physical Rev-A** supports today:
  one whole-frame solid color, no gradient/effects, brightness fixed at ~12.5%,
  no telemetry. The Rev-A transport assigns it statically (there is no capability
  blob to read). The UI is driven entirely by the active profile.
- A future packet-v1 device returns its own capability blob to negotiate; until
  then, physical = `revALegacy`, simulator = `revA`.

## Firmware coordination
Rev-A firmware lives at
`hardware/blueprint-plan/firmware/shade_shifter_bench.ino` and is the
**authoritative** source for the Rev-A legacy contract. Any change to the Rev-A
UUIDs, payload, or brightness cap must change firmware and app together in the
same PR. Packet-v1 remains a proposed contract to agree jointly before firmware
implements it; document mismatches first.

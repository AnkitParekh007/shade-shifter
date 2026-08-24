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
- **`BleTransport` is implemented** (`lib/features/device/ble_transport.dart`)
  and selected by `TransportFactory` for any non-simulator device. It has been
  verified in CI (analyze, 25 unit tests, Android + iOS compile) but has **not
  yet talked to a physical frame** — see the validation checklist below.

## How the Rev-A transport works
Two seams, not one. `DeviceTransport` keeps UI and business logic away from BLE;
a second, narrower `BleBackend` seam keeps the *protocol logic* away from the
BLE package itself:

| File | Role | Imports `flutter_blue_plus`? |
|------|------|------|
| `ble_transport.dart` | Rev-A semantics: command → bytes, lifecycle, errors | no — pure Dart, unit-tested |
| `ble_backend.dart` | Narrow platform-BLE interface | no |
| `flutter_blue_plus_backend.dart` | Permissions, scan, connect, read/write | **yes — the only one** |

That split exists because the native plugin cannot run on the dev machine or in
`flutter test` (ADR 0003). Keeping the plugin surface to one thin adapter means
everything worth testing runs in CI against `FakeBleBackend`, which imitates the
bench firmware — including its rule that a payload of any length but 3 is
silently ignored.

What the transport does, given what the hardware lacks:

1. **Permissions** — `ensureReady()` requests Android `BLUETOOTH_SCAN`/
   `BLUETOOTH_CONNECT` (iOS: `Permission.bluetooth`) and checks the adapter is
   on, only after an explicit user action. It never turns the radio on.
2. **Scan** — filtered in the platform stack by `BleIds.serviceRevA`. iOS
   requires a service filter to find a vendor peripheral, and the service UUID
   is the field the Rev-A advertisement is most likely to carry: a 128-bit UUID
   plus `ShadeShifter-POC` does not fit one 31-byte legacy advertising packet,
   so the **name may arrive only in the scan response**. The name prefix is
   therefore used for display, not for filtering.
3. **Connect + discover** — verifies the peripheral really exposes
   `serviceRevA`/`charRevAColor`, and fails with `unsupportedFirmware` (dropping
   the link) if not.
4. **Capabilities** — `DeviceCapabilities.revALegacy` applied **statically**.
   Nothing is negotiated; there is no capability characteristic to read.
5. **Commands** — everything collapses to a 3-byte R,G,B write:
   - solid color → scaled RGB (see *Brightness* below)
   - gradient → **midpoint blend**, not a rejection, because `SafetyGovernor`
     already tells the user the frame "renders gradients as a solid blend"
   - illumination-off → `00 00 00`, **verified by read-back**
   - intensity-only → re-writes the last color at the new level
   - static effect → no-op success; animated effect, temple zone, rename →
     `rejectedUnsupported` (surfaced honestly, never faked)
   - handshake / capability / state reads → answered locally, no BLE traffic
6. **Brightness** — the firmware fixes global brightness at 32/255 and takes no
   intensity byte, so **scaling the RGB channels is the only dimming lever the
   app has**. Intensity is expressed as a fraction of the firmware ceiling: a
   request at the ceiling writes full-scale channels (rendered at 12.5%), and
   zero writes black. This deliberately differs from packet-v1, where intensity
   is a separate byte and must never be premultiplied.
7. **Acks** — none exist. A write-with-response (ATT-level confirmation) is
   treated as `AckStatus.ok`. Safety-critical writes are additionally read back
   and compared, which is meaningful because NimBLE stores the written value and
   serves it on READ.
8. **Telemetry** — link-layer RSSI only, polled every 10 s. Battery,
   temperature and firmware version stay `null` so the UI shows "Not supported"
   instead of inventing numbers.
9. **Lifecycle** — an unexpected disconnect surfaces as `error` → `disconnected`;
   every subscription and timer is cancelled in `dispose()`.

The `DeviceController` pipeline (timeout, bounded retry — safe because commands
are idempotent) and the `SafetyGovernor` sit above this unchanged. Packet-v1
(negotiation, per-zone commands, acks, telemetry) is a later firmware milestone;
it stays behind capability checks.

## Validation checklist against real firmware (Phase 7)
Nothing below has been done — the transport is code-complete and CI-verified,
but **no byte has reached a real frame**. Work top to bottom at the bench.

- [x] Rev-A **UUIDs / payload confirmed** from `shade_shifter_bench.ino`
      (service `7f4a0001…`, color `7f4a0002…`, 3-byte RGB, 12.5% fixed).
- [ ] Bench-verify a live write actually recolors the 24-LED strip.
- [ ] **Confirm the frame is discoverable with a service-UUID scan filter.** If
      NimBLE drops the 128-bit UUID from the advertisement rather than the name,
      `scan()` finds nothing and must fall back to name-prefix matching.
- [ ] Confirm READ returns the last written value (the read-back verification
      used for illumination-off depends on it).
- [ ] Sanity-check the RGB-scaling dim curve on real LEDs — WS2812B output is
      not linear, so a gamma correction may be needed in `_scaled`.
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

# ADR 0005 — A second seam (`BleBackend`) between BleTransport and flutter_blue_plus

- Status: Accepted
- Date: 2026-08-24

## Context
ADR 0001 put `DeviceTransport` between the app and BLE. That is enough to keep UI
and business logic hardware-free, but it leaves the **physical** transport itself
untestable: if `BleTransport` calls `flutter_blue_plus` directly, then the Rev-A
protocol logic — command → 3-byte payload, intensity scaling, gradient blending,
read-back verification, unsupported-feature rejection, disconnect handling — can
only run on a real device.

That matters more here than usual. Per ADR 0003 there is no Flutter SDK on the
dev machine and no hardware in CI, so anything that requires a radio is verified
by nobody. The Rev-A mapping is also the part most likely to be wrong: it is
where the app's rich model collapses onto a frame that does one thing.

## Decision
Split the physical transport in two:

- `features/device/ble_transport.dart` — all Rev-A semantics. Pure Dart,
  depends only on `BleBackend`.
- `features/device/ble_backend.dart` — a narrow interface: ensure-ready, scan,
  connect, discover, read, write, RSSI, disconnect.
- `features/device/flutter_blue_plus_backend.dart` — the **only** file in the
  app allowed to import `flutter_blue_plus` or `permission_handler`.

Tests drive `BleTransport` through `FakeBleBackend`, which imitates the bench
firmware: it stores the last written value and serves it on read, and it ignores
any payload whose length is not exactly 3 — the same rule as `onWrite` in
`shade_shifter_bench.ino`.

## Consequences
- The interesting logic is covered by 25 unit tests that run in CI on every push,
  with no radio and no plugin.
- The un-verifiable surface shrinks to one thin adapter with no branching logic,
  whose only real check is that it compiles (Android + iOS jobs).
- Swapping BLE packages, or adding a packet-v1 transport later, touches one file.
- Cost: one extra interface and a fake to maintain. Accepted — without it the
  Rev-A mapping would ship on inspection alone.
- **This does not substitute for bench validation.** Passing tests prove the app
  does what we believe the firmware expects; only hardware proves that belief.
  See the checklist in HARDWARE-INTEGRATION.md.

# Mobile App Implementation Status

Updated: 2026-08-05

## Delivered

- Android and iOS Flutter runners; Android API 24 minimum and BLE permissions.
- Guest onboarding, permission education, simulator/physical pairing, and four-tab shell.
- Riverpod application state, GoRouter navigation, capability-aware transports, and local persistence.
- Three-zone appearance model, solid colors, hex input, intensity, linked zones, undo/redo, off, and debounced writes.
- CAD-derived GLB with named `front`, `left_temple`, and `right_temple` meshes plus a 2D fallback.
- Curated and saved looks with create, duplicate, delete, apply, deterministic ordering, and malformed-row recovery.
- Rev A BLE transport and packet-v1 codec, telemetry/safety presentation, tests, and CI workflows.

## Evidence and limitations

| Acceptance area | Status | Evidence / limitation |
|---|---|---|
| Simulator-first journey | Implemented | Automated transport tests; simulator available without permissions |
| Rev A RGB writes | Implemented, hardware verification pending | Exact 3-byte adapter and UUID filtering |
| Packet v1 | Implemented | Round-trip, endian, CRC, and corruption tests |
| Saved looks | Implemented | Drift/SQLite schema with idempotent curated seed |
| 3D zones | Implemented | Bundled CAD-derived GLB and native material overrides |
| Android build | CI verification required | Local host has no Android SDK; `flutter build apk --debug` reached and reported that external prerequisite |
| iOS build | CI verification required | Requires macOS runner |
| Physical-device UX/thermal behavior | Manual verification pending | Requires ESP32 bench frame and phone hardware |

The app is a prototype companion, not a medical or certified safety system. Firmware remains authoritative.

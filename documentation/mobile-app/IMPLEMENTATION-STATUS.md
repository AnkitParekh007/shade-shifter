# Mobile App — Implementation Status

_Last updated: 2026-08-19. This is the canonical, honest progress checklist.
"Done" means implemented **and** covered by an automated test or manually
verifiable in the simulator. Build/analysis steps are **CI-verified** — the
authoring machine has no Flutter SDK (see ADR 0003)._

**CI status (PR #13, run 32240793520): all green** — format/analyze/test (43
tests), Android debug build, and iOS no-codesign build all pass on Flutter 3.29._

## Legend
✅ done · 🟡 partial · ⛔ not started · 🧪 CI-verified elsewhere

## Phase 0 — Repository audit ✅
- ✅ Repo inspected: greenfield (`LICENSE` + stub `README.md`), single `main`
  branch, no prior mobile/firmware/hardware/docs assets. No conflicts.
- ✅ Environment finding recorded: **no local Flutter/Dart** → verification via CI.

## Phase 1 — Flutter foundation ✅
- ✅ Project scaffold under `software/mobile-app/` (feature-first structure).
- ✅ `pubspec.yaml` (Riverpod, GoRouter, flutter_blue_plus, secure storage…).
- ✅ Strict `analysis_options.yaml`.
- ✅ `Result`/`AppError` types, `AppLogger` (with id redaction).
- ✅ Design tokens + Material 3 light/dark theme.
- ✅ GoRouter, app bootstrap/composition root.
- ✅ GitHub Actions CI (format, analyze, test, Android debug, iOS no-codesign).
- ✅ ADRs 0001–0004.

## Phase 2 — Simulator-first vertical slice ✅
- ✅ Splash → onboarding (5 pages) → pairing → **Try Simulator** → Home.
- ✅ `SimulatorTransport`: realistic connect/negotiate, latency+jitter, acks,
  battery drain, thermal drift, fault injection (drop ack, fail connect,
  thermal alarm, disconnect).
- ✅ Customize whole frame / front / left / right / both temples.
- ✅ **Independent zone persistence** (unit-tested: editing front leaves temples).
- ✅ Save look, re-apply look, **restart restoration** (last-applied appearance).
- ✅ Fully usable with no hardware.

## Phase 3 — BLE foundation 🟡
- ✅ `DeviceTransport` interface; UI/logic never import the BLE package.
- ✅ Binary `CommandCodec` (wire frames + checksum + test vectors).
- ✅ Command/ack pipeline with client timeout + bounded retry (idempotent).
- ✅ `FakeTransport` + BLE contract tests (handshake, unsupported version,
  dropped/duplicate ack, disconnect-during-apply).
- 🟡 Capability negotiation modelled + simulated. Rev-A has no capability
  characteristic, so the physical transport applies `revALegacy` statically;
  real negotiation arrives with packet-v1 firmware.
- ✅ **`BleTransport` implemented** (`features/device/ble_transport.dart`) for
  the Rev-A legacy contract, and wired into `TransportFactory` for physical
  devices. Command → 3-byte RGB mapping, static capability profile, read-back
  verification, unsupported-feature rejection and disconnect handling are
  covered by `test/ble_transport_test.dart` (25 tests, no radio required).
- ✅ `BleBackend` seam (`ble_backend.dart` + `flutter_blue_plus_backend.dart`):
  `flutter_blue_plus`/`permission_handler` are imported in exactly one file, so
  the protocol logic is testable and the un-runnable-locally surface is small.
- ✅ Runtime permission flow (`permission_handler`) implemented in the backend's
  `ensureReady()` (Android scan/connect, iOS bluetooth), gated behind an
  explicit user action.
- 🟡 **Not hardware-verified.** Everything above is verified by CI (analyze +
  tests + Android/iOS compile). No byte has yet reached a real frame — see the
  Phase 7 checklist in HARDWARE-INTEGRATION.md.

## Phase 4 — Customization studio 🟡
- ✅ Solid: swatches, hue slider, hex display, shades row, intensity.
- 🟡 Gradient: start/end/direction + capability warning (live gradient preview
  in 2D is represented by base color; richer gradient rendering pending).
- 🟡 Shades: lighter/darker done; warm/cool util implemented, not yet surfaced.
- 🟡 Effects: model + safety caps + simulator support; UI effect picker pending.
- ✅ Independent zones, debounced controlled command rate, apply-state feedback.
- ✅ Emergency illumination-off.

## Phase 5 — Realistic 3D experience 🟡
- ✅ High-quality custom-painted **2D vector frame** with independent zone
  materials, selection highlight, tap-to-select, optical proportions. This is
  the reliable default and the documented 3D fallback.
- ⛔ True GLB/3D (rotation, camera presets) — interface + replacement point
  documented in ARCHITECTURE.md; not implemented (can't verify heavy 3D
  compiles locally — ADR 0003).

## Phase 6 — Looks & device management 🟡
- ✅ 8 curated built-in looks; save/rename/duplicate/favourite/delete(+confirm).
- ✅ Favourites section; local persistence.
- ✅ Device screen: battery, est. remaining, temperature, signal, firmware,
  hardware rev, zones, effects, connect/disconnect/forget.
- 🟡 Rename/find-my-frame/diagnostics export are wired to UX with honest
  "syncs in Phase 3"/redacted-capture placeholders.
- ✅ Settings: theme, reduced motion, app brightness ceiling, privacy, forget.
- ⛔ Reorder favourites (drag) — not implemented.

## Phase 7 — Hardware integration 🟡
- ✅ Rev-A contract reconciled against real firmware (UUIDs, 3-byte payload,
  fixed 12.5% brightness) and pinned by `rev_a_contract_test.dart`.
- ✅ `BleTransport` implemented against that contract.
- ⛔ **Bench validation not done** — no code in this repo has talked to a
  physical frame yet. The open checklist lives in HARDWARE-INTEGRATION.md
  ("Validation checklist against real firmware"); the first item is confirming
  a live write actually recolors the 24-LED strip.

## Phase 8 — Quality & release readiness 🟡
- ✅ Unit tests: color, codec (test vectors), safety, simulator, studio
  (independent zones), persistence, BLE contract.
- ✅ Widget test (studio) + integration test (first-launch → simulator).
- ✅ `flutter analyze` clean + `flutter test` (43 tests) green in CI.
- ✅ Android debug build + iOS no-codesign build green in CI.
- 🧪 `dart format` reports drift (non-blocking) — run `dart format .` to normalize.
- 🟡 Accessibility: semantics labels, reduced-motion + text-scale honored;
  full audit pending. Performance audit pending. Physical-device tests pending.

## Acceptance criteria (§20) snapshot
| # | Criterion | State |
|---|-----------|-------|
| 1 | Launches on Android/iOS | 🟡 both builds green in CI; on-device launch untested |
| 2 | Full simulator journey | ✅ |
| 3 | Whole/front/temple selections unmistakable | ✅ |
| 4 | Front & temple colors independent | ✅ (tested) |
| 5 | Solid colors end-to-end | ✅ |
| 6 | Gradients preview + respect capability | 🟡 |
| 7 | Looks persist across restarts | ✅ (tested) |
| 8 | BLE isolated behind transport | ✅ |
| 9 | Handles denied perms / failed connections | 🟡 (failed-connect ✅; perms ⛔) |
| 10 | Ack + timeout + retry | ✅ (tested) |
| 11 | State reconciled after reconnect | 🟡 (reconnect path ✅; physical ⛔) |
| 12 | Safety limits can't be exceeded from UI | ✅ (tested) |
| 13 | Tests cover critical flows | ✅ |
| 14 | Analysis passes | ✅ CI-verified |
| 15 | Android debug build | ✅ CI-verified |
| 16 | iOS no-codesign build | ✅ CI-verified |
| 17 | Docs exist & match | ✅ |
| 18 | No secrets committed | ✅ |
| 19 | Buildable from README alone | ✅ |
| 20 | Polished investor demo, no hardware | ✅ |

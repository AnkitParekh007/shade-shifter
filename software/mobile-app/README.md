# Shade Shifter — Mobile App

Premium Flutter companion app for the Shade Shifter customizable BLE eyewear
(Rev-A ESP32 RGB-zone POC). Business/UI logic is fully decoupled from Bluetooth
behind a `DeviceTransport` interface, so a **simulator** and the physical BLE
transport are interchangeable. The entire experience runs with **no hardware**.

> ⚠️ Experimental POC hardware worn near the eyes. Safety limits are enforced in
> firmware; the app adds an extra protective layer. See
> [`../../documentation/mobile-app/`](../../documentation/mobile-app/).

## Requirements

- Flutter **stable ≥ 3.29** (Dart ≥ 3.7) — the theme uses `Color.withValues()`
  and `CardThemeData`, which require 3.27+. CI pins 3.29.0. Check with
  `flutter --version`.
- Android Studio / Xcode for device builds (iOS requires macOS + Xcode).

## Quick start (simulator — no hardware)

```bash
cd software/mobile-app
flutter pub get
flutter run            # choose any emulator/simulator, then "Try the simulator"
```

The `android/` and `ios/` folders are generated (not committed). If `flutter run`
reports missing platform folders, hydrate them first:

```bash
bash tool/bootstrap_platforms.sh all
```

This runs `flutter create` and applies our BLE permissions, identifiers and iOS
usage descriptions from `tool/platform/` (see ANDROID-SETUP / IOS-SETUP docs).

## Common commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
flutter build ios --no-codesign      # macOS only
```

## Architecture (feature-first clean architecture)

```
lib/
  app/        bootstrap, router, theme + design tokens
  core/       result, errors, logging, ble (transport interface + codec),
              persistence, safety, utils, di (Riverpod providers)
  features/   onboarding, device_pairing, frame_control (studio), looks,
              device_health, simulator, settings, device, home
  shared/     models (color, zones, appearance, capabilities, looks), widgets
```

- **State/DI:** Riverpod (`Notifier`/`Provider`, no code-gen — see ADR 0002).
- **Navigation:** GoRouter.
- **Transport seam:** `core/ble/device_transport.dart`. Implementations:
  `SimulatorTransport`, `FakeTransport` (tests), `BleTransport` (Phase 3).
- **Persistence:** `shared_preferences` (looks, prefs) + `flutter_secure_storage`
  (authorized-device reference). Drift migration noted in ADR 0004.

Full docs, diagrams, BLE protocol and status live in
[`documentation/mobile-app/`](../../documentation/mobile-app/).

## What works today

First launch → onboarding → **Try Simulator** → customize whole frame / front /
each temple independently → solid + gradient + shades + intensity → apply with a
full acknowledged/timeout/rejected state machine → save & re-apply looks →
restart restoration → device health → emergency illumination-off. See
[`IMPLEMENTATION-STATUS.md`](../../documentation/mobile-app/IMPLEMENTATION-STATUS.md)
for the honest per-feature state, including what is still stubbed.

# Android Setup

## Toolchain
- Flutter stable ≥ 3.29 (theme uses 3.27+ APIs; CI pins 3.29.0), Android SDK, JDK 17.
- **minSdk 23** (BLE + `flutter_blue_plus` baseline), **targetSdk 34**,
  compileSdk 34. Rationale: API 23 is the practical floor for stable BLE; API 31+
  needs the new runtime Bluetooth permissions handled below.
- Kotlin/AGP: use the versions `flutter create` emits for the pinned Flutter
  version (kept in sync automatically by the bootstrap script).

## Generate the native shell
`android/` is not committed. Recreate it and apply Shade Shifter config:

```bash
cd software/mobile-app
bash tool/bootstrap_platforms.sh android
```

This runs `flutter create --org com.shadeshifter --platforms android .`, copies
`tool/platform/android/AndroidManifest.xml` (permissions + `Shade Shifter`
label), and sets `applicationId = com.shadeshifter.app` (store identity; the code
namespace stays as generated).

## Permissions (already in the overlay manifest)
- **API 31+**: `BLUETOOTH_SCAN` (with `neverForLocation`) + `BLUETOOTH_CONNECT`.
  We do **not** derive location from BLE.
- **API ≤ 30**: legacy `BLUETOOTH`, `BLUETOOTH_ADMIN`, and `ACCESS_FINE_LOCATION`
  (`maxSdkVersion=30`) — required by the platform for BLE scanning on old APIs.
- `uses-feature android.hardware.bluetooth_le` (required).

Runtime requests are made **contextually at pairing**, never on launch —
implemented in `FlutterBluePlusBackend.ensureReady()` (`permission_handler`) and
triggered only when the user opens the scan sheet.

## Build & run
```bash
flutter build apk --debug            # CI artifact
flutter build appbundle              # release bundle (unsigned until keys exist)
flutter run                          # on device/emulator
```

## Release signing
No keystore is committed (see `.gitignore`). When ownership is finalized, add
`android/key.properties` (git-ignored) and wire `signingConfigs` per the Flutter
release docs. ProGuard/R8: default Flutter rules suffice; `flutter_blue_plus`
and `flutter_secure_storage` ship their own consumer rules — add keep rules only
if release stripping is observed to break reflection.

## Physical-device testing
1. Enable Developer options + USB debugging, connect device.
2. `flutter devices` → confirm it appears.
3. `flutter run` → **Pair a frame** (live BLE scan) or **Try the simulator**.
4. Verify BLE permission prompts appear only when pairing.
5. With a Rev-A frame powered on, confirm it appears in the scan sheet and that
   connecting applies the whole-frame color — the first unchecked item in
   HARDWARE-INTEGRATION.md's validation checklist.

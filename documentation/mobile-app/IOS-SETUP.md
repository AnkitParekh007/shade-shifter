# iOS Setup

> iOS compilation, signing and App Store submission require **macOS + Xcode +
> an Apple Developer account**. None of that can be done from Windows/Linux; use
> a Mac or the macOS CI job (`ios-build`).

## Toolchain
- Flutter stable ≥ 3.29 (theme uses 3.27+ APIs; CI pins 3.29.0), Xcode (latest stable), CocoaPods.
- **Minimum iOS 13.0** (Core Bluetooth + modern Flutter baseline).
- Dependencies use CocoaPods (Flutter default); `pod install` is handled by the
  Flutter build.

## Generate the native shell
`ios/` is not committed. Recreate it and apply config (run on macOS):

```bash
cd software/mobile-app
bash tool/bootstrap_platforms.sh ios
```

This runs `flutter create`, adds Bluetooth **usage descriptions** to
`ios/Runner/Info.plist` via PlistBuddy, and sets `PRODUCT_BUNDLE_IDENTIFIER =
com.shadeshifter.app`.

## Info.plist keys (applied by the script)
- `NSBluetoothAlwaysUsageDescription` — "Shade Shifter uses Bluetooth to connect
  to and control your frame."
- `NSBluetoothPeripheralUsageDescription` — same copy (older iOS).

**Background modes**: none by default. Do **not** add
`bluetooth-central` background mode unless a concrete requirement (e.g. keeping a
frame connected while backgrounded) is agreed — it triggers extra App Review
scrutiny and battery cost.

## Build
```bash
flutter build ios --no-codesign      # CI / local verification without signing
```

## Signing (placeholders only)
No provisioning profiles or certificates are committed (`.gitignore`). In Xcode,
set the Team and a real bundle id under Signing & Capabilities when an Apple
Developer account is available. Keep automatic signing for development.

## Physical-device testing
1. Open `ios/Runner.xcworkspace` in Xcode, select your device + Team.
2. `flutter run` (or Run in Xcode).
3. Confirm the Bluetooth permission prompt appears at **pairing**, not launch.

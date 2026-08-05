# Development Setup

Install stable Flutter 3.44 or newer, Android Studio with SDK 24+, and Xcode on macOS. From `software/mobile-app`, run `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter run`.

Simulator mode needs no permissions or hardware. For Rev A, first verify the frame using nRF Connect and the UUID/payload in `BLE-PROTOCOL.md`. Android requires Bluetooth scan/connect permission; Android 11 and earlier use location permission for BLE scanning. iOS shows the Bluetooth explanation from `Info.plist`.

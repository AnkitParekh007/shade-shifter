# Shade Shifter Mobile

Flutter companion app for Android and iOS. It is simulator-first, guest-first, local-only, and capability-aware.

## Quick start

```text
flutter pub get
flutter analyze
flutter test
flutter run
```

Choose **Try simulator** to use the entire app without hardware. Choose **Pair physical frame** for the ESP32 Rev A device. Rev A accepts only a whole-frame solid RGB value; unsupported controls are disabled rather than emulated.

## Structure

- `lib/src/core`: domain models and design system
- `lib/src/device`: transport contract, simulator, BLE, protocol, and studio state
- `lib/src/looks`: Drift/SQLite saved looks
- `lib/src/preview`: native GLB renderer and 2D fallback
- `documentation/mobile-app`: architecture, BLE, setup, testing, release, safety/privacy, accessibility, and troubleshooting

Android development requires API 24+. iOS builds require macOS/Xcode. The bundled GLB is a labeled proof-of-concept derived from project CAD, not production eyewear geometry. See the repository mobile documentation before hardware testing.

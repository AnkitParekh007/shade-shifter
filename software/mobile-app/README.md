# Shade Shifter mobile app

Flutter application for Android and iOS. The app is guest-first and simulator-first: the presentation and business logic depend only on `FrameTransport`, allowing the simulator to be replaced by the ESP32 BLE implementation without changing screens or controllers.

## Current foundation

- Premium light and dark themes
- Guest onboarding
- Simulator connection lifecycle
- Whole-frame, front and temple zone selection
- Persistent independent zone colors
- Safe intensity cap
- Live frame preview
- Battery, temperature, firmware and acknowledgement status
- Transport abstraction ready for BLE

## Development

```shell
flutter pub get
flutter analyze
flutter test
flutter run
```

Android/iOS platform generation, BLE implementation, presets, gradients, effects and complete release documentation are tracked as subsequent implementation slices.

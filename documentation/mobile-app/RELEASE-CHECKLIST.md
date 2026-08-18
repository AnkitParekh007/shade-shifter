# Release Checklist

## Every build
- [ ] `dart format --set-exit-if-changed .` clean
- [ ] `flutter analyze` clean (no ignored critical warnings)
- [ ] `flutter test` green
- [ ] `flutter test integration_test` green (emulator/device)
- [ ] CI green on all jobs (analyze-test, android-build, ios-build)

## Pre-release (POC demo build)
- [ ] Full simulator journey verified on a physical Android device
- [ ] Front-only vs temple-only recolor visually independent
- [ ] Looks persist across a real restart
- [ ] Denied-permission and failed-connection paths show recovery
- [ ] Emergency illumination-off works
- [ ] Reduced-motion + large text-scale render correctly (light & dark)
- [ ] Contrast + semantic labels spot-checked with a screen reader
- [ ] No secrets/signing material committed (`git grep` for keys, `.gitignore` ok)
- [ ] Version bumped in `pubspec.yaml`
- [ ] IMPLEMENTATION-STATUS.md reflects reality

## Android release (when signing ownership exists)
- [ ] `android/key.properties` present locally (git-ignored), keystore secured
- [ ] `flutter build appbundle` signed
- [ ] `applicationId` finalized (`com.shadeshifter.app`) & agreed
- [ ] R8/ProGuard smoke-tested (BLE + secure storage reflection intact)

## iOS release (macOS + Apple Developer account)
- [ ] Team + provisioning configured in Xcode (no profiles committed)
- [ ] Bundle id finalized (`com.shadeshifter.app`)
- [ ] Bluetooth usage descriptions present & accurate
- [ ] Background modes: none, unless a justified requirement is added
- [ ] `flutter build ios` signed; TestFlight validation

## Security gates before ANY consumer release
- [ ] Authenticated, replay-resistant BLE control implemented (not POC pairing)
- [ ] Signed, versioned firmware update path (no plaintext flashing)
- [ ] Log-scrubbing verified (no raw identifiers/PII in release logs)
- [ ] Threat model (SECURITY-THREAT-MODEL.md) re-reviewed & gaps closed

## Do NOT
- [ ] Configure automatic production release before signing ownership is provided
- [ ] Ship with the placeholder BLE UUIDs unconfirmed by firmware
- [ ] Present the simulator as real hardware (it is always labelled)

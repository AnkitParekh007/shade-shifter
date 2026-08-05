# Release Process

1. Update version and implementation status.
2. Run formatting, analysis, tests, Android release build, and iOS no-codesign build.
3. Complete physical-device and BLE checklist in `TESTING.md`.
4. Review privacy strings, permissions, signing, icons, screenshots, and store metadata.
5. Tag only a commit that passed CI. Production signing credentials stay outside Git.

The current Android release configuration uses debug signing for development and must be replaced before distribution.

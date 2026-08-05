# Security and Privacy

The app is guest-first and local-only. It has no account, analytics, advertising, cloud backend, or remote configuration. Looks and preferences remain on the device. Bluetooth is used only for nearby frame discovery/control; location data is not read or stored.

No BLE identifiers or diagnostics are transmitted. Future pairing secrets must use platform secure storage, never Drift or preferences. Logs must omit device identifiers and packet contents by default. Reset operations require confirmation, and sensitive release/signing files are excluded from source control.

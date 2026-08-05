# Troubleshooting

- **No frame found:** confirm `ShadeShifter-POC` is powered, nearby, advertising, and controllable with nRF Connect. Stop other BLE apps and retry.
- **Permission denied:** enable Nearby Devices/Bluetooth in system settings. Android 11 or earlier may require location permission for scanning.
- **Incompatible frame:** confirm both documented UUIDs exist and the color characteristic is writable.
- **Edits do not reach Rev A:** Rev A supports only the front/whole-frame primary solid color; other controls are intentionally unavailable.
- **3D preview unavailable:** the app uses its 2D fallback. Validate the GLB and use a supported Android/iOS device.
- **Database issue:** malformed saved rows are skipped. Reset local app data only after preserving any required looks.

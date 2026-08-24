# Privacy Notes

Privacy by design for the POC.

## Principles
- **Guest-first.** No account, login, email or phone number required or
  supported. Nothing to leak.
- **Local-first.** Looks and the last-applied appearance live in on-device
  storage (`shared_preferences`); the authorized-device reference lives in
  `flutter_secure_storage`. Nothing is uploaded.
- **No background scanning.** BLE scanning only runs on explicit user action and
  stops when no longer needed.
- **No location.** On Android 12+ we request `BLUETOOTH_SCAN` with
  `neverForLocation`; we never read, derive or store location. On ≤ API 30 the
  platform forces fine-location for scanning; we still store nothing.
- **No advertising identifiers, no analytics, no ad/attribution SDKs.**

## Data handling
| Data | Where | Notes |
|------|-------|-------|
| Saved looks | `shared_preferences` (JSON) | User-created; deletable in-app |
| Last-applied appearance | `shared_preferences` | For restart restoration |
| Authorized device ref (id/name) | `flutter_secure_storage` | For reconnect |
| Telemetry (battery/temp/rssi) | in-memory only | Not persisted |

## Logging & diagnostics
- `AppLogger.redactId()` reduces device identifiers to `AB••••EF` — **raw BLE
  MAC addresses / identifiers never reach normal logs.**
- Diagnostics export is **sanitized**: redacted identifiers, no personal data,
  no raw secrets.
- Decoded BLE payloads are validated and size-bounded before use; malformed or
  oversized frames are rejected (see SECURITY-THREAT-MODEL.md).

## In-app disclosure
The Settings → Privacy card states, in plain language, that no account is
needed, looks stay on-device, Bluetooth is only used while pairing/controlling a
frame, identifiers are redacted from logs, and no ad/location data is collected.

## Deletion
"Forget device" clears the secure device reference. Deleting a look removes it
from local storage. Uninstalling removes all app data.

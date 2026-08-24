# Security Threat Model

Scope: the mobile app + its BLE link to a Rev-A frame. The POC uses **simple,
unauthenticated pairing**; this document names the threats, what the app does
today, and the gap to production-grade authenticated control.

## Assets
- Control of a device worn on the face/near the eyes (safety-critical).
- The authorized-device reference on the phone.
- Firmware integrity.

## Threats & mitigations

| # | Threat | Today (POC) | Production gap |
|---|--------|-------------|----------------|
| 1 | **Unauthorized nearby control** — anyone in BLE range sends commands | Firmware enforces safety limits; app clamps intensity/effects | Add authenticated session (pairing key / bonding, per-session nonce) so only paired phones control the frame |
| 2 | **Replay attack** — capture & re-send a command | `sequence` (uint32, monotonic) + `commandId` present in every frame | Firmware must reject non-increasing sequence; add a rolling MAC/signature over the frame |
| 3 | **Malformed BLE packets** | Client validates length, `payloadLength ≤ 512`, verifies XOR checksum; rejects malformed | Stronger integrity field (CRC/MAC); fuzz firmware parser |
| 4 | **Rogue device impersonating a frame** | Name-prefix + capability handshake filter | Authenticate device identity (signed capability response / cert) before trust |
| 5 | **Insecure firmware update** | Update path is a **placeholder only** — disabled | Signed, versioned images; rollback protection; verify before flash |
| 6 | **Sensitive logs** | `redactId()`; sanitized diagnostics; no raw secrets/PII logged | Add log-scrubbing tests; ensure no verbose BLE dumps in release |
| 7 | **Lost/stolen phone** | No account; secure storage for device ref; no location/PII | OS-level device encryption assumed; optional app lock |
| 8 | **DoS via command flooding** | 120 ms debounce + bounded retry + idempotent commands rate-limit the link | Firmware-side rate limiting + backpressure; ignore floods safely |

## Trust boundaries
- **Untrusted:** anything received over BLE (telemetry, acks, capability blob) —
  validated and size-bounded before use.
- **Authoritative:** firmware safety limits. The app's `SafetyGovernor` is a
  *second* layer that clamps toward safe values and never bypasses firmware.

## POC → production gap (summary)
The single biggest gap is **authentication**: the POC link is open. Before any
consumer release, add authenticated + replay-resistant control (threats 1–2, 4)
and signed firmware updates (threat 5). Until then the product is labelled
experimental and safety depends on firmware-enforced limits.

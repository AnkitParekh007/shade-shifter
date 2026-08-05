# Shade Shifter BLE Protocol

## Rev A legacy profile

- Advertised name: `ShadeShifter-POC`
- Service: `7f4a0001-9d45-4d9e-b890-9f132c08a001`
- Read/write color characteristic: `7f4a0002-9d45-4d9e-b890-9f132c08a001`
- Write payload: exactly `[red, green, blue]`, three unsigned bytes from 0–255.
- A write applies one solid color to every LED. There are no zones, brightness, effects, telemetry, capability response, or acknowledgement.
- The firmware limits output to 32/255. The app cannot raise or replace that ceiling.

## Packet profile v1

All multi-byte values are little-endian. Maximum packet length is 96 bytes.

| Offset | Size | Field |
|---:|---:|---|
| 0 | 1 | Magic `0x53` |
| 1 | 1 | Version `0x01` |
| 2 | 2 | Sequence |
| 4 | 1 | Command |
| 5 | 1 | Flags |
| 6 | 2 | Payload length |
| 8 | N | Payload |
| 8+N | 2 | CRC16/Modbus over all preceding bytes |

Commands: `0x10` set appearance, `0x20` request status, `0x21` status, `0x7E` acknowledgement, `0x7F` error. Unknown commands, versions, lengths, or CRCs are rejected. Sequence numbers wrap at 65535. A command retry reuses its sequence so firmware can treat it idempotently. Writes time out after eight seconds; connect/discovery after twelve seconds. Retry only transient transport failures, at most twice with 250/500 ms backoff.

Example request-status packet before CRC: `53 01 01 00 20 00 00 00`. Capability discovery is required before packet-v1 controls are enabled. If discovery is absent and the Rev A color characteristic exists, the app explicitly selects the legacy profile.

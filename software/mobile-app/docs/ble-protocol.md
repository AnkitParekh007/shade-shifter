# Shade Shifter BLE protocol v1

The mobile app and firmware communicate through a versioned binary envelope. Every state-changing command carries a sequence number and requires an acknowledgement. The simulator implements the same semantics as the future ESP32 transport.

## Packet envelope

All multi-byte values use little-endian byte order.

| Offset | Size | Field | Description |
| --- | ---: | --- | --- |
| 0 | 1 | Magic | `0x53` (`S`) |
| 1 | 1 | Version | `0x01` |
| 2 | 2 | Sequence | Rolls over after 65,535 |
| 4 | 1 | Command | Command identifier |
| 5 | 1 | Flags | Command-specific flags |
| 6 | 2 | Payload length | Bytes following the header |
| 8 | N | Payload | Maximum packet size is 96 bytes |
| 8+N | 2 | CRC-16 | Modbus polynomial `0xA001`, initial value `0xFFFF` |

## Commands

| Value | Command | Direction |
| ---: | --- | --- |
| `0x10` | Set appearance | App to frame |
| `0x20` | Request status | App to frame |
| `0x21` | Device status | Frame to app |
| `0x7E` | Acknowledgement | Frame to app |
| `0x7F` | Error | Frame to app |

`Set appearance` encodes front RGB, left-temple RGB, right-temple RGB, secondary RGB, safe intensity and effect. The frame remains authoritative for hardware brightness and thermal limits.

The Rev A firmware's existing three-byte RGB characteristic remains a compatibility transport. It is intentionally isolated behind `FrameTransport`; production screens and controllers never encode legacy packets directly.

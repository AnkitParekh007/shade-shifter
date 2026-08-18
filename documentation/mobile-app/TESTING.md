# Testing

Goal: meaningful coverage of domain logic and the BLE protocol, not a coverage
percentage. Everything runs against the simulator/fakes — **no hardware needed**.

## Run
```bash
cd software/mobile-app
flutter test                      # unit + widget
flutter test integration_test     # e2e (device/emulator)
```

## Unit tests
| File | Covers |
|------|--------|
| `color_and_models_test.dart` | hex/HSV round-trip, shades, contrast; **independent-zone** appearance edits; Look/appearance JSON; selection→zone resolution |
| `command_codec_test.dart` | binary frame layout, **test vectors**, checksum verify/corruption, gradient/empty/rename payloads |
| `safety_governor_test.dart` | intensity clamp to firmware max, thermal-alarm effect suspension, unsupported-effect fallback |
| `simulator_transport_test.dart` | connect/negotiate, ok ack, dropped-ack timeout, injected rejection, disconnected send, thermal telemetry |
| `studio_and_persistence_test.dart` | **front/temple isolation** via the controller, intensity clamp, last-applied round-trip, save-look persistence |
| `ble_contract_test.dart` | handshake, unsupported version, dropped/duplicate ack, disconnect-during-apply (via `FakeTransport`) |

## Widget tests
| File | Covers |
|------|--------|
| `widget_customize_test.dart` | studio renders zone selector, selection updates, swatch tap drives the apply-state machine without crashing |

## Integration tests
| File | Covers |
|------|--------|
| `integration_test/app_flow_test.dart` | first launch → onboarding → **Try Simulator** → Home/Customize |

## BLE contract testing approach
`test/fakes/fake_transport.dart` is a programmable `DeviceTransport`. Tests script
scenarios (delayed/duplicate ack, dropped packet, connect failure, mid-apply
disconnect) deterministically, so the command/ack pipeline is exercised without
timing flakiness or hardware.

## Still to add (tracked in IMPLEMENTATION-STATUS)
- Widget tests for onboarding pages, permission states, device-health warnings,
  text-scaling/accessibility.
- Integration tests for front-only vs temple-only recolor, save+reapply,
  connection-failure recovery, thermal warning, emergency-off, restart
  restoration.
- Golden tests for `FramePreview` per theme.

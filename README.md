# Shade Shifter

Customizable eyewear whose frame appearance can be restyled from a phone. The
first hardware POC uses an ESP32-compatible BLE controller with independently
controllable RGB zones; future revisions may use electrochromic or other
low-power color-changing materials.

## Repository layout

```
software/mobile-app/        Flutter app (Android + iOS) — simulator-first
documentation/mobile-app/   Product, architecture, BLE protocol, setup, ADRs
.github/workflows/          CI (format, analyze, test, Android/iOS builds)
```

## Start here

- **Run the app (no hardware needed):**
  [`software/mobile-app/README.md`](software/mobile-app/README.md) — then choose
  **Try the simulator**.
- **How it's built:**
  [`documentation/mobile-app/ARCHITECTURE.md`](documentation/mobile-app/ARCHITECTURE.md)
- **BLE contract (draft, for firmware agreement):**
  [`documentation/mobile-app/BLE-PROTOCOL.md`](documentation/mobile-app/BLE-PROTOCOL.md)
- **What's done vs. pending (honest checklist):**
  [`documentation/mobile-app/IMPLEMENTATION-STATUS.md`](documentation/mobile-app/IMPLEMENTATION-STATUS.md)

## Status

Investor-demo-quality MVP foundation: a full **simulator** experience
(onboarding → pair/simulator → customize whole frame + independent front/temples
→ save & re-apply looks → restart restoration → device health → safety), with
BLE isolated behind a transport interface. The physical `BleTransport` is the
next hardware task — see
[`HARDWARE-INTEGRATION.md`](documentation/mobile-app/HARDWARE-INTEGRATION.md).

> ⚠️ Experimental POC hardware worn near the eyes. Safety limits are enforced in
> firmware; the app adds an additional protective layer.

## License

BSD 3-Clause — see [`LICENSE`](LICENSE).

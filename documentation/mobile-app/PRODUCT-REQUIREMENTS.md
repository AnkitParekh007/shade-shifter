# Product Requirements — Shade Shifter Mobile (POC/MVP)

## Vision
A premium fashion companion app that makes a single Shade Shifter frame feel like
many — recolour the whole frame or each zone independently, save looks, and
control it over Bluetooth. Must feel like a luxury product, not a dev utility.

## Target users
- Early adopters / investors evaluating the concept (demo without hardware).
- Owners of a Rev-A POC frame (ESP32, RGB zones).

## Must-have (MVP)
1. Complete simulator experience — usable with no hardware.
2. Whole-frame + independent front/left-temple/right-temple customization, with
   colours persisted **per zone**.
3. Solid colour (swatches, hue, hex, shades, intensity). Gradient (start/end/
   direction) with capability-aware warnings.
4. Curated built-in looks + user looks (save, rename, duplicate, favourite,
   delete, re-apply); persistence across restarts.
5. Pairing flow with contextual permission education and robust error recovery.
6. Command/ack pipeline with timeouts, retries and reconnection.
7. Safety: safe default intensity, firmware-capped brightness, thermal
   suspension, emergency illumination-off, experimental-hardware labelling.
8. Device health screen from **negotiated capabilities** ("Not supported" when
   absent).
9. Accessibility: contrast, semantic labels, text scaling, reduced motion,
   light/dark.

## Nice-to-have (post-MVP)
- Real-time 3D frame with rotation/camera presets.
- Effect editor UI (pulse/breathing/color-shift) with prototype labelling.
- Favourite reordering, look thumbnails, sharing.
- Warm/cool finish adjustment surfaced in UI.

## Explicitly out of scope for the POC
- Accounts, cloud sync, analytics, ads, payments (only behind disabled,
  documented interfaces).
- Authenticated BLE control and signed firmware update (documented gap — see
  SECURITY-THREAT-MODEL.md).

## Non-functional
- Runs on small phones → large screens; light + dark.
- Smooth but efficient animations; honors reduced-motion.
- BLE-agnostic core (transport interface).
- No secrets/signing material in the repo.

## Success criteria
The §20 acceptance criteria in the brief; live state in IMPLEMENTATION-STATUS.md.
The headline demo: **first launch → Try Simulator → customize front & temples
independently → save & re-apply a look → survives restart**, all polished and
hardware-free.

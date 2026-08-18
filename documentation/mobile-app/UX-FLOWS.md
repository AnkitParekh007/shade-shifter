# UX Flows

## Navigation map

```mermaid
flowchart TD
  Splash --> Onboarding
  Onboarding --> Pairing[Pair a frame / Try Simulator]
  Pairing -->|Try Simulator| Home
  Pairing -->|Pair a frame| Home
  Home --> Customize
  Home --> Looks
  Home --> Device
  Home --> Settings
```

Home is a 4-tab shell (`IndexedStack`): **Customize · Looks · Device · Settings**.
Bluetooth permission is **not** requested on launch — only contextually at
pairing.

## Onboarding
Five pages: one frame/many looks → whole-frame & zone customization → saved looks
→ Bluetooth control (with the "only asked at pairing" promise) → simulator
availability. Skippable; completion is persisted so returning users land on Home.

## Pairing sequence

```mermaid
sequenceDiagram
  actor U as User
  participant App
  participant OS as OS Bluetooth
  participant F as Frame
  U->>App: Tap "Pair a frame"
  App->>U: Explain why Bluetooth is needed
  App->>OS: Request runtime BLE permissions (contextual)
  alt granted & BT on
    App->>OS: Start scan (user-initiated)
    OS-->>App: Discovered ShadeShifter* devices (name + RSSI)
    U->>App: Select device
    App->>F: Connect + discover services
    App->>F: Read capabilities / handshake
    F-->>App: Capabilities (zones, effects, limits)
    App->>App: Save authorized device (secure) + success animation
    App->>U: Home
  else denied / BT off / none found / mismatch
    App->>U: Friendly error + recovery action
  end
```

Handled error states (each with a recovery action): Bluetooth disabled,
permission denied, permanently denied (→ open settings), Android location
requirement, no devices found (→ retry), unsupported firmware, protocol mismatch,
connection timeout (→ retry), device busy elsewhere, unexpected disconnect.
_POC note: physical scanning is the Phase 3 `BleTransport`; today "Pair a frame"
explains this and routes to the simulator, which mirrors these states._

## Reconnection flow

```mermaid
flowchart TD
  A[App start / resume] --> B{Authorized device stored?}
  B -- no --> H[Home / prompt to pair]
  B -- yes --> C[reconnect last device]
  C --> D{Connected?}
  D -- yes --> E[Read current state] --> G[Reconcile local vs device] --> H
  D -- no --> F[Show reconnect + Try Simulator options] --> H
```

## Customization interaction
Immediate local preview on every edit; continuous controls (hue, intensity) are
**debounced 120 ms** before a rate-limited BLE send. The apply-state chip shows:
Previewing → Pending → Sending → Acknowledged → Applied, or Timed out / Rejected
/ Reverted. Selecting a zone (chips or tapping the preview) scopes edits;
"Whole frame" and "Both temples" fan out to multiple physical zones while
preserving each zone's own configuration.

## Safety UX
- Safe default intensity on first connection.
- App brightness ceiling (Settings) layered under firmware max.
- Safety notices banner explains any auto-adjustment (clamped/thermal/effect).
- Prominent emergency **illumination-off** button on Customize.
- "Experimental hardware — POC" labelling at pairing and on Device.

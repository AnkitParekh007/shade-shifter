# Architecture

Feature-first clean architecture. The guiding constraint: **UI and business
logic never depend on the BLE package** — they talk to a `DeviceTransport`
interface, so the simulator, a test fake, and the physical BLE transport are
drop-in interchangeable.

## Layers

```mermaid
flowchart TB
  subgraph Presentation
    UI[Screens & widgets<br/>onboarding · studio · looks · device · settings]
  end
  subgraph Application
    SC[StudioController]
    DC[DeviceController]
    LC[LooksController]
    SET[SettingsController]
  end
  subgraph Domain
    M[Models: RgbColor · Zone · Appearance · Capabilities · Look]
    SAFE[SafetyGovernor]
    T[[DeviceTransport interface]]
    CMD[Commands / Acks]
  end
  subgraph Infrastructure
    SIM[SimulatorTransport]
    FAKE[FakeTransport - tests]
    BLE[BleTransport - Phase 3]
    CODEC[CommandCodec]
    PREFS[(shared_preferences)]
    SEC[(secure_storage)]
  end

  UI --> SC & DC & LC & SET
  SC --> DC & SAFE & M
  DC --> T & CMD
  T -. implements .- SIM & FAKE & BLE
  BLE --> CODEC
  LC --> PREFS
  DC --> SEC
```

## Transport seam (simulator vs physical)

```mermaid
flowchart LR
  APP[App code<br/>DeviceController.send] --> IF{{DeviceTransport}}
  IF -->|simulator id| SIM[SimulatorTransport<br/>latency · acks · telemetry · faults]
  IF -->|physical id| BLE[BleTransport<br/>flutter_blue_plus]
  IF -->|tests| FAKE[FakeTransport<br/>scripted scenarios]
```

`TransportFactory.createFor(DeviceRef)` selects the implementation. Nothing above
the factory branches on transport type.

## Frame state synchronization

```mermaid
sequenceDiagram
  participant U as User
  participant S as StudioController
  participant D as DeviceController
  participant T as Transport
  U->>S: edit selected zone (color/intensity)
  S->>S: update local appearance (immediate preview)
  Note over S: debounce (120ms) — coalesces drags
  S->>S: SafetyGovernor.sanitize()
  S->>D: send(SetZoneSolidColor…) per zone
  D->>T: send with timeout + bounded retry
  T-->>D: CommandAck (correlated by commandId)
  D-->>S: Result.ok / Result.err
  S->>S: phase → applied | timedOut | rejected
  S->>S: persist last-applied appearance
```

## 3D preview strategy

The reliable default is a **custom-painted 2D vector frame**
(`shared/widgets/frame_preview.dart`) with independently addressable zone
materials, selection highlight, tap-to-select and optical proportions. It is
also the **graceful fallback** for the future 3D view.

Replacement point for real 3D: introduce `FramePreview3D` behind the same inputs
(`FrameAppearance`, `supportedZones`, `selection`, `onSelectZone`). A GLB asset
with named materials `frame_front`, `temple_left`, `temple_right`, `lenses`,
`hinges` drops into `assets/models/`; the loader tints each material from the
matching `ZoneAppearance`. On init failure or low-end devices, fall back to the
2D `FramePreview`. See IMPLEMENTATION-STATUS (Phase 5) and HARDWARE-INTEGRATION.

## Key decisions
- **No code-gen** (Freezed/json_serializable/riverpod_generator) — hand-written
  immutable models + manual providers. Rationale in ADR 0002/0003.
- **Result over exceptions** at every layer boundary.
- **Capability-driven UI** — unsupported features render "Not supported", never
  faked.
- **Safety as a layer** — `SafetyGovernor` clamps toward safe values before send
  and reports every adjustment; firmware remains authoritative.

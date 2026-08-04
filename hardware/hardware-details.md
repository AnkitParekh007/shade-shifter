# Hardware Architecture and Design Details

## Scope

The Shade Shifter POC is an electronically recolorable eyewear frame controlled by a physical button and a Bluetooth mobile app. It does not alter prescription or sunglass lenses. The architecture deliberately separates the near-term illuminated experience prototype from the production-material investigation.

## System architecture

```text
Mobile app
   │ Bluetooth Low Energy
   ▼
BLE MCU ── preset button / sensors / debug
   │
   ├── front-zone color control
   ├── left-temple color control
   ├── right-temple color control
   └── battery/thermal/brightness management

USB-C or keyed magnetic input
   ▼
charger + power path ── protected LiPo ── fuel gauge
   │
   ├── low-noise 3.3 V rail
   └── switched optical-driver rail
```

## Prototype tracks

### Track A — illuminated experience demonstrator

Miniature RGB LEDs feed diffusers or light guides inside the front and temples. The MCU applies curated colors, zones, animations, and brightness limits. The goals are to validate interaction, desirability, color selection, app flow, and industrial-design packaging.

This architecture is not automatically the production solution because emissive light can appear gadget-like, consume significant power, produce heat, create hotspots, and be difficult to view as a surface color in sunlight.

### Track B — production-material investigation

Flat and curved coupons evaluate electrochromic and reflective technologies. Each coupon includes the complete visible stack: substrate, electrode, active material, electrical contact, barrier, adhesive, and protective surface. The goal is to select a technology using measured appearance, durability, switching, power, curvature, safety, and manufacturability.

## Mechanical design

### Modular construction

The POC frame should be serviceable and divided into replaceable modules:

1. Front chassis with conventional lens grooves
2. Front optical/material insert
3. Left temple electronics enclosure
4. Right temple battery enclosure
5. Replaceable hinge interconnects
6. Charging-port cover or magnetic interface
7. Skin-facing opaque thermal/light barrier

### Weight allocation

| Subsystem | Target maximum |
|---|---:|
| Chassis, hinges, screws | 18 g |
| Lenses used for evaluation | 8 g |
| Battery | 6 g |
| Electronics and wiring | 4 g |
| Optical/material layers and covers | 4 g |
| **Total** | **40 g** |

The left/right temple mass difference should be less than 3 g, or counterbalanced, to avoid perceived tilt.

### Critical dimensions

- Electronics enclosure thickness target: ≤6 mm in temple zones
- Minimum bend radius for FPC: supplier requirement plus 50% design margin
- Wiring at hinges must have a defined flex loop and strain relief
- No rigid component may sit directly against skin without a protective wall
- All skin-facing corners and edges: target radius ≥0.5 mm; industrial design to confirm
- Lens retention and hinge geometry must not be compromised by prototype channels

Prescription lenses must be fitted only through an eyewear professional after the frame's mechanical behavior is understood.

## Electrical design

### Power domains

- **Battery domain:** protected single-cell LiPo, approximately 3.0–4.2 V
- **Logic domain:** regulated 3.3 V for MCU and sensors
- **Optical domain:** switched rail appropriate to the selected LED/material driver
- **Charging domain:** 5 V USB-C or protected keyed magnetic input

The optical rail must default off during reset, charging faults, brownout, firmware crash, and over-temperature events.

### Battery sizing method

Use measured current and the following estimate:

```text
runtime_hours = usable_capacity_mAh / average_current_mA
```

Do not use nominal battery capacity alone. Derate for converter loss, temperature, cell aging, cutoff voltage, self-discharge, and safety reserve. A five-day target requires the optical system to be off or extremely low-power most of the time; continuously illuminated RGB effects will not meet it with a comfortably wearable battery.

### Initial power budget for Track A

| State | Target current |
|---|---:|
| Shipping/hard off | <5 µA where supported |
| Connected standby | <500 µA average |
| Disconnected advertising | <250 µA average |
| Typical curated color | <20 mA average system current |
| Demonstration high brightness | Firmware-limited; characterize, not a normal mode |
| Charging | Limited by cell rating, thermal design, and connector |

The LED count, brightness, PWM scheme, and diffuser efficiency must be tuned against measured temperature and runtime.

### PCB strategy

1. Start with development kits and off-the-shelf power boards.
2. Build a segmented rigid-PCB prototype connected with replaceable fine-wire harnesses.
3. After electrical and mechanical placement stabilize, design a rigid-flex assembly.
4. Include SWD/debug pads, test points, current-measurement jumpers, board revision, and serial number.
5. Keep the BLE antenna away from the battery, metal hinges, conductive coatings, and the head.

## Optical system

### Zones

- Zone 1: front rim
- Zone 2: left temple
- Zone 3: right temple

Each zone must support independent color and brightness. Generation-one modes should emphasize curated, premium-looking colors rather than unrestricted animations.

### Light management

- Use internal reflective backing to increase efficiency.
- Use a diffuser/light guide to eliminate visible LED points at normal conversation distance.
- Use an opaque skin-facing barrier to prevent light entering the eyes or creating cheek/temple glow.
- Limit blue-rich, flashing, or high-brightness patterns through firmware.
- Evaluate appearance at 100, 500, 2,000, 10,000, and 50,000+ lux.

### Color calibration

Store per-zone calibration values in nonvolatile memory. Measure a standard set of colors with a colorimeter and report CIE L*a*b* and ΔE across zones, devices, viewing angles, and brightness settings.

## Bluetooth and controls

### Proposed BLE services

- Device information and firmware revision
- Connection and pairing state
- Battery percentage and charging state
- Three-zone color command
- Preset selection
- Brightness limit
- Temperature/fault status
- Firmware update service (after basic stability)

Commands must include range checks and must not allow the app to bypass current, brightness, temperature, or battery safety limits.

### Physical control

- Short press: next curated preset
- Long press: power/wake or pairing, finalized through user testing
- Very long press: safe reset, protected against accidental activation
- Usable by touch while worn
- No essential function should require a network connection or subscription

## Thermal design

Place temperature sensing near the highest-power electronics and characterize the skin-facing temperature separately. Firmware must reduce brightness/power before shutdown and log the fault reason. Charging and maximum optical output should not occur simultaneously until validated.

Initial engineering targets appear in `requirements.md`; formal safe limits require applicable standards review and expert validation.

## Environmental protection

- Separate sweat paths from electronics using covers, gaskets, conformal coating, and drainage strategy.
- Avoid capillary gaps that retain sweat near contacts.
- Prefer corrosion-resistant contacts and fasteners.
- Treat USB-C as a POC interface; compare a sealed magnetic interface for later versions.
- Validate cleaning agents used by opticians and consumers.
- Do not claim an IP rating until tested by an appropriate lab.

## Material coupon stack definition

Every material candidate must document:

1. Substrate material and thickness
2. Transparent/conductive electrode
3. Active color-changing layer
4. Counter-electrode/electrolyte where applicable
5. Barrier/encapsulation layer
6. Adhesive and surface preparation
7. Skin-facing/outer protective coating
8. Contact design and strain relief
9. Driver waveform, voltage, current, and switching time
10. Failure mode after puncture, bending, sweat, UV, and overdrive

## Prototype revisions

| Revision | Purpose | Exit condition |
|---|---|---|
| H0 bench rig | BLE, power, LED/material driver feasibility | Stable control and measured power |
| H1 non-wearable frame | Optical uniformity and packaging | Three zones work; no unsafe heat/light leakage |
| H2 wearable engineering unit | Comfort, runtime, sweat, and usability | Passes internal POC requirements |
| H3 investor/customer demo | Refined finish and repeatability | Three consistent units with documented limitations |

## Required design records

- System block diagram and interface control document
- Schematic, PCB source, Gerbers, assembly drawings, and fabrication notes
- Mechanical CAD, drawings, tolerances, materials, and finishes
- Controlled BOM with manufacturer part numbers and approved alternates
- Battery and charger calculations
- Antenna placement and BLE test notes
- Optical calibration data
- Risk register and FMEA
- Verification plan, raw data, photos, and signed test reports
- Prototype build record and serial-number history

# Hardware Tools and Lab Equipment

This document lists the tools needed to build and validate the Shade Shifter proof of concept (POC). Prices are indicative India retail prices in August 2026 and must be confirmed before purchase. Equivalent equipment may be substituted if it meets or exceeds the stated capability.

## Procurement priority

- **P0 — mandatory:** required to assemble and safely power the first prototype.
- **P1 — recommended:** required for repeatable debugging and wearable validation.
- **P2 — later/shared:** can initially be rented, outsourced, or accessed through a makerspace or lab.

## Electronics assembly tools

| Priority | Tool | Minimum specification | Qty. | Indicative unit cost | Purpose |
|---|---|---:|---:|---:|---|
| P0 | Temperature-controlled soldering station | 60 W+, 200–450 °C, fine tips | 1 | ₹3,000–₹10,000 | PCB, wire, LED, and connector assembly |
| P0 | Lead-free solder wire | SAC305, 0.5–0.8 mm | 1 roll | ₹800–₹1,800 | Electrical joints |
| P0 | No-clean flux pen/paste | Electronics grade | 2 | ₹250–₹700 | Reliable fine-pitch soldering |
| P0 | ESD-safe tweezers | Straight and curved, fine tip | 2 | ₹300–₹1,200 | SMD placement |
| P0 | Flush cutter and wire stripper | 20–30 AWG support | 1 each | ₹500–₹2,000 | Harness preparation |
| P0 | Helping hands or PCB vise | Adjustable, ESD-safe preferred | 1 | ₹800–₹3,000 | Stable assembly |
| P0 | Heat gun/rework station | Adjustable airflow and temperature | 1 | ₹2,500–₹8,000 | SMD rework and heat-shrink |
| P0 | Heat-shrink assortment | 1–10 mm, preferably 3:1 adhesive-lined for exposed joints | 1 kit | ₹500–₹1,500 | Insulation and strain relief |
| P0 | ESD mat and wrist strap | Grounded, heat-resistant mat | 1 | ₹1,500–₹5,000 | Component protection |
| P1 | Stereo microscope or digital inspection microscope | 10–40× useful magnification | 1 | ₹5,000–₹25,000 | Fine-pitch inspection |
| P1 | Hot plate or small reflow oven | Controlled profile to at least 250 °C | 1 | ₹6,000–₹35,000 | Prototype PCB assembly |
| P2 | Fume extractor | Replaceable carbon/HEPA filtering | 1 | ₹3,000–₹12,000 | Safer soldering workspace |

## Electrical measurement tools

| Priority | Tool | Minimum specification | Qty. | Indicative unit cost | Purpose |
|---|---|---:|---:|---:|---|
| P0 | Digital multimeter | True RMS, µA–10 A current, continuity, diode mode | 2 | ₹2,000–₹12,000 | Voltage, resistance, current, and fault checks |
| P0 | Bench DC power supply | 0–30 V, 0–5 A, current limiting, two or more presets | 1 | ₹5,000–₹18,000 | Safe bring-up without a battery |
| P0 | USB power meter | USB-C voltage/current/power logging | 1 | ₹1,000–₹4,000 | Charging validation |
| P1 | Oscilloscope | 4 channels, 100 MHz+, 1 GSa/s+ | 1 | ₹25,000–₹80,000 | PWM, power rails, charging, and communication debugging |
| P1 | Logic analyzer | 8 channels, 24 MHz+ | 1 | ₹1,000–₹15,000 | I²C, SPI, UART, and timing analysis |
| P1 | Low-current power profiler | nA/µA to hundreds of mA with logging | 1 | ₹35,000–₹1,00,000 | Battery-life optimization |
| P1 | Electronic load | 0–30 V, 0–5 A, constant-current mode | 1 | ₹5,000–₹20,000 | Battery and charger tests |
| P2 | LCR meter | Capacitance, inductance, resistance; 100 Hz–100 kHz | 1 | ₹8,000–₹35,000 | Component and material characterization |
| P2 | Thermal camera | ≤0.1 °C sensitivity preferred | 1 | ₹25,000–₹1,50,000 | Hotspot and skin-contact thermal checks |

## Mechanical prototyping tools

| Priority | Tool | Minimum specification | Qty. | Indicative unit cost | Purpose |
|---|---|---:|---:|---:|---|
| P0 | Precision screwdriver set | Torx, hex, Phillips, flat, 1.5–4 mm bits | 1 | ₹800–₹3,000 | Eyewear and enclosure assembly |
| P0 | Digital caliper | 0–150 mm, 0.01 mm resolution | 1 | ₹1,000–₹4,000 | Fit and dimensional inspection |
| P0 | Needle files, hobby knife, pin vise, mini drills | Fine-scale plastics capability | 1 kit | ₹1,000–₹4,000 | Frame modification |
| P0 | Clamps and soft jaws | Non-marring | 1 set | ₹500–₹2,000 | Holding eyewear safely |
| P1 | Rotary tool | Variable speed, fine cutting/grinding accessories | 1 | ₹3,000–₹10,000 | Prototype frame modification |
| P1 | FDM 3D printer | 0.4 mm nozzle, PLA/PETG/TPU support | 1 | ₹20,000–₹60,000 | Jigs, early housings, fit checks |
| P1 | Filament dryer | Supports hygroscopic engineering filaments | 1 | ₹4,000–₹12,000 | Consistent prints |
| P2 | SLA/MSLA printer | 35–50 µm XY class | 1 | ₹25,000–₹80,000 | High-detail frame and optical-guide parts |
| P2 | Small CNC or laser cutter | Outsource initially | — | ₹1,000–₹20,000/job | Precise flat parts and tooling |
| P2 | Force gauge and test stand | 0–100 N, logging preferred | 1 | ₹20,000–₹80,000 | Hinge, adhesion, and flex tests |

## Optical and material test tools

| Priority | Tool | Minimum specification | Indicative cost | Purpose |
|---|---|---|---:|---|
| P0 | Standardized color/grey card | Matte, stable reference | ₹1,000–₹5,000 | Repeatable photo comparisons |
| P0 | Lux meter | 0–100,000 lux minimum | ₹1,500–₹8,000 | Indoor/daylight test records |
| P1 | Colorimeter or spectrophotometer | CIE L*a*b*, ΔE reporting | ₹25,000–₹2,00,000 | Objective color quality and aging |
| P1 | UV inspection lamp | UVA with eye/skin protection | ₹3,000–₹15,000 | Screening before formal UV exposure |
| P1 | Environmental data logger | Temperature and relative humidity | ₹2,000–₹12,000 | Test condition traceability |
| P2 | UV weathering chamber | Outsource or shared lab | ₹2,000–₹20,000/test series | Accelerated sunlight aging |
| P2 | Temperature/humidity chamber | Outsource or shared lab | ₹3,000–₹25,000/test series | Environmental qualification |
| P2 | IP splash/dust setup | Calibrated lab access | ₹5,000–₹40,000/test | Enclosure validation |

## Safety equipment

| Priority | Item | Requirement | Indicative cost |
|---|---|---|---:|
| P0 | Safety glasses | EN 166 or equivalent | ₹500–₹2,000 |
| P0 | Heat-resistant work mat | Non-flammable bench surface | ₹800–₹3,000 |
| P0 | Li-ion safety bag/metal battery box | For charging and storage during development | ₹800–₹3,000 |
| P0 | ABC/CO₂ extinguisher | Correctly rated and accessible | ₹2,000–₹8,000 |
| P0 | Nitrile gloves | Material, adhesive, and cleaning work | ₹400–₹1,000/box |
| P1 | Chemical splash goggles and lab coat | Coupon chemistry and solvent handling | ₹1,500–₹5,000 |
| P1 | Local ventilation | Appropriate for solder and adhesive fumes | ₹3,000–₹20,000 |

## Software and services used with hardware

| Tool/service | Use | Cost guidance |
|---|---|---:|
| KiCad | Schematic and PCB design | Free |
| FreeCAD or Fusion | Mechanical CAD | Free/open-source or eligible startup subscription |
| Git + GitHub | Revision control and design review | Existing repository |
| Nordic nRF Connect | BLE bring-up and packet inspection | Free |
| Saleae Logic or equivalent | Protocol decode | Free with supported hardware |
| JLCPCB/PCBWay/local PCB vendor | PCB fabrication and assembly | ₹2,000–₹30,000/iteration |
| 3D-print service | High-quality fit prototypes | ₹500–₹10,000/iteration |

## Recommended lab budget

| Setup | Approximate budget | Notes |
|---|---:|---|
| Minimum safe bench | ₹35,000–₹75,000 | P0 tools; borrow scope and printer |
| Capable POC bench | ₹1.5–₹4 lakh | Adds scope, microscope, printer, logging, and rework |
| In-house validation lab | ₹6–₹20 lakh | Adds metrology, environmental and mechanical testing; outsource certification |

## Operating rules

1. Do not charge or test an unprotected Li-ion/LiPo cell on a wearable prototype.
2. Use a current-limited bench supply for first power-up.
3. Inspect every battery after mechanical, thermal, or drop testing.
4. Perform solvent, adhesive, UV, and material work with manufacturer safety data sheets available.
5. Calibrate or verify measurement tools before a formal test campaign.
6. Record tool model, serial number, firmware, settings, and calibration date in every test report.

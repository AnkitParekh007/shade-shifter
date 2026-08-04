# Prototype Components and BOM

This is the initial component plan for a dual-track Shade Shifter POC. Track A demonstrates the app-controlled experience using addressable light. Track B evaluates electrochromic or reflective materials for a premium production direction.

Prices are indicative prototype quantities in India, exclude taxes/shipping where noted, and require supplier quotations before purchase. Components touching the face are experimental until material-safety and thermal requirements are verified.

## Track A: wearable experience prototype

### Core electronics

| Ref. | Component | Preferred specification | Qty./unit | Indicative cost | Selection notes |
|---|---|---|---:|---:|---|
| MCU-1 | BLE microcontroller module | Nordic nRF52840 module; Bluetooth 5, USB, ≥1 MB flash | 1 | ₹1,500–₹3,500 | Strong BLE tooling and low-power modes; use a module with antenna approvals for POC |
| MCU-ALT | Alternative MCU module | ESP32-C3 or ESP32-S3 module | 1 | ₹500–₹1,500 | Lower cost, typically higher power; acceptable for bench prototype |
| LED-1 | Miniature addressable RGB LEDs | SK6805/2020 or equivalent, 5 V, individually addressable | 20–60 | ₹15–₹60 each | Use only at brightness limited by thermal and battery budgets |
| DRV-1 | Logic-level shifter/buffer | 3.3 V to 5 V, high-speed CMOS | 1 | ₹50–₹250 | Reliable LED data level |
| PWR-1 | Boost converter | 3–4.2 V input, regulated 5 V, ≥1 A peak, high efficiency | 1 | ₹150–₹800 | Powers LEDs; must include enable control |
| PWR-2 | 3.3 V regulator | Low-Iq buck or LDO, ≥300 mA | 1 | ₹50–₹300 | MCU and sensors |
| CHG-1 | Li-ion charger with power path | USB-C input, single-cell, programmable current, thermistor support | 1 | ₹300–₹1,200 | Do not use a bare TP4056 board in a final wearable design |
| PROT-1 | Cell protection | Over-charge, over-discharge, over-current, short-circuit | 1 | ₹100–₹400 | Prefer protected cell plus board-level protection during POC |
| FUEL-1 | Fuel gauge | Single-cell, low-power, I²C | 1 | ₹250–₹900 | Battery percentage and characterization |
| ESD-1 | USB/data ESD protection | Low-capacitance TVS array | 1 | ₹30–₹150 | Port robustness |
| SW-1 | Tactile preset button | Side-actuated or sealed, 100k cycles target | 1 | ₹30–₹250 | Accessible without removing eyewear |
| SW-2 | Power switch or load switch | Low-profile; hardware isolation for bench safety | 1 | ₹30–₹300 | POC serviceability |
| LED-STAT | Status LED or light pipe | Low-current RGB or single-color | 1 | ₹20–₹100 | Charging/pairing status; optional if frame LEDs indicate state |
| DBG-1 | Programming/debug connector | Tag-Connect pads or 1.27 mm SWD header | 1 | ₹50–₹500 | Firmware flashing and diagnostics |
| PCB-1 | Rigid-flex or segmented PCB set | 0.8 mm rigid sections plus flex interconnect preferred | 1 set | ₹4,000–₹25,000 | Begin with small rigid boards and fine-wire harness; move to rigid-flex after layout stabilizes |

### Battery and charging

| Component | POC target | Qty. | Indicative cost | Notes |
|---|---|---:|---:|---|
| Protected LiPo cell | 3.7 V, 250–500 mAh, ≤6 mm thick, supplier-certified | 2–3 options | ₹500–₹1,500 each | Fit, weight, peak-current, and runtime comparison |
| Battery NTC | 10 kΩ, matched to charger | 1 | ₹20–₹100 | Charging temperature supervision |
| USB-C receptacle | Mid-mount or waterproof option | 1 | ₹100–₹500 | POC service charging; avoid exposed sharp edges |
| USB-C CC resistors | 5.1 kΩ, 1% | 2 | <₹20 | Valid USB-C sink configuration |
| Magnetic charging alternative | 2-pin keyed connector, corrosion-resistant | 1 set | ₹300–₹1,500 | Evaluate for sealing and usability; protect against shorts |

### Optical and frame components

| Component | Preferred specification | Qty. | Indicative cost | Notes |
|---|---|---:|---:|---|
| Donor eyewear chassis | Full-rim acetate/TR90, replaceable demo lenses, wide temples | 3–5 | ₹1,000–₹5,000 each | Use multiple sizes and document modifications |
| Custom prototype chassis | SLA/MJF/CNC, modular front and temple covers | 3 | ₹3,000–₹15,000 each | Non-prescription fit testing until professionally glazed |
| Light guide/diffuser | Optical silicone, frosted PMMA, or side-emitting fiber | 3–5 m/options | ₹500–₹5,000 | Must eliminate LED hotspots |
| Reflective backing | White optical film or coated insert | 1 sheet | ₹300–₹2,000 | Improves uniformity and efficiency |
| Opaque light barrier | Black TPU, coating, or film | 1 set | ₹500–₹3,000 | Prevents light leakage toward eyes and skin |
| Clear protective overmold/cover | UV-stable, sweat-resistant, optically diffusing | 3 sets | ₹1,000–₹8,000 | Must remain serviceable in POC |
| Hinges and screws | Stainless steel, eyewear standard | 10 sets | ₹500–₹2,000 | Spares for repeated assembly |
| Demo lenses | Clear polycarbonate, non-prescription | 3 pairs | ₹500–₹2,000/pair | Impact-resistant display use |

### Sensors (optional POC enhancements)

| Sensor | Requirement | Cost | Value |
|---|---|---:|---|
| Ambient light sensor | Low-power I²C, wide dynamic range | ₹100–₹500 | Automatic brightness limiting |
| Skin/frame temperature sensor | ±0.5 °C class near 20–50 °C | ₹100–₹600 | Thermal safety logging |
| 6-axis IMU | Low-power motion/wake function | ₹200–₹800 | Auto-sleep and wear detection research |
| Hall sensor | Low-power magnetic switch | ₹50–₹250 | Case/temple state detection |

## Track B: materials evaluation kit

| Component | Requirement | Qty. | Indicative cost | Purpose |
|---|---|---:|---:|---|
| Flexible electrochromic samples | Multiple colors, ≤1 mm stack, supplier drive data | 10–30 coupons | ₹1,000–₹15,000/sample | Curvature, color, switching, and durability screening |
| Electrochromic driver boards | Bipolar/controlled low-voltage drive, current monitoring | 3–5 | ₹3,000–₹20,000 each | Safe waveform evaluation |
| Reflective/e-paper color samples | Flexible where available; sunlight-readable | 3–10 | ₹3,000–₹25,000 each | Compare appearance and power |
| Thermochromic/photochromic samples | Encapsulated films or pigments | 5–10 | ₹500–₹5,000 each | Passive benchmark, not primary app-control solution |
| Transparent barrier films | UV, oxygen, and moisture barrier options | 5 types | ₹500–₹5,000/type | Encapsulation screening |
| Conductive films/inks | ITO/PET, PEDOT:PSS, silver ink options | 3–5 types | ₹1,000–₹10,000/type | Flexible electrodes and contacts |
| Flexible tail/contact materials | FPC, anisotropic conductive film, conductive epoxy | 1 kit | ₹3,000–₹15,000 | Coupon connection and strain relief |
| Skin-safe candidate coatings | Sweat/UV-resistant; supplier declarations required | 3–5 | ₹1,000–₹10,000/type | Protective stack research |

## Consumables

| Item | Specification | Initial quantity | Budget |
|---|---|---:|---:|
| Fine silicone wire | 28–32 AWG, multiple colors | 50 m | ₹1,500–₹4,000 |
| Magnet wire | 32–38 AWG, solderable enamel | 3 rolls | ₹800–₹2,000 |
| JST/Molex micro connectors | Polarized, locking where possible | 50 sets | ₹2,000–₹8,000 |
| Heat-shrink and braided sleeve | Thin-wall, lightweight | Assortment | ₹1,000–₹3,000 |
| Epoxy and flexible adhesive | Electronics grade; documented cure | 3 types | ₹1,500–₹6,000 |
| Optical clear adhesive | UV-stable candidate | 2 types | ₹2,000–₹8,000 |
| Removable prototype adhesive | Low residue | 3 rolls | ₹500–₹2,000 |
| IPA and lint-free wipes | ≥99% IPA for electronics | 2 L + wipes | ₹1,000–₹3,000 |
| Artificial sweat solution | ISO/EN-referenced formulation or lab-prepared | 2 L | ₹1,000–₹5,000 |
| Fasteners, inserts, springs | Stainless/brass micro hardware | Assortment | ₹2,000–₹8,000 |

## Development boards and spares

Order enough for parallel software, hardware, and destructive testing:

- 3× preferred BLE development kits
- 2× alternate MCU development boards
- 5× charger/power-path evaluation boards
- 5× boost/regulator evaluation boards
- 3× fuel-gauge evaluation boards
- 3× LED strip/matrix samples for early firmware work
- At least 30% spare LEDs, connectors, PCBs, and mechanical parts
- At least three batteries from each shortlisted supplier lot

Expected budget: **₹50,000–₹1.5 lakh** before custom PCBs and frame fabrication.

## Preliminary POC cost roll-up

| Work package | Indicative range |
|---|---:|
| Electronics development kits and evaluation boards | ₹50,000–₹1.5 lakh |
| First two PCB iterations | ₹50,000–₹2 lakh |
| Three wearable frame builds | ₹75,000–₹3 lakh |
| Optical diffusion experiments | ₹25,000–₹1 lakh |
| Material coupons and drivers | ₹1–₹4 lakh |
| Batteries, chargers, harnesses, and consumables | ₹50,000–₹1.5 lakh |
| External testing and specialist fabrication | ₹1–₹4 lakh |
| Contingency (20–30%) | ₹1–₹3 lakh |

These figures support the earlier recommended **₹8–₹15 lakh dual-track POC**, including iteration and outsourced work.

## Procurement gates

Before approving any production-intent component:

1. Obtain datasheet, lifecycle status, minimum order quantity, lead time, and authorized supplier evidence.
2. Obtain RoHS/REACH declarations and relevant battery transport documents.
3. Confirm operating and storage temperatures.
4. Confirm skin-contact, sweat, UV, cleaning, and flammability suitability for its installed location.
5. Verify peak and sleep current on the bench, not only from datasheets.
6. Record manufacturer part number and approved alternates in a controlled BOM.

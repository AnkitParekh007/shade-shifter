# Hardware Requirements

## Purpose and status

This document defines measurable POC requirements for Shade Shifter hardware. It is an engineering baseline, not a certification declaration. Values marked **Target** guide design; values marked **Must** are POC acceptance gates. Regulatory, medical, optical, battery, radio, and skin-contact requirements must be reviewed by qualified specialists before sale.

Requirement IDs remain stable. Changes should update the text and revision history rather than renumbering existing requirements.

## Product and functional requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-FUN-001 | The frame shall recolor the frame body without changing the optical properties of the lenses. | Must | Inspection and functional test |
| HW-FUN-002 | The system shall independently control the front, left-temple, and right-temple zones. | Must | Functional test |
| HW-FUN-003 | The system shall provide at least 8 curated color presets stored on the device. | Must | Functional test |
| HW-FUN-004 | A physical control shall change presets without the mobile app. | Must | Functional test |
| HW-FUN-005 | The system shall retain the last safe preset across a normal restart. | Target | Power-cycle test |
| HW-FUN-006 | The system shall report battery and fault status to the app over BLE. | Must | Interface test |
| HW-FUN-007 | Loss of Bluetooth connection shall not cause an unsafe state or disable physical control. | Must | Fault-injection test |
| HW-FUN-008 | Firmware shall enforce power, thermal, and brightness limits independently of the app. | Must | Boundary and fault test |

## Appearance and optical requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-OPT-001 | No individual LED hotspot shall be obvious at 1 m in typical indoor lighting for approved presets. | Target | Panel inspection and photographs |
| HW-OPT-002 | Light shall not be directly visible to the wearer through the skin-facing side in normal use. | Must | Wear test in dark and indoor conditions |
| HW-OPT-003 | Each approved preset shall remain distinguishable at 10,000 lux. | Target | Lux-controlled inspection/color measurement |
| HW-OPT-004 | The same preset across three zones shall achieve ΔE00 ≤5 after calibration. | Target | Colorimeter test |
| HW-OPT-005 | The same preset across three H2 units shall achieve ΔE00 ≤7 after calibration. | Target | Colorimeter test |
| HW-OPT-006 | Brightness changes shall not create visible flicker under normal viewing or common phone-video capture settings. | Target | Visual and camera test |
| HW-OPT-007 | Flashing effects shall be excluded from normal presets unless separately reviewed for photobiological risk. | Must | Firmware and preset review |

## Electrical and battery requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-PWR-001 | The wearable system shall use a protected, rechargeable single-cell battery from a traceable supplier. | Must | BOM and certificate review |
| HW-PWR-002 | Charging shall include over-voltage, over-current, short-circuit, and temperature protection. | Must | Design review and fault test |
| HW-PWR-003 | The optical power rail shall default off during reset, firmware crash, brownout, and critical fault. | Must | Fault-injection test |
| HW-PWR-004 | Five-day runtime under the defined generation-one usage profile is the product target. | Target | Logged runtime test |
| HW-PWR-005 | The POC shall complete at least one full typical-use day with ≥20% indicated capacity remaining. | Must | Logged wearable simulation |
| HW-PWR-006 | Connected standby current shall be <500 µA average. | Target | Power-profiler measurement |
| HW-PWR-007 | The battery state estimate shall be within ±10 percentage points after characterization. | Target | Charge/discharge comparison |
| HW-PWR-008 | The product shall prevent normal operation below the validated battery cutoff. | Must | Discharge test |
| HW-PWR-009 | The charging input shall tolerate cable insertion/removal and ESD appropriate to the POC interface without permanent damage. | Target | Repetition and pre-compliance test |

### Defined POC usage profile

Unless superseded by a controlled test plan:

- 16 hours available per day
- 8 hours powered down or deep sleep
- 20 preset changes per day
- 30 minutes total active app connection
- Optical output active for the duration intended by the selected material/experience design
- Indoor and outdoor brightness behavior enabled

The test report must record the exact firmware, battery lot, brightness, temperatures, and usage events.

## Mechanical and ergonomic requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-MEC-001 | Total mass with non-prescription evaluation lenses shall be <40 g. | Target | Calibrated scale |
| HW-MEC-002 | Left/right temple mass imbalance shall be <3 g unless user testing validates an alternative. | Target | Scale and balance test |
| HW-MEC-003 | Electronics, battery, conductors, and sharp edges shall not be exposed during normal wear. | Must | Inspection |
| HW-MEC-004 | The frame shall be wearable for 2 hours by at least 80% of POC participants without pain or skin marking beyond conventional eyewear. | Target | Controlled user study |
| HW-MEC-005 | A serviceable H2 unit shall permit replacement of the battery/electronics module without damaging the lens chassis. | Target | Service demonstration |
| HW-MEC-006 | Hinge interconnects shall survive 10,000 open/close cycles without loss of function for POC acceptance. | Must | Automated cycle test |
| HW-MEC-007 | The POC shall survive a 1 m drop onto a representative hard surface in six orientations without battery damage, exposed conductors, or unsafe heat. | Must | Controlled drop test |
| HW-MEC-008 | Lens retention shall not be degraded by the electronics and optical channels. | Must | Inspection and mechanical review |

## Thermal and safety requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-SAF-001 | No skin-facing surface shall exceed 41 °C during the defined normal-use profile at 25 °C ambient. | Must | Thermocouple/thermal-camera test |
| HW-SAF-002 | Firmware shall reduce output before any skin-facing surface reaches 41 °C and enter a safe fault state if temperature continues rising. | Must | Heated/fault test |
| HW-SAF-003 | The battery shall not be charged outside its supplier-specified temperature range. | Must | Cold/hot charge attempt |
| HW-SAF-004 | Charging and maximum optical output shall not run concurrently until thermal validation approves the combination. | Must | Firmware and functional test |
| HW-SAF-005 | The system shall remain safe after a single open circuit or short circuit in any externally routed prototype harness. | Must | Fault-injection test |
| HW-SAF-006 | Prototype users shall receive documented limitations and shall not sleep, drive, exercise intensely, or charge while wearing the POC. | Must | Protocol review |
| HW-SAF-007 | POC batteries shall be inspected and quarantined after drop, crush, overheating, swelling, or enclosure damage. | Must | Lab procedure audit |

The 41 °C POC gate is a conservative internal engineering limit, not a claim of compliance with any specific standard.

## Environmental and durability requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-ENV-001 | H2 electronics shall remain functional after 8 hours of artificial-sweat exposure using a documented method. | Must | Exposure and functional test |
| HW-ENV-002 | Approved visible surfaces shall show no peeling, cracking, corrosion, or ΔE00 >5 after the POC sweat test. | Target | Inspection and color measurement |
| HW-ENV-003 | The POC shall tolerate 500 wipe cycles using approved lens/frame cleaner without loss of safety or function. | Must | Wipe-cycle test |
| HW-ENV-004 | H2 shall survive incidental splash testing without hazardous behavior. | Must | Controlled splash test |
| HW-ENV-005 | No public IP rating shall be claimed until tested to the applicable standard by a qualified lab. | Must | Claims review |
| HW-ENV-006 | Material coupons shall undergo UV exposure with pre/post color, adhesion, switching, and visual records. | Must | Outsourced or controlled UV test |
| HW-ENV-007 | Active material coupons shall complete at least 10,000 switch cycles before H2 architecture selection. | Must | Automated cycle test |
| HW-ENV-008 | The selected production-intent material shall have a documented path to ≥100,000 cycles. | Target | Supplier evidence and extended test |

## Bluetooth and firmware-related hardware requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-RAD-001 | The POC shall maintain BLE control at 5 m line-of-sight while worn. | Must | Range test |
| HW-RAD-002 | The device shall reconnect after phone Bluetooth is toggled without requiring a hardware reset. | Must | Reconnection test |
| HW-RAD-003 | Pairing and control shall reject unauthorized devices after ownership is established. | Must | Security test |
| HW-RAD-004 | The antenna layout shall follow module/vendor keep-out guidance and be documented. | Must | PCB review |
| HW-RAD-005 | The design shall use a pre-qualified radio module for early POC units where practical. | Target | BOM/certificate review |

## Material and skin-contact requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-MAT-001 | Every skin-contact material shall have a recorded manufacturer, grade, finish, adhesive, and supplier. | Must | BOM audit |
| HW-MAT-002 | Materials shall be screened for sweat, cosmetics, sunscreen, cleaning agents, and UV exposure. | Must | Test reports |
| HW-MAT-003 | No leaking, uncured, or unencapsulated active chemistry shall be used in a wearable unit. | Must | Inspection and build record |
| HW-MAT-004 | Electrochromic/material drivers shall enforce supplier voltage, polarity, timing, and current limits. | Must | Waveform and boundary test |
| HW-MAT-005 | A punctured or delaminated coupon shall be treated as failed and shall not be worn. | Must | Lab/user procedure |

## Documentation and traceability requirements

| ID | Requirement | Priority | Verification |
|---|---|---|---|
| HW-DOC-001 | Every prototype shall have a unique serial number and build record. | Must | Record audit |
| HW-DOC-002 | Schematics, PCB, CAD, BOM, firmware, and test results shall identify compatible revisions. | Must | Configuration audit |
| HW-DOC-003 | Every test report shall record equipment, calibration status, firmware, hardware revision, environment, procedure, raw data, and result. | Must | Report review |
| HW-DOC-004 | Known hazards and mitigations shall be maintained in a living risk register/FMEA. | Must | Design review |
| HW-DOC-005 | Supplier certificates and safety data sheets shall be stored with the controlled component record. | Target | Procurement audit |

## Compliance planning requirements

Before any commercial pilot, obtain a qualified assessment covering at minimum:

- ISO 12870 and other applicable eyewear-frame requirements
- Battery cell/product safety and UN 38.3 transport documentation
- USB/charger electrical safety where applicable
- Bluetooth qualification and regional radio approvals
- India WPC/BIS obligations based on the final architecture and sales package
- RoHS/REACH and e-waste/battery obligations in target markets
- Skin-contact material and chemical-safety evaluation
- Photobiological safety if the commercial product emits light
- Consumer-product labeling, warranty, and disposal requirements

## POC release gates

An H2 wearable unit may enter supervised user evaluation only when:

1. All **Must** requirements applicable to H2 have passing evidence or an approved, documented exception.
2. Battery, charging, short-circuit, and thermal fault tests pass.
3. No active material or conductor is exposed.
4. The build record and risk review are complete.
5. Participants receive and accept the prototype-use protocol.

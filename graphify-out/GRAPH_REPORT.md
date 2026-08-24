# Graph Report - shade-shifter  (2026-08-19)

## Corpus Check
- 29 files · ~145,244 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1065 nodes · 1411 edges · 78 communities (65 shown, 13 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 58 edges (avg confidence: 0.83)
- Token cost: 368,012 input · 0 output

## Community Hubs (Navigation)
- Transport Seam & Safety
- Transport Interface & Fakes
- Customization Studio UI
- Frame Preview & Zones
- Looks & Device Screens
- BLE Command Protocol
- Simulator Transport
- Command Codec & Wire Format
- Design Tokens
- Purchasing Parts Lists
- Appearance Model
- Device Session Wiring
- Studio Controller
- Device State & Telemetry
- Safety Governor & Apply State
- Preferences Store
- Device Capabilities
- Look Model
- RGB Color Model
- Onboarding Screen
- Settings Controller
- Hardware Design & Requirements
- Hardware Tools & Gates
- Pairing & Settings UI
- Result Type
- App Logger
- Android Showcase v2 (image)
- ADRs & CI
- App Root
- Product Tracks & Sourcing
- Looks Repository & Presets
- Android Showcase v1 (image)
- App Error Types
- Test & Bootstrap Harness
- Looks Controller
- App Entry Point
- Debouncer Utility
- App Router
- Secure Device Store
- Home Shell
- DI Providers
- Controller Providers
- Built-in Looks Data
- Color Utilities
- Splash Screen
- Studio & Persistence Tests
- Core Result & Models
- Consumer Widget Scaffolding
- Simulator Transport Tests
- Requirements & Security Gaps
- ESP32 Bench Electronics
- Device Controller
- Widget Studio Test
- Transport Factory
- BLE Contract Tests
- 3D-Printed Frame CAD
- Safety Governor Tests
- Codec Tests
- STL Preview Generator
- Rev-A BLE Hardware Contract
- Thermal Safety & Optics
- Color & Model Tests
- UX Navigation Flows
- Dual-Track POC Strategy
- Mumbai Procurement & Suppliers
- Capability-Driven GATT
- Ack & Version Negotiation
- Zone Persistence & Restore
- Platform Bootstrap Script
- Graphify Instructions
- Result-over-Exceptions
- Firmware Validation Checklist
- iOS Background Modes
- Replay Attack Mitigation
- Safety UX
- 3M Adhesive Supplier
- Settings Controller Concept
- Permission Handler

## God Nodes (most connected - your core abstractions)
1. `_` - 49 edges
2. `_` - 34 edges
3. `Shade Shifter Complete Parts List (master)` - 20 edges
4. `deviceControllerProvider` - 17 edges
5. `DeviceTransport` - 17 edges
6. `Online Purchases checklist (documented supplier)` - 13 edges
7. `DeviceCommand` - 12 edges
8. `_` - 12 edges
9. `_` - 11 edges
10. `_` - 11 edges

## Surprising Connections (you probably didn't know these)
- `BleTransport` --references--> `CommandCodec`  [EXTRACTED]
  documentation/mobile-app/ARCHITECTURE.md → software/mobile-app/lib/core/ble/command_codec.dart
- `Command frame layout` --references--> `CommandType`  [EXTRACTED]
  documentation/mobile-app/BLE-PROTOCOL.md → software/mobile-app/lib/core/ble/protocol.dart
- `BleTransport (Phase 3, flutter_blue_plus)` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `ADR 0001 — Isolate BLE behind DeviceTransport interface` --references--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `FakeTransport (tests)` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **App-to-LED BLE RGB control chain** — hardware_build_blueprint_flutter_mobile_app, hardware_build_blueprint_ble_rgb_payload, hardware_build_blueprint_esp32_controller, hardware_build_blueprint_74ahct125_level_shifter, hardware_build_blueprint_ws2812b_leds [INFERRED 0.85]
- **Staged gate/spend procurement flow** — hardware_build_blueprint_stage_gates, hardware_components_procurement_gates, hardware_hardware_suppliers_four_sourcing_lanes, documentation_research_analysis_demand_gate, hardware_requirements_poc_release_gates [INFERRED 0.75]
- **40-41C thermal safety gate consensus** — hardware_build_blueprint_thermal_40c_gate, hardware_requirements_hw_saf_41c_thermal_requirements, hardware_hardware_details_power_domains, hardware_tools_thermal_camera [INFERRED 0.75]
- **DeviceTransport implementations** — software_mobile_app_lib_simulatortransport, software_mobile_app_test_fakes_fake_transport_faketransport, software_mobile_app_lib_core_ble_ble_transport_bletransport [INFERRED 0.95]
- **Application-layer controllers** — software_mobile_app_lib_studiocontroller, software_mobile_app_lib_devicecontroller, software_mobile_app_lib_lookscontroller [INFERRED 0.85]
- **Command/ack pipeline** — software_mobile_app_lib_core_ble_command_codec_commandcodec, documentation_mobile_app_ble_protocol_commandack, documentation_mobile_app_ble_protocol_timeouts_retries [INFERRED 0.85]
- **Buy-now bench prototype core parts** — purchasing_buy_now_checklist, purchasing_all_parts_esp32_c3_devkitm_1, purchasing_all_parts_ynvisible_evaluation_kit [INFERRED 0.75]
- **Deferred later-stage display procurement** — purchasing_bu_later_checklist, purchasing_all_parts_e_ink_prism_3_module, purchasing_all_parts_flexible_six_color_epd [INFERRED 0.75]
- **In-person frame fit inspection group** — purchasing_buy_in_person_checklist, purchasing_all_parts_wide_temple_donor_frames, purchasing_all_parts_3d_printed_frame_set [INFERRED 0.75]
- **POC to production security gap** — documentation_mobile_app_security_threat_model_authentication_gap, documentation_mobile_app_security_threat_model_replay_attack, documentation_mobile_app_security_threat_model_firmware_update, documentation_mobile_app_security_threat_model_trust_boundaries [EXTRACTED 0.85]
- **DeviceTransport seam and its interchangeable implementations** — software_mobile_app_lib_core_ble_device_transport_devicetransport, documentation_mobile_app_adr_0001_transport_abstraction_simulatortransport, documentation_mobile_app_adr_0001_transport_abstraction_faketransport, documentation_mobile_app_adr_0001_transport_abstraction_bletransport, documentation_mobile_app_adr_0001_transport_abstraction_transportfactory [EXTRACTED 1.00]
- **Mobile CI job pipeline (analyze-test gates platform builds)** — github_workflows_mobile_ci_analyze_test, github_workflows_mobile_ci_android_build, github_workflows_mobile_ci_ios_build, github_workflows_mobile_ci_integration_test [EXTRACTED 1.00]
- **No-local-SDK constraint drives CI verification, no-codegen and prefs persistence** — documentation_mobile_app_adr_0003_verification_in_ci_decision, documentation_mobile_app_adr_0002_no_codegen_decision, documentation_mobile_app_adr_0004_local_persistence_decision, github_workflows_mobile_ci_workflow [INFERRED 0.80]

## Communities (78 total, 13 thin omitted)

### Community 0 - "Transport Seam & Safety"
Cohesion: 0.04
Nodes (48): BleTransport (Phase 3, flutter_blue_plus), ADR 0001 — Isolate BLE behind DeviceTransport interface, FakeTransport (tests), SimulatorTransport, TransportFactory, bootstrap_platforms.sh, Contextual runtime permission flow (permission_handler), Android BLE permissions overlay (+40 more)

### Community 1 - "Transport Interface & Fakes"
Cohesion: 0.05
Nodes (43): ConnectionStatus get, DeviceCapabilities? get, package:shade_shifter/core/ble/device_transport.dart, package:shade_shifter/core/result/result.dart, ../result/result.dart, acks, capabilities, connect (+35 more)

### Community 2 - "Customization Studio UI"
Cohesion: 0.06
Nodes (42): ../../core/utils/color_utils.dart, EdgeInsetsGeometry?, ../looks/looks_controller.dart, ../models/apply_state.dart, base, controller, current, _GradientControls (+34 more)

### Community 3 - "Frame Preview & Zones"
Cohesion: 0.05
Nodes (36): Brightness, CustomPainter, ../models/appearance.dart, ../models/rgb_color.dart, ../models/zone.dart, FrameAppearance, fromWire, label (+28 more)

### Community 4 - "Looks & Device Screens"
Cohesion: 0.08
Nodes (36): ConsumerWidget, ../frame_control/studio_controller.dart, looks_controller.dart, ../../shared/widgets/frame_preview.dart, deviceControllerProvider, _action, build, _ConnectedBody (+28 more)

### Community 5 - "BLE Command Protocol"
Cohesion: 0.07
Nodes (35): CommandType get, appearance, ApplyLookCommand, color, CommandAck, commandId, detail, DeviceCommand (+27 more)

### Community 6 - "Simulator Transport"
Cohesion: 0.06
Nodes (34): Random, _ackController, acks, _capabilities, commandLatency, connect, connectionStatus, connectLatency (+26 more)

### Community 7 - "Command Codec & Wire Format"
Cohesion: 0.06
Nodes (32): dart:typed_data, applyLook, Command frame layout, Security notes (unauthenticated pairing), setZoneSolidColor, BLE Protocol v1, protocol.dart, ../../shared/models/appearance.dart (+24 more)

### Community 8 - "Design Tokens"
Cohesion: 0.06
Nodes (33): _, bleControlDebounce, danger, elevationCard, elevationSheet, fog, graphite, mist (+25 more)

### Community 9 - "Purchasing Parts Lists"
Cohesion: 0.14
Nodes (32): 3D-printed frame set (PLA/PA12), 74AHCT125 level shifter (DIP-14), Addressable RGB LED strip (WS2812B/SK6812), Shade Shifter Complete Parts List (master), BLE microcontroller (hardware component concept), Electrochromic display (hardware component concept), E-paper display (hardware component concept), Eyewear frame/enclosure (hardware component concept) (+24 more)

### Community 10 - "Appearance Model"
Cohesion: 0.07
Nodes (28): Map, rgb_color.dart, RgbColor get, AppearanceMode, copyWith, effect, effectSpeed, EffectType (+20 more)

### Community 11 - "Device Session Wiring"
Cohesion: 0.07
Nodes (28): ../../core/logging/app_logger.dart, ../../core/result/result.dart, _, _bind, build, capabilities, _commandTimeout, connectSimulator (+20 more)

### Community 12 - "Studio Controller"
Cohesion: 0.07
Nodes (26): ../../core/ble/protocol.dart, ../../core/errors/app_error.dart, ../../core/safety/safety_governor.dart, ../../core/utils/debouncer.dart, ../../shared/models/apply_state.dart, appearance, applyAll, applyLook (+18 more)

### Community 13 - "Device State & Telemetry"
Cohesion: 0.10
Nodes (20): double?, int?, batteryPercent, charging, ConnectionStatus, copyWith, DeviceRef, DeviceTelemetry (+12 more)

### Community 14 - "Safety Governor & Apply State"
Cohesion: 0.10
Nodes (18): bool get, ../../shared/models/device_capabilities.dart, adjusted, appearance, clampIntensity, code, kMaxSafeEffectSpeed, message (+10 more)

### Community 15 - "Preferences Store"
Cohesion: 0.10
Nodes (19): dart:convert, getBool, getDouble, getJson, getJsonList, getString, keyLastAppliedAppearance, keyOnboardingComplete (+11 more)

### Community 16 - "Device Capabilities"
Cohesion: 0.10
Nodes (19): capabilityVersion, fromJson, hardwareRevision, maxIntensity, protocolVersion, revA, safeDefaultIntensity, supportedEffects (+11 more)

### Community 17 - "Look Model"
Cohesion: 0.11
Nodes (17): appearance.dart, DateTime, FrameAppearance, appearance, builtIn, copyWith, createdAt, deviceCapabilityVersion (+9 more)

### Community 18 - "RGB Color Model"
Cohesion: 0.11
Nodes (17): dart:ui, b, black, fromHex, fromJson, g, _h, hashCode (+9 more)

### Community 19 - "Onboarding Screen"
Cohesion: 0.12
Nodes (16): IconData, Routes.pairing, body, build, _controller, count, createState, dispose (+8 more)

### Community 20 - "Settings Controller"
Cohesion: 0.13
Nodes (15): PreferencesStore get, preferencesStoreProvider, AppSettings, build, completeOnboarding, copyWith, onboardingComplete, _prefs (+7 more)

### Community 21 - "Hardware Design & Requirements"
Cohesion: 0.16
Nodes (15): Two-week demand go/no-go gate, Five-day battery life target, Initial Research and POC Direction, ISO 12870 and compliance planning, App-recolorable eyewear product vision, Hardware architecture and design details, Rigid-flex PCB strategy, Power domains and optical rail fail-safe (+7 more)

### Community 22 - "Hardware Tools & Gates"
Cohesion: 0.14
Nodes (15): 60-minute endurance test matrix, Gate 0 paper review, Gate 2 USB bench light, Gate 5 battery wearable, Traceable protected LiPo battery system, Stage gates 0-5 spend ceilings, Battery traceability rule, Online battery safety gate (+7 more)

### Community 23 - "Pairing & Settings UI"
Cohesion: 0.16
Nodes (12): ../../app/router/app_router.dart, ../../app/theme/design_tokens.dart, ../device/device_controller.dart, settings_controller.dart, ../../shared/widgets/ui_kit.dart, build, _busy, createState (+4 more)

### Community 24 - "Result Type"
Cohesion: 0.14
Nodes (13): AppError? get, ../errors/app_error.dart, R, error, errorOrNull, hashCode, isErr, isOk (+5 more)

### Community 25 - "App Logger"
Cohesion: 0.14
Nodes (13): dart:developer, AppLogger, debug, error, info, _levelValue, _log, LogLevel (+5 more)

### Community 26 - "Android Showcase v2 (image)"
Cohesion: 0.16
Nodes (14): BLE connection status indicator ('Connected BLE'), Bottom navigation (palette / eyewear / settings tabs), Customization screen ('My Shade 01'), Design language (purple accent, Material 3 Android, phone mockups), Device status screen (battery / temperature / signal), Frame zone selector (Whole / Front / Temples), Intensity slider (82%), Looks / presets library screen (+6 more)

### Community 27 - "ADRs & CI"
Cohesion: 0.18
Nodes (14): ADR 0002 — Hand-written models & providers (no build_runner code-gen), ADR 0003 — Build/test verification happens in CI, not locally, ADR 0004 — Local persistence: preferences now, Drift later, Drift Migration Path, LooksRepository, PreferencesStore, SecureDeviceStore, Reconnection Flow (+6 more)

### Community 28 - "App Root"
Cohesion: 0.16
Nodes (13): ../features/settings/settings_controller.dart, Routes.home, router/app_router.dart, build, createState, _router, ShadeShifterApp, _ShadeShifterAppState (+5 more)

### Community 29 - "Product Tracks & Sourcing"
Cohesion: 0.15
Nodes (14): Li-ion charger with power path, Flexible electrochromic coupons, Nordic nRF52840 BLE MCU module, Component procurement gates, Dual-track prototype components and BOM, SK6805/2020 addressable RGB LEDs, Track A wearable experience prototype, Track B materials evaluation kit (+6 more)

### Community 30 - "Looks Repository & Presets"
Cohesion: 0.15
Nodes (12): built_in_looks.dart, ../../core/persistence/preferences_store.dart, all, builtIn, delete, _persist, _prefs, readLastApplied (+4 more)

### Community 31 - "Android Showcase v1 (image)"
Cohesion: 0.18
Nodes (13): Bottom tab nav: Customize, Looks, Device, Settings, Color palette swatches: gold, navy, green, maroon, gray, Customize screen: frame render, view tabs, color, intensity, Design language: warm cream bg, gold accent, serif headings, minimal luxury, Device screen: connection, battery, temperature, signal, power, Device status: ShadeShifter-Simulator Connected, 82%, 31.4C, -46 dBm, Smart tintable eyewear product depicted in renders, Intensity slider (0%–100%) (+5 more)

### Community 32 - "App Error Types"
Cohesion: 0.15
Nodes (12): int get, Object?, package:meta/meta.dart, AppErrorKind, cause, code, hashCode, kind (+4 more)

### Community 33 - "Test & Bootstrap Harness"
Cohesion: 0.18
Nodes (10): app.dart, package:flutter_riverpod/flutter_riverpod.dart, package:flutter_test/flutter_test.dart, package:flutter/widgets.dart, package:integration_test/integration_test.dart, package:shade_shifter/app/app.dart, package:shared_preferences/shared_preferences.dart, main (+2 more)

### Community 34 - "Looks Controller"
Cohesion: 0.17
Nodes (11): ../../core/di/providers.dart, data/looks_repository.dart, LooksRepository get, build, delete, duplicate, _refresh, rename (+3 more)

### Community 35 - "App Entry Point"
Cohesion: 0.18
Nodes (10): app/bootstrap.dart, design_tokens.dart, package:flutter/material.dart, _, AppTheme, _build, dark, light (+2 more)

### Community 36 - "Debouncer Utility"
Cohesion: 0.18
Nodes (10): dart:async, Duration, cancel, Debouncer, dispose, duration, isActive, run (+2 more)

### Community 37 - "App Router"
Cohesion: 0.18
Nodes (11): ../../features/device_pairing/pairing_screen.dart, ../../features/home/home_shell.dart, ../../features/onboarding/onboarding_screen.dart, ../../features/onboarding/splash_screen.dart, _, buildRouter, home, onboarding (+3 more)

### Community 38 - "Secure Device Store"
Cohesion: 0.18
Nodes (10): FlutterSecureStorage, package:flutter_secure_storage/flutter_secure_storage.dart, forget, _keyLastDeviceId, _keyLastDeviceName, _keyLastDeviceSim, readAuthorizedDevice, saveAuthorizedDevice (+2 more)

### Community 39 - "Home Shell"
Cohesion: 0.20
Nodes (9): ../device_health/device_screen.dart, ../frame_control/customize_screen.dart, ../looks/looks_screen.dart, ../settings/settings_screen.dart, build, createState, _index, _tabs (+1 more)

### Community 40 - "DI Providers"
Cohesion: 0.20
Nodes (9): ../../features/looks/data/looks_repository.dart, ../persistence/preferences_store.dart, ../persistence/secure_device_store.dart, ../safety/safety_governor.dart, SharedPreferences, secureStorageProvider, sharedPreferencesProvider, PreferencesStore (+1 more)

### Community 41 - "Controller Providers"
Cohesion: 0.22
Nodes (10): List, looksRepositoryProvider, safetyGovernorProvider, build, emergencyOff, setIntensity, StudioController, StudioState (+2 more)

### Community 42 - "Built-in Looks Data"
Cohesion: 0.20
Nodes (10): ../../shared/models/look.dart, ../../../shared/models/zone.dart, _, all, BuiltInLooks, _epoch, _festivalSpectrum, _gradient (+2 more)

### Community 43 - "Color Utilities"
Cohesion: 0.20
Nodes (10): ../../../shared/models/rgb_color.dart, _, ColorUtils, contrastRatio, darker, fromHsv, lighter, _mix (+2 more)

### Community 44 - "Splash Screen"
Cohesion: 0.25
Nodes (8): package:go_router/go_router.dart, ../settings/settings_controller.dart, build, createState, initState, SplashScreen, _SplashScreenState, _Wordmark

### Community 45 - "Studio & Persistence Tests"
Cohesion: 0.22
Nodes (8): package:shade_shifter/features/frame_control/studio_controller.dart, package:shade_shifter/features/looks/data/looks_repository.dart, package:shade_shifter/features/looks/looks_controller.dart, _container, green, main, prefs, red

### Community 46 - "Core Result & Models"
Cohesion: 0.36
Nodes (8): @immutable, Exception, AppError, Err, Ok, Result, RgbColor, T

### Community 47 - "Consumer Widget Scaffolding"
Cohesion: 0.32
Nodes (8): ConsumerState, ConsumerStatefulWidget, PairingScreen, _PairingScreenState, HomeShell, _HomeShellState, OnboardingScreen, _OnboardingScreenState

### Community 48 - "Simulator Transport Tests"
Cohesion: 0.25
Nodes (7): dart:math, package:shade_shifter/features/device/device_controller.dart, package:shade_shifter/features/simulator/simulator_transport.dart, package:shade_shifter/shared/models/device_state.dart, _cmd, _fast, main

### Community 49 - "Requirements & Security Gaps"
Cohesion: 0.25
Nodes (8): Accessibility requirements, Looks (curated + user), MVP must-have requirements, Safety requirements, Per-zone customization, Security gates before consumer release, Authentication gap (POC to production), Insecure firmware update threat

### Community 50 - "ESP32 Bench Electronics"
Cohesion: 0.29
Nodes (8): 1000 uF surge capacitor, 330 ohm data resistor, 74AHCT125 level shifter, shade_shifter_bench.ino bench firmware, ESP32 controller, WS2812B power budget 60mA/LED, Rev A firmware brightness cap 32/255, WS2812B LEDs

### Community 51 - "Device Controller"
Cohesion: 0.25
Nodes (8): Notifier, secureDeviceStoreProvider, connect, DeviceController, DeviceSession, forget, reconnectLast, transportFactoryProvider

### Community 52 - "Widget Studio Test"
Cohesion: 0.25
Nodes (7): package:shade_shifter/app/theme/app_theme.dart, package:shade_shifter/core/di/providers.dart, package:shade_shifter/features/frame_control/customize_screen.dart, _harness, main, prefs, _useTallSurface

### Community 53 - "Transport Factory"
Cohesion: 0.29
Nodes (6): ../../core/ble/device_transport.dart, ../../shared/models/device_state.dart, ../simulator/simulator_transport.dart, createFor, createSimulator, TransportFactory

### Community 54 - "BLE Contract Tests"
Cohesion: 0.29
Nodes (6): fakes/fake_transport.dart, package:shade_shifter/core/errors/app_error.dart, _cmd, device, main, FakeTransport

### Community 55 - "3D-Printed Frame CAD"
Cohesion: 0.33
Nodes (7): Job A FDM PLA/PETG fit check, Job B PA12 SLS/MJF functional prototype, Online 3D Printing RFQ Rev A, Beginner Build Package Rev A, Staged bom.csv, generate_preview_stl.py, cad/shade_shifter_rev_a.scad OpenSCAD model

### Community 56 - "Safety Governor Tests"
Cohesion: 0.29
Nodes (6): package:shade_shifter/core/safety/safety_governor.dart, package:shade_shifter/shared/models/device_capabilities.dart, package:shade_shifter/shared/models/zone.dart, caps, governor, main

### Community 57 - "Codec Tests"
Cohesion: 0.33
Nodes (5): Testing, package:shade_shifter/core/ble/command_codec.dart, package:shade_shifter/core/ble/protocol.dart, codec, main

### Community 58 - "STL Preview Generator"
Cohesion: 0.47
Nodes (4): box(), front(), Generate dependency-free ASCII STL fit/volume previews. The preview meshes are…, temple()

### Community 59 - "Rev-A BLE Hardware Contract"
Cohesion: 0.40
Nodes (6): BLE 3-byte RGB payload, BLE service 7f4a0001-9d45-4d9e-b890-9f132c08a001, Flutter mobile app contract, nRF Connect BLE debug app, Proposed BLE services, HW-RAD Bluetooth/radio requirements

### Community 60 - "Thermal Safety & Optics"
Cohesion: 0.33
Nodes (6): Translucent light-guide diffusers, Tethered wearable assembly, 40C skin-contact thermal gate, HW-SAF 41C thermal safety requirements, POC release gates for H2 unit, Thermal camera

### Community 61 - "Color & Model Tests"
Cohesion: 0.33
Nodes (5): package:shade_shifter/core/utils/color_utils.dart, package:shade_shifter/shared/models/appearance.dart, package:shade_shifter/shared/models/look.dart, package:shade_shifter/shared/models/rgb_color.dart, main

### Community 62 - "UX Navigation Flows"
Cohesion: 0.40
Nodes (5): Contextual Bluetooth Permission (only at pairing), Home IndexedStack Shell (Customize/Looks/Device/Settings), Navigation Map (4-tab shell), Onboarding Flow (five pages), Pairing Sequence

### Community 63 - "Dual-Track POC Strategy"
Cohesion: 0.40
Nodes (5): Dual-track POC strategy, Experience POC track, Materials POC track, Blueprint-plan copy of Build Blueprint Rev A, POC Build Blueprint Rev A

### Community 64 - "Mumbai Procurement & Suppliers"
Cohesion: 0.40
Nodes (5): ESP32-C3/S3 alternative MCU, Four sourcing lanes, Mumbai procurement and supplier guide, Prakaash Eyewear donor frames, Visha World (Lamington Road)

## Knowledge Gaps
- **593 isolated node(s):** `_byteFromUnit`, `_checksum`, `encode`, `_encodeLook`, `headerLength` (+588 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `Device Session Wiring` to `Transport Seam & Safety`, `Test & Bootstrap Harness`, `Looks Controller`, `Debouncer Utility`, `Looks & Device Screens`, `Home Shell`, `Studio Controller`, `Device State & Telemetry`, `Safety Governor & Apply State`, `Core Result & Models`, `Device Controller`, `Transport Factory`?**
  _High betweenness centrality (0.144) - this node is a cross-community bridge._
- **Why does `_` connect `Design Tokens` to `Test & Bootstrap Harness`, `Safety Governor & Apply State`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Why does `DeviceTransport` connect `Transport Seam & Safety` to `Transport Interface & Fakes`, `Device Session Wiring`, `BLE Contract Tests`?**
  _High betweenness centrality (0.039) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `Shade Shifter Complete Parts List (master)` (e.g. with `Buy Later checklist (deferred until gates pass)` and `Buy In Person checklist (physical inspection)`) actually correct?**
  _`Shade Shifter Complete Parts List (master)` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `_byteFromUnit`, `_checksum`, `encode` to the rest of the system?**
  _593 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Transport Seam & Safety` be split into smaller, more focused modules?**
  _Cohesion score 0.044326241134751775 - nodes in this community are weakly interconnected._
- **Should `Transport Interface & Fakes` be split into smaller, more focused modules?**
  _Cohesion score 0.046464646464646465 - nodes in this community are weakly interconnected._
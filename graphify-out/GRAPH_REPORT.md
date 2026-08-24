# Graph Report - shade-shifter  (2026-08-24)

## Corpus Check
- 94 files · ~153,670 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1228 nodes · 1656 edges · 91 communities (78 shown, 13 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 58 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `175de0e4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- DeviceTransport
- fake_transport.dart
- customize_screen.dart
- frame_preview.dart
- deviceControllerProvider
- protocol.dart
- simulator_transport.dart
- _
- _
- Shade Shifter Complete Parts List (master)
- appearance.dart
- _
- studio_controller.dart
- device_state.dart
- safety_governor.dart
- preferences_store.dart
- device_capabilities.dart
- look.dart
- rgb_color.dart
- onboarding_screen.dart
- settings_controller.dart
- Hardware architecture and design details
- Hardware tools and lab equipment
- device_screen.dart
- result.dart
- app_logger.dart
- Customization screen ('My Shade 01')
- analyze-test job
- package:flutter_riverpod/flutter_riverpod.dart
- Track A wearable experience prototype
- looks_repository.dart
- Shade Shifter Android app design showcase (4 phone screens)
- app_error.dart
- bootstrap.dart
- looks_controller.dart
- package:flutter/material.dart
- ble_transport.dart
- _
- secure_device_store.dart
- home_shell.dart
- providers.dart
- List
- _
- _
- pairing_screen.dart
- studio_and_persistence_test.dart
- AppError
- fake_ble_backend.dart
- simulator_transport_test.dart
- MVP must-have requirements
- ESP32 controller
- DeviceController
- widget_customize_test.dart
- transport_factory.dart
- ble_contract_test.dart
- Job A FDM PLA/PETG fit check
- safety_governor_test.dart
- flutter_blue_plus_backend.dart
- generate_preview_stl.py
- BLE 3-byte RGB payload
- HW-SAF 41C thermal safety requirements
- command_codec_test.dart
- Navigation Map (4-tab shell)
- Dual-track POC strategy
- ESP32-C3/S3 alternative MCU
- Capability-driven UI
- CommandAck
- Independent zone persistence
- bootstrap_platforms.sh
- Graphify Project Instructions
- Result over exceptions
- Phase 7 firmware validation checklist
- iOS background modes (none)
- Replay attack mitigation
- Safety UX (intensity ceiling, emergency off, POC labelling)
- 3M (transfer-tape/adhesive supplier)
- SettingsController
- permission_handler
- ble_backend.dart
- looks_screen.dart
- Android BLE permissions overlay
- SafetyGovernor
- ble_transport_test.dart
- BleTransport
- error_presentation.dart
- settingsControllerProvider
- bool get
- Mobile App README
- package:flutter_test/flutter_test.dart
- ADR 0005 — A second seam (`BleBackend`) between BleTransport and flutter_blue_plus
- BleBackend

## God Nodes (most connected - your core abstractions)
1. `_` - 52 edges
2. `_` - 36 edges
3. `deviceControllerProvider` - 20 edges
4. `Shade Shifter Complete Parts List (master)` - 20 edges
5. `DeviceTransport` - 18 edges
6. `_` - 15 edges
7. `_` - 14 edges
8. `_` - 13 edges
9. `Online Purchases checklist (documented supplier)` - 13 edges
10. `DeviceCommand` - 12 edges

## Surprising Connections (you probably didn't know these)
- `Feature-first clean architecture` --references--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/ARCHITECTURE.md → software/mobile-app/lib/core/ble/device_transport.dart
- `SimulatorTransport` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/ARCHITECTURE.md → software/mobile-app/lib/core/ble/device_transport.dart
- `BleTransport` --references--> `CommandCodec`  [EXTRACTED]
  documentation/mobile-app/ARCHITECTURE.md → software/mobile-app/lib/core/ble/command_codec.dart
- `BleTransport (Phase 3, flutter_blue_plus)` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `ADR 0001 — Isolate BLE behind DeviceTransport interface` --references--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **POC to production security gap** — documentation_mobile_app_security_threat_model_authentication_gap, documentation_mobile_app_security_threat_model_replay_attack, documentation_mobile_app_security_threat_model_firmware_update, documentation_mobile_app_security_threat_model_trust_boundaries [EXTRACTED 0.85]
- **DeviceTransport seam and its interchangeable implementations** — software_mobile_app_lib_core_ble_device_transport_devicetransport, documentation_mobile_app_adr_0001_transport_abstraction_simulatortransport, documentation_mobile_app_adr_0001_transport_abstraction_faketransport, documentation_mobile_app_adr_0001_transport_abstraction_bletransport, documentation_mobile_app_adr_0001_transport_abstraction_transportfactory [EXTRACTED 1.00]
- **Mobile CI job pipeline (analyze-test gates platform builds)** — github_workflows_mobile_ci_analyze_test, github_workflows_mobile_ci_android_build, github_workflows_mobile_ci_ios_build, github_workflows_mobile_ci_integration_test [EXTRACTED 1.00]
- **Staged gate/spend procurement flow** — hardware_build_blueprint_stage_gates, hardware_components_procurement_gates, hardware_hardware_suppliers_four_sourcing_lanes, documentation_research_analysis_demand_gate, hardware_requirements_poc_release_gates [INFERRED 0.75]
- **40-41C thermal safety gate consensus** — hardware_build_blueprint_thermal_40c_gate, hardware_requirements_hw_saf_41c_thermal_requirements, hardware_hardware_details_power_domains, hardware_tools_thermal_camera [INFERRED 0.75]
- **Buy-now bench prototype core parts** — purchasing_buy_now_checklist, purchasing_all_parts_esp32_c3_devkitm_1, purchasing_all_parts_ynvisible_evaluation_kit [INFERRED 0.75]
- **In-person frame fit inspection group** — purchasing_buy_in_person_checklist, purchasing_all_parts_wide_temple_donor_frames, purchasing_all_parts_3d_printed_frame_set [INFERRED 0.75]
- **Deferred later-stage display procurement** — purchasing_bu_later_checklist, purchasing_all_parts_e_ink_prism_3_module, purchasing_all_parts_flexible_six_color_epd [INFERRED 0.75]
- **No-local-SDK constraint drives CI verification, no-codegen and prefs persistence** — documentation_mobile_app_adr_0003_verification_in_ci_decision, documentation_mobile_app_adr_0002_no_codegen_decision, documentation_mobile_app_adr_0004_local_persistence_decision, github_workflows_mobile_ci_workflow [INFERRED 0.80]
- **Application-layer controllers** — software_mobile_app_lib_studiocontroller, software_mobile_app_lib_devicecontroller, software_mobile_app_lib_lookscontroller [INFERRED 0.85]
- **App-to-LED BLE RGB control chain** — hardware_build_blueprint_flutter_mobile_app, hardware_build_blueprint_ble_rgb_payload, hardware_build_blueprint_esp32_controller, hardware_build_blueprint_74ahct125_level_shifter, hardware_build_blueprint_ws2812b_leds [INFERRED 0.85]
- **Command/ack pipeline** — software_mobile_app_lib_core_ble_command_codec_commandcodec, documentation_mobile_app_ble_protocol_commandack, documentation_mobile_app_ble_protocol_timeouts_retries [INFERRED 0.85]
- **DeviceTransport implementations** — software_mobile_app_lib_simulatortransport, software_mobile_app_test_fakes_fake_transport_faketransport, software_mobile_app_lib_core_ble_ble_transport_bletransport [INFERRED 0.95]

## Communities (91 total, 13 thin omitted)

### Community 0 - "DeviceTransport"
Cohesion: 0.15
Nodes (13): BleTransport (Phase 3, flutter_blue_plus), ADR 0001 — Isolate BLE behind DeviceTransport interface, FakeTransport (tests), SimulatorTransport, TransportFactory, Transport seam, Apply-State Chip Machine (Previewing/Pending/Sending/Acknowledged/Applied), Customization Interaction (debounced BLE send) (+5 more)

### Community 1 - "fake_transport.dart"
Cohesion: 0.05
Nodes (42): ConnectionStatus get, DeviceCapabilities? get, package:shade_shifter/core/ble/device_transport.dart, package:shade_shifter/core/result/result.dart, ../result/result.dart, acks, capabilities, connect (+34 more)

### Community 2 - "customize_screen.dart"
Cohesion: 0.05
Nodes (43): ../../core/utils/color_utils.dart, EdgeInsetsGeometry?, ../looks/looks_controller.dart, ../models/apply_state.dart, _ErrorNotice, base, controller, current (+35 more)

### Community 3 - "frame_preview.dart"
Cohesion: 0.05
Nodes (36): Brightness, CustomPainter, ../models/appearance.dart, ../models/rgb_color.dart, ../models/zone.dart, FrameAppearance, fromWire, label (+28 more)

### Community 4 - "deviceControllerProvider"
Cohesion: 0.19
Nodes (17): ConsumerWidget, deviceControllerProvider, build, _ConnectedBody, DeviceScreen, _DisconnectedBody, _connect, _scan (+9 more)

### Community 5 - "protocol.dart"
Cohesion: 0.07
Nodes (35): CommandType get, appearance, ApplyLookCommand, color, CommandAck, commandId, detail, DeviceCommand (+27 more)

### Community 6 - "simulator_transport.dart"
Cohesion: 0.05
Nodes (44): dart:async, Duration, Random, cancel, Debouncer, dispose, duration, isActive (+36 more)

### Community 7 - "_"
Cohesion: 0.06
Nodes (33): dart:typed_data, applyLook, Command frame layout, Security notes (unauthenticated pairing), setZoneSolidColor, BLE Protocol v1, protocol.dart, _ (+25 more)

### Community 8 - "_"
Cohesion: 0.06
Nodes (33): _, bleControlDebounce, danger, elevationCard, elevationSheet, fog, graphite, mist (+25 more)

### Community 9 - "Shade Shifter Complete Parts List (master)"
Cohesion: 0.14
Nodes (32): 3D-printed frame set (PLA/PA12), 74AHCT125 level shifter (DIP-14), Addressable RGB LED strip (WS2812B/SK6812), Shade Shifter Complete Parts List (master), BLE microcontroller (hardware component concept), Electrochromic display (hardware component concept), E-paper display (hardware component concept), Eyewear frame/enclosure (hardware component concept) (+24 more)

### Community 10 - "appearance.dart"
Cohesion: 0.07
Nodes (28): Map, rgb_color.dart, RgbColor get, AppearanceMode, copyWith, effect, effectSpeed, EffectType (+20 more)

### Community 11 - "_"
Cohesion: 0.08
Nodes (26): _, _bind, build, capabilities, _commandTimeout, connectSimulator, copyWith, device (+18 more)

### Community 12 - "studio_controller.dart"
Cohesion: 0.08
Nodes (25): ../../core/ble/protocol.dart, ../../core/safety/safety_governor.dart, ../../core/utils/debouncer.dart, ../../shared/models/apply_state.dart, appearance, applyAll, applyLook, _caps (+17 more)

### Community 13 - "device_state.dart"
Cohesion: 0.10
Nodes (20): double?, int?, batteryPercent, charging, ConnectionStatus, copyWith, DeviceRef, DeviceTelemetry (+12 more)

### Community 14 - "safety_governor.dart"
Cohesion: 0.14
Nodes (13): ../../shared/models/device_capabilities.dart, adjusted, appearance, clampIntensity, code, kMaxSafeEffectSpeed, message, notices (+5 more)

### Community 15 - "preferences_store.dart"
Cohesion: 0.10
Nodes (19): dart:convert, getBool, getDouble, getJson, getJsonList, getString, keyLastAppliedAppearance, keyOnboardingComplete (+11 more)

### Community 16 - "device_capabilities.dart"
Cohesion: 0.10
Nodes (20): capabilityVersion, fromJson, hardwareRevision, maxIntensity, protocolVersion, revA, revALegacy, safeDefaultIntensity (+12 more)

### Community 17 - "look.dart"
Cohesion: 0.11
Nodes (17): appearance.dart, DateTime, FrameAppearance, appearance, builtIn, copyWith, createdAt, deviceCapabilityVersion (+9 more)

### Community 18 - "rgb_color.dart"
Cohesion: 0.11
Nodes (17): dart:ui, b, black, fromHex, fromJson, g, _h, hashCode (+9 more)

### Community 19 - "onboarding_screen.dart"
Cohesion: 0.12
Nodes (18): IconData, Routes.pairing, body, build, _controller, count, createState, dispose (+10 more)

### Community 20 - "settings_controller.dart"
Cohesion: 0.15
Nodes (12): PreferencesStore get, build, completeOnboarding, copyWith, onboardingComplete, _prefs, reducedMotion, setReducedMotion (+4 more)

### Community 21 - "Hardware architecture and design details"
Cohesion: 0.16
Nodes (15): Two-week demand go/no-go gate, Five-day battery life target, Initial Research and POC Direction, ISO 12870 and compliance planning, App-recolorable eyewear product vision, Hardware architecture and design details, Rigid-flex PCB strategy, Power domains and optical rail fail-safe (+7 more)

### Community 22 - "Hardware tools and lab equipment"
Cohesion: 0.14
Nodes (15): 60-minute endurance test matrix, Gate 0 paper review, Gate 2 USB bench light, Gate 5 battery wearable, Traceable protected LiPo battery system, Stage gates 0-5 spend ceilings, Battery traceability rule, Online battery safety gate (+7 more)

### Community 23 - "device_screen.dart"
Cohesion: 0.14
Nodes (14): ../../app/theme/design_tokens.dart, ../device/device_controller.dart, settings_controller.dart, ../../shared/widgets/ui_kit.dart, _action, _exportDiagnostics, _findMyFrame, _fmt (+6 more)

### Community 24 - "result.dart"
Cohesion: 0.14
Nodes (13): AppError? get, ../errors/app_error.dart, R, error, errorOrNull, hashCode, isErr, isOk (+5 more)

### Community 25 - "app_logger.dart"
Cohesion: 0.14
Nodes (13): dart:developer, AppLogger, debug, error, info, _levelValue, _log, LogLevel (+5 more)

### Community 26 - "Customization screen ('My Shade 01')"
Cohesion: 0.16
Nodes (14): BLE connection status indicator ('Connected BLE'), Bottom navigation (palette / eyewear / settings tabs), Customization screen ('My Shade 01'), Design language (purple accent, Material 3 Android, phone mockups), Device status screen (battery / temperature / signal), Frame zone selector (Whole / Front / Temples), Intensity slider (82%), Looks / presets library screen (+6 more)

### Community 27 - "analyze-test job"
Cohesion: 0.18
Nodes (14): ADR 0002 — Hand-written models & providers (no build_runner code-gen), ADR 0003 — Build/test verification happens in CI, not locally, ADR 0004 — Local persistence: preferences now, Drift later, Drift Migration Path, LooksRepository, PreferencesStore, SecureDeviceStore, Reconnection Flow (+6 more)

### Community 28 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.25
Nodes (8): ../features/settings/settings_controller.dart, package:flutter_riverpod/flutter_riverpod.dart, router/app_router.dart, createState, _router, ShadeShifterApp, _ShadeShifterAppState, theme/app_theme.dart

### Community 29 - "Track A wearable experience prototype"
Cohesion: 0.15
Nodes (14): Li-ion charger with power path, Flexible electrochromic coupons, Nordic nRF52840 BLE MCU module, Component procurement gates, Dual-track prototype components and BOM, SK6805/2020 addressable RGB LEDs, Track A wearable experience prototype, Track B materials evaluation kit (+6 more)

### Community 30 - "looks_repository.dart"
Cohesion: 0.15
Nodes (12): built_in_looks.dart, ../../core/persistence/preferences_store.dart, all, builtIn, delete, _persist, _prefs, readLastApplied (+4 more)

### Community 31 - "Shade Shifter Android app design showcase (4 phone screens)"
Cohesion: 0.18
Nodes (13): Bottom tab nav: Customize, Looks, Device, Settings, Color palette swatches: gold, navy, green, maroon, gray, Customize screen: frame render, view tabs, color, intensity, Design language: warm cream bg, gold accent, serif headings, minimal luxury, Device screen: connection, battery, temperature, signal, power, Device status: ShadeShifter-Simulator Connected, 82%, 31.4C, -46 dBm, Smart tintable eyewear product depicted in renders, Intensity slider (0%–100%) (+5 more)

### Community 32 - "app_error.dart"
Cohesion: 0.17
Nodes (11): int get, Object?, package:meta/meta.dart, AppErrorKind, cause, code, hashCode, kind (+3 more)

### Community 33 - "bootstrap.dart"
Cohesion: 0.29
Nodes (6): app.dart, ../../core/di/providers.dart, package:flutter/widgets.dart, package:shared_preferences/shared_preferences.dart, bootstrap, prefs

### Community 34 - "looks_controller.dart"
Cohesion: 0.17
Nodes (11): data/looks_repository.dart, LooksRepository get, ../../shared/models/appearance.dart, build, delete, duplicate, _refresh, rename (+3 more)

### Community 35 - "package:flutter/material.dart"
Cohesion: 0.20
Nodes (10): app/bootstrap.dart, design_tokens.dart, package:flutter/material.dart, _, AppTheme, _build, dark, light (+2 more)

### Community 36 - "ble_transport.dart"
Cohesion: 0.05
Nodes (39): ../../core/ble/ble_ids.dart, _ack, _ackController, acks, backend, _blend, _capabilities, _commandId (+31 more)

### Community 37 - "_"
Cohesion: 0.20
Nodes (11): ../../features/device_pairing/pairing_screen.dart, ../../features/home/home_shell.dart, ../../features/onboarding/onboarding_screen.dart, ../../features/onboarding/splash_screen.dart, _, buildRouter, home, onboarding (+3 more)

### Community 38 - "secure_device_store.dart"
Cohesion: 0.17
Nodes (11): FlutterSecureStorage, package:flutter_secure_storage/flutter_secure_storage.dart, ../../shared/models/device_state.dart, forget, _keyLastDeviceId, _keyLastDeviceName, _keyLastDeviceSim, readAuthorizedDevice (+3 more)

### Community 39 - "home_shell.dart"
Cohesion: 0.20
Nodes (9): ../device_health/device_screen.dart, ../frame_control/customize_screen.dart, ../looks/looks_screen.dart, ../settings/settings_screen.dart, build, createState, _index, _tabs (+1 more)

### Community 40 - "providers.dart"
Cohesion: 0.20
Nodes (9): ../../features/looks/data/looks_repository.dart, ../persistence/preferences_store.dart, ../persistence/secure_device_store.dart, ../safety/safety_governor.dart, SharedPreferences, secureStorageProvider, sharedPreferencesProvider, PreferencesStore (+1 more)

### Community 41 - "List"
Cohesion: 0.16
Nodes (14): List, Notifier, looksRepositoryProvider, preferencesStoreProvider, safetyGovernorProvider, build, emergencyOff, setIntensity (+6 more)

### Community 42 - "_"
Cohesion: 0.22
Nodes (10): ../../shared/models/look.dart, ../../../shared/models/zone.dart, _, all, BuiltInLooks, _epoch, _festivalSpectrum, _gradient (+2 more)

### Community 43 - "_"
Cohesion: 0.22
Nodes (10): ../../../shared/models/rgb_color.dart, _, ColorUtils, contrastRatio, darker, fromHsv, lighter, _mix (+2 more)

### Community 44 - "pairing_screen.dart"
Cohesion: 0.09
Nodes (29): ../../app/router/app_router.dart, ConsumerState, ConsumerStatefulWidget, ../../core/errors/app_error.dart, ../../core/errors/error_presentation.dart, ../device/transport_factory.dart, package:go_router/go_router.dart, ../settings/settings_controller.dart (+21 more)

### Community 45 - "studio_and_persistence_test.dart"
Cohesion: 0.22
Nodes (8): package:shade_shifter/features/frame_control/studio_controller.dart, package:shade_shifter/features/looks/data/looks_repository.dart, package:shade_shifter/features/looks/looks_controller.dart, _container, green, main, prefs, red

### Community 46 - "AppError"
Cohesion: 0.36
Nodes (8): @immutable, Exception, AppError, Err, Ok, Result, RgbColor, T

### Community 47 - "fake_ble_backend.dart"
Cohesion: 0.06
Nodes (31): package:shade_shifter/features/device/ble_backend.dart, connect, _connected, connectError, _connection, connectionEvents, disconnect, discover (+23 more)

### Community 48 - "simulator_transport_test.dart"
Cohesion: 0.25
Nodes (7): dart:math, package:shade_shifter/core/ble/protocol.dart, package:shade_shifter/features/device/device_controller.dart, package:shade_shifter/features/simulator/simulator_transport.dart, _cmd, _fast, main

### Community 49 - "MVP must-have requirements"
Cohesion: 0.25
Nodes (8): Accessibility requirements, Looks (curated + user), MVP must-have requirements, Safety requirements, Per-zone customization, Security gates before consumer release, Authentication gap (POC to production), Insecure firmware update threat

### Community 50 - "ESP32 controller"
Cohesion: 0.29
Nodes (8): 1000 uF surge capacitor, 330 ohm data resistor, 74AHCT125 level shifter, shade_shifter_bench.ino bench firmware, ESP32 controller, WS2812B power budget 60mA/LED, Rev A firmware brightness cap 32/255, WS2812B LEDs

### Community 51 - "DeviceController"
Cohesion: 0.25
Nodes (8): secureDeviceStoreProvider, connect, DeviceController, DeviceSession, forget, reconnectLast, _recover, transportFactoryProvider

### Community 52 - "widget_customize_test.dart"
Cohesion: 0.25
Nodes (7): Testing, package:shade_shifter/app/theme/app_theme.dart, package:shade_shifter/features/frame_control/customize_screen.dart, _harness, main, prefs, _useTallSurface

### Community 53 - "transport_factory.dart"
Cohesion: 0.18
Nodes (10): ble_backend.dart, ble_transport.dart, ../../core/ble/device_transport.dart, flutter_blue_plus_backend.dart, ../simulator/simulator_transport.dart, createBle, createFor, createSimulator (+2 more)

### Community 54 - "ble_contract_test.dart"
Cohesion: 0.29
Nodes (6): fakes/fake_transport.dart, package:shade_shifter/core/errors/app_error.dart, _cmd, device, main, FakeTransport

### Community 55 - "Job A FDM PLA/PETG fit check"
Cohesion: 0.33
Nodes (7): Job A FDM PLA/PETG fit check, Job B PA12 SLS/MJF functional prototype, Online 3D Printing RFQ Rev A, Beginner Build Package Rev A, Staged bom.csv, generate_preview_stl.py, cad/shade_shifter_rev_a.scad OpenSCAD model

### Community 56 - "safety_governor_test.dart"
Cohesion: 0.20
Nodes (9): package:shade_shifter/core/ble/ble_ids.dart, package:shade_shifter/core/safety/safety_governor.dart, package:shade_shifter/shared/models/device_capabilities.dart, package:shade_shifter/shared/models/device_state.dart, package:shade_shifter/shared/models/zone.dart, main, caps, governor (+1 more)

### Community 57 - "flutter_blue_plus_backend.dart"
Cohesion: 0.07
Nodes (29): BluetoothDevice?, ../../core/logging/app_logger.dart, dart:io, package:flutter_blue_plus/flutter_blue_plus.dart, package:permission_handler/permission_handler.dart, _characteristic, connect, _connectionController (+21 more)

### Community 58 - "generate_preview_stl.py"
Cohesion: 0.47
Nodes (4): box(), front(), Generate dependency-free ASCII STL fit/volume previews. The preview meshes are…, temple()

### Community 59 - "BLE 3-byte RGB payload"
Cohesion: 0.40
Nodes (6): BLE 3-byte RGB payload, BLE service 7f4a0001-9d45-4d9e-b890-9f132c08a001, Flutter mobile app contract, nRF Connect BLE debug app, Proposed BLE services, HW-RAD Bluetooth/radio requirements

### Community 60 - "HW-SAF 41C thermal safety requirements"
Cohesion: 0.33
Nodes (6): Translucent light-guide diffusers, Tethered wearable assembly, 40C skin-contact thermal gate, HW-SAF 41C thermal safety requirements, POC release gates for H2 unit, Thermal camera

### Community 61 - "command_codec_test.dart"
Cohesion: 0.22
Nodes (8): package:shade_shifter/core/ble/command_codec.dart, package:shade_shifter/core/utils/color_utils.dart, package:shade_shifter/shared/models/appearance.dart, package:shade_shifter/shared/models/look.dart, package:shade_shifter/shared/models/rgb_color.dart, main, codec, main

### Community 62 - "Navigation Map (4-tab shell)"
Cohesion: 0.40
Nodes (5): Contextual Bluetooth Permission (only at pairing), Home IndexedStack Shell (Customize/Looks/Device/Settings), Navigation Map (4-tab shell), Onboarding Flow (five pages), Pairing Sequence

### Community 63 - "Dual-track POC strategy"
Cohesion: 0.40
Nodes (5): Dual-track POC strategy, Experience POC track, Materials POC track, Blueprint-plan copy of Build Blueprint Rev A, POC Build Blueprint Rev A

### Community 64 - "ESP32-C3/S3 alternative MCU"
Cohesion: 0.40
Nodes (5): ESP32-C3/S3 alternative MCU, Four sourcing lanes, Mumbai procurement and supplier guide, Prakaash Eyewear donor frames, Visha World (Lamington Road)

### Community 78 - "ble_backend.dart"
Cohesion: 0.13
Nodes (14): ../../core/result/result.dart, connect, connectionEvents, disconnect, discover, dispose, ensureReady, isConnected (+6 more)

### Community 79 - "looks_screen.dart"
Cohesion: 0.17
Nodes (11): ../frame_control/studio_controller.dart, looks_controller.dart, ../../shared/widgets/frame_preview.dart, _apply, caps, _confirmDelete, controller, look (+3 more)

### Community 80 - "Android BLE permissions overlay"
Cohesion: 0.18
Nodes (11): bootstrap_platforms.sh, Contextual runtime permission flow (permission_handler), Android BLE permissions overlay, BleTransport (flutter_blue_plus), DeviceCapabilities (revA profile), iOS Bluetooth usage descriptions, Privacy by design (guest-first), AppLogger.redactId (+3 more)

### Community 81 - "SafetyGovernor"
Cohesion: 0.20
Nodes (10): Idempotent commands, Timeouts, retries, idempotency, Local-first storage, DoS via command flooding, flutter_secure_storage, SafetyGovernor, DeviceController, LooksController (+2 more)

### Community 82 - "ble_transport_test.dart"
Cohesion: 0.20
Nodes (9): fakes/fake_ble_backend.dart, package:shade_shifter/features/device/ble_transport.dart, backend, ceiling, connect, frame, main, transport (+1 more)

### Community 83 - "BleTransport"
Cohesion: 0.22
Nodes (9): Implementation Status, CI-verified builds, Simulator-first vertical slice, ESP32-compatible BLE controller, Repository layout, Independently controllable RGB zones, Shade Shifter, BleTransport (+1 more)

### Community 84 - "error_presentation.dart"
Cohesion: 0.25
Nodes (7): app_error.dart, actionLabel, ErrorPresentation, message, of, opensSettings, String?

### Community 85 - "settingsControllerProvider"
Cohesion: 0.29
Nodes (8): Routes.home, build, _pairFrame, _trySimulator, _decideNext, settingsControllerProvider, build, SettingsScreen

### Community 86 - "bool get"
Cohesion: 0.33
Nodes (5): bool get, ApplyPhase, isInFlight, isTerminal, label

### Community 87 - "Mobile App README"
Cohesion: 0.33
Nodes (6): Feature-first clean architecture, No code-gen, Strict analysis_options, GoRouter, Mobile App README, Riverpod

### Community 88 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.33
Nodes (5): package:flutter_test/flutter_test.dart, package:integration_test/integration_test.dart, package:shade_shifter/app/app.dart, package:shade_shifter/core/di/providers.dart, main

### Community 89 - "ADR 0005 — A second seam (`BleBackend`) between BleTransport and flutter_blue_plus"
Cohesion: 0.40
Nodes (4): ADR 0005 — A second seam (`BleBackend`) between BleTransport and flutter_blue_plus, Consequences, Context, Decision

### Community 90 - "BleBackend"
Cohesion: 0.67
Nodes (3): BleBackend, FlutterBluePlusBackend, FakeBleBackend

## Knowledge Gaps
- **721 isolated node(s):** `main`, `_router`, `createState`, `prefs`, `bootstrap` (+716 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `_` to `DeviceTransport`, `bootstrap.dart`, `deviceControllerProvider`, `simulator_transport.dart`, `secure_device_store.dart`, `home_shell.dart`, `studio_controller.dart`, `pairing_screen.dart`, `ble_backend.dart`, `safety_governor.dart`, `AppError`, `looks_screen.dart`, `device_state.dart`, `DeviceController`, `transport_factory.dart`, `bool get`, `flutter_blue_plus_backend.dart`, `package:flutter_riverpod/flutter_riverpod.dart`?**
  _High betweenness centrality (0.099) - this node is a cross-community bridge._
- **Why does `DeviceTransport` connect `DeviceTransport` to `fake_transport.dart`, `_`, `SafetyGovernor`, `BleTransport`, `ble_contract_test.dart`, `Mobile App README`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **Why does `_` connect `_` to `bootstrap.dart`, `safety_governor.dart`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `Shade Shifter Complete Parts List (master)` (e.g. with `Buy Later checklist (deferred until gates pass)` and `Buy In Person checklist (physical inspection)`) actually correct?**
  _`Shade Shifter Complete Parts List (master)` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `main`, `_router`, `createState` to the rest of the system?**
  _721 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `fake_transport.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._
- **Should `customize_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05454545454545454 - nodes in this community are weakly interconnected._
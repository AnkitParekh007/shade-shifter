# Graph Report - shade-shifter  (2026-08-19)

## Corpus Check
- Corpus is ~23,111 words - fits in a single context window. You may not need a graph.

## Summary
- 922 nodes · 1240 edges · 58 communities (52 shown, 6 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.77)
- Token cost: 153,322 input · 0 output

## Community Hubs (Navigation)
- Looks & Command Codec
- Customization Studio UI
- Persistence & DI Providers
- BLE Command Protocol
- Architecture Decisions & Build
- Appearance & Apply State
- Studio Controller
- Simulator Transport
- Frame Preview & Zones
- Design Tokens
- Device Screen & Providers
- Device Session Wiring
- Fake Transport (tests)
- Device State & Telemetry
- Device Capabilities
- Onboarding Screen
- RGB Color Model
- Transport Interface
- Model & Protocol Tests
- Settings Controller
- Look Model
- Looks Screen
- Safety Governor
- Pairing & Settings UI
- Result Type
- App Logger
- App Root & Consumers
- Widget & Integration Tests
- Home Shell
- App Error Types
- BLE Identifiers (UUIDs)
- Debouncer Utility
- BLE Contract & Acks
- App Router
- Splash Screen
- MVP Requirements & Looks
- Color Utilities
- Permissions & Privacy
- Transport Seam Architecture
- BLE Wire Format & Codec
- Studio & Persistence Tests
- Core Result & Models
- Simulator Transport Tests
- App Bootstrap
- Transport Factory
- Theme & Design Tokens
- Safety Governor Tests
- Device Controller
- Command Timing & Safety
- UX Navigation Flows
- App Entry Point
- Frame Preview Strategy
- Platform Bootstrap Script
- Graphify Instructions
- Result-over-Exceptions
- Settings Controller Concept
- iOS Background Modes
- Safety UX

## God Nodes (most connected - your core abstractions)
1. `_` - 51 edges
2. `_` - 36 edges
3. `deviceControllerProvider` - 17 edges
4. `_` - 14 edges
5. `_` - 13 edges
6. `_` - 13 edges
7. `DeviceTransport` - 12 edges
8. `DeviceCommand` - 12 edges
9. `_` - 12 edges
10. `BleTransport (flutter_blue_plus)` - 10 edges

## Surprising Connections (you probably didn't know these)
- `BleTransport (Phase 3, flutter_blue_plus)` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `ADR 0001 — Isolate BLE behind DeviceTransport interface` --references--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `FakeTransport (tests)` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `SimulatorTransport` --implements--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart
- `TransportFactory` --references--> `DeviceTransport`  [EXTRACTED]
  documentation/mobile-app/adr/0001-transport-abstraction.md → software/mobile-app/lib/core/ble/device_transport.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Transport seam (simulator/fake/BLE interchangeable)** — documentation_mobile_app_architecture_device_transport, documentation_mobile_app_architecture_simulator_transport, documentation_mobile_app_architecture_fake_transport, documentation_mobile_app_hardware_integration_ble_transport, documentation_mobile_app_architecture_transport_factory [EXTRACTED 1.00]
- **Reliable command/ack pipeline** — documentation_mobile_app_ble_protocol_command_frame, documentation_mobile_app_ble_protocol_checksum, documentation_mobile_app_ble_protocol_acknowledgement, documentation_mobile_app_ble_protocol_timeouts_retries, documentation_mobile_app_ble_protocol_idempotent_commands [EXTRACTED 0.85]
- **POC to production security gap** — documentation_mobile_app_security_threat_model_authentication_gap, documentation_mobile_app_security_threat_model_replay_attack, documentation_mobile_app_security_threat_model_firmware_update, documentation_mobile_app_security_threat_model_trust_boundaries [EXTRACTED 0.85]
- **DeviceTransport seam and its interchangeable implementations** — software_mobile_app_lib_core_ble_device_transport_devicetransport, documentation_mobile_app_adr_0001_transport_abstraction_simulatortransport, documentation_mobile_app_adr_0001_transport_abstraction_faketransport, documentation_mobile_app_adr_0001_transport_abstraction_bletransport, documentation_mobile_app_adr_0001_transport_abstraction_transportfactory [EXTRACTED 1.00]
- **No-local-SDK constraint drives CI verification, no-codegen and prefs persistence** — documentation_mobile_app_adr_0003_verification_in_ci_decision, documentation_mobile_app_adr_0002_no_codegen_decision, documentation_mobile_app_adr_0004_local_persistence_decision, github_workflows_mobile_ci_workflow [INFERRED 0.80]
- **Mobile CI job pipeline (analyze-test gates platform builds)** — github_workflows_mobile_ci_analyze_test, github_workflows_mobile_ci_android_build, github_workflows_mobile_ci_ios_build, github_workflows_mobile_ci_integration_test [EXTRACTED 1.00]

## Communities (58 total, 6 thin omitted)

### Community 0 - "Looks & Command Codec"
Cohesion: 0.04
Nodes (46): built_in_looks.dart, ../../core/persistence/preferences_store.dart, dart:typed_data, data/looks_repository.dart, LooksRepository get, protocol.dart, ../../shared/models/appearance.dart, ../../shared/models/look.dart (+38 more)

### Community 1 - "Customization Studio UI"
Cohesion: 0.05
Nodes (43): ../../core/utils/color_utils.dart, EdgeInsetsGeometry?, ../looks/looks_controller.dart, ../models/apply_state.dart, base, controller, current, _GradientControls (+35 more)

### Community 2 - "Persistence & DI Providers"
Cohesion: 0.05
Nodes (38): dart:convert, ../../features/looks/data/looks_repository.dart, FlutterSecureStorage, package:flutter_secure_storage/flutter_secure_storage.dart, ../persistence/preferences_store.dart, ../persistence/secure_device_store.dart, ../safety/safety_governor.dart, SharedPreferences (+30 more)

### Community 3 - "BLE Command Protocol"
Cohesion: 0.07
Nodes (36): CommandType get, appearance, ApplyLookCommand, color, CommandAck, commandId, CommandType, detail (+28 more)

### Community 4 - "Architecture Decisions & Build"
Cohesion: 0.07
Nodes (36): BleTransport (Phase 3, flutter_blue_plus), ADR 0001 — Isolate BLE behind DeviceTransport interface, FakeTransport (tests), SimulatorTransport, TransportFactory, ADR 0002 — Hand-written models & providers (no build_runner code-gen), ADR 0003 — Build/test verification happens in CI, not locally, ADR 0004 — Local persistence: preferences now, Drift later (+28 more)

### Community 5 - "Appearance & Apply State"
Cohesion: 0.06
Nodes (33): bool get, Map, rgb_color.dart, RgbColor get, AppearanceMode, copyWith, effect, effectSpeed (+25 more)

### Community 6 - "Studio Controller"
Cohesion: 0.07
Nodes (34): ../../core/ble/protocol.dart, ../../core/errors/app_error.dart, ../../core/safety/safety_governor.dart, ../../core/utils/debouncer.dart, ../../shared/models/apply_state.dart, looksRepositoryProvider, safetyGovernorProvider, appearance (+26 more)

### Community 7 - "Simulator Transport"
Cohesion: 0.06
Nodes (34): Random, _ackController, acks, _capabilities, commandLatency, connect, connectionStatus, connectLatency (+26 more)

### Community 8 - "Frame Preview & Zones"
Cohesion: 0.06
Nodes (32): Brightness, CustomPainter, ../models/appearance.dart, ../models/rgb_color.dart, ../models/zone.dart, fromWire, label, resolve (+24 more)

### Community 9 - "Design Tokens"
Cohesion: 0.06
Nodes (33): _, bleControlDebounce, danger, elevationCard, elevationSheet, fog, graphite, mist (+25 more)

### Community 10 - "Device Screen & Providers"
Cohesion: 0.09
Nodes (31): ConsumerWidget, Routes.home, build, deviceControllerProvider, _action, build, _ConnectedBody, DeviceScreen (+23 more)

### Community 11 - "Device Session Wiring"
Cohesion: 0.07
Nodes (28): ../../core/logging/app_logger.dart, ../../core/result/result.dart, _, _bind, build, capabilities, _commandTimeout, connectSimulator (+20 more)

### Community 12 - "Fake Transport (tests)"
Cohesion: 0.07
Nodes (27): package:shade_shifter/core/ble/device_transport.dart, package:shade_shifter/core/result/result.dart, AckStatus, _acks, capabilities, capabilitiesOverride, _caps, connect (+19 more)

### Community 13 - "Device State & Telemetry"
Cohesion: 0.10
Nodes (20): double?, int?, batteryPercent, charging, ConnectionStatus, copyWith, DeviceRef, DeviceTelemetry (+12 more)

### Community 14 - "Device Capabilities"
Cohesion: 0.10
Nodes (19): capabilityVersion, fromJson, hardwareRevision, maxIntensity, protocolVersion, revA, safeDefaultIntensity, supportedEffects (+11 more)

### Community 15 - "Onboarding Screen"
Cohesion: 0.12
Nodes (18): IconData, Routes.pairing, body, build, _controller, count, createState, dispose (+10 more)

### Community 16 - "RGB Color Model"
Cohesion: 0.11
Nodes (17): dart:ui, b, black, fromHex, fromJson, g, _h, hashCode (+9 more)

### Community 17 - "Transport Interface"
Cohesion: 0.12
Nodes (16): ConnectionStatus get, DeviceCapabilities? get, ../result/result.dart, acks, capabilities, connect, connectionStatus, currentStatus (+8 more)

### Community 18 - "Model & Protocol Tests"
Cohesion: 0.15
Nodes (14): fakes/fake_transport.dart, package:shade_shifter/core/ble/command_codec.dart, package:shade_shifter/core/ble/protocol.dart, package:shade_shifter/core/utils/color_utils.dart, package:shade_shifter/shared/models/appearance.dart, package:shade_shifter/shared/models/look.dart, package:shade_shifter/shared/models/rgb_color.dart, package:shade_shifter/shared/models/zone.dart (+6 more)

### Community 19 - "Settings Controller"
Cohesion: 0.12
Nodes (16): Notifier, PreferencesStore get, preferencesStoreProvider, AppSettings, build, completeOnboarding, copyWith, onboardingComplete (+8 more)

### Community 20 - "Look Model"
Cohesion: 0.12
Nodes (15): appearance.dart, DateTime, appearance, builtIn, copyWith, createdAt, deviceCapabilityVersion, favorite (+7 more)

### Community 21 - "Looks Screen"
Cohesion: 0.14
Nodes (14): ../frame_control/studio_controller.dart, List, looks_controller.dart, ../../shared/widgets/frame_preview.dart, LooksController, _apply, caps, _confirmDelete (+6 more)

### Community 22 - "Safety Governor"
Cohesion: 0.13
Nodes (14): ../../shared/models/device_capabilities.dart, adjusted, appearance, clampIntensity, code, kMaxSafeEffectSpeed, message, notices (+6 more)

### Community 23 - "Pairing & Settings UI"
Cohesion: 0.16
Nodes (12): ../../app/theme/design_tokens.dart, ../device/device_controller.dart, settings_controller.dart, ../../shared/widgets/ui_kit.dart, build, _busy, createState, _error (+4 more)

### Community 24 - "Result Type"
Cohesion: 0.14
Nodes (13): AppError? get, ../errors/app_error.dart, R, error, errorOrNull, hashCode, isErr, isOk (+5 more)

### Community 25 - "App Logger"
Cohesion: 0.14
Nodes (13): dart:developer, AppLogger, debug, error, info, _levelValue, _log, LogLevel (+5 more)

### Community 26 - "App Root & Consumers"
Cohesion: 0.18
Nodes (12): ConsumerState, ConsumerStatefulWidget, ../features/settings/settings_controller.dart, package:flutter_riverpod/flutter_riverpod.dart, router/app_router.dart, createState, _router, ShadeShifterApp (+4 more)

### Community 27 - "Widget & Integration Tests"
Cohesion: 0.17
Nodes (11): package:flutter_test/flutter_test.dart, package:integration_test/integration_test.dart, package:shade_shifter/app/app.dart, package:shade_shifter/app/theme/app_theme.dart, package:shade_shifter/core/di/providers.dart, package:shade_shifter/features/frame_control/customize_screen.dart, main, _harness (+3 more)

### Community 28 - "Home Shell"
Cohesion: 0.18
Nodes (11): ../device_health/device_screen.dart, ../frame_control/customize_screen.dart, ../looks/looks_screen.dart, ../settings/settings_screen.dart, build, createState, HomeShell, _HomeShellState (+3 more)

### Community 29 - "App Error Types"
Cohesion: 0.17
Nodes (11): int get, Object?, package:meta/meta.dart, AppErrorKind, cause, code, hashCode, kind (+3 more)

### Community 30 - "BLE Identifiers (UUIDs)"
Cohesion: 0.18
Nodes (12): _, BleIds, charCapabilities, charCommandAck, charCommandWrite, charCurrentState, charDeviceInfo, charFirmwareUpdate (+4 more)

### Community 31 - "Debouncer Utility"
Cohesion: 0.18
Nodes (10): dart:async, Duration, cancel, Debouncer, dispose, duration, isActive, run (+2 more)

### Community 32 - "BLE Contract & Acks"
Cohesion: 0.20
Nodes (11): Capability-driven UI, FakeTransport, CommandAck acknowledgement, BleIds / placeholder UUIDs, GATT services and characteristics, Handshake and version negotiation, DeviceCapabilities (revA profile), GitHub Actions CI pipeline (+3 more)

### Community 33 - "App Router"
Cohesion: 0.20
Nodes (11): ../../features/device_pairing/pairing_screen.dart, ../../features/home/home_shell.dart, ../../features/onboarding/onboarding_screen.dart, ../../features/onboarding/splash_screen.dart, _, buildRouter, home, onboarding (+3 more)

### Community 34 - "Splash Screen"
Cohesion: 0.22
Nodes (9): ../../app/router/app_router.dart, package:go_router/go_router.dart, ../settings/settings_controller.dart, build, createState, initState, SplashScreen, _SplashScreenState (+1 more)

### Community 35 - "MVP Requirements & Looks"
Cohesion: 0.22
Nodes (10): LooksController, SafetyGovernor, StudioController, Local-first storage, shared_preferences, Accessibility requirements, Looks (curated + user), MVP must-have requirements (+2 more)

### Community 36 - "Color Utilities"
Cohesion: 0.22
Nodes (10): ../../../shared/models/rgb_color.dart, _, ColorUtils, contrastRatio, darker, fromHsv, lighter, _mix (+2 more)

### Community 37 - "Permissions & Privacy"
Cohesion: 0.22
Nodes (9): bootstrap_platforms.sh, Contextual runtime permission flow (permission_handler), Android BLE permissions overlay, XOR checksum, iOS Bluetooth usage descriptions, Privacy by design (guest-first), AppLogger.redactId, Sensitive logs threat (+1 more)

### Community 38 - "Transport Seam Architecture"
Cohesion: 0.31
Nodes (9): Feature-first clean architecture, DeviceController, DeviceTransport interface, No code-gen decision, SimulatorTransport, TransportFactory, BleTransport (flutter_blue_plus), flutter_blue_plus (+1 more)

### Community 39 - "BLE Wire Format & Codec"
Cohesion: 0.25
Nodes (9): CommandCodec, Command frame layout, Compact binary wire encoding, Payload fragmentation, Message types, Zone ids, Authentication gap (POC to production), Replay attack mitigation (+1 more)

### Community 40 - "Studio & Persistence Tests"
Cohesion: 0.22
Nodes (8): package:shade_shifter/features/frame_control/studio_controller.dart, package:shade_shifter/features/looks/data/looks_repository.dart, package:shade_shifter/features/looks/looks_controller.dart, _container, green, main, prefs, red

### Community 41 - "Core Result & Models"
Cohesion: 0.36
Nodes (8): @immutable, Exception, AppError, Err, Ok, Result, RgbColor, T

### Community 42 - "Simulator Transport Tests"
Cohesion: 0.25
Nodes (7): dart:math, package:shade_shifter/core/errors/app_error.dart, package:shade_shifter/features/device/device_controller.dart, package:shade_shifter/features/simulator/simulator_transport.dart, _cmd, _fast, main

### Community 43 - "App Bootstrap"
Cohesion: 0.29
Nodes (6): app.dart, ../../core/di/providers.dart, package:flutter/widgets.dart, package:shared_preferences/shared_preferences.dart, bootstrap, prefs

### Community 44 - "Transport Factory"
Cohesion: 0.29
Nodes (6): ../../core/ble/device_transport.dart, ../../shared/models/device_state.dart, ../simulator/simulator_transport.dart, createFor, createSimulator, TransportFactory

### Community 45 - "Theme & Design Tokens"
Cohesion: 0.33
Nodes (7): design_tokens.dart, _, AppTheme, _build, dark, light, _textTheme

### Community 46 - "Safety Governor Tests"
Cohesion: 0.29
Nodes (6): package:shade_shifter/core/safety/safety_governor.dart, package:shade_shifter/shared/models/device_capabilities.dart, package:shade_shifter/shared/models/device_state.dart, caps, governor, main

### Community 47 - "Device Controller"
Cohesion: 0.29
Nodes (7): secureDeviceStoreProvider, connect, DeviceController, DeviceSession, forget, reconnectLast, transportFactoryProvider

### Community 48 - "Command Timing & Safety"
Cohesion: 0.40
Nodes (5): Frame state synchronization flow, 120ms UI debounce, Idempotent commands, Timeouts, retries, idempotency, DoS via command flooding

### Community 49 - "UX Navigation Flows"
Cohesion: 0.40
Nodes (5): Contextual Bluetooth Permission (only at pairing), Home IndexedStack Shell (Customize/Looks/Device/Settings), Navigation Map (4-tab shell), Onboarding Flow (five pages), Pairing Sequence

### Community 50 - "App Entry Point"
Cohesion: 0.50
Nodes (3): app/bootstrap.dart, package:flutter/material.dart, main

### Community 51 - "Frame Preview Strategy"
Cohesion: 0.50
Nodes (4): FramePreview (2D vector frame), FramePreview3D (GLB 3D view), Phase 7 firmware validation checklist, Simulator-first vertical slice

## Knowledge Gaps
- **527 isolated node(s):** `main`, `_router`, `createState`, `prefs`, `bootstrap` (+522 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `_` connect `Device Session Wiring` to `Architecture Decisions & Build`, `Appearance & Apply State`, `Studio Controller`, `Core Result & Models`, `Device Screen & Providers`, `App Bootstrap`, `Transport Factory`, `Device State & Telemetry`, `Device Controller`, `Looks Screen`, `Safety Governor`, `App Root & Consumers`, `Home Shell`, `Debouncer Utility`?**
  _High betweenness centrality (0.173) - this node is a cross-community bridge._
- **Why does `DeviceTransport` connect `Architecture Decisions & Build` to `Transport Interface`, `Device Session Wiring`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._
- **Why does `_` connect `Design Tokens` to `App Bootstrap`, `Safety Governor`?**
  _High betweenness centrality (0.061) - this node is a cross-community bridge._
- **What connects `main`, `_router`, `createState` to the rest of the system?**
  _527 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Looks & Command Codec` be split into smaller, more focused modules?**
  _Cohesion score 0.04336734693877551 - nodes in this community are weakly interconnected._
- **Should `Customization Studio UI` be split into smaller, more focused modules?**
  _Cohesion score 0.05454545454545454 - nodes in this community are weakly interconnected._
- **Should `Persistence & DI Providers` be split into smaller, more focused modules?**
  _Cohesion score 0.0524390243902439 - nodes in this community are weakly interconnected._
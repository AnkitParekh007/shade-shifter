# ADR 0001 — Isolate BLE behind a DeviceTransport interface

- Status: Accepted
- Date: 2026-08-17

## Context
The app must work with no hardware, be testable, and eventually drive a physical
ESP32 frame — without rewriting UI/business logic. BLE libraries are stateful,
platform-specific and awkward to test.

## Decision
All device I/O goes through `core/ble/device_transport.dart` (`DeviceTransport`).
Concrete implementations — `SimulatorTransport`, `FakeTransport` (tests) and the
future `BleTransport` (`flutter_blue_plus`) — are interchangeable and selected by
`TransportFactory`. UI, controllers and models never import a BLE package.

## Consequences
- Simulator-first development and deterministic tests (acceptance #8).
- One integration point to harden for security and reconnection.
- Slight indirection cost; justified by testability + hardware decoupling.

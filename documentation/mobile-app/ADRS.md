# Architecture Decision Records

## ADR-001 — Riverpod and feature-first boundaries
Accepted. Testable dependency injection and explicit state ownership outweigh a small dependency cost.

## ADR-002 — Capability-driven transports
Accepted. Simulator, Rev A, and packet v1 share one domain contract; UI never guesses firmware support.

## ADR-003 — Drift with explicit SQL
Accepted. SQLite provides migrations and deterministic ordering. Explicit schema SQL avoids making source generation a run prerequisite.

## ADR-004 — Native GLB renderer behind an adapter
Accepted. Native Filament/SceneKit enables mesh material overrides. The wrapper and 2D fallback contain package/platform risk.

## ADR-005 — Local-only guest product
Accepted. No backend is required for the product's current value and avoiding one minimizes privacy/security scope.

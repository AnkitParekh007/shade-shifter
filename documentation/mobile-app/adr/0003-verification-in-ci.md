# ADR 0003 — Build/test verification happens in CI, not locally

- Status: Accepted
- Date: 2026-08-17

## Context
The development machine used to author this MVP has **no Flutter/Dart SDK**
installed (Java 17 only). `flutter analyze/test/build` cannot run locally.

## Decision
- Treat **GitHub Actions** (`.github/workflows/mobile-ci.yml`) as the source of
  truth for formatting, static analysis, tests and Android/iOS builds.
- Write analysis-clean, idiomatic code so CI passes on first run.
- Keep native `android/`/`ios/` shells **generated, not committed**
  (`tool/bootstrap_platforms.sh` recreates them + applies our config overlays).
- Never claim a build/analysis acceptance criterion as "verified" from the
  authoring machine — status is `CI-pending` until a green run.

## Consequences
- Also motivates ADR 0002 (no codegen) and the choice to keep an unverifiable
  heavy 3D engine and the physical `BleTransport` out of the compiled tree until
  they can be validated on real hardware/CI.
- The 3D preview ships as a dependable 2D custom-painter; real 3D is a
  documented, isolated replacement.

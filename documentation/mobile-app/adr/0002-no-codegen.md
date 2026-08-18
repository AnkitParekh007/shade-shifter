# ADR 0002 — Hand-written models & providers (no build_runner code-gen)

- Status: Accepted
- Date: 2026-08-17

## Context
The recommended stack lists Freezed, json_serializable and riverpod_generator.
These require running `build_runner` to produce `*.g.dart`/`*.freezed.dart`.

## Decision
Use **hand-written immutable models** (`copyWith`, `==`, `toJson`/`fromJson`) and
**manual Riverpod providers** (`Notifier`/`NotifierProvider`). No code generation
in the POC.

## Rationale
- The authoring environment has no Flutter SDK (ADR 0003), so generated output
  cannot be produced or verified locally. Committing stale generated code is
  worse than not having it; requiring a codegen step in CI adds fragility.
- The model surface is small and stable; hand-written code is readable and fully
  under test.

## Consequences
- Slightly more boilerplate, offset by no codegen toolchain or generated-file
  churn. `*.g.dart`/`*.freezed.dart` are git-ignored as a guard.
- Revisit if the model surface grows materially — migration is mechanical.

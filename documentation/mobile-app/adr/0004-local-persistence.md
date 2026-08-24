# ADR 0004 — Local persistence: preferences now, Drift later

- Status: Accepted
- Date: 2026-08-17

## Context
Looks and the last-applied appearance need local, offline storage. The stack
suggests Drift/Isar; both add build/codegen and native weight.

## Decision
POC persistence uses **`shared_preferences`** (JSON documents for looks + last
applied) and **`flutter_secure_storage`** for the authorized-device reference
(kept out of plain prefs and logs). All access is funnelled through
`PreferencesStore` / `SecureDeviceStore` and `LooksRepository`.

## Rationale
- Small dataset, no relational queries needed yet; avoids codegen (ADR 0002).
- The repository abstraction means the storage engine can change without
  touching controllers or UI.

## Consequences / migration
- When looks grow (sharing, thumbnails, ordering, sync), migrate `LooksRepository`
  to **Drift**: same public methods, JSON import from the existing prefs blob.
- Sensitive data already isolated in secure storage, so the migration touches
  only the non-sensitive document store.

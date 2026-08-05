# Mobile Architecture

The app uses feature-first clean boundaries. Widgets depend on Riverpod controllers and domain models. Controllers depend on `FrameTransport` and repositories. Bluetooth, simulation, Drift, preferences, and the native preview remain data-layer details.

`SelectableTransport` switches between simulator and physical BLE modes. Both publish the same status and capability streams, so screens never branch on plugin types. `DeviceCapabilities` is authoritative for enabling controls.

State flows one way: user gesture → `StudioController` → immediate local preview → debounced transport command → status/acknowledgement stream → UI. Disconnects do not discard the appearance.

ADRs record choices that are expensive to reverse. Platform packages are wrapped so they can be replaced without changing product screens.

# Simulator Guide

Choose **Try simulator** on the connection screen. It models scan and connection delays, complete capabilities, battery, temperature, signal, acknowledgements, and command latency. Simulator status is always labeled and must never be presented as real telemetry.

The simulator implements the same `FrameTransport` contract as BLE, making it suitable for demos, development, and automated tests. Scenario controls can be extended through `SimulatorTransport` without changing screens.

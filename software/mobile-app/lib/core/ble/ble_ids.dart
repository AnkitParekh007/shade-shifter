/// BLE identifiers, organized by hardware profile.
///
/// Two profiles exist:
///  - **Rev-A legacy** — the contract ACTUALLY implemented by the bench firmware
///    (`hardware/blueprint-plan/firmware/shade_shifter_bench.ino`): one service
///    with a single 3-byte RGB "color" characteristic, whole-frame only,
///    brightness fixed in firmware. These UUIDs are AUTHORITATIVE — they match
///    real silicon and must not be changed without a firmware change.
///  - **Packet-v1** — a richer, versioned contract (zones, gradients, effects,
///    acks, telemetry) that the app already models for the simulator. It is
///    PROPOSED and NOT YET in any firmware; these UUIDs are development
///    placeholders to be agreed jointly with firmware.
///
/// See documentation/mobile-app/BLE-PROTOCOL.md and HARDWARE-INTEGRATION.md.
class BleIds {
  const BleIds._();

  /// Advertised device-name prefix used to identify Shade Shifter frames.
  /// Matches the Rev-A firmware's advertised name `ShadeShifter-POC` (and any
  /// future `ShadeShifter-*`). Configurable so branding can change.
  static const String deviceNamePrefix = 'ShadeShifter';

  // ---- Rev-A legacy (AUTHORITATIVE — matches shade_shifter_bench.ino) ----

  /// Vendor service advertised by Rev-A firmware.
  static const String serviceRevA = '7f4a0001-9d45-4d9e-b890-9f132c08a001';

  /// Whole-frame color characteristic (READ | WRITE). Write exactly three bytes
  /// R,G,B; any other length is ignored by firmware. Brightness is applied
  /// firmware-side (fixed safe cap), so it is NOT part of this payload.
  static const String charRevAColor = '7f4a0002-9d45-4d9e-b890-9f132c08a001';

  // ---- Packet-v1 (PROPOSED — not in firmware; dev placeholders) ----
  // Prefix 0x5348534F == "SHSO". Do not treat as final; agree with firmware.
  static const String servicePacketV1 =
      '5348534f-0001-4000-8000-536861646572';
  static const String charDeviceInfo = '5348534f-0002-4000-8000-536861646572';
  static const String charCapabilities =
      '5348534f-0003-4000-8000-536861646572';
  static const String charCommandWrite =
      '5348534f-0004-4000-8000-536861646572';
  static const String charCommandAck = '5348534f-0005-4000-8000-536861646572';
  static const String charCurrentState =
      '5348534f-0006-4000-8000-536861646572';
  static const String charTelemetry = '5348534f-0007-4000-8000-536861646572';
  static const String charFirmwareUpdate =
      '5348534f-0008-4000-8000-536861646572';
}

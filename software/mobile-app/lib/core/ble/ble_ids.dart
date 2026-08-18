/// Configurable development BLE identifiers.
///
/// IMPORTANT: These UUIDs are DEVELOPMENT PLACEHOLDERS and MUST be agreed
/// jointly with firmware before any production build. Do not treat them as
/// final. See documentation/mobile-app/BLE-PROTOCOL.md.
class BleIds {
  const BleIds._();

  /// Advertised device name prefix used to identify Shade Shifter frames.
  /// Configurable so branding / final naming can change without code edits.
  static const String deviceNamePrefix = 'ShadeShifter';

  // 128-bit vendor service/characteristics. Prefix 0x5348534F == "SHSO".
  static const String service = '5348534f-0001-4000-8000-536861646572';

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

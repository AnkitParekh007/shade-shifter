import '../../shared/models/appearance.dart';
import '../../shared/models/device_state.dart';
import '../../shared/models/rgb_color.dart';
import '../../shared/models/zone.dart';

/// Protocol version this client speaks. Negotiated against the device during
/// handshake; a mismatch surfaces as [AppErrorKind.protocolMismatch].
const int kProtocolVersion = 1;

/// Maximum command payload the transport will accept before rejecting as
/// oversized (defensive bound; real MTU is negotiated). See SECURITY-THREAT-MODEL.
const int kMaxPayloadBytes = 512;

/// Command types. `wire` is the message-type byte on the BLE link.
enum CommandType {
  handshake(0x01),
  readCapabilities(0x02),
  readCurrentState(0x03),
  setZoneSolidColor(0x10),
  setZoneGradient(0x11),
  setZoneIntensity(0x12),
  setEffect(0x13),
  applyLook(0x14),
  illuminationOff(0x1F),
  renameDevice(0x20),
  ping(0x30),
  enterFirmwareUpdate(0x40);

  const CommandType(this.wire);
  final int wire;
}

/// Status code returned in an acknowledgement.
enum AckStatus {
  ok(0x00),
  rejectedUnsafe(0x01),
  rejectedUnsupported(0x02),
  malformed(0x03),
  busy(0x04),
  protocolMismatch(0x05);

  const AckStatus(this.wire);
  final int wire;

  bool get isOk => this == AckStatus.ok;
}

/// Correlated acknowledgement for a previously-sent [DeviceCommand].
class CommandAck {
  const CommandAck({
    required this.commandId,
    required this.type,
    required this.status,
    this.telemetry,
    this.detail,
  });

  final int commandId;
  final CommandType type;
  final AckStatus status;

  /// Optional post-apply device state snapshot echoed with the ack.
  final DeviceTelemetry? telemetry;
  final String? detail;
}

/// Base type for high-level commands. The transport assigns [commandId] and a
/// timestamp/sequence at send time and is responsible for wire encoding; the
/// simulator interprets the semantic fields directly. Keeping commands as data
/// (not bytes) here is what lets business logic stay BLE-package-agnostic.
sealed class DeviceCommand {
  const DeviceCommand();
  CommandType get type;

  /// Physical zones this command affects (empty for non-zone commands).
  List<ZoneId> get targets => const [];
}

class HandshakeCommand extends DeviceCommand {
  const HandshakeCommand({this.protocolVersion = kProtocolVersion});
  final int protocolVersion;
  @override
  CommandType get type => CommandType.handshake;
}

class ReadCapabilitiesCommand extends DeviceCommand {
  const ReadCapabilitiesCommand();
  @override
  CommandType get type => CommandType.readCapabilities;
}

class ReadCurrentStateCommand extends DeviceCommand {
  const ReadCurrentStateCommand();
  @override
  CommandType get type => CommandType.readCurrentState;
}

class SetZoneSolidColorCommand extends DeviceCommand {
  const SetZoneSolidColorCommand({
    required this.zone,
    required this.color,
    required this.intensity,
  });
  final ZoneId zone;
  final RgbColor color;
  final double intensity;
  @override
  CommandType get type => CommandType.setZoneSolidColor;
  @override
  List<ZoneId> get targets => [zone];
}

class SetZoneGradientCommand extends DeviceCommand {
  const SetZoneGradientCommand({
    required this.zone,
    required this.start,
    required this.end,
    required this.direction,
    required this.intensity,
  });
  final ZoneId zone;
  final RgbColor start;
  final RgbColor end;
  final GradientDirection direction;
  final double intensity;
  @override
  CommandType get type => CommandType.setZoneGradient;
  @override
  List<ZoneId> get targets => [zone];
}

class SetZoneIntensityCommand extends DeviceCommand {
  const SetZoneIntensityCommand({required this.zone, required this.intensity});
  final ZoneId zone;
  final double intensity;
  @override
  CommandType get type => CommandType.setZoneIntensity;
  @override
  List<ZoneId> get targets => [zone];
}

class SetEffectCommand extends DeviceCommand {
  const SetEffectCommand({
    required this.zone,
    required this.effect,
    required this.speed,
  });
  final ZoneId zone;
  final EffectType effect;
  final double speed;
  @override
  CommandType get type => CommandType.setEffect;
  @override
  List<ZoneId> get targets => [zone];
}

class ApplyLookCommand extends DeviceCommand {
  const ApplyLookCommand(this.appearance);
  final FrameAppearance appearance;
  @override
  CommandType get type => CommandType.applyLook;
  @override
  List<ZoneId> get targets => appearance.zones.keys.toList();
}

class IlluminationOffCommand extends DeviceCommand {
  const IlluminationOffCommand();
  @override
  CommandType get type => CommandType.illuminationOff;
  @override
  List<ZoneId> get targets => ZoneId.values;
}

class RenameDeviceCommand extends DeviceCommand {
  const RenameDeviceCommand(this.name);
  final String name;
  @override
  CommandType get type => CommandType.renameDevice;
}

class PingCommand extends DeviceCommand {
  const PingCommand();
  @override
  CommandType get type => CommandType.ping;
}

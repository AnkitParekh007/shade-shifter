import 'dart:typed_data';

import '../../shared/models/appearance.dart';
import 'protocol.dart';

/// Binary wire codec for the Shade Shifter BLE protocol v1.
///
/// Frame layout (big-endian), see BLE-PROTOCOL.md for the authoritative spec:
///
/// ```
/// off size field
///  0   1   protocolVersion
///  1   1   messageType (CommandType.wire)
///  2   2   commandId          (uint16)
///  4   4   sequence           (uint32, monotonic)
///  8   1   targetZone         (ZoneId.wire, 0x00 = n/a)
///  9   1   payloadLength (L)
/// 10   L   payload
/// 10+L 1   checksum (XOR of all preceding bytes)
/// ```
class CommandCodec {
  const CommandCodec();

  static const int headerLength = 10;

  Uint8List encode(
    DeviceCommand command, {
    required int commandId,
    required int sequence,
  }) {
    final zone = command.targets.isEmpty ? 0x00 : command.targets.first.wire;
    final payload = _payload(command);
    if (payload.length > kMaxPayloadBytes) {
      throw ArgumentError('payload ${payload.length} > $kMaxPayloadBytes');
    }
    final frame = Uint8List(headerLength + payload.length + 1);
    frame[0] = kProtocolVersion;
    frame[1] = command.type.wire;
    frame[2] = (commandId >> 8) & 0xFF;
    frame[3] = commandId & 0xFF;
    frame[4] = (sequence >> 24) & 0xFF;
    frame[5] = (sequence >> 16) & 0xFF;
    frame[6] = (sequence >> 8) & 0xFF;
    frame[7] = sequence & 0xFF;
    frame[8] = zone & 0xFF;
    frame[9] = payload.length & 0xFF;
    frame.setRange(headerLength, headerLength + payload.length, payload);
    frame[frame.length - 1] = _checksum(frame, frame.length - 1);
    return frame;
  }

  List<int> _payload(DeviceCommand command) {
    switch (command) {
      case SetZoneSolidColorCommand(:final color, :final intensity):
        return [color.r, color.g, color.b, _byteFromUnit(intensity)];
      case SetZoneGradientCommand(
          :final start,
          :final end,
          :final direction,
          :final intensity
        ):
        return [
          start.r,
          start.g,
          start.b,
          end.r,
          end.g,
          end.b,
          direction.index,
          _byteFromUnit(intensity),
        ];
      case SetZoneIntensityCommand(:final intensity):
        return [_byteFromUnit(intensity)];
      case SetEffectCommand(:final effect, :final speed):
        return [effect.wire, _byteFromUnit(speed)];
      case HandshakeCommand(:final protocolVersion):
        return [protocolVersion];
      case RenameDeviceCommand(:final name):
        final bytes = utf8Clamp(name, 30);
        return [bytes.length, ...bytes];
      case ApplyLookCommand(:final appearance):
        return _encodeLook(appearance);
      case IlluminationOffCommand():
      case ReadCapabilitiesCommand():
      case ReadCurrentStateCommand():
      case PingCommand():
        return const [];
    }
  }

  List<int> _encodeLook(FrameAppearance appearance) {
    final out = <int>[appearance.zones.length];
    for (final entry in appearance.zones.entries) {
      final a = entry.value;
      final c = a.representativeColor;
      out.addAll([
        entry.key.wire,
        a.mode.index,
        c.r,
        c.g,
        c.b,
        a.effect.wire,
        _byteFromUnit(a.intensity),
      ]);
    }
    return out;
  }

  int _byteFromUnit(double unit) => (unit.clamp(0.0, 1.0) * 255).round();

  int _checksum(Uint8List frame, int end) {
    var xor = 0;
    for (var i = 0; i < end; i++) {
      xor ^= frame[i];
    }
    return xor & 0xFF;
  }

  bool verifyChecksum(Uint8List frame) {
    if (frame.length < headerLength + 1) return false;
    return _checksum(frame, frame.length - 1) == frame[frame.length - 1];
  }

  /// Trims a UTF-8 string to at most [maxBytes] whole code units for the wire.
  static List<int> utf8Clamp(String value, int maxBytes) {
    final bytes = value.codeUnits.where((c) => c < 0x80).take(maxBytes).toList();
    return bytes;
  }
}

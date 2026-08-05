import 'dart:typed_data';

import '../lib/src/device/protocol/shade_protocol.dart';

void main() {
  final payload = Uint8List.fromList([
    0x28,
    0x4B,
    0x63,
    0x9B,
    0x22,
    0x26,
    0x3A,
    0x5A,
    0x40,
    0xE9,
    0xD8,
    0xA6,
    89,
    1,
  ]);
  final packet = ShadePacket(
    sequence: 513,
    command: ShadeCommand.setAppearance,
    flags: 1,
    payload: payload,
  );
  final encoded = ShadePacketCodec.encode(packet);
  final decoded = ShadePacketCodec.decode(encoded);
  _expect(decoded.sequence == packet.sequence, 'sequence round-trip');
  _expect(decoded.command == packet.command, 'command round-trip');
  _expect(decoded.flags == packet.flags, 'flags round-trip');
  _expect(_sameBytes(decoded.payload, payload), 'payload round-trip');

  final damaged = Uint8List.fromList(encoded)..[8] ^= 0x01;
  try {
    ShadePacketCodec.decode(damaged);
    throw StateError('Damaged packets must not decode.');
  } on FormatException catch (error) {
    _expect(error.message == 'CRC mismatch.', 'CRC rejection');
  }

  try {
    ShadePacketCodec.decode(
      Uint8List.fromList([0x53, 2, 0, 0, 0, 0, 0, 0, 0, 0]),
    );
    throw StateError('Unknown protocol versions must not decode.');
  } on FormatException catch (error) {
    _expect(
      error.message.toString().contains('Unsupported protocol version'),
      'version rejection',
    );
  }
}

void _expect(bool condition, String label) {
  if (!condition) throw StateError('Protocol verification failed: $label');
}

bool _sameBytes(Uint8List a, Uint8List b) {
  if (a.length != b.length) return false;
  for (var index = 0; index < a.length; index++) {
    if (a[index] != b[index]) return false;
  }
  return true;
}

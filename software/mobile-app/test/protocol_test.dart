import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/src/device/protocol/shade_protocol.dart';

void main() {
  test('packet v1 round trips with little-endian sequence and CRC', () {
    final encoded = ShadePacketCodec.encode(ShadePacket(
        sequence: 0x1234,
        command: ShadeCommand.setAppearance,
        payload: Uint8List.fromList([1, 2, 3]),
        flags: 4));
    expect(encoded.sublist(0, 8), [0x53, 1, 0x34, 0x12, 0x10, 4, 3, 0]);
    final decoded = ShadePacketCodec.decode(encoded);
    expect(decoded.sequence, 0x1234);
    expect(decoded.payload, [1, 2, 3]);
  });
  test('corrupt packet is rejected', () {
    final bytes = ShadePacketCodec.encode(ShadePacket(
        sequence: 1,
        command: ShadeCommand.requestStatus,
        payload: Uint8List(0)));
    bytes[4] ^= 1;
    expect(() => ShadePacketCodec.decode(bytes), throwsFormatException);
  });
  test('CRC16 matches the Modbus reference vector', () {
    expect(ShadePacketCodec.crc16('123456789'.codeUnits), 0x4b37);
  });
}

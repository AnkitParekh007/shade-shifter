import 'package:flutter_test/flutter_test.dart';
import 'package:shade_shifter/core/ble/command_codec.dart';
import 'package:shade_shifter/core/ble/protocol.dart';
import 'package:shade_shifter/shared/models/rgb_color.dart';
import 'package:shade_shifter/shared/models/zone.dart';

void main() {
  const codec = CommandCodec();

  group('CommandCodec — solid color test vector', () {
    final frame = codec.encode(
      const SetZoneSolidColorCommand(
        zone: ZoneId.front,
        color: RgbColor(124, 92, 255),
        intensity: 0.6,
      ),
      commandId: 1,
      sequence: 1,
    );

    test('header fields are correct', () {
      expect(frame[0], kProtocolVersion);
      expect(frame[1], CommandType.setZoneSolidColor.wire); // 0x10
      expect(frame[2], 0x00); // commandId high
      expect(frame[3], 0x01); // commandId low
      expect(frame[7], 0x01); // sequence low
      expect(frame[8], ZoneId.front.wire); // 0x01
      expect(frame[9], 4); // payload length
    });

    test('payload encodes RGB + intensity byte', () {
      expect(frame.sublist(10, 14), [124, 92, 255, 153]); // 0.6*255 = 153
    });

    test('checksum verifies', () {
      expect(codec.verifyChecksum(frame), isTrue);
    });

    test('corrupting a byte fails checksum', () {
      final corrupted = frame.sublist(0)..[10] = frame[10] ^ 0xFF;
      expect(codec.verifyChecksum(corrupted), isFalse);
    });
  });

  test('gradient command encodes both colors and direction', () {
    final frame = codec.encode(
      const SetZoneGradientCommand(
        zone: ZoneId.leftTemple,
        start: RgbColor(1, 2, 3),
        end: RgbColor(4, 5, 6),
        direction: GradientDirection.diagonal,
        intensity: 1.0,
      ),
      commandId: 2,
      sequence: 2,
    );
    expect(frame[1], CommandType.setZoneGradient.wire);
    expect(frame[8], ZoneId.leftTemple.wire);
    expect(frame.sublist(10, 18),
        [1, 2, 3, 4, 5, 6, GradientDirection.diagonal.index, 255]);
    expect(codec.verifyChecksum(frame), isTrue);
  });

  test('empty-payload commands still frame + checksum', () {
    final frame = codec.encode(const PingCommand(), commandId: 9, sequence: 9);
    expect(frame[9], 0);
    expect(codec.verifyChecksum(frame), isTrue);
  });

  test('rename clamps name to the wire limit', () {
    final frame = codec.encode(
      RenameDeviceCommand('a' * 100),
      commandId: 3,
      sequence: 3,
    );
    expect(codec.verifyChecksum(frame), isTrue);
    // 30-char cap + 1 length byte.
    expect(frame[9], 31);
  });
}

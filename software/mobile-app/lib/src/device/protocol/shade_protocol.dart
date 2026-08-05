import 'dart:typed_data';

abstract final class ShadeProtocol {
  static const magic = 0x53;
  static const version = 1;
  static const headerLength = 8;
  static const checksumLength = 2;
  static const maxPacketLength = 96;
}

enum ShadeCommand {
  setAppearance(0x10),
  requestStatus(0x20),
  status(0x21),
  acknowledgement(0x7E),
  error(0x7F);

  const ShadeCommand(this.code);
  final int code;

  static ShadeCommand fromCode(int code) => values.firstWhere(
    (value) => value.code == code,
    orElse: () =>
        throw FormatException('Unknown command 0x${code.toRadixString(16)}'),
  );
}

class ShadePacket {
  ShadePacket({
    required this.sequence,
    required this.command,
    required Uint8List payload,
    this.flags = 0,
  }) : payload = Uint8List.fromList(payload) {
    if (sequence < 0 || sequence > 0xFFFF) {
      throw RangeError.range(sequence, 0, 0xFFFF, 'sequence');
    }
    if (flags < 0 || flags > 0xFF) {
      throw RangeError.range(flags, 0, 0xFF, 'flags');
    }
    if (payload.length >
        ShadeProtocol.maxPacketLength -
            ShadeProtocol.headerLength -
            ShadeProtocol.checksumLength) {
      throw RangeError('Payload is too large.');
    }
  }

  final int sequence;
  final ShadeCommand command;
  final int flags;
  final Uint8List payload;
}

abstract final class ShadePacketCodec {
  static Uint8List encode(ShadePacket packet) {
    final length =
        ShadeProtocol.headerLength +
        packet.payload.length +
        ShadeProtocol.checksumLength;
    final bytes = Uint8List(length);
    final data = ByteData.sublistView(bytes);
    bytes[0] = ShadeProtocol.magic;
    bytes[1] = ShadeProtocol.version;
    data.setUint16(2, packet.sequence, Endian.little);
    bytes[4] = packet.command.code;
    bytes[5] = packet.flags;
    data.setUint16(6, packet.payload.length, Endian.little);
    bytes.setRange(
      ShadeProtocol.headerLength,
      ShadeProtocol.headerLength + packet.payload.length,
      packet.payload,
    );
    data.setUint16(
      length - 2,
      crc16(bytes.sublist(0, length - 2)),
      Endian.little,
    );
    return bytes;
  }

  static ShadePacket decode(Uint8List bytes) {
    if (bytes.length <
        ShadeProtocol.headerLength + ShadeProtocol.checksumLength) {
      throw const FormatException('Packet is shorter than the minimum frame.');
    }
    if (bytes.length > ShadeProtocol.maxPacketLength) {
      throw const FormatException(
        'Packet exceeds the negotiated maximum length.',
      );
    }
    if (bytes[0] != ShadeProtocol.magic) {
      throw const FormatException('Invalid packet magic.');
    }
    if (bytes[1] != ShadeProtocol.version) {
      throw FormatException('Unsupported protocol version ${bytes[1]}.');
    }
    final data = ByteData.sublistView(bytes);
    final payloadLength = data.getUint16(6, Endian.little);
    final expectedLength =
        ShadeProtocol.headerLength +
        payloadLength +
        ShadeProtocol.checksumLength;
    if (bytes.length != expectedLength) {
      throw const FormatException(
        'Payload length does not match packet length.',
      );
    }
    final expectedCrc = data.getUint16(bytes.length - 2, Endian.little);
    final actualCrc = crc16(bytes.sublist(0, bytes.length - 2));
    if (actualCrc != expectedCrc) {
      throw const FormatException('CRC mismatch.');
    }
    return ShadePacket(
      sequence: data.getUint16(2, Endian.little),
      command: ShadeCommand.fromCode(bytes[4]),
      flags: bytes[5],
      payload: Uint8List.fromList(
        bytes.sublist(ShadeProtocol.headerLength, bytes.length - 2),
      ),
    );
  }

  static int crc16(List<int> bytes) {
    var crc = 0xFFFF;
    for (final byte in bytes) {
      crc ^= byte;
      for (var bit = 0; bit < 8; bit++) {
        crc = (crc & 1) == 1 ? (crc >> 1) ^ 0xA001 : crc >> 1;
      }
    }
    return crc & 0xFFFF;
  }
}

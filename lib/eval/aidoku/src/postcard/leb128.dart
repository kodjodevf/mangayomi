import 'dart:typed_data';

/// Encodes a signed 32-bit integer to ZigZag format.
int encodeZigZag32(int value) {
  return ((value << 1) ^ (value >> 31)) & 0xFFFFFFFF;
}

/// Decodes a ZigZag-encoded 32-bit integer.
int decodeZigZag32(int value) {
  final int unsigned = value & 0xFFFFFFFF;
  return ((unsigned >> 1) ^ -(unsigned & 1)).toSigned(32);
}

/// Encodes a signed 64-bit integer to ZigZag format.
int encodeZigZag64(int value) {
  return ((value << 1) ^ (value >> 63));
}

/// Decodes a ZigZag-encoded 64-bit integer.
int decodeZigZag64(int value) {
  return ((value >> 1) ^ -(value & 1)).toSigned(64);
}

/// Writes an unsigned LEB128 varint into a [BytesBuilder].
void writeVarUint(BytesBuilder builder, int value) {
  var v = value;
  while (v >= 0x80) {
    builder.addByte((v & 0x7F) | 0x80);
    v >>= 7;
  }
  builder.addByte(v & 0x7F);
}

/// Reads an unsigned LEB128 varint from [data] starting at [offset],
/// returns a record with the decoded value and the new offset.
({int value, int newOffset}) readVarUint(Uint8List data, int offset) {
  var result = 0;
  var shift = 0;
  var curr = offset;

  while (curr < data.length) {
    final byte = data[curr++];
    result |= (byte & 0x7F) << shift;
    if ((byte & 0x80) == 0) {
      return (value: result, newOffset: curr);
    }
    shift += 7;
    if (shift >= 64) {
      throw FormatException('LEB128 varint overflow at offset $curr');
    }
  }
  throw RangeError('Unexpected end of buffer while reading LEB128 at offset $offset');
}

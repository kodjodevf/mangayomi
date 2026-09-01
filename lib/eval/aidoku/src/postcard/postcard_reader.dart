import 'dart:convert';
import 'dart:typed_data';

import 'leb128.dart';

/// Postcard binary deserializer reader.
class PostcardReader {
  PostcardReader(Uint8List data, [this.offset = 0])
    : data = data,
      _byteData = ByteData.sublistView(data);

  final Uint8List data;
  final ByteData _byteData;
  int offset;

  bool get hasRemaining => offset < data.length;
  int get remaining => data.length - offset;

  void _checkAvailable(int count) {
    if (offset + count > data.length) {
      throw RangeError(
        'Buffer underrun: need $count bytes, but only $remaining remaining at offset $offset',
      );
    }
  }

  bool readBool() {
    _checkAvailable(1);
    return data[offset++] != 0;
  }

  int readU8() {
    _checkAvailable(1);
    return data[offset++];
  }

  int readI8() {
    _checkAvailable(1);
    return _byteData.getInt8(offset++);
  }

  /// Reads an unsigned LEB128 varint, advancing [offset] in place.
  ///
  /// Postcard integers are the single most frequently decoded value in this
  /// format (every list/string/map length and every u16/u32/u64/i16/i32/i64
  /// field goes through this path), so this avoids the record allocation
  /// that a `readVarUint(data, offset)` call/return would otherwise incur
  /// on every single integer decoded.
  int _readVarUint() {
    var result = 0;
    var shift = 0;
    while (offset < data.length) {
      final byte = data[offset++];
      result |= (byte & 0x7F) << shift;
      if ((byte & 0x80) == 0) return result;
      shift += 7;
      if (shift >= 64) {
        throw FormatException('LEB128 varint overflow at offset $offset');
      }
    }
    throw RangeError(
      'Unexpected end of buffer while reading LEB128 at offset $offset',
    );
  }

  int readU16() => _readVarUint() & 0xFFFF;

  int readI16() => decodeZigZag32(_readVarUint()).toSigned(16);

  int readU32() => _readVarUint() & 0xFFFFFFFF;

  int readI32() => decodeZigZag32(_readVarUint());

  int readU64() => _readVarUint();

  int readI64() => decodeZigZag64(_readVarUint());

  double readF32() {
    _checkAvailable(4);
    final val = _byteData.getFloat32(offset, Endian.little);
    offset += 4;
    return val;
  }

  double readF64() {
    _checkAvailable(8);
    final val = _byteData.getFloat64(offset, Endian.little);
    offset += 8;
    return val;
  }

  String readString() {
    final len = readU64();
    if (len == 0) return '';
    _checkAvailable(len);
    final str = utf8.decode(data.sublist(offset, offset + len));
    offset += len;
    return str;
  }

  Uint8List readBytes() {
    final len = readU64();
    if (len == 0) return Uint8List(0);
    _checkAvailable(len);
    final bytes = Uint8List.fromList(data.sublist(offset, offset + len));
    offset += len;
    return bytes;
  }

  T? readOption<T>(T Function(PostcardReader reader) readFn) {
    _checkAvailable(1);
    final tag = data[offset++];
    if (tag == 0) {
      return null;
    } else if (tag == 1) {
      return readFn(this);
    } else {
      throw FormatException(
        'Invalid option discriminant $tag at offset ${offset - 1}',
      );
    }
  }

  List<T> readList<T>(T Function(PostcardReader reader) readItem) {
    final count = readU64();
    final list = <T>[];
    for (var i = 0; i < count; i++) {
      list.add(readItem(this));
    }
    return list;
  }

  Map<K, V> readMap<K, V>(
    K Function(PostcardReader reader) readKey,
    V Function(PostcardReader reader) readValue,
  ) {
    final count = readU64();
    final map = <K, V>{};
    for (var i = 0; i < count; i++) {
      final k = readKey(this);
      final v = readValue(this);
      map[k] = v;
    }
    return map;
  }
}

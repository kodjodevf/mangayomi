import 'dart:convert';
import 'dart:typed_data';

import 'leb128.dart';

/// Postcard binary serializer writer.
class PostcardWriter {
  PostcardWriter() : _builder = BytesBuilder();

  final BytesBuilder _builder;

  void writeBool(bool value) {
    _builder.addByte(value ? 1 : 0);
  }

  void writeU8(int value) {
    _builder.addByte(value & 0xFF);
  }

  void writeI8(int value) {
    _builder.addByte(value.toSigned(8) & 0xFF);
  }

  void writeU16(int value) {
    writeVarUint(_builder, value & 0xFFFF);
  }

  void writeI16(int value) {
    writeVarUint(_builder, encodeZigZag32(value.toSigned(16)));
  }

  void writeU32(int value) {
    writeVarUint(_builder, value & 0xFFFFFFFF);
  }

  void writeI32(int value) {
    writeVarUint(_builder, encodeZigZag32(value.toSigned(32)));
  }

  void writeU64(int value) {
    writeVarUint(_builder, value);
  }

  void writeI64(int value) {
    writeVarUint(_builder, encodeZigZag64(value.toSigned(64)));
  }

  void writeF32(double value) {
    final byteData = ByteData(4)..setFloat32(0, value, Endian.little);
    _builder.add(byteData.buffer.asUint8List());
  }

  void writeF64(double value) {
    final byteData = ByteData(8)..setFloat64(0, value, Endian.little);
    _builder.add(byteData.buffer.asUint8List());
  }

  void writeString(String value) {
    final bytes = utf8.encode(value);
    writeU64(bytes.length);
    _builder.add(bytes);
  }

  void writeBytes(Uint8List value) {
    writeU64(value.length);
    _builder.add(value);
  }

  void writeOption<T>(
    T? value,
    void Function(PostcardWriter writer, T item) writeItem,
  ) {
    if (value == null) {
      writeU8(0);
    } else {
      writeU8(1);
      writeItem(this, value);
    }
  }

  void writeList<T>(
    List<T> list,
    void Function(PostcardWriter writer, T item) writeItem,
  ) {
    writeU64(list.length);
    for (final item in list) {
      writeItem(this, item);
    }
  }

  void writeMap<K, V>(
    Map<K, V> map,
    void Function(PostcardWriter writer, K key) writeKey,
    void Function(PostcardWriter writer, V value) writeValue,
  ) {
    writeU64(map.length);
    for (final entry in map.entries) {
      writeKey(this, entry.key);
      writeValue(this, entry.value);
    }
  }

  Uint8List toBytes() => _builder.toBytes();
}

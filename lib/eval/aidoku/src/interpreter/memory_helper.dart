import 'dart:convert';
import 'dart:typed_data';

import 'package:wasd/wasd.dart';

/// Helper for reading and writing data within a WebAssembly linear [Memory].
class MemoryHelper {
  MemoryHelper(this.getMemory);

  final Memory Function() getMemory;

  ByteBuffer? _cachedBuffer;
  Uint8List? _cachedBytes;
  ByteData? _cachedByteData;

  /// Returns the current linear memory buffer, refreshing the cached
  /// [Uint8List]/[ByteData] views only when the underlying buffer instance
  /// has actually changed (e.g. after `memory.grow`). WASM memory access is
  /// extremely hot (every host import call touches it), so re-wrapping the
  /// buffer on every single read/write is avoided.
  ByteBuffer get buffer => _refresh();
  Uint8List get bytes {
    _refresh();
    return _cachedBytes!;
  }

  ByteData get byteData {
    _refresh();
    return _cachedByteData!;
  }

  ByteBuffer _refresh() {
    final current = getMemory().buffer;
    if (!identical(current, _cachedBuffer)) {
      _cachedBuffer = current;
      _cachedBytes = Uint8List.view(current);
      _cachedByteData = ByteData.view(current);
    }
    return current;
  }

  String readString(int offset, int length) {
    if (offset < 0 || length <= 0) return '';
    if (offset + length > buffer.lengthInBytes) {
      throw RangeError(
        'Memory out of bounds: reading $length bytes at $offset (buffer size: ${buffer.lengthInBytes})',
      );
    }
    final sub = Uint8List.view(buffer, offset, length);
    return utf8.decode(sub);
  }

  Uint8List readBytes(int offset, int length) {
    if (offset < 0 || length <= 0) return Uint8List(0);
    if (offset + length > buffer.lengthInBytes) {
      throw RangeError(
        'Memory out of bounds: reading $length bytes at $offset (buffer size: ${buffer.lengthInBytes})',
      );
    }
    return Uint8List.fromList(Uint8List.view(buffer, offset, length));
  }

  int readUint32(int offset) {
    return byteData.getUint32(offset, Endian.little);
  }

  int readInt32(int offset) {
    return byteData.getInt32(offset, Endian.little);
  }

  void writeBytes(int offset, List<int> data) {
    if (offset < 0 || offset + data.length > buffer.lengthInBytes) {
      throw RangeError(
        'Memory out of bounds: writing ${data.length} bytes at $offset (buffer size: ${buffer.lengthInBytes})',
      );
    }
    Uint8List.view(buffer, offset, data.length).setAll(0, data);
  }

  void writeUint32(int offset, int value) {
    byteData.setUint32(offset, value, Endian.little);
  }

  void writeInt32(int offset, int value) {
    byteData.setInt32(offset, value, Endian.little);
  }
}

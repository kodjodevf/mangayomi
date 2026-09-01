import 'dart:typed_data';

/// Manages host objects passed to and referenced by WebAssembly modules via integer descriptors.
class GlobalStore {
  final Map<int, Object> _storage = {};
  int _pointer = 1;

  int store(Object item) {
    final descriptor = _pointer;
    _storage[descriptor] = item;
    _pointer++;
    return descriptor;
  }

  Object? fetch(int descriptor) {
    return _storage[descriptor];
  }

  void set(int descriptor, Object item) {
    _storage[descriptor] = item;
  }

  void remove(int descriptor) {
    _storage.remove(descriptor);
    if (_storage.isEmpty) {
      _pointer = 1;
    }
  }

  Uint8List? fetchImage(int descriptor) {
    final res = fetch(descriptor);
    if (res is Uint8List) {
      return res;
    }
    return null;
  }

  void clear() {
    _storage.clear();
    _pointer = 1;
  }
}

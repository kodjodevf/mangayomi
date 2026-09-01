import 'dart:typed_data';

import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
import '../store/global_store.dart';
import '../store/settings_store.dart';

enum DefaultKind {
  data(0),
  boolVal(1),
  intVal(2),
  floatVal(3),
  string(4),
  stringArray(5),
  nullVal(6);

  const DefaultKind(this.value);
  final int value;

  static DefaultKind fromValue(int val) {
    for (final k in values) {
      if (k.value == val) return k;
    }
    return DefaultKind.nullVal;
  }
}

class DefaultsImports {
  DefaultsImports({
    required this.store,
    required this.memoryHelper,
    required this.defaultNamespace,
  });

  final GlobalStore store;
  final MemoryHelper memoryHelper;
  final String defaultNamespace;

  static const namespace = 'defaults';

  ModuleImports build() {
    return {
      'get': ImportExportKind.function((args) {
        final keyPointer = (args[0] as num).toInt();
        final length = (args[1] as num).toInt();
        return get(keyPointer, length);
      }),
      'set': ImportExportKind.function((args) {
        final keyPointer = (args[0] as num).toInt();
        final length = (args[1] as num).toInt();
        final valueKind = (args[2] as num).toInt();
        final valuePointer = (args[3] as num).toInt();
        return set(keyPointer, length, valueKind, valuePointer);
      }),
    };
  }

  int get(int keyPointer, int length) {
    if (keyPointer < 0 || length < 0) return -1; // invalidKey
    try {
      final key = memoryHelper.readString(keyPointer, length);
      final obj = SettingsStore.shared.object('$defaultNamespace.$key') ??
          SettingsStore.shared.object(key);
      // print('[Defaults.get] $defaultNamespace.$key / $key -> $obj');
      if (obj == null) return -2; // invalidValue

      final writer = PostcardWriter();
      if (obj is bool) {
        writer.writeBool(obj);
      } else if (obj is int) {
        writer.writeI32(obj);
      } else if (obj is double) {
        writer.writeF32(obj);
      } else if (obj is String) {
        writer.writeString(obj);
      } else if (obj is List<String>) {
        writer.writeList(obj, (w, s) => w.writeString(s));
      } else if (obj is Uint8List) {
        return store.store(obj);
      } else {
        return -2;
      }
      return store.store(writer.toBytes());
    } catch (_) {
      return -3; // failedEncoding
    }
  }

  int set(int keyPointer, int length, int valueKind, int valuePointer) {
    if (keyPointer < 0 || length < 0) return -1;
    try {
      final key = memoryHelper.readString(keyPointer, length);
      final kind = DefaultKind.fromValue(valueKind);

      Uint8List getData() {
        final len = memoryHelper.readUint32(valuePointer);
        return memoryHelper.readBytes(valuePointer + 8, len - 8);
      }

      Object? obj;
      switch (kind) {
        case DefaultKind.data:
          obj = getData();
          break;
        case DefaultKind.boolVal:
          obj = PostcardReader(getData()).readBool();
          break;
        case DefaultKind.intVal:
          obj = PostcardReader(getData()).readI32();
          break;
        case DefaultKind.floatVal:
          obj = PostcardReader(getData()).readF32();
          break;
        case DefaultKind.string:
          obj = PostcardReader(getData()).readString();
          break;
        case DefaultKind.stringArray:
          obj = PostcardReader(getData()).readList((r) => r.readString());
          break;
        case DefaultKind.nullVal:
          obj = null;
          break;
      }

      SettingsStore.shared.setValue('$defaultNamespace.$key', obj);
      return 0; // success
    } catch (_) {
      return -4; // failedDecoding
    }
  }
}

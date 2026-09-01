import 'dart:async';
import 'dart:typed_data';

import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';

class EnvImports {
  EnvImports({
    required this.memoryHelper,
    this.printHandler,
    this.partialResultHandler,
  });

  final MemoryHelper memoryHelper;
  final void Function(String message)? printHandler;
  final void Function(Uint8List data)? partialResultHandler;

  static const namespace = 'env';

  ModuleImports build() {
    return {
      'abort': ImportExportKind.function((args) {
        return null;
      }),
      'print': ImportExportKind.function((args) {
        final offset = (args[0] as num).toInt();
        final length = (args[1] as num).toInt();
        envPrint(offset, length);
        return null;
      }),
      'sleep': ImportExportKind.function((args) async {
        final seconds = (args[0] as num).toInt();
        await Future.delayed(Duration(seconds: seconds));
        return null;
      }),
      'send_partial_result': ImportExportKind.function((args) {
        final valuePointer = (args[0] as num).toInt();
        sendPartialResult(valuePointer);
        return null;
      }),
    };
  }

  void envPrint(int offset, int length) {
    if (offset < 0 || length < 0) return;
    final str = memoryHelper.readString(offset, length);
    if (printHandler != null) {
      printHandler!(str);
    } else {
      // ignore: avoid_print
      print('[Aidoku Wasm] $str');
    }
  }

  void sendPartialResult(int valuePointer) {
    if (valuePointer < 0) return;
    try {
      final length = memoryHelper.readUint32(valuePointer);
      final data = memoryHelper.readBytes(valuePointer + 8, length - 8);
      partialResultHandler?.call(data);
    } catch (_) {}
  }
}

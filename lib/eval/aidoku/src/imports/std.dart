import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:wasd/wasd.dart';

import '../interpreter/memory_helper.dart';
import '../store/global_store.dart';

class StdImports {
  StdImports({
    required this.store,
    required this.memoryHelper,
    this.printHandler,
  });

  final GlobalStore store;
  final MemoryHelper memoryHelper;
  final void Function(String message)? printHandler;

  static const namespace = 'std';

  ModuleImports build() {
    return {
      'destroy': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        destroy(descriptor);
        return null;
      }),
      'buffer_len': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        return bufferLength(descriptor);
      }),
      'read_buffer': ImportExportKind.function((args) {
        final descriptor = (args[0] as num).toInt();
        final buffer = (args[1] as num).toInt();
        final size = (args[2] as num).toInt();
        return readBuffer(descriptor, buffer, size);
      }),
      'current_date': ImportExportKind.function((args) {
        return currentDate();
      }),
      'utc_offset': ImportExportKind.function((args) {
        return utcOffset();
      }),
      'parse_date': ImportExportKind.function((args) {
        final stringPtr = (args[0] as num).toInt();
        final stringLength = (args[1] as num).toInt();
        final formatPtr = (args[2] as num).toInt();
        final formatLength = (args[3] as num).toInt();
        final localePtr = (args[4] as num).toInt();
        final localeLength = (args[5] as num).toInt();
        final timeZonePtr = (args[6] as num).toInt();
        final timeZoneLength = (args[7] as num).toInt();
        return parseDate(
          stringPtr,
          stringLength,
          formatPtr,
          formatLength,
          localePtr,
          localeLength,
          timeZonePtr,
          timeZoneLength,
        );
      }),
      'print': ImportExportKind.function((args) {
        final offset = (args[0] as num).toInt();
        final length = (args[1] as num).toInt();
        if (offset >= 0 && length >= 0) {
          final str = memoryHelper.readString(offset, length);
          printHandler?.call(str);
        }
        return null;
      }),
      'abort': ImportExportKind.function((args) => null),
      'sleep': ImportExportKind.function((args) async {
        final seconds = (args[0] as num).toInt();
        await Future.delayed(Duration(seconds: seconds));
        return null;
      }),
      'send_partial_result': ImportExportKind.function((args) => null),
    };
  }

  void destroy(int descriptor) {
    store.remove(descriptor);
  }

  Uint8List? _getBytes(int descriptor) {
    final item = store.fetch(descriptor);
    if (item is Uint8List) {
      return item;
    } else if (item is List<int>) {
      return Uint8List.fromList(item);
    } else if (item is String) {
      return utf8.encode(item);
    }
    return null;
  }

  int bufferLength(int descriptor) {
    final data = _getBytes(descriptor);
    if (data == null) return -1; // invalidDescriptor
    return data.length;
  }

  int readBuffer(int descriptor, int buffer, int size) {
    final data = _getBytes(descriptor);
    if (data == null) return -1; // invalidDescriptor
    if (size > data.length) return -2; // invalidBufferSize
    try {
      memoryHelper.writeBytes(buffer, data.sublist(0, size));
      return 0; // success
    } catch (_) {
      return -3; // failedMemoryWrite
    }
  }

  double currentDate() {
    return DateTime.now().toUtc().millisecondsSinceEpoch / 1000.0;
  }

  int utcOffset() {
    return -DateTime.now().timeZoneOffset.inSeconds;
  }

  double parseDate(
    int stringPtr,
    int stringLength,
    int formatPtr,
    int formatLength,
    int localePtr,
    int localeLength,
    int timeZonePtr,
    int timeZoneLength,
  ) {
    try {
      final string = memoryHelper.readString(stringPtr, stringLength);
      final format = memoryHelper.readString(formatPtr, formatLength);
      final locale = localeLength > 0 ? memoryHelper.readString(localePtr, localeLength) : null;

      final formatter = locale != null && locale != 'current'
          ? DateFormat(format, locale)
          : DateFormat(format);

      final date = formatter.parse(string, true);
      return date.millisecondsSinceEpoch / 1000.0;
    } catch (_) {
      return -5.0; // invalidDateString
    }
  }
}

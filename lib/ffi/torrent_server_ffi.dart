import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'generated_bindings.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
Future<int> start(String mcfg) async {
  var completer = Completer<int>();
  var res = _bindings.Start(mcfg.toNativeUtf8().cast());
  if (res.r1 != nullptr) {
    completer.completeError(Exception(res.r1.cast<Utf8>().toDartString()));
  } else {
    completer.complete(res.r0);
  }
  return completer.future;
}

const String _libName = 'libmtorrentserver';

/// The dynamic library in which the symbols for [NativeAddBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS) {
    return DynamicLibrary.open('$_libName.dylib');
  }
  if (Platform.isLinux) {
    return DynamicLibrary.open('$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final TorrentLibrary _bindings = TorrentLibrary(_dylib);

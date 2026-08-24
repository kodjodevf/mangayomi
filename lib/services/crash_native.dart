import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:mangayomi/services/crash_report.dart';
import 'package:path/path.dart' as p;

/// The crashes Dart cannot see.
///
/// [CrashReports] catches everything Dart throws, which is everything except
/// the crashes that matter most. A SIGSEGV kills the process outright, so none
/// of the three Dart handlers run, nothing reaches logs.txt, and the reader is
/// left saying the app "just closes" with nothing to send. Issue #902 is that:
/// a segfault during playback that left no trace anywhere in the app.
///
/// The handler itself lives in the Rust library the app already links, because
/// a signal handler has to be native. It writes one short line and re-raises,
/// so the process still dies exactly as it would have. This side installs it,
/// keeps it told where the reader is, and turns whatever it left into a report
/// on the next launch.
class NativeCrashHandler {
  NativeCrashHandler._();

  static const _fileName = 'native_crash.txt';
  static File? _file;

  /// Installs the handler and reports anything the last run left behind.
  ///
  /// Does nothing on a platform without the symbol, which is any build where
  /// the Rust library is missing and Windows, where sigaction does not exist.
  static Future<void> init(Directory? directory) async {
    if (directory == null) return;
    _file = File(p.join(directory.path, _fileName));

    await _reportPreviousCrash();

    final install = _installFn();
    if (install == null) return;
    final path = _file!.path.toNativeUtf8();
    try {
      if (install(path.cast()) == 0) return;
    } finally {
      malloc.free(path);
    }
    // Something to say before the first navigation. Without this a crash
    // during startup reports no screen at all, which is the case where knowing
    // the screen would help most.
    setContext('startup');
  }

  /// Tells the handler where the reader is, so a crash says so.
  static void setContext(String context) {
    final set = _contextFn();
    if (set == null) return;
    final native = context.toNativeUtf8();
    try {
      set(native.cast());
    } finally {
      malloc.free(native);
    }
  }

  /// Reads what the handler left, records it, and clears it.
  ///
  /// Clearing matters: the file outlives the process that wrote it, so leaving
  /// it would re-report the same crash on every launch forever.
  static Future<void> _reportPreviousCrash() async {
    final file = _file;
    if (file == null) return;
    try {
      if (!await file.exists()) return;
      final contents = (await file.readAsString()).trim();
      await file.delete();
      if (contents.isEmpty) return;

      final lines = contents.split('\n');
      final signal = lines.first.trim();
      final screen = lines.length > 1 ? lines[1].trim() : null;
      CrashReports.record(
        source: 'native',
        error:
            'The app was stopped by the operating system ($signal). '
            'This is a native crash, so there is no Dart stack for it.',
        screen: screen == null || screen.isEmpty ? null : screen,
      );
    } catch (_) {
      // A crash reporter that throws while reporting a crash is worse than one
      // that reports nothing.
    }
  }

  /// The Rust library is already loaded by the time this runs, and is
  /// statically linked into the executable on iOS, so looking in the process
  /// finds it either way without needing a file name per platform. Returns
  /// null when the symbol is absent, which is any build without the Rust
  /// library and Windows, where sigaction does not exist.
  static _InstallDart? _installFn() {
    try {
      return DynamicLibrary.process()
          .lookupFunction<_InstallNative, _InstallDart>(
            'mangayomi_install_crash_handler',
          );
    } catch (_) {
      return null;
    }
  }

  static _ContextDart? _contextFn() {
    try {
      return DynamicLibrary.process()
          .lookupFunction<_ContextNative, _ContextDart>(
            'mangayomi_set_crash_context',
          );
    } catch (_) {
      return null;
    }
  }
}

typedef _InstallNative = Int32 Function(Pointer<Utf8>);
typedef _InstallDart = int Function(Pointer<Utf8>);
typedef _ContextNative = Void Function(Pointer<Utf8>);
typedef _ContextDart = void Function(Pointer<Utf8>);

/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:ffi';

/// NativeLibrary
/// -------------
///
/// This class is used to discover & load the libmpv shared library.
/// It is generally present with the name `libmpv-2.dll` on Windows & `libmpv.so` on GNU/Linux.
///
abstract class NativeLibrary {
  /// The resolved libmpv dynamic library.
  static String get path {
    if (_resolved == null) {
      throw Exception(
        'MediaKit.ensureInitialized must be called before using any API from package:media_kit.',
      );
    }
    return _resolved!;
  }

  /// Initializes the |NativeLibrary| class for usage.
  /// This method discovers & loads the libmpv shared library. It is generally present with the name `libmpv-2.dll` on Windows & `libmpv.so` on GNU/Linux.
  /// The [libmpv] parameter can be used to manually specify the path to the libmpv shared library.
  static void ensureInitialized({String? libmpv}) {
    // Attempt to load [libmpv] argument.
    if (libmpv != null) {
      DynamicLibrary.open(libmpv);
      _resolved = libmpv;
      return;
    }
    // Attempt to load [LIBMPV_LIBRARY_PATH] environment variable.
    try {
      final env = Platform.environment['LIBMPV_LIBRARY_PATH'];
      if (env != null) {
        DynamicLibrary.open(env);
        _resolved = env;
        return;
      }
    } catch (_) {}
    // Attempt to load default names.
    final names = {
      'windows': [
        'libmpv-2.dll',
        'mpv-2.dll',
        'mpv-1.dll',
      ],
      'linux': [
        'libmpv.so',
        'libmpv.so.2',
        'libmpv.so.1',
      ],
      'macos': [
        'Mpv.framework/Mpv',
      ],
      'ios': [
        'Mpv.framework/Mpv',
      ],
      'android': [
        'libmpv.so',
      ],
    }[Platform.operatingSystem];
    if (names != null) {
      // Try to load the dynamic library from the system using [DynamicLibrary.open].
      for (final name in names) {
        try {
          DynamicLibrary.open(name);
          _resolved = name;
          return;
        } catch (_) {}
      }
      // If the dynamic library is not loaded, throw an [Exception].
      if (_resolved == null) {
        throw Exception(
          {
            'windows':
                'Cannot find libmpv-2.dll in your system %PATH%. One way to deal with this is to ship libmpv-2.dll with your compiled executable or script in the same directory.',
            'linux':
                'Cannot find libmpv at the usual places. Depending upon your distribution, you can install the libmpv package to make shared library available globally. On Debian or Ubuntu based systems, you can install it with: apt install libmpv-dev.',
            'macos':
                'Cannot find Mpv.framework/Mpv. Please ensure it\'s presence in the Frameworks folder of the application.',
            'ios':
                'Cannot find Mpv.framework/Mpv. Please ensure it\'s presence in the Frameworks folder of the application.',
            'android':
                'Cannot find libmpv.so. Please ensure it\'s presence in the APK.',
          }[Platform.operatingSystem]!,
        );
      }
    } else {
      throw Exception(
        'Unsupported operating system: ${Platform.operatingSystem}',
      );
    }
  }

  /// The resolved libmpv dynamic library.
  ///
  /// **NOTE:** We are storing this value as [String] because we want to share this across [Isolate]s.
  static String? _resolved;
}

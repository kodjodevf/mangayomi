/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'package:media_kit/src/player/native/utils/android_helper.dart';

/// {@template temp_file}
/// TempFile
/// --------
/// A simple class to create temporary files.
/// {@endtemplate}
abstract class TempFile {
  /// Creates a temporary file & returns it.
  static Future<File> create() async {
    String? directory;
    if (Platform.isWindows) {
      directory = Directory.systemTemp.path;
    } else if (Platform.isLinux) {
      directory = Directory.systemTemp.path;
    } else if (Platform.isMacOS) {
      directory = Directory.systemTemp.path;
    } else if (Platform.isIOS) {
      directory = Directory.systemTemp.path;
    } else if (Platform.isAndroid) {
      directory = AndroidHelper.filesDir;
    }
    if (directory == null) {
      throw UnsupportedError('[TempFile.create] is unsupported');
    }
    final file = File(join(directory, Uuid().v4()));
    await file.create();
    return file;
  }
}

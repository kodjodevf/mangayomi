/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
import 'dart:io';
import 'package:uri_parser/uri_parser.dart';
import 'package:safe_local_storage/safe_local_storage.dart';

/// libmpv doesn't seem to read the bitrate from the files which contain bitrate in their stream metadata (not file metadata).
/// Typically, I've seen this happening with FLAC & OGG files, since they do not offer the bitrate as a metadata / attached-tags key.
///
/// Adding this helper class to calculate the bitrate of the FLAC & OGG files manually. Considering FLAC is a lossless format, this approximation should be fine.
/// At-least better than the one in libmpv, because it calculates the bitrate from the loaded stream currently in-memory & updates it dynamically as playback progresses.
abstract class FallbackBitrateHandler {
  static bool supported(String uri) => extractFilePath(uri) != null;

  static String? extractFilePath(String uri) {
    try {
      // Handle local [File] paths.
      final parser = URIParser(uri);
      switch (parser.type) {
        case URIType.file:
          {
            if (['OGG', 'FLAC'].contains(parser.file!.extension)) {
              return parser.file!.path;
            }
            return null;
          }
        // No support for other URI types.
        default:
          {
            return null;
          }
      }
    } catch (exception) {
      return null;
    }
  }

  static Future<double> calculateBitrate(String uri, Duration duration) async {
    try {
      final resource = extractFilePath(uri);
      if (resource != null) {
        final file = File(resource);
        final size = await file.length_();
        final result = size * 8 / duration.inSeconds;
        return result;
      }
      return 0;
    } catch (exception) {
      return 0;
    }
  }
}

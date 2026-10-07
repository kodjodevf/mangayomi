import 'dart:io';

import 'package:media_kit/media_kit.dart';

/// Creates media without allowing media_kit's URI parser to reinterpret a
/// local file path.
///
/// In particular, a Windows UNC path such as `\\server\share` must retain
/// its host component so libmpv can open it.
Media playbackMedia(
  String resource, {
  required bool isLocal,
  Map<String, String>? httpHeaders,
  Duration? start,
  bool? windows,
}) {
  if (!isLocal) {
    return Media(resource, httpHeaders: httpHeaders, start: start);
  }

  return Media(
    localFileUri(resource, windows: windows ?? Platform.isWindows),
    httpHeaders: httpHeaders,
    start: start,
  );
}

String localFileUri(String resource, {required bool windows}) {
  final uri = Uri.tryParse(resource);
  if (uri != null && uri.isScheme('file')) {
    return uri.toString();
  }
  return Uri.file(resource, windows: windows).toString();
}

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

  return _LocalFileMedia(
    resource,
    httpHeaders: httpHeaders,
    start: start,
    windows: windows ?? Platform.isWindows,
  );
}

String localFileUri(String resource, {required bool windows}) {
  final uri = Uri.tryParse(resource);
  if (uri != null && uri.isScheme('file')) {
    return uri.toString();
  }
  return Uri.file(resource, windows: windows).toString();
}

// Media's constructors are not extendable, so implement its interface instead.
class _LocalFileMedia implements Media {
  _LocalFileMedia(
    String resource, {
    this.httpHeaders,
    this.start,
    this.end,
    this.extras,
    required bool windows,
  }) : uri = localFileUri(resource, windows: windows);

  @override
  final String uri;

  @override
  final Map<String, dynamic>? extras;

  @override
  final Map<String, String>? httpHeaders;

  @override
  final Duration? start;

  @override
  final Duration? end;

  @override
  Media copyWith({
    String? uri,
    Map<String, dynamic>? extras,
    Map<String, String>? httpHeaders,
    Duration? start,
    Duration? end,
  }) {
    return _LocalFileMedia(
      uri ?? this.uri,
      extras: extras ?? this.extras,
      httpHeaders: httpHeaders ?? this.httpHeaders,
      start: start ?? this.start,
      end: end ?? this.end,
      windows: false,
    );
  }

  @override
  bool operator ==(Object other) => other is Media && other.uri == uri;

  @override
  int get hashCode => uri.hashCode;

  @override
  String toString() =>
      'Media($uri, extras: $extras, httpHeaders: $httpHeaders, start: $start, end: $end)';
}

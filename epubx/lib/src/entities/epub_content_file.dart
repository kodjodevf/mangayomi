import 'package:quiver/core.dart';

import 'epub_content_type.dart';

abstract class EpubContentFile {
  String? FileName;
  EpubContentType? ContentType;
  String? ContentMimeType;

  @override
  int get hashCode =>
      hash3(FileName.hashCode, ContentType.hashCode, ContentMimeType.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubContentFile)) {
      return false;
    }
    return FileName == other.FileName &&
        ContentType == other.ContentType &&
        ContentMimeType == other.ContentMimeType;
  }
}

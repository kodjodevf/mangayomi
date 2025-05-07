import 'package:quiver/core.dart';

import 'epub_content_file.dart';

class EpubTextContentFile extends EpubContentFile {
  String? Content;

  @override
  int get hashCode => hash4(Content, ContentMimeType, ContentType, FileName);

  @override
  bool operator ==(other) {
    if (!(other is EpubTextContentFile)) {
      return false;
    }

    return Content == other.Content &&
        ContentMimeType == other.ContentMimeType &&
        ContentType == other.ContentType &&
        FileName == other.FileName;
  }
}

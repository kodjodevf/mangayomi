import 'dart:async';

import 'epub_book_ref.dart';
import 'epub_content_file_ref.dart';

class EpubByteContentFileRef extends EpubContentFileRef {
  EpubByteContentFileRef(EpubBookRef epubBookRef) : super(epubBookRef);

  Future<List<int>> readContent() {
    return readContentAsBytes();
  }
}

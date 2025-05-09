import 'dart:async';

import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  // Referece to Text content reader.
  EpubTextContentFileRef? epubTextContentFileRef;
  // If the chapter is split into multiple files, this list contains the references to content readers of the other files.
  List<EpubTextContentFileRef> otherTextContentFileRefs = [];

  String? Title;
  String? ContentFileName;
  String? Anchor;
  List<EpubChapterRef>? SubChapters;
  // If the chapter is split into multiple files, this list contains the names of the other files.
  List<String> OtherContentFileNames = [];

  EpubChapterRef(EpubTextContentFileRef? epubTextContentFileRef) {
    this.epubTextContentFileRef = epubTextContentFileRef;
  }

  @override
  int get hashCode {
    var objects = [
      Title.hashCode,
      ContentFileName.hashCode,
      OtherContentFileNames.hashCode,
      Anchor.hashCode,
      epubTextContentFileRef.hashCode,
      otherTextContentFileRefs.hashCode,
      ...SubChapters?.map((subChapter) => subChapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubChapterRef)) {
      return false;
    }
    return Title == other.Title &&
        ContentFileName == other.ContentFileName &&
        OtherContentFileNames == other.OtherContentFileNames &&
        Anchor == other.Anchor &&
        epubTextContentFileRef == other.epubTextContentFileRef &&
        otherTextContentFileRefs == other.otherTextContentFileRefs &&
        collections.listsEqual(SubChapters, other.SubChapters);
  }

  Future<String> readHtmlContent() async {
    var contentFuture = epubTextContentFileRef!.readContentAsText();
    if (OtherContentFileNames.isNotEmpty) {
      var allContentFutures = <Future<String>>[contentFuture];
      for (var otherContentFileRef in otherTextContentFileRefs) {
        allContentFutures.add(otherContentFileRef.readContentAsText());
      }
      return Future.wait(allContentFutures).then((List<String> contents) {
        return contents.join('');
      });
    } else {
      return contentFuture;
    }
  }

  @override
  String toString() {
    return 'Title: $Title, Subchapter count: ${SubChapters!.length}';
  }
}

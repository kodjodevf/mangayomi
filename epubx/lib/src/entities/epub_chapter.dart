import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubChapter {
  String? Title;
  String? ContentFileName;
  String? Anchor;
  String? HtmlContent;
  List<EpubChapter>? SubChapters;
  List<String> OtherContentFileNames = [];

  @override
  int get hashCode {
    var objects = [
      Title.hashCode,
      ContentFileName.hashCode,
      OtherContentFileNames.hashCode,
      Anchor.hashCode,
      HtmlContent.hashCode,
      ...SubChapters?.map((subChapter) => subChapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubChapter)) {
      return false;
    }
    return Title == other.Title &&
        ContentFileName == other.ContentFileName &&
        OtherContentFileNames == other.OtherContentFileNames &&
        Anchor == other.Anchor &&
        HtmlContent == other.HtmlContent &&
        collections.listsEqual(SubChapters, other.SubChapters);
  }

  @override
  String toString() {
    return 'Title: $Title, Subchapter count: ${SubChapters!.length}';
  }
}

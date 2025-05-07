import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file.dart';
import 'epub_content_file.dart';
import 'epub_text_content_file.dart';

class EpubContent {
  Map<String, EpubTextContentFile>? Html;
  Map<String, EpubTextContentFile>? Css;
  Map<String, EpubByteContentFile>? Images;
  Map<String, EpubByteContentFile>? Fonts;
  Map<String, EpubContentFile>? AllFiles;

  EpubContent() {
    Html = <String, EpubTextContentFile>{};
    Css = <String, EpubTextContentFile>{};
    Images = <String, EpubByteContentFile>{};
    Fonts = <String, EpubByteContentFile>{};
    AllFiles = <String, EpubContentFile>{};
  }

  @override
  int get hashCode {
    var objects = [
      ...Html!.keys.map((key) => key.hashCode),
      ...Html!.values.map((value) => value.hashCode),
      ...Css!.keys.map((key) => key.hashCode),
      ...Css!.values.map((value) => value.hashCode),
      ...Images!.keys.map((key) => key.hashCode),
      ...Images!.values.map((value) => value.hashCode),
      ...Fonts!.keys.map((key) => key.hashCode),
      ...Fonts!.values.map((value) => value.hashCode),
      ...AllFiles!.keys.map((key) => key.hashCode),
      ...AllFiles!.values.map((value) => value.hashCode),
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubContent)) {
      return false;
    }
    return collections.mapsEqual(Html, other.Html) &&
        collections.mapsEqual(Css, other.Css) &&
        collections.mapsEqual(Images, other.Images) &&
        collections.mapsEqual(Fonts, other.Fonts) &&
        collections.mapsEqual(AllFiles, other.AllFiles);
  }
}

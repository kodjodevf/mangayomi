import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_byte_content_file_ref.dart';
import 'epub_content_file_ref.dart';
import 'epub_text_content_file_ref.dart';

class EpubContentRef {
  Map<String, EpubTextContentFileRef>? Html;
  Map<String, EpubTextContentFileRef>? Css;
  Map<String, EpubByteContentFileRef>? Images;
  Map<String, EpubByteContentFileRef>? Fonts;
  Map<String, EpubContentFileRef>? AllFiles;

  EpubContentRef() {
    Html = <String, EpubTextContentFileRef>{};
    Css = <String, EpubTextContentFileRef>{};
    Images = <String, EpubByteContentFileRef>{};
    Fonts = <String, EpubByteContentFileRef>{};
    AllFiles = <String, EpubContentFileRef>{};
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
      ...AllFiles!.values.map((value) => value.hashCode)
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubContentRef)) {
      return false;
    }

    return collections.mapsEqual(Html, other.Html) &&
        collections.mapsEqual(Css, other.Css) &&
        collections.mapsEqual(Images, other.Images) &&
        collections.mapsEqual(Fonts, other.Fonts) &&
        collections.mapsEqual(AllFiles, other.AllFiles);
  }
}

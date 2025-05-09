import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_navigation_head_meta.dart';

class EpubNavigationHead {
  List<EpubNavigationHeadMeta>? Metadata;

  EpubNavigationHead() {
    Metadata = <EpubNavigationHeadMeta>[];
  }

  @override
  int get hashCode {
    var objects = [...Metadata!.map((meta) => meta.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationHead?;
    if (otherAs == null) {
      return false;
    }

    return collections.listsEqual(Metadata, otherAs.Metadata);
  }
}

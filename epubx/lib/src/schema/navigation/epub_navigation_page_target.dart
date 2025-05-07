import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';
import 'epub_navigation_page_target_type.dart';

class EpubNavigationPageTarget {
  String? Id;
  String? Value;
  EpubNavigationPageTargetType? Type;
  String? Class;
  String? PlayOrder;
  List<EpubNavigationLabel>? NavigationLabels;
  EpubNavigationContent? Content;

  @override
  int get hashCode {
    var objects = [
      Id.hashCode,
      Value.hashCode,
      Type.hashCode,
      Class.hashCode,
      PlayOrder.hashCode,
      Content.hashCode,
      ...NavigationLabels?.map((label) => label.hashCode) ?? [0]
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationPageTarget?;
    if (otherAs == null) {
      return false;
    }

    if (!(Id == otherAs.Id &&
        Value == otherAs.Value &&
        Type == otherAs.Type &&
        Class == otherAs.Class &&
        PlayOrder == otherAs.PlayOrder &&
        Content == otherAs.Content)) {
      return false;
    }

    return collections.listsEqual(NavigationLabels, otherAs.NavigationLabels);
  }
}

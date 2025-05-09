import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata.dart';
import 'epub_navigation_label.dart';

class EpubNavigationPoint {
  String? Id;
  String? Class;
  String? PlayOrder;
  List<EpubNavigationLabel>? NavigationLabels;
  EpubNavigationContent? Content;
  List<EpubNavigationPoint>? ChildNavigationPoints;

  @override
  int get hashCode {
    var objects = [
      Id.hashCode,
      Class.hashCode,
      PlayOrder.hashCode,
      Content.hashCode,
      ...NavigationLabels!.map((label) => label.hashCode),
      ...ChildNavigationPoints!.map((point) => point.hashCode)
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationPoint?;
    if (otherAs == null) {
      return false;
    }

    if (!collections.listsEqual(NavigationLabels, otherAs.NavigationLabels)) {
      return false;
    }

    if (!collections.listsEqual(
        ChildNavigationPoints, otherAs.ChildNavigationPoints)) return false;

    return Id == otherAs.Id &&
        Class == otherAs.Class &&
        PlayOrder == otherAs.PlayOrder &&
        Content == otherAs.Content;
  }

  @override
  String toString() {
    return 'Id: $Id, Content.Source: ${Content!.Source}';
  }
}

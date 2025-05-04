import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

class EpubNavigationDocAuthor {
  List<String>? Authors;

  EpubNavigationDocAuthor() {
    Authors = <String>[];
  }

  @override
  int get hashCode {
    var objects = [...Authors!.map((author) => author.hashCode)];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationDocAuthor?;
    if (otherAs == null) return false;

    return collections.listsEqual(Authors, otherAs.Authors);
  }
}

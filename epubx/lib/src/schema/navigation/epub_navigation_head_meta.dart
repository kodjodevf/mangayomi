import 'package:quiver/core.dart';

class EpubNavigationHeadMeta {
  String? Name;
  String? Content;
  String? Scheme;

  @override
  int get hashCode => hash3(Name.hashCode, Content.hashCode, Scheme.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubNavigationHeadMeta?;
    if (otherAs == null) {
      return false;
    }

    return Name == otherAs.Name &&
        Content == otherAs.Content &&
        Scheme == otherAs.Scheme;
  }
}

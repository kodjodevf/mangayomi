import 'package:quiver/core.dart';

class EpubGuideReference {
  String? Type;
  String? Title;
  String? Href;

  @override
  int get hashCode => hash3(Type.hashCode, Title.hashCode, Href.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubGuideReference?;
    if (otherAs == null) {
      return false;
    }

    return Type == otherAs.Type &&
        Title == otherAs.Title &&
        Href == otherAs.Href;
  }

  @override
  String toString() {
    return 'Type: $Type, Href: $Href';
  }
}

import 'package:quiver/core.dart';

class EpubMetadataIdentifier {
  String? Id;
  String? Scheme;
  String? Identifier;

  @override
  int get hashCode => hash3(Id.hashCode, Scheme.hashCode, Identifier.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataIdentifier?;
    if (otherAs == null) return false;
    return Id == otherAs.Id &&
        Scheme == otherAs.Scheme &&
        Identifier == otherAs.Identifier;
  }
}

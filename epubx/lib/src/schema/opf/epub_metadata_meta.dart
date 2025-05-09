import 'package:quiver/core.dart';

class EpubMetadataMeta {
  String? Name;
  String? Content;
  String? Id;
  String? Refines;
  String? Property;
  String? Scheme;
  Map<String, String>? Attributes;

  @override
  int get hashCode => hashObjects([
        Name.hashCode,
        Content.hashCode,
        Id.hashCode,
        Refines.hashCode,
        Property.hashCode,
        Scheme.hashCode
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataMeta?;
    if (otherAs == null) return false;
    return Name == otherAs.Name &&
        Content == otherAs.Content &&
        Id == otherAs.Id &&
        Refines == otherAs.Refines &&
        Property == otherAs.Property &&
        Scheme == otherAs.Scheme;
  }
}

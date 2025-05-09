import 'package:quiver/core.dart';

class EpubMetadataDate {
  String? Date;
  String? Event;

  @override
  int get hashCode => hash2(Date.hashCode, Event.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubMetadataDate?;
    if (otherAs == null) return false;
    return Date == otherAs.Date && Event == otherAs.Event;
  }
}

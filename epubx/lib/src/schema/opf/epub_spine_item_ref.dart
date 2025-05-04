import 'package:quiver/core.dart';

class EpubSpineItemRef {
  String? IdRef;
  bool? IsLinear;

  @override
  int get hashCode => hash2(IdRef.hashCode, IsLinear.hashCode);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubSpineItemRef?;
    if (otherAs == null) {
      return false;
    }

    return IdRef == otherAs.IdRef && IsLinear == otherAs.IsLinear;
  }

  @override
  String toString() {
    return 'IdRef: $IdRef';
  }
}

import 'package:quiver/core.dart';

class EpubManifestItem {
  String? Id;
  String? Href;
  String? MediaType;
  String? MediaOverlay;
  String? RequiredNamespace;
  String? RequiredModules;
  String? Fallback;
  String? FallbackStyle;
  String? Properties;

  @override
  int get hashCode => hashObjects([
        Id.hashCode,
        Href.hashCode,
        MediaType.hashCode,
        MediaOverlay.hashCode,
        RequiredNamespace.hashCode,
        RequiredModules.hashCode,
        Fallback.hashCode,
        FallbackStyle.hashCode,
        Properties.hashCode
      ]);

  @override
  bool operator ==(other) {
    var otherAs = other as EpubManifestItem?;
    if (otherAs == null) {
      return false;
    }

    return Id == otherAs.Id &&
        Href == otherAs.Href &&
        MediaType == otherAs.MediaType &&
        MediaOverlay == otherAs.MediaOverlay &&
        RequiredNamespace == otherAs.RequiredNamespace &&
        RequiredModules == otherAs.RequiredModules &&
        Fallback == otherAs.Fallback &&
        FallbackStyle == otherAs.FallbackStyle &&
        Properties == otherAs.Properties;
  }

  @override
  String toString() {
    return 'Id: $Id, Href = $Href, MediaType = $MediaType, Properties = $Properties, MediaOverlay = $MediaOverlay';
  }
}

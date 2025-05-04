import 'package:quiver/core.dart';

import '../schema/navigation/epub_navigation.dart';
import '../schema/opf/epub_package.dart';

class EpubSchema {
  EpubPackage? Package;
  EpubNavigation? Navigation;
  String? ContentDirectoryPath;

  @override
  int get hashCode => hash3(
      Package.hashCode, Navigation.hashCode, ContentDirectoryPath.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubSchema)) {
      return false;
    }

    return Package == other.Package &&
        Navigation == other.Navigation &&
        ContentDirectoryPath == other.ContentDirectoryPath;
  }
}

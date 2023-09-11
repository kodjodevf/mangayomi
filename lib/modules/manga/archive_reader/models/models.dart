import 'package:flutter/foundation.dart';

class LocalArchive {
  String? name;

  Uint8List? coverImage;

  List<LocalImage>? images = [];

  LocalExtensionType? extensionType;

  String? path;
}

enum LocalExtensionType { cbz, zip, cbt, tar }

class LocalImage {
  String? name;
  Uint8List? image;
}

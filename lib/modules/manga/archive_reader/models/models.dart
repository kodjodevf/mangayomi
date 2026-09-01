import 'package:flutter/foundation.dart';

class LocalArchive {
  String? name;

  Uint8List? coverImage;

  List<LocalImage>? images = [];

  LocalExtensionType? extensionType;

  String? path;
}

enum LocalExtensionType { cbz, zip, cbt, tar, cbr, rar, folder }

class LocalImage {
  String? name;
  Uint8List? image;

  /// The real on-disk path of this page, when it's a standalone image file
  /// (a plain image-folder chapter) rather than an entry inside an archive.
  /// When this is set, [image] is intentionally left unread - callers should
  /// read the file directly (or hand its path straight to an image widget)
  /// instead of loading it into memory, since the bytes already live on disk
  /// under a real, addressable path. Null for archive-file entries (cbz/zip/
  /// cbt/tar/cbr/rar), which have no standalone file to point to and so are
  /// still read fully into [image].
  String? path;
}

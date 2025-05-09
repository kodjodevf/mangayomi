library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:epubx/epubx.dart';

main() async {
  String fileName = "MY VAMPIRE SYSTEM (JKSManga) (Z-Library).epub";
  String fullPath =
      path.join(io.Directory.current.path, "test", "res", fileName);
  var targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }
  List<int> bytes = await targetFile.readAsBytes();
  test("Test Epub Image", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);

    expect(epubRef.CoverImage, isNotNull);

    // expect(3, epubRef.CoverImage.format);
    // expect(581, epubRef.CoverImage.width);
    // expect(1034, epubRef.CoverImage.height);
  });

  test("Test Epub Ref Image", () async {
    EpubBookRef epubRef = await EpubReader.openBook(bytes);

    Image? coverImage = await epubRef.readCover();

    expect(coverImage, isNotNull);

    // expect(3, coverImage.format);
    // expect(581, coverImage.width);
    // expect(1034, coverImage.height);
  });
}

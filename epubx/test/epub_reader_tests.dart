library epubreadertest;

import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:epubx/epubx.dart';

main() async {
  String fileName = "stevenson-a-childs-garden-of-verses-illustrations.epub";
  String fullPath = path.join(io.Directory.current.path, "test", "res", fileName);
  var targetFile = new io.File(fullPath);
  if (!(await targetFile.exists())) {
    throw new Exception("Specified epub file not found: ${fullPath}");
  }

  List<int> bytes = await targetFile.readAsBytes();
  test("Test Epub Ref", () async {
    EpubBookRef epubRef = await EpubReader.openBook(bytes);
    var t = await epubRef.getChapters();
    print("${t.length}");
  });
  test("Test Epub Read", () async {
    EpubBook epubRef = await EpubReader.readBook(bytes);

    expect(epubRef.Author, equals("John S. Hittell"));
    expect(epubRef.Title, equals("Hittel on Gold Mines and Mining"));
  });

  test("Test can read", () async {
    String baseName = path.join(io.Directory.current.path, "test", "res", "std");
    io.Directory baseDir = new io.Directory(baseName);
    if (!(await baseDir.exists())) {
      throw new Exception("Base path does not exist: ${baseName}");
    }

    await baseDir.list(recursive: false, followLinks: false).forEach((io.FileSystemEntity fe) async {
      try {
        io.File tf = new io.File(fe.path);
        List<int> bytes = await tf.readAsBytes();
        EpubBook book = await EpubReader.readBook(bytes);
        expect(book, isNotNull);
      } catch (e) {
        print("File: ${fe.path}, Exception: ${e}");
        fail("Caught error...");
      }
    });
  });

  test("Test can open", () async {
    var baseName = path.join(io.Directory.current.path, "test", "res", "std");
    var baseDir = new io.Directory(baseName);
    if (!(await baseDir.exists())) {
      throw new Exception("Base path does not exist: ${baseName}");
    }

    await baseDir.list(recursive: false, followLinks: false).forEach((io.FileSystemEntity fe) async {
      try {
        var tf = new io.File(fe.path);
        var bytes = await tf.readAsBytes();
        var ref = await EpubReader.openBook(bytes);
        expect(ref, isNotNull);
      } catch (e) {
        print("File: ${fe.path}, Exception: ${e}");
        fail("Caught error...");
      }
    });
  });
}

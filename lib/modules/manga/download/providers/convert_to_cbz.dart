import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'convert_to_cbz.g.dart';

@riverpod
Future<List<String>> convertToCBZ(ConvertToCBZRef ref, String chapterDir,
    String mangaDir, String chapterName, List<String> pageList) async {
  Map<String, dynamic> data = {
    "chapterDir": chapterDir,
    "mangaDir": mangaDir,
    "chapterName": chapterName,
    "pageList": pageList
  };
  return compute(_convertToCBZ, data);
}

List<String> _convertToCBZ(Map<String, dynamic> data) {
  List<String> imagesPaths = [];
  String chapterDir = data["chapterDir"]!;
  String mangaDir = data["mangaDir"]!;
  String chapterName = data["chapterName"]!;
  List<String> pageList = data["pageList"]!;

  if (Directory(chapterDir).existsSync()) {
    List<FileSystemEntity> entities = Directory(chapterDir).listSync();
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        String path = entity.path;
        if (path.endsWith('.jpg')) {
          imagesPaths.add(path);
        }
      }
    }
    imagesPaths.sort(
      (a, b) {
        return a.toString().compareTo(b.toString());
      },
    );
  }

  if (imagesPaths.isNotEmpty && pageList.length == imagesPaths.length) {
    var encoder = ZipFileEncoder();
    encoder.create("$mangaDir/$chapterName.cbz");
    for (var path in imagesPaths) {
      encoder.addFile(File(path));
    }
    encoder.close();
    Directory(chapterDir).deleteSync(recursive: true);
  }

  return imagesPaths;
}

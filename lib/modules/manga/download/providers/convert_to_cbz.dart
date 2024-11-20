import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'convert_to_cbz.g.dart';

@riverpod
Future<List<String>> convertToCBZ(Ref ref, String chapterDir, String mangaDir,
    String chapterName, List<String> pageList) async {
  return compute(_convertToCBZ, (chapterDir, mangaDir, chapterName, pageList));
}

List<String> _convertToCBZ((String, String, String, List<String>) datas) {
  List<String> imagesPaths = [];
  final (chapterDir, mangaDir, chapterName, pageList) = datas;

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

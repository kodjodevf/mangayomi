import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
part 'convert_to_cbz.g.dart';

@riverpod
Future<List<String>> convertToCBZ(
  Ref ref,
  String chapterDir,
  String mangaDir,
  String chapterName,
  List<String> pageList,
) async {
  return compute(_convertToCBZ, (chapterDir, mangaDir, chapterName, pageList));
}

List<String> _convertToCBZ((String, String, String, List<String>) datas) {
  final (chapterDir, mangaDir, chapterName, pageList) = datas;
  final imagesPaths = pageList.where((path) => path.endsWith('.jpg')).toList()
    ..sort();

  if (imagesPaths.isNotEmpty) {
    final archive = Archive();
    final cbzPath = path.join(mangaDir, "$chapterName.cbz");

    for (var imagePath in imagesPaths) {
      final file = File(imagePath);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        final fileName = path.basename(imagePath);
        archive.add(ArchiveFile.bytes(fileName, bytes));
      }
    }
    final cbzData = ZipEncoder().encode(archive);
    File(cbzPath).writeAsBytesSync(cbzData);
    Directory(chapterDir).deleteSync(recursive: true);
  }

  return imagesPaths;
}

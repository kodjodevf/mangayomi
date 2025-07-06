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

  if (imagesPaths.isEmpty) return imagesPaths;

  final archive = Archive();
  final cbzPath = path.join(mangaDir, "$chapterName.cbz");
  final List<String> missingFiles = [];
  final List<String> includedFiles = [];

  for (var imagePath in imagesPaths) {
    final file = File(imagePath);
    if (!file.existsSync()) {
      missingFiles.add(imagePath);
      continue;
    }
    final bytes = file.readAsBytesSync();
    final fileName = path.basename(imagePath);
    archive.add(ArchiveFile.bytes(fileName, bytes));
    includedFiles.add(imagePath);
  }
  try {
    final cbzData = ZipEncoder().encode(archive);
    File(cbzPath).writeAsBytesSync(cbzData);
  } catch (e) {
    if (File(cbzPath).existsSync()) File(cbzPath).deleteSync();
    throw FileSystemException("Failed to create/write CBZ file: $e", cbzPath);
  }
  try {
    Directory(chapterDir).deleteSync(recursive: true);
  } catch (e) {
    throw FileSystemException("Failed to delete chapter directory", chapterDir);
  }
  if (missingFiles.isNotEmpty) {
    final missingListStr = missingFiles.join(", ");
    throw Exception(
      "CBZ created, but the following pages were missing and not included: $missingListStr",
    );
  }

  return includedFiles;
}

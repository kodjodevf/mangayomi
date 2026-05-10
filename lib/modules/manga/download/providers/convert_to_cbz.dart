import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as path;
part 'convert_to_cbz.g.dart';

/// Metadata for ComicInfo.xml generation (serializable for isolate).
class ComicInfoData {
  final String? title;
  final String? series;
  final String? number;
  final String? writer;
  final String? penciller;
  final String? summary;
  final String? genre;
  final String? translator;
  final String? publishingStatusStr;
  final int pageCount;

  const ComicInfoData({
    this.title,
    this.series,
    this.number,
    this.writer,
    this.penciller,
    this.summary,
    this.genre,
    this.translator,
    this.publishingStatusStr,
    this.pageCount = 0,
  });
}

@riverpod
Future<List<String>> convertToCBZ(
  Ref ref,
  String chapterDir,
  String mangaDir,
  String chapterName,
  List<String> pageList, {
  ComicInfoData? comicInfo,
}) async {
  return compute(_convertToCBZ, (
    chapterDir,
    mangaDir,
    chapterName,
    pageList,
    comicInfo,
  ));
}

String _buildComicInfoXml(ComicInfoData info, int pageCount) {
  final sb = StringBuffer();
  sb.writeln('<?xml version="1.0" encoding="utf-8"?>');
  sb.writeln(
    '<ComicInfo xmlns:xsd="http://www.w3.org/2001/XMLSchema" '
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">',
  );

  void addTag(String tag, String? value) {
    if (value != null && value.isNotEmpty) {
      final escaped = _xmlEscape(value);
      sb.writeln('  <$tag>$escaped</$tag>');
    }
  }

  addTag('Title', info.title);
  addTag('Series', info.series);
  addTag('Number', info.number);
  addTag('Writer', info.writer);
  addTag('Penciller', info.penciller);
  addTag('Summary', info.summary);
  addTag('Genre', info.genre);
  addTag('Translator', info.translator);
  if (pageCount > 0) {
    sb.writeln('  <PageCount>$pageCount</PageCount>');
  }
  addTag('PublishingStatusTachiyomi', info.publishingStatusStr);

  sb.writeln('</ComicInfo>');
  return sb.toString();
}

String _xmlEscape(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}

List<String> _convertToCBZ(
  (String, String, String, List<String>, ComicInfoData?) datas,
) {
  final (chapterDir, mangaDir, chapterName, pageList, comicInfo) = datas;
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

  // Add ComicInfo.xml if metadata is provided
  if (comicInfo != null) {
    final xml = _buildComicInfoXml(comicInfo, includedFiles.length);
    archive.add(ArchiveFile.bytes('ComicInfo.xml', utf8.encode(xml)));
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

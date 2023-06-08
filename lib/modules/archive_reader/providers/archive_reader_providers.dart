import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/archive_reader/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'archive_reader_providers.g.dart';

@riverpod
Future<List<LocalArchive>> getArchiveDataFromDirectory(
    GetArchiveDataFromDirectoryRef ref, String path) async {
  return compute(_extract, path);
}

@riverpod
Future<LocalArchive> getArchiveDataFromFile(
    GetArchiveDataFromFileRef ref, String path) async {
  return compute(_extractArchive, path);
}

List<LocalArchive> _extract(String data) {
  return _searchForArchive(Directory(data));
}

List<LocalArchive> _list = [];
List<LocalArchive> _searchForArchive(Directory dir) {
  List<FileSystemEntity> entities = dir.listSync();
  for (FileSystemEntity entity in entities) {
    if (entity is Directory) {
      _searchForArchive(entity);
    } else if (entity is File) {
      String path = entity.path;
      if (_isArchiveFile(path)) {
        final dd = _extractArchive(path);
        _list.add(dd);
      }
    }
  }
  return _list;
}

bool _isImageFile(String path) {
  List<String> imageExtensions = ['.png', '.jpg', '.jpeg'];
  String extension = path.toLowerCase();
  for (String imageExtension in imageExtensions) {
    if (extension.endsWith(imageExtension)) {
      return true;
    }
  }
  return false;
}

bool _isArchiveFile(String path) {
  List<String> archiveExtensions = ['.cbz', '.zip', 'cbt', 'tar'];
  String extension = path.toLowerCase();
  for (String archiveExtension in archiveExtensions) {
    if (extension.endsWith(archiveExtension)) {
      return true;
    }
  }
  return false;
}

LocalArchive _extractArchive(String path) {
  final bytes = File(path).readAsBytesSync();
  final localArchive = LocalArchive()
    ..path = path
    ..extensionType =
        setTypeExtension(path.split('/').last.split("\\").last.split(".").last)
    ..name = path
        .split('/')
        .last
        .split("\\")
        .last
        .replaceAll(RegExp(r'\.(cbz|zip|cbt|tar)'), '');
  Archive? archive;
  final extensionType = localArchive.extensionType;
  if (extensionType == LocalExtensionType.cbt ||
      extensionType == LocalExtensionType.tar) {
    archive = TarDecoder().decodeBytes(bytes);
  } else {
    archive = ZipDecoder().decodeBytes(bytes);
  }

  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      if (_isImageFile(filename)) {
        if (filename.contains("cover")) {
          final data = file.content as Uint8List;
          localArchive.coverImage = data;
        } else {
          final data = file.content as Uint8List;
          localArchive.images!.add(LocalImage()
            ..image = data
            ..name = filename.split('/').last.split("\\").last);
        }
      }
    }
  }
  localArchive.images!.sort((a, b) => a.name!.compareTo(b.name!));
  localArchive.coverImage ??= localArchive.images!.first.image;
  return localArchive;
}

String getTypeExtension(LocalExtensionType type) {
  return switch (type) {
    LocalExtensionType.cbt => type.name,
    LocalExtensionType.zip => type.name,
    LocalExtensionType.tar => type.name,
    _ => type.name,
  };
}

LocalExtensionType setTypeExtension(String extension) {
  return switch (extension) {
    "cbt" => LocalExtensionType.cbt,
    "zip" => LocalExtensionType.zip,
    "tar" => LocalExtensionType.tar,
    _ => LocalExtensionType.cbz,
  };
}

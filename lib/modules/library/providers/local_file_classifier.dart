// Listing a directory's entries and classifying what kind of local-library
// content a file is. Split out of file_scanner.dart: this only reads the
// filesystem and inspects file names/extensions, it never touches Isar or
// Riverpod state.
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:path/path.dart' as p;

Future<List<FileSystemEntity>> listLocalDirectory(
  Directory directory, {
  required String logContext,
}) async {
  if (Platform.isIOS) {
    try {
      final entries = await LocalDirectoryAccess.listDirectory(directory.path);
      if (entries != null) {
        debugPrint(
          '[LocalLibraryScanner] $logContext native iOS list: '
          'path=${directory.path}, entries=${entries.length}, '
          'preview=${entries.take(8).map((e) => '${e.type}:${p.basename(e.path)}').join(', ')}',
        );
        return entries.map((entry) {
          if (entry.isDirectory) return Directory(entry.path);
          if (entry.isFile) return File(entry.path);
          return FileSystemEntity.typeSync(entry.path) ==
                  FileSystemEntityType.directory
              ? Directory(entry.path)
              : File(entry.path);
        }).toList();
      }
    } catch (e, stackTrace) {
      debugPrint(
        '[LocalLibraryScanner] $logContext native iOS list failed: '
        'path=${directory.path}, error=$e\n$stackTrace',
      );
    }
  }

  try {
    return await directory.list(followLinks: true).toList();
  } catch (e, stackTrace) {
    debugPrint(
      '[LocalLibraryScanner] $logContext list failed: '
      'path=${directory.path}, error=$e\n$stackTrace',
    );
    return [];
  }
}

Future<List<Directory>> localDirectories(
  List<FileSystemEntity> entities, {
  required String logContext,
}) async {
  final dirs = <Directory>[];
  for (final entity in entities) {
    if (entity is Directory ||
        await _localEntityType(entity, logContext: logContext) ==
            FileSystemEntityType.directory) {
      dirs.add(entity is Directory ? entity : Directory(entity.path));
    }
  }
  return dirs;
}

Future<List<File>> localFiles(
  List<FileSystemEntity> entities, {
  required String logContext,
}) async {
  final files = <File>[];
  for (final entity in entities) {
    if (entity is File ||
        await _localEntityType(entity, logContext: logContext) ==
            FileSystemEntityType.file) {
      files.add(entity is File ? entity : File(entity.path));
    }
  }
  return files;
}

Future<FileSystemEntityType> _localEntityType(
  FileSystemEntity entity, {
  required String logContext,
}) async {
  try {
    return await FileSystemEntity.type(entity.path, followLinks: true);
  } catch (e) {
    debugPrint(
      '[LocalLibraryScanner] $logContext entity type failed: '
      'path=${entity.path}, runtimeType=${entity.runtimeType}, error=$e',
    );
    return FileSystemEntityType.notFound;
  }
}

String debugEntityPreview(List<FileSystemEntity> entities) {
  if (entities.isEmpty) return '<empty>';
  return entities
      .take(8)
      .map((entity) => '${entity.runtimeType}:${p.basename(entity.path)}')
      .join(', ');
}

bool isHiddenSystemFile(String path) {
  final name = path.replaceAll('\\', '/').split('/').last;
  return name.startsWith('.');
}

/// Returns if file is a json
bool isJsonFile(String path) {
  if (isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.json';
}

/// Returns if file is an image
bool isLocalImageFile(String path) {
  if (isHiddenSystemFile(path)) return false;
  return isRecognizedImageFile(path);
}

/// Returns if file is an archive
bool isArchiveFile(String path) {
  if (isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.cbz' ||
      ext == '.zip' ||
      ext == '.cbt' ||
      ext == '.tar' ||
      ext == '.cbr' ||
      ext == '.rar';
}

/// Returns if file is a video
bool isVideoFile(String path) {
  if (isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  const videoExtensions = {
    '.mp4',
    '.mov',
    '.avi',
    '.flv',
    '.wmv',
    '.mpeg',
    '.mkv',
  };
  return videoExtensions.contains(ext);
}

/// Returns if file is an epub or html
bool isEpubFile(String path) {
  if (isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.epub';
}

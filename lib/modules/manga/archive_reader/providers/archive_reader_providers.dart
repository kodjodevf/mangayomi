import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/archive_reader/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
part 'archive_reader_providers.g.dart';

// Constants for supported file types
const List<String> _kImageExtensions = [
  '.png',
  '.jpg',
  '.jpeg',
  '.gif',
  '.webp',
];
const List<String> _kArchiveExtensions = ['.cbz', '.zip', '.cbt', '.tar'];

@riverpod
Future<List<(String, LocalExtensionType, Uint8List, String)>>
getArchivesDataFromDirectory(Ref ref, String path) async {
  return compute(_extractArchiveMetadataFromDirectory, path);
}

@riverpod
Future<List<LocalArchive>> getArchiveDataFromDirectory(
  Ref ref,
  String path,
) async {
  return compute(_extractArchivesFromDirectory, path);
}

@riverpod
Future<(String, LocalExtensionType, Uint8List, String)> getArchivesDataFromFile(
  Ref ref,
  String path,
) async {
  return compute(_extractArchiveMetadata, path);
}

@riverpod
Future<LocalArchive> getArchiveDataFromFile(Ref ref, String path) async {
  return compute(_extractArchive, path);
}

/// Extract full archive data from all archives in a directory (recursive)
Future<List<LocalArchive>> _extractArchivesFromDirectory(
  String directoryPath,
) async {
  final archives = <LocalArchive>[];

  try {
    final dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      return archives;
    }

    await _scanDirectoryRecursive(
      dir,
      onArchiveFound: (path) async {
        try {
          final archive = await _extractArchive(path);
          archives.add(archive);
        } catch (e) {
          debugPrint('Error extracting archive at $path: $e');
        }
      },
    );
  } catch (e) {
    debugPrint('Error scanning directory $directoryPath: $e');
  }

  return archives;
}

/// Extract only metadata (cover) from all archives in a directory (recursive)
Future<List<(String, LocalExtensionType, Uint8List, String)>>
_extractArchiveMetadataFromDirectory(String directoryPath) async {
  final metadata = <(String, LocalExtensionType, Uint8List, String)>[];

  try {
    final dir = Directory(directoryPath);
    if (!dir.existsSync()) {
      return metadata;
    }

    await _scanDirectoryRecursive(
      dir,
      onArchiveFound: (path) async {
        try {
          final data = await _extractArchiveMetadata(path);
          metadata.add(data);
        } catch (e) {
          debugPrint('Error extracting metadata at $path: $e');
        }
      },
    );
  } catch (e) {
    debugPrint('Error scanning directory $directoryPath: $e');
  }

  return metadata;
}

/// Recursively scan directory for archive files
Future<void> _scanDirectoryRecursive(
  Directory dir, {
  required Future<void> Function(String path) onArchiveFound,
}) async {
  try {
    final entities = dir.listSync();

    for (final entity in entities) {
      if (entity is Directory) {
        // Recursive scan
        await _scanDirectoryRecursive(entity, onArchiveFound: onArchiveFound);
      } else if (entity is File) {
        if (_isArchiveFile(entity.path)) {
          await onArchiveFound(entity.path);
        }
      }
    }
  } catch (e) {
    debugPrint('Error scanning directory ${dir.path}: $e');
  }
}

/// Check if a file is an image based on extension
bool _isImageFile(String path) {
  final extension = p.extension(path).toLowerCase();
  return _kImageExtensions.contains(extension);
}

/// Check if a file is a supported archive based on extension
bool _isArchiveFile(String path) {
  final extension = p.extension(path).toLowerCase();
  return _kArchiveExtensions.any((ext) => extension.endsWith(ext));
}

/// Extract full archive with all images
Future<LocalArchive> _extractArchive(String path) async {
  try {
    // Handle directory of images
    if (Directory(path).existsSync()) {
      return await _extractFromImageFolder(path);
    }

    // Handle archive file
    return _extractFromArchiveFile(path);
  } catch (e) {
    debugPrint('Error extracting archive from $path: $e');
    rethrow;
  }
}

/// Extract images from a folder
Future<LocalArchive> _extractFromImageFolder(String path) async {
  final dir = Directory(path);
  final imageFiles =
      await dir
            .list()
            .where((entity) => entity is File && _isImageFile(entity.path))
            .cast<File>()
            .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (imageFiles.isEmpty) {
    throw Exception('No images found in folder: $path');
  }

  final images = imageFiles.map((file) {
    return LocalImage()
      ..image = file.readAsBytesSync()
      ..name = p.basename(file.path);
  }).toList();

  return LocalArchive()
    ..path = path
    ..extensionType = LocalExtensionType.folder
    ..name = p.basename(path)
    ..images = images
    ..coverImage = images.first.image;
}

/// Extract images from an archive file
LocalArchive _extractFromArchiveFile(String path) {
  final extensionType = _getArchiveType(path);
  final localArchive = LocalArchive()
    ..path = path
    ..extensionType = extensionType
    ..name = p.basenameWithoutExtension(path)
    ..images = [];

  InputFileStream? inputStream;

  try {
    inputStream = InputFileStream(path);
    final archive = _decodeArchive(inputStream, extensionType);

    final imageFiles =
        archive.files
            .where(
              (file) =>
                  file.isFile &&
                  _isImageFile(file.name) &&
                  !file.name.startsWith('.'),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    if (imageFiles.isEmpty) {
      throw Exception('No images found in archive: $path');
    }

    // Extract images
    for (final file in imageFiles) {
      final filename = file.name;
      final data = file.content;

      if (filename.toLowerCase().contains('cover')) {
        localArchive.coverImage = data;
      }

      localArchive.images!.add(
        LocalImage()
          ..image = data
          ..name = p.basename(filename),
      );
    }

    // Set cover image if not explicitly found
    localArchive.coverImage ??= localArchive.images!.first.image;

    return localArchive;
  } finally {
    inputStream?.close();
  }
}

/// Extract only metadata (name, type, cover) from archive
Future<(String, LocalExtensionType, Uint8List, String)> _extractArchiveMetadata(
  String path,
) async {
  try {
    // Handle directory of images
    if (await Directory(path).exists()) {
      return await _extractMetadataFromImageFolder(path);
    }

    // Handle archive file
    return _extractMetadataFromArchiveFile(path);
  } catch (e) {
    debugPrint('Error extracting metadata from $path: $e');
    rethrow;
  }
}

/// Extract metadata from image folder
Future<(String, LocalExtensionType, Uint8List, String)>
_extractMetadataFromImageFolder(String path) async {
  final dir = Directory(path);
  final images =
      await dir
            .list()
            .where((entity) => entity is File && _isImageFile(entity.path))
            .cast<File>()
            .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (images.isEmpty) {
    throw Exception('No images found in folder: $path');
  }

  final cover = images.first.readAsBytesSync();
  return (p.basename(path), LocalExtensionType.folder, cover, path);
}

/// Extract metadata from archive file
(String, LocalExtensionType, Uint8List, String) _extractMetadataFromArchiveFile(
  String path,
) {
  final extensionType = _getArchiveType(path);
  final name = p.basenameWithoutExtension(path);

  InputFileStream? inputStream;

  try {
    inputStream = InputFileStream(path);
    final archive = _decodeArchive(inputStream, extensionType);

    // Look for cover image first
    final coverFile = archive.files.firstWhere(
      (file) =>
          file.isFile &&
          _isImageFile(file.name) &&
          file.name.toLowerCase().contains('cover') &&
          !file.name.startsWith('.'),
      orElse: () {
        // If no cover, get first image alphabetically
        final imageFiles =
            archive.files
                .where(
                  (file) =>
                      file.isFile &&
                      _isImageFile(file.name) &&
                      !file.name.startsWith('.'),
                )
                .toList()
              ..sort((a, b) => a.name.compareTo(b.name));

        if (imageFiles.isEmpty) {
          throw Exception('No images found in archive: $path');
        }

        return imageFiles.first;
      },
    );

    final coverImage = coverFile.content;
    return (name, extensionType, coverImage, path);
  } finally {
    inputStream?.close();
  }
}

/// Decode archive based on type
Archive _decodeArchive(InputFileStream stream, LocalExtensionType type) {
  switch (type) {
    case LocalExtensionType.cbt:
    case LocalExtensionType.tar:
      return TarDecoder().decodeStream(stream);
    case LocalExtensionType.zip:
    case LocalExtensionType.cbz:
    case LocalExtensionType.folder:
      return ZipDecoder().decodeStream(stream);
  }
}

/// Get archive type from file extension
LocalExtensionType _getArchiveType(String path) {
  final extension = p.extension(path).toLowerCase().replaceFirst('.', '');
  return setTypeExtension(extension);
}

String getTypeExtension(LocalExtensionType type) {
  return type.name;
}

LocalExtensionType setTypeExtension(String extension) {
  return switch (extension.toLowerCase()) {
    'cbt' => LocalExtensionType.cbt,
    'zip' => LocalExtensionType.zip,
    'tar' => LocalExtensionType.tar,
    'cbz' => LocalExtensionType.cbz,
    _ => LocalExtensionType.cbz,
  };
}

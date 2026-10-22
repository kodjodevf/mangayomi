import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/avif.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:path_provider/path_provider.dart';

String md5HashString(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

Future<File?> findCachedImageFile(String url, String? cacheFolderName) async {
  try {
    final hash = md5HashString(url);
    final foldersToCheck = [?cacheFolderName, 'cacheimagemanga', 'cacheimage'];

    final dirs = <Directory>[];
    try {
      dirs.add(await getApplicationCacheDirectory());
    } catch (_) {}
    try {
      dirs.add(await getTemporaryDirectory());
    } catch (_) {}

    for (final baseDir in dirs) {
      for (final folder in foldersToCheck) {
        final file = File('${baseDir.path}/$folder/$hash');
        if (file.existsSync()) {
          return file;
        }
      }
    }
  } catch (_) {}
  return null;
}

Future<String?> convertLegacyIosAvifToPng(String path) async {
  if (!Platform.isIOS) return null;

  final source = File(path);
  final reader = await source.open();
  late final Uint8List header;
  try {
    header = await reader.read(256);
  } finally {
    await reader.close();
  }
  if (!isAvifImage(header)) return null;

  final stat = await source.stat();
  final key = md5HashString(
    '$path:${stat.size}:${stat.modified.millisecondsSinceEpoch}',
  );
  // Decoding is deferred into bytesProvider so it only runs on a cache miss
  final target = await cacheImageBytesToTempFile(
    tempDir: await getTemporaryDirectory(),
    baseName: 'ssiv_avif_$key',
    extension: '.png', // decodeAvifToPng always returns PNG bytes
    bytesProvider: () async => decodeAvifToPng(await source.readAsBytes()),
  );
  return target.path;
}

/// Attempts fast-path file resolution for [provider] (FileImage, duck-typed `.file`,
/// memory bytes, or already-cached network image).
/// Returns `(resolvedPath, networkUrl, cacheFolderName)`.
Future<(String?, String?, String?)> tryResolveFastPathProvider(
  ImageProvider<Object> provider,
) async {
  // 1. Fast path: FileImage
  if (provider is FileImage) {
    return (provider.file.path, null, null);
  }

  // Duck-typing for ExtendedFileImageProvider (or any provider exposing a File)
  try {
    final dynamic dynProvider = provider;
    if (dynProvider.file is File) {
      return ((dynProvider.file as File).path, null, null);
    }
  } catch (_) {}

  // 2. Fast path: Memory-based providers (MemoryImage, ExtendedMemoryImageProvider, etc.)
  try {
    final dynamic dynProvider = provider;
    if (dynProvider.bytes is Uint8List) {
      final Uint8List bytes = dynProvider.bytes;
      final cacheKey = provider.hashCode.abs();
      final tempFile = await cacheImageBytesToTempFile(
        tempDir: await getTemporaryDirectory(),
        baseName: 'ssiv_cache_$cacheKey',
        extension: detectImageExtension(bytes),
        bytesProvider: () => bytes,
      );
      return (tempFile.path, null, null);
    }
  } catch (_) {}

  // 3. Fast path: Network/Cached-based providers (CustomExtendedNetworkImageProvider)
  String? networkUrl;
  String? cacheFolderName;
  try {
    final dynamic dynProvider = provider;
    networkUrl = dynProvider.url;
    cacheFolderName = dynProvider.imageCacheFolderName;
  } catch (_) {}

  if (networkUrl != null) {
    final cachedFile = await findCachedImageFile(networkUrl, cacheFolderName);
    if (cachedFile != null) {
      return (cachedFile.path, networkUrl, cacheFolderName);
    }
  }

  return (null, networkUrl, cacheFolderName);
}

/// Encodes a decoded [ui.Image] to a temporary PNG file on disk.
Future<File> encodeLoadedUiImageToTempFile(
  ui.Image loadedImage,
  int cacheKey,
) async {
  return cacheImageBytesToTempFile(
    tempDir: await getTemporaryDirectory(),
    baseName: 'ssiv_cache_$cacheKey',
    extension: '.png',
    bytesProvider: () async {
      final byteData = await loadedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw Exception('Failed to convert image to PNG bytes');
      }
      return byteData.buffer.asUint8List();
    },
  );
}

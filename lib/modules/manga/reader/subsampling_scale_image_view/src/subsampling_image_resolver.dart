import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/utils/avif.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/services/http/custom_extended_image_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String md5HashString(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

/// The file a network page was downloaded to, or null while it is not
/// there.
///
/// Where [CustomExtendedNetworkImageProvider] writes it, then in
/// extended_image's own cache for any other network provider. Asynchronously:
/// this runs for each page shown, on the thread that draws the app.
Future<File?> findCachedImageFile(String url, String? cacheFolderName) async {
  try {
    final own = await CustomExtendedNetworkImageProvider.findCachedFile(
      url,
      cacheFolderName,
    );
    if (own != null) return own;
    final other = File(
      p.join(
        (await getTemporaryDirectory()).path,
        'cacheimage',
        md5HashString(url),
      ),
    );
    if (await other.exists()) return other;
  } catch (error, stack) {
    // The page is decoded through its provider instead.
    recordError(
      error,
      stack: stack,
      source: 'page_cache_lookup',
      level: LogLevel.warning,
    );
  }
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

/// Whether [bytes] start like a JPEG: the start-of-image marker followed by
/// another marker.
bool isJpegImage(Uint8List bytes) =>
    bytes.length >= 3 &&
    bytes[0] == 0xFF &&
    bytes[1] == 0xD8 &&
    bytes[2] == 0xFF;

/// [bytes] decoded by Flutter and encoded as PNG.
Future<Uint8List> decodeWithFlutterToPng(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    final frame = await codec.getNextFrame();
    try {
      final png = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      if (png == null) throw StateError('Could not encode the image as PNG');
      return png.buffer.asUint8List();
    } finally {
      frame.image.dispose();
    }
  } finally {
    codec.dispose();
  }
}

/// A JPEG the native decoder could not read, as a PNG Flutter decoded, on
/// Linux.
///
/// The native decoder reads JPEG through the system's libjpeg, which must be
/// the version the app was built against: a build made on Ubuntu (libjpeg 8)
/// cannot use the libjpeg 6.2 of Fedora, Arch or openSUSE, and every JPEG
/// failed there (#1071). PNG it reads through libpng, which has no such
/// split.
Future<String?> convertLinuxJpegToPng(String path) async {
  if (!Platform.isLinux) return null;

  final source = File(path);
  final reader = await source.open();
  late final Uint8List header;
  try {
    header = await reader.read(3);
  } finally {
    await reader.close();
  }
  if (!isJpegImage(header)) return null;

  final stat = await source.stat();
  final key = md5HashString(
    '$path:${stat.size}:${stat.modified.millisecondsSinceEpoch}',
  );
  // Decoding is deferred into bytesProvider so it only runs on a cache miss
  final target = await cacheImageBytesToTempFile(
    tempDir: await getTemporaryDirectory(),
    baseName: 'ssiv_jpeg_$key',
    extension: '.png',
    bytesProvider: () async =>
        decodeWithFlutterToPng(await source.readAsBytes()),
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

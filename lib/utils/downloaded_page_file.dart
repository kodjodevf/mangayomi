import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/utils/avif.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;

/// Every extension a downloaded page might legitimately be saved under.
/// Order matters only as a tie-breaker if a directory somehow has more than
/// one file for the same page index (shouldn't normally happen).
const List<String> knownPageImageExtensions = [
  '.jpg',
  '.png',
  '.webp',
  '.gif',
  '.avif',
];

/// Superset of [knownPageImageExtensions] for recognizing image files
/// mangayomi didn't create itself - user-added local comics, archive
/// contents, anything from outside the downloader. Includes the '.jpeg'
/// spelling some external tools use, which detectImageExtension never
/// produces, so [knownPageImageExtensions] deliberately excludes it - a
/// lookup for one of mangayomi's own downloaded pages should never need to
/// check for a spelling it never writes.
const List<String> recognizedImageExtensions = [
  ...knownPageImageExtensions,
  '.jpeg',
];

/// Whether [path]'s extension is a recognized image format. Case-insensitive.
/// For scanning arbitrary files - see [recognizedImageExtensions].
bool isRecognizedImageFile(String path) {
  return recognizedImageExtensions.contains(p.extension(path).toLowerCase());
}

/// Sniffs [bytes] for a known image-format magic number and returns the
/// matching extension (including the leading dot). Falls back to '.jpg' for
/// anything unrecognized - matches the historical always-.jpg behavior for
/// the (hopefully rare) case of a format this doesn't know how to detect,
/// rather than failing the download outright over a cosmetic mislabel.
String detectImageExtension(Uint8List bytes) {
  if (isJpegImage(bytes)) return knownPageImageExtensions[0];
  if (isPngImage(bytes)) return knownPageImageExtensions[1];
  if (isWebpImage(bytes)) return knownPageImageExtensions[2];
  if (isGifImage(bytes)) return knownPageImageExtensions[3];
  if (isAvifImage(bytes)) return knownPageImageExtensions[4];
  return knownPageImageExtensions[0];
}

bool isJpegImage(Uint8List bytes) {
  return bytes.length >= 3 &&
      bytes[0] == 0xFF && // JPEG SOI marker start
      bytes[1] == 0xD8 && // JPEG SOI marker
      bytes[2] == 0xFF; // Next marker (JFIF/EXIF/etc.)
}

bool isPngImage(Uint8List bytes) {
  return bytes.length >= 8 &&
      bytes[0] == 0x89 && // PNG signature byte 1
      bytes[1] == 0x50 && // 'P'
      bytes[2] == 0x4E && // 'N'
      bytes[3] == 0x47 && // 'G'
      bytes[4] == 0x0D && // CR
      bytes[5] == 0x0A && // LF
      bytes[6] == 0x1A && // EOF
      bytes[7] == 0x0A; // LF
}

bool isWebpImage(Uint8List bytes) {
  return bytes.length >= 12 &&
      bytes[0] == 0x52 && // 'R'
      bytes[1] == 0x49 && // 'I'
      bytes[2] == 0x46 && // 'F'
      bytes[3] == 0x46 && // 'F'
      bytes[8] == 0x57 && // 'W'
      bytes[9] == 0x45 && // 'E'
      bytes[10] == 0x42 && // 'B'
      bytes[11] == 0x50; // 'P'
}

bool isGifImage(Uint8List bytes) {
  return bytes.length >= 6 &&
      bytes[0] == 0x47 && // 'G'
      bytes[1] == 0x49 && // 'I'
      bytes[2] == 0x46 && // 'F'
      bytes[3] == 0x38 && // '8'
      (bytes[4] == 0x37 || bytes[4] == 0x39) && // '7' or '9'
      bytes[5] == 0x61; // 'a'
}

/// The single source of truth for "does an exported cover already exist in
/// [directory], and under what extension" - same tolerant-extension lookup
/// as [findDownloadedPageFile], but for the fixed "cover" basename that
/// exportMangaMetadata/exportMangaCoverFromFile write under (see
/// export_metadata.dart), rather than a page index.
File? findMangaCoverFile(Directory directory) {
  for (final ext in knownPageImageExtensions) {
    final file = File(p.join(directory.path, 'cover$ext'));
    if (file.existsSync()) return file;
  }
  return null;
}

/// The single source of truth for "where is page [index] of this chapter on
/// disk". Looks for a file named `padIndex(index)` under any known image
/// extension and returns it if found, regardless of which extension it
/// actually has - callers should never reconstruct this path by hand with a
/// hardcoded extension.
File? findDownloadedPageFile(Directory directory, int index) {
  final base = padIndex(index);
  for (final ext in knownPageImageExtensions) {
    final file = File(p.join(directory.path, '$base$ext'));
    if (file.existsSync()) return file;
  }
  return null;
}

/// Async variant of [findDownloadedPageFile], for callers already in an
/// async context that would rather not block on sync file-system checks.
Future<File?> findDownloadedPageFileAsync(
  Directory directory,
  int index,
) async {
  final base = padIndex(index);
  for (final ext in knownPageImageExtensions) {
    final file = File(p.join(directory.path, '$base$ext'));
    if (await file.exists()) return file;
  }
  return null;
}

import 'dart:convert';
import 'dart:io';

import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:path/path.dart' as p;

Future<void> exportMangaMetadata({
  required Manga manga,
  required Directory directory,
  Map<String, String>? headers,
  bool onlyIfMissing = false,
}) async {
  await directory.create(recursive: true);

  final metadataFile = File(p.join(directory.path, "metadata.json"));

  if (!onlyIfMissing || findMangaCoverFile(directory) == null) {
    final imageUrl = (manga.customCoverFromTracker ?? manga.imageUrl ?? "")
        .trim();
    if (imageUrl.isNotEmpty) {
      final uri = Uri.tryParse(imageUrl);
      if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
        try {
          final client = MClient.init();
          final res = await client.get(uri, headers: headers);
          if (res.bodyBytes.isNotEmpty) {
            final ext = detectImageExtension(res.bodyBytes);
            final coverFile = File(p.join(directory.path, "cover$ext"));
            await coverFile.writeAsBytes(res.bodyBytes);
          }
        } catch (_) {
          // Metadata export should never block the chapter download.
        }
      }
    }
  }

  if (!onlyIfMissing || !await metadataFile.exists()) {
    await metadataFile.writeAsString(
      jsonEncode({
        "name": manga.name,
        "description": manga.description,
        "artist": manga.artist,
        "author": manga.author,
        "genre": manga.genre,
        "status": manga.status.index,
        "imageUrl": manga.customCoverFromTracker ?? manga.imageUrl,
      }),
    );
  }
}

Future<void> exportMangaCoverFromFile({
  required Directory directory,
  required File imageFile,
  bool onlyIfMissing = true,
}) async {
  if (onlyIfMissing && findMangaCoverFile(directory) != null) return;
  if (!await imageFile.exists()) return;

  await directory.create(recursive: true);
  final bytes = await imageFile.readAsBytes();
  final ext = detectImageExtension(bytes);
  final coverFile = File(p.join(directory.path, "cover$ext"));
  await coverFile.writeAsBytes(bytes);
}

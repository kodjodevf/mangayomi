import 'dart:convert';
import 'dart:io';

import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:path/path.dart' as p;

/// How long fetching a series' cover may take. Without a limit, a source
/// that never answers keeps the request open for good.
const _coverTimeout = Duration(seconds: 20);

/// Marks a cover taken from a downloaded page, a stand-in until the series'
/// own cover could be fetched.
const _pageCoverMarker = '.cover-from-page';

Future<void> exportMangaMetadata({
  required Manga manga,
  required Directory directory,
  Map<String, String>? headers,
  bool onlyIfMissing = false,
  bool fetchCover = true,
}) async {
  await directory.create(recursive: true);

  final metadataFile = File(p.join(directory.path, "metadata.json"));

  if (fetchCover && (!onlyIfMissing || findMangaCoverFile(directory) == null)) {
    await _downloadCover(manga, directory, headers);
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

/// Fetches the series' own cover into [directory] when there is none yet or
/// only one taken from a page. Meant to run once a download is done, so a
/// slow source never holds up the download itself.
Future<void> fetchMissingMangaCover({
  required Manga manga,
  required Directory directory,
  Map<String, String>? headers,
}) async {
  final marker = File(p.join(directory.path, _pageCoverMarker));
  if (findMangaCoverFile(directory) != null && !await marker.exists()) return;
  await _downloadCover(manga, directory, headers);
}

/// Downloads [manga]'s cover into [directory], replacing the one there.
/// Failing, or taking longer than [_coverTimeout], leaves it as it was.
Future<void> _downloadCover(
  Manga manga,
  Directory directory,
  Map<String, String>? headers,
) async {
  final imageUrl = (manga.customCoverFromTracker ?? manga.imageUrl ?? "")
      .trim();
  final uri = Uri.tryParse(imageUrl);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) return;
  try {
    final client = MClient.init(
      reqcopyWith: {
        'timeout': _coverTimeout.inSeconds,
        'connectTimeout': _coverTimeout.inSeconds,
      },
    );
    // Also bounded here: the Dart HTTP client ignores the settings above.
    final res = await client.get(uri, headers: headers).timeout(_coverTimeout);
    if (res.statusCode >= 400 || res.bodyBytes.isEmpty) return;
    await directory.create(recursive: true);
    // One cover at a time: another extension would be found first.
    findMangaCoverFile(directory)?.deleteSync();
    final ext = detectImageExtension(res.bodyBytes);
    await File(p.join(directory.path, "cover$ext")).writeAsBytes(res.bodyBytes);
    final marker = File(p.join(directory.path, _pageCoverMarker));
    if (await marker.exists()) await marker.delete();
  } catch (_) {
    // A cover is optional: without one, the folder simply has none.
  }
}

/// Writes [imageFile] as the cover of [directory]. With [fromPage], it is
/// marked as a page standing in for the series' cover, which
/// [fetchMissingMangaCover] later replaces.
Future<void> exportMangaCoverFromFile({
  required Directory directory,
  required File imageFile,
  bool onlyIfMissing = true,
  bool fromPage = false,
}) async {
  if (onlyIfMissing && findMangaCoverFile(directory) != null) return;
  if (!await imageFile.exists()) return;

  await directory.create(recursive: true);
  final bytes = await imageFile.readAsBytes();
  final ext = detectImageExtension(bytes);
  final coverFile = File(p.join(directory.path, "cover$ext"));
  await coverFile.writeAsBytes(bytes);
  if (fromPage) {
    await File(p.join(directory.path, _pageCoverMarker)).writeAsString('');
  }
}

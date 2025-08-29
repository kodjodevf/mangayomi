import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../models/source.dart';
part 'get_video_list.g.dart';

@riverpod
Future<(List<Video>, bool, List<String>, Directory?)> getVideoList(
  Ref ref, {
  required Chapter episode,
}) async {
  final storageProvider = StorageProvider();
  final mpvDirectory = await storageProvider.getMpvDirectory();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(episode);
  final isLocalArchive =
      episode.manga.value!.isLocalArchive! &&
      episode.manga.value!.source != "torrent";
  final mp4animePath = p.join(
    mangaDirectory!.path,
    "${episode.name!.replaceForbiddenCharacters(' ')}.mp4",
  );
  List<String> infoHashes = [];
  if (await File(mp4animePath).exists() || isLocalArchive) {
    final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
      episode,
      mangaMainDirectory: mangaDirectory,
    ))!;
    final path = isLocalArchive ? episode.archivePath : mp4animePath;
    final subtitlesDir = Directory(
      p.join('${chapterDirectory.path}_subtitles'),
    );
    List<Track> subtitles = [];
    if (subtitlesDir.existsSync()) {
      for (var element in subtitlesDir.listSync()) {
        if (element is File) {
          final subtitle = Track(
            label: element.uri.pathSegments.last.replaceAll('.srt', ''),
            file: element.uri.toString(),
          );
          subtitles.add(subtitle);
        }
      }
    }
    return (
      [Video(path!, episode.name!, path, subtitles: subtitles)],
      true,
      infoHashes,
      mpvDirectory,
    );
  }
  final source = getSource(
    episode.manga.value!.lang!,
    episode.manga.value!.source!,
    episode.manga.value!.sourceId,
  );
  final proxyServer = ref.read(androidProxyServerStateProvider);

  final isMihonTorrent =
      source?.sourceCodeLanguage == SourceCodeLanguage.mihon &&
      source!.name!.contains("(Torrent");
  if ((source?.isTorrent ?? false) ||
      episode.manga.value!.source == "torrent" ||
      isMihonTorrent) {
    List<Video> list = [];

    List<Video> torrentList = [];
    if (episode.archivePath?.isNotEmpty ?? false) {
      final (videos, infohash) = await MTorrentServer().getTorrentPlaylist(
        episode.url,
        episode.archivePath,
      );
      return (videos, false, [infohash ?? ""], mpvDirectory);
    }

    try {
      list = await getExtensionService(
        source!,
        proxyServer,
      ).getVideoList(episode.url!);
    } catch (e) {
      list = [Video(episode.url!, episode.name!, episode.url!)];
    }

    for (var v in list) {
      final (videos, infohash) = await MTorrentServer().getTorrentPlaylist(
        v.url,
        episode.archivePath,
      );
      for (var video in videos) {
        torrentList.add(
          video..quality = video.quality.substringBeforeLast("."),
        );
        if (infohash != null) {
          infoHashes.add(infohash);
        }
      }
    }
    return (torrentList, false, infoHashes, mpvDirectory);
  }

  List<Video> list = await getExtensionService(
    source!,
    proxyServer,
  ).getVideoList(episode.url!);
  List<Video> videos = [];

  for (var video in list) {
    if (!videos.any((element) => element.quality == video.quality)) {
      videos.add(video);
    }
  }

  return (videos, false, infoHashes, mpvDirectory);
}

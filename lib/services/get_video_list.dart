import 'dart:async';
import 'dart:io';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

import '../models/source.dart';
part 'get_video_list.g.dart';

@riverpod
Future<(List<Video>, bool, List<String>, Directory?)> getVideoList(
  Ref ref, {
  required Chapter episode,
}) async {
  (List<Video>, bool, List<String>, Directory?) result;
  final keepAlive = ref.keepAlive();
  try {
    final storageProvider = StorageProvider();
    // Only touch the (public) mpv config dir when the mpv-config feature is on.
    // Otherwise a fresh install with no all-files access would hit a permission
    // error just for streaming an episode — the dir was being created on every
    // play even though useMpvConfig defaults to false. See #740.
    final useMpvConfig = ref.read(useMpvConfigStateProvider);
    final mpvDirectory = useMpvConfig
        ? await storageProvider.getMpvDirectory()
        : null;
    final isLocalArchive =
        episode.manga.value!.isLocalArchive! &&
        episode.manga.value!.source != "torrent";
    // Episodes downloaded on the builds that sent downloads to a local folder
    // are still in that folder, so look there as well as in the downloads
    // directory rather than only where new downloads land.
    final episodeFileName =
        "${episode.name!.replaceForbiddenCharacters(' ')}.mp4";
    final candidateDirectories = await downloadedMangaDirectories(episode);
    final downloadedDirectory = candidateDirectories.firstWhere(
      (directory) => File(p.join(directory.path, episodeFileName)).existsSync(),
      orElse: () => candidateDirectories.first,
    );
    final mp4animePath = p.join(downloadedDirectory.path, episodeFileName);
    final resolvedArchivePath = episode.archivePath?.isNotEmpty ?? false
        ? await resolveLocalArchivePath(episode.archivePath!)
        : null;
    List<String> infoHashes = [];
    if (await File(mp4animePath).exists() || isLocalArchive) {
      final animeDir =
          resolvedArchivePath != null && episode.manga.value?.source == "local"
          ? Directory(p.dirname(resolvedArchivePath))
          : null;
      final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
        episode,
        mangaMainDirectory: animeDir ?? downloadedDirectory,
      ))!;
      final path = isLocalArchive ? resolvedArchivePath : mp4animePath;
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
      keepAlive.close();
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
      installedOnly: true,
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
        keepAlive.close();
        final hashes = <String>{};
        if (infohash != null && infohash.isNotEmpty) {
          hashes.add(infohash);
        }
        for (var video in videos) {
          final h = Uri.tryParse(video.url)?.queryParameters['infohash'];
          if (h != null && h.isNotEmpty) {
            hashes.add(h);
          }
        }
        return (videos, false, hashes.toList(), mpvDirectory);
      }

      try {
        list = await getIsolateService.get<List<Video>>(
          url: episode.url!,
          source: source,
          serviceType: 'getVideoList',
          proxyServer: proxyServer,
        );
      } catch (e) {
        list = [Video(episode.url!, episode.name!, episode.url!)];
      }

      for (var v in list) {
        final (videos, infohash) = await MTorrentServer().getTorrentPlaylist(
          v.url,
          episode.archivePath,
        );
        if (infohash != null &&
            infohash.isNotEmpty &&
            !infoHashes.contains(infohash)) {
          infoHashes.add(infohash);
        }
        for (var video in videos) {
          torrentList.add(
            video..quality = video.quality.substringBeforeLast("."),
          );
          final videoHash =
              Uri.tryParse(video.url)?.queryParameters['infohash'];
          if (videoHash != null &&
              videoHash.isNotEmpty &&
              !infoHashes.contains(videoHash)) {
            infoHashes.add(videoHash);
          }
        }
      }
      keepAlive.close();
      return (torrentList, false, infoHashes, mpvDirectory);
    }

    List<Video> list = await getIsolateService.get<List<Video>>(
      url: episode.url!,
      source: source,
      serviceType: 'getVideoList',
      proxyServer: proxyServer,
    );
    List<Video> videos = [];

    for (var video in list) {
      if (!videos.any((element) => element.quality == video.quality)) {
        videos.add(video);
      }
    }

    result = (videos, false, infoHashes, mpvDirectory);

    keepAlive.close();
    return result;
  } catch (e) {
    keepAlive.close();
    rethrow;
  }
}

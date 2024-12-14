import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'get_video_list.g.dart';

@riverpod
Future<(List<Video>, bool, List<String>)> getVideoList(Ref ref,
    {required Chapter episode}) async {
  final storageProvider = StorageProvider();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(episode);
  final isLocalArchive = episode.manga.value!.isLocalArchive! &&
      episode.manga.value!.source != "torrent";
  final mp4animePath =
      "${mangaDirectory!.path}${episode.name!.replaceForbiddenCharacters(' ')}.mp4";
  List<String> infoHashes = [];
  if (await File(mp4animePath).exists() || isLocalArchive) {
    final path = isLocalArchive ? episode.archivePath : mp4animePath;
    return (
      [Video(path!, episode.name!, path, subtitles: [])],
      true,
      infoHashes
    );
  }
  final source =
      getSource(episode.manga.value!.lang!, episode.manga.value!.source!);

  if (source?.isTorrent ?? false || episode.manga.value!.source == "torrent") {
    List<Video> list = [];

    List<Video> torrentList = [];
    if (episode.archivePath?.isNotEmpty ?? false) {
      final (videos, infohash) = await MTorrentServer()
          .getTorrentPlaylist(episode.url, episode.archivePath);
      return (videos, false, [infohash ?? ""]);
    }
    if (source?.sourceCodeLanguage == SourceCodeLanguage.dart) {
      list = await DartExtensionService(source).getVideoList(episode.url!);
    } else {
      list = await JsExtensionService(source).getVideoList(episode.url!);
    }
    for (var v in list) {
      final (videos, infohash) =
          await MTorrentServer().getTorrentPlaylist(v.url, episode.archivePath);
      for (var video in videos) {
        torrentList
            .add(video..quality = video.quality.substringBeforeLast("."));
        if (infohash != null) {
          infoHashes.add(infohash);
        }
      }
    }
    return (torrentList, false, infoHashes);
  }

  List<Video> list = [];
  if (source?.sourceCodeLanguage == SourceCodeLanguage.dart) {
    list = await DartExtensionService(source).getVideoList(episode.url!);
  } else {
    list = await JsExtensionService(source).getVideoList(episode.url!);
  }
  List<Video> videos = [];
  for (var video in list) {
    if (!videos.any((element) => element.quality == video.quality)) {
      videos.add(video);
    }
  }
  return (videos, false, infoHashes);
}

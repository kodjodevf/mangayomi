import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/m3u8/m3u8_server.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_video_list.g.dart';

@riverpod
Future<(List<Video>, bool, String?, HttpServer?)> getVideoList(
    GetVideoListRef ref,
    {required Chapter episode,
    bool ignoreM3u8File = false}) async {
  final storageProvider = StorageProvider();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(episode);
  final isLocalArchive = episode.manga.value!.isLocalArchive! &&
      episode.manga.value!.source != "torrent";
  final mp4animePath =
      "${mangaDirectory!.path}${episode.name!.replaceForbiddenCharacters(' ')}.mp4";
  final episodeFolderPath =
      "${mangaDirectory.path}${episode.name!.replaceForbiddenCharacters(' ')}";

  if (await File(mp4animePath).exists() || isLocalArchive) {
    final path = isLocalArchive ? episode.archivePath : mp4animePath;
    return (
      [Video(path!, episode.name!, path, subtitles: [])],
      true,
      null,
      null
    );
  }
  final source =
      getSource(episode.manga.value!.lang!, episode.manga.value!.source!);

  if (source?.isTorrent ?? false || episode.manga.value!.source == "torrent") {
    final (videos, infohash) = await MTorrentServer()
        .getTorrentPlaylist(episode.url, episode.archivePath);
    return (videos, false, infohash, null);
  }
  if (File("$episodeFolderPath/index.m3u8").existsSync() && !ignoreM3u8File) {
    const indexUrl = "http://localhost:3000/index.m3u8";
    final httpServer = await m3u8Server(
        m3u8Content: File("$episodeFolderPath/index.m3u8").readAsStringSync(),
        episodeFolderPath: episodeFolderPath);
    return (
      [Video(indexUrl, episode.name!, indexUrl)],
      false,
      null,
      httpServer
    );
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
  return (videos, false, null, null);
}

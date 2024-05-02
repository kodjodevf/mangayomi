import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/model/m_provider.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_video_list.g.dart';

@riverpod
Future<(List<Video>, bool, String?)> getVideoList(
  GetVideoListRef ref, {
  required Chapter episode,
}) async {
  final storageProvider = StorageProvider();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(episode);
  final isLocalArchive = episode.manga.value!.isLocalArchive!;
  final mp4animePath = "${mangaDirectory!.path}${episode.name}.mp4";

  if (await File(mp4animePath).exists() || isLocalArchive) {
    final path = isLocalArchive ? episode.archivePath : mp4animePath;
    return ([Video(path!, episode.name!, path, subtitles: [])], true, null);
  }

  final source =
      getSource(episode.manga.value!.lang!, episode.manga.value!.source!)!;

  if (source.isTorrent) {
    final (videos, infohash) =
        await MTorrentServer().getTorrentPlaylist(episode.url!);
    return (videos, false, infohash);
  }
  List<Video> list = [];
  if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]);
    list = (await (res as MProvider).getVideoList(episode.url!));
  } else {
    list = await JsExtensionService(source).getVideoList(episode.url!);
  }
  List<Video> videos = [];
  for (var video in list) {
    if (!videos.any((element) => element.quality == video.quality)) {
      videos.add(video);
    }
  }
  return (videos, false, null);
}

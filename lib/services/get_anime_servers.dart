import 'dart:async';
import 'dart:io';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_anime_servers.g.dart';

@riverpod
Future<(List<Video>, bool)> getAnimeServers(
  GetAnimeServersRef ref, {
  required Chapter episode,
}) async {
  final storageProvider = StorageProvider();
  final mangaDirectory = await storageProvider.getMangaMainDirectory(episode);
  final isLocalArchive = episode.manga.value!.isLocalArchive!;
  List<Video> video = [];
  final mp4animePath = "${mangaDirectory!.path}${episode.name}.mp4";
  if (await File(mp4animePath).exists() || isLocalArchive) {
    final path = isLocalArchive ? episode.archivePath : mp4animePath;
    return ([Video(path!, episode.name!, path, subtitles: [])], true);
  }
  final source =
      getSource(episode.manga.value!.lang!, episode.manga.value!.source!)!;

  final bytecode =
      compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [
    $MangaModel.wrap(MangaModel(
      lang: source.lang,
      link: episode.url,
      baseUrl: source.baseUrl,
      source: source.name,
      apiUrl: source.apiUrl,
      sourceId: source.id,
    ))
  ];
  var res = await runtime.executeLib(
      'package:mangayomi/source_code.dart', 'getVideoList');
  if (res is $List) {
    video = res.$reified.map(
      (e) {
        List<Track>? subtitles = [];
        var subs = e.subtitles;
        if (subs is $List) {
          subtitles = subs.map((e) => Track(e.file, e.label)).toList();
        } else {
          try {
            subtitles = (subs as List<TrackModel>).map((e) {
              return Track(e.file, e.label);
            }).toList();
          } catch (_) {}
        }
        List<Track>? audios = [];
        var auds = e.audios;
        if (auds is $List) {
          audios = auds.map((e) => Track(e.file, e.label)).toList();
        } else {
          try {
            audios = (subs as List<TrackModel>).map((e) {
              return Track(e.file, e.label);
            }).toList();
          } catch (_) {}
        }
        return Video(e.url, e.quality, e.originalUrl,
            headers: e.headers, subtitles: subtitles, audios: audios);
      },
    ).toList();
  }
  return (video, false);
}

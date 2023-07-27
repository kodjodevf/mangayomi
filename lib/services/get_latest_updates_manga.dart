import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_latest_updates_manga.g.dart';

@riverpod
Future<List<MangaModel?>> getLatestUpdatesManga(
  GetLatestUpdatesMangaRef ref, {
  required Source source,
  required int page,
}) async {
  List<MangaModel?>? latestUpdatesManga = [];
  final bytecode = compilerEval(source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [
    $MangaModel.wrap(MangaModel(
        page: page,
        lang: source.lang,
        baseUrl: source.baseUrl,
        apiUrl: source.apiUrl,
        sourceId: source.id,
        source: source.name,
        dateFormat: source.dateFormat,
        dateFormatLocale: source.dateFormatLocale))
  ];
  var res = await runtime.executeLib(
    'package:package:mangayomi/main.dart',
    source.isManga! ? 'getLatestUpdatesManga' : 'getLatestUpdatesAnime',
  );
  try {
    if (res is $MangaModel) {
      final value = res.$reified;
      List<MangaModel> newManga = [];
      for (var i = 0; i < value.names!.length; i++) {
        MangaModel newMangaa = MangaModel(
            name: value.names![i],
            link: value.urls![i],
            imageUrl: value.images![i],
            baseUrl: value.baseUrl,
            apiUrl: value.apiUrl,
            lang: value.lang,
            sourceId: value.sourceId,
            dateFormat: value.dateFormat,
            dateFormatLocale: value.dateFormatLocale);
        newManga.add(newMangaa);
      }
      latestUpdatesManga = newManga;
    }
  } catch (_) {
    throw Exception("");
  }

  return latestUpdatesManga;
}

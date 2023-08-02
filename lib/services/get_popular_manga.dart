import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular_manga.g.dart';

@riverpod
Future<List<MangaModel?>> getPopularManga(
  GetPopularMangaRef ref, {
  required Source source,
  required int page,
}) async {
  List<MangaModel> popularManga = [];
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
    'package:mangayomi/source_code.dart',
    source.isManga! ? 'getPopularManga' : 'getPopularAnime',
  );
  try {
    if (res is $MangaModel) {
      final value = res.$reified;
      List<MangaModel> newManga = [];
      for (var i = 0; i < value.names!.length; i++) {
        MangaModel newMangaa = MangaModel(
            name: value.names![i],
            link: value.urls![i],
            imageUrl: value.images!.isEmpty ? emptyImg : value.images![i],
            baseUrl: value.baseUrl,
            apiUrl: value.apiUrl,
            lang: value.lang,
            status: value.status,
            dateFormat: value.dateFormat,
            hasNextPage: value.hasNextPage ?? true,
            dateFormatLocale: value.dateFormatLocale);
        newManga.add(newMangaa);
      }
      popularManga = newManga;
    } else {
      popularManga =
          (res.$reified as List<dynamic>).map((e) => e as MangaModel).toList();
    }
  } catch (e) {
    throw Exception(e);
  }

  return popularManga;
}

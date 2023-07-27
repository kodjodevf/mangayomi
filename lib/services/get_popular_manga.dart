import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
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
    'package:package:mangayomi/main.dart',
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
            imageUrl: value.images![i],
            baseUrl: value.baseUrl,
            apiUrl: value.apiUrl,
            lang: value.lang,
            status: value.status,
            dateFormat: value.dateFormat,
            dateFormatLocale: value.dateFormatLocale);
        newManga.add(newMangaa);
      }
      popularManga = newManga;
    }
  } catch (_) {
    throw Exception("");
  }

  return popularManga;
}



// import 'dart:convert';
// import 'package:bridge_lib/bridge_lib.dart';

// getPopularManga(MangaModel manga) async {
//   final url = "https://animevostfr.tv/filter-advance/page/1";
//   final data = {"url": url, "headers": null, "sourceId": manga.sourceId};
//   final res = await MBridge.http(json.encode(data), 0);
//   if (res.isEmpty) {
//     return manga;
//   }
  
//   return getPopularAnime(manga,res);
// }
// getLatestManga(MangaModel manga) async {
//   final url = "https://animevostfr.tv/filter-advance/page/1/?status=ongoing";
//   final data = {"url": url, "headers": null, "sourceId": manga.sourceId};
//   final res = await MBridge.http(json.encode(data), 0);
//   if (res.isEmpty) {
//     return manga;
//   }
  
//   return getPopularAnime(manga,res);
// }
// MangaModel getPopularAnime(MangaModel manga,String res) async {
//   manga.urls =
//       MBridge.xpath(res, '//*[ @class="ml-item" ]/a/@href', '._')
//           .split('._');
//   manga.names =
//       MBridge.xpath(res, '//*[ @class="ml-item"]/a/span/h2/text()', '._')
//           .split('._');
//   manga.images = MBridge.xpath(
//           res, '//*[ @class="ml-item" ]/a/img/@data-original', '._')
//       .split('._');
//   return manga;
// }

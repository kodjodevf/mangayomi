import 'dart:async';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/bridge_class/manga_model.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

@riverpod
Future<MangaModel> getMangaDetail(
  GetMangaDetailRef ref, {
  required MangaModel manga,
  required Source source,
}) async {
  MangaModel? mangadetail;
  final bytecode = compilerEval(source.sourceCode!);

  final runtime = runtimeEval(bytecode);
  runtime.args = [
    $MangaModel.wrap(manga
      ..source = source.name
      ..lang = source.lang)
  ];

  try {
    var result = await runtime.executeLib('package:package:mangayomi/main.dart',
        source.isManga! ? 'getMangaDetail' : 'getAnimeDetail');
    if (result is $MangaModel) {
      final value = result.$reified;
      mangadetail = value;
    }
  } catch (_) {
    return manga;
  }
  return mangadetail!;
}







// import 'dart:convert';
// import 'package:bridge_lib/bridge_lib.dart';

// getMangaDetail(MangaModel manga) async {
//   final statusList = [
//     {
//       "En cours": 0,
//       "Fin": 1,
//     }
//   ];
//   final url = manga.link;
//   final data = {"url": url, "headers": null};
//   final res = await MBridge.http(json.encode(data), 0);
//   if (res.isEmpty) {
//     return manga;
//   }
  
// final status = MBridge.xpath(
//           res,
//           '//*[@class="mvici-right"]/p[contains(text(), "Statut")]/a/text()',
//           '');

//    manga.description =MBridge.xpath(
//       res, '//*[@itemprop="description"]/text()', '');
//   final type = MBridge.xpath(
//           res,
//           '//*[@class="mvici-right"]/p[contains(text(), "Type")]/a/text()',
//           '');
//   manga.status = MBridge.parseStatus(status, statusList);
//   manga.genre =MBridge.listParse(MBridge.xpath(res,'//*[@class="mvici-left"]/p[contains(text(), "Genres")]/a/text()','._')
//       .split("._"),4) ;


//           print(type);
//           if(type=='MOVIE'){
//               manga.names = ["Movie"];
//               manga.urls=[manga.link];
//           }else{
//             final eps = MBridge.xpath(res,'//*[@id="seasonss"]/div[@class="les-title"]/a/text()','._')
//       .split("._");
//       final urls = MBridge.xpath(res,'//*[@id="seasonss"]/div[@class="les-title"]/a/@href','._')
//       .split("._");
// List<String> episodes = [];
//       for (var a in MBridge.listParse(eps,4)){
      
//         episodes.add("Épisode ${MBridge.subString(MBridge.subString(a,'-episode-',1),'-',0)}");
//       }
//        manga.names = episodes;
//               manga.urls=urls;
//           }
//           manga.chaptersDateUploads = [];
//   return manga;
// }

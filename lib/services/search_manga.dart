import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/sources/service/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/src/multi/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/src/multi/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_manga.g.dart';

@riverpod
Future<GetMangaModel> searchManga(SearchMangaRef ref,
    {required String source, required String query}) async {
  GetMangaModel? manga;
  source = source.toLowerCase();

  /********/
  /*comick*/
  /********/

  if (getWpMangTypeSource(source) == TypeSource.comick) {
    manga = await Comick().searchManga(source: source, query: query);
  }

  /***************/
  /*mangathemesia*/
  /***************/

  else if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    manga = await MangaThemeSia().searchManga(source: source, query: query);
  }
  
  /***********/
  /*mangakawaii*/
  /***********/

  else if (source == "mangakawaii") {
    manga = await MangaKawaii().searchManga(source: source, query: query);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source) == TypeSource.mmrcms) {
    manga = await Mmrcms().searchManga(source: source, query: query);
  }
  
  /***********/
  /*mangahere*/
  /***********/

  else if (source == "mangahere") {
    manga = await Mangahere().searchManga(source: source, query: query);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source == "japscan") {
    manga = await Japscan().searchManga(source: source, query: query);
  }

  return manga!;
}

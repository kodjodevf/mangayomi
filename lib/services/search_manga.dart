import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms.dart';
import 'package:mangayomi/sources/multisrc/madara/src/madara.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/all/mangadex/src/mangadex.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_manga.g.dart';

@riverpod
Future<List<GetManga?>> searchManga(
  SearchMangaRef ref, {
  required String source,
  required String query,
  required String lang,
}) async {
  List<GetManga?>? manga;
  source = source.toLowerCase();

  /********/
  /*comick*/
  /********/

  if (getMangaTypeSource(source) == TypeSource.comick) {
    manga = await Comick()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***************/
  /*mangathemesia*/
  /***************/

  else if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
    manga = await MangaThemeSia()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*mangakawaii*/
  /***********/

  else if (source == "mangakawaii") {
    manga = await MangaKawaii()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
    manga = await Mmrcms()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*mangahere*/
  /***********/

  else if (source == "mangahere") {
    manga = await Mangahere()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source == "japscan") {
    manga = await Japscan()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*heancms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.heancms) {
    manga = await HeanCms()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*madara*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.madara) {
    manga = await Madara()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }

  /***********/
  /*mangadex*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mangadex) {
    manga = await MangaDex()
        .searchManga(source: source, query: query, ref: ref, lang: lang);
  }
  return manga!;
}

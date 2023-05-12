import 'dart:async';
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
part 'get_manga_detail.g.dart';

@riverpod
Future<GetMangaDetailModel> getMangaDetail(GetMangaDetailRef ref,
    {required String imageUrl,
    required String url,
    required String title,
    required String lang,
    required String source}) async {
  GetMangaDetailModel? mangadetail;

  /********/
  /*comick*/
  /********/

  if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.comick) {
    mangadetail = await Comick().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }
  /*************/
  /*mangathemesia*/
  /**************/

  if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.mangathemesia) {
    mangadetail = await MangaThemeSia().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }
  /***********/
  /*mangakawaii*/
  /***********/
  else if (source.toLowerCase() == "mangakawaii") {
    mangadetail = await MangaKawaii().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.mmrcms) {
    mangadetail = await Mmrcms().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source.toLowerCase() == "mangahere") {
    mangadetail = await Mangahere().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source.toLowerCase() == "japscan") {
    mangadetail = await Japscan().getMangaDetail(
        imageUrl: imageUrl, url: url, title: title, lang: lang, source: source);
  }
  return mangadetail!;
}

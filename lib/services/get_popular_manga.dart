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
part 'get_popular_manga.g.dart';

@riverpod
Future<GetMangaModel> getPopularManga(GetPopularMangaRef ref,
    {required String source, required int page}) async {
  GetMangaModel? popularManga;
  source = source.toLowerCase();

  /*********/
  /*comick*/
  /*******/
  if (getWpMangTypeSource(source) == TypeSource.comick) {
    popularManga = await Comick().getPopularManga(source: source, page: page);
  }

  /***************/
  /*mangathemesia*/
  /**************/
  if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    popularManga =
        await MangaThemeSia().getPopularManga(source: source, page: page);
  }

  /***********/
  /*mangakawaii*/
  /***********/
  if (source == "mangakawaii") {
    popularManga =
        await MangaKawaii().getPopularManga(source: source, page: page);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source) == TypeSource.mmrcms) {
    popularManga = await Mmrcms().getPopularManga(source: source, page: page);
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    popularManga =
        await Mangahere().getPopularManga(source: source, page: page);
  }
  /***********/
  /*japscan*/
  /***********/
  else if (source == "japscan") {
    popularManga = await Japscan().getPopularManga(source: source, page: page);
  }
  return popularManga!;
}

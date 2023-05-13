// ignore_for_file: depend_o
import 'dart:async';
import 'dart:io';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_chapter_url.g.dart';

class GetMangaChapterUrlModel {
  Directory? path;
  List pageUrls = [];
  List<bool> isLocaleList = [];
  GetMangaChapterUrlModel(
      {required this.path, required this.pageUrls, required this.isLocaleList});
}

@riverpod
Future<GetMangaChapterUrlModel> getMangaChapterUrl(
  GetMangaChapterUrlRef ref, {
  required Chapter chapter,
}) async {
  Directory? path;
  List pageUrls = [];
  final manga = chapter.manga.value!;
  List<bool> isLocaleList = [];
  String source = manga.source!.toLowerCase();
  List hivePagesUrls = ref.watch(hiveBoxMangaProvider).get(
      "${manga.lang}-${manga.source}/${manga.name}/${chapter.name}-pageurl",
      defaultValue: []);
  final incognitoMode = ref.watch(incognitoModeStateProvider);
  path = await StorageProvider().getMangaChapterDirectory(chapter);

  if (hivePagesUrls.isNotEmpty) {
    pageUrls = hivePagesUrls;
  }

  /*********/
  /*comick*/
  /********/

  else if (getMangaTypeSource(source) == TypeSource.comick) {
    pageUrls = await Comick().getMangaChapterUrl(chapter: chapter);
  }

  /*************/
  /*mangathemesia*/
  /**************/

  else if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
    pageUrls = await MangaThemeSia().getMangaChapterUrl(chapter: chapter);
  }

  /***********/
  /*mangakawaii*/
  /***********/

  else if (source == 'mangakawaii') {
    pageUrls = await MangaKawaii().getMangaChapterUrl(chapter: chapter);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
    pageUrls = await Mmrcms().getMangaChapterUrl(chapter: chapter);
  }

  /***********/
  /*mangahere*/
  /***********/

  else if (source == 'mangahere') {
    pageUrls = await Mangahere().getMangaChapterUrl(chapter: chapter);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source == 'japscan') {
    pageUrls = await Japscan().getMangaChapterUrl(chapter: chapter);
  }

  /***********/
  /*heancms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.heancms) {
    pageUrls = await HeanCms().getMangaChapterUrl(chapter: chapter);
  }

  if (pageUrls.isNotEmpty) {
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaProvider).put(
          "${manga.lang}-${manga.source}/${manga.name}/${chapter.name}-pageurl",
          pageUrls);
    }
    for (var i = 0; i < pageUrls.length; i++) {
      if (await File("${path!.path}" "${padIndex(i + 1)}.jpg").exists()) {
        isLocaleList.add(true);
      } else {
        isLocaleList.add(false);
      }
    }
  }

  return GetMangaChapterUrlModel(
      path: path, pageUrls: pageUrls, isLocaleList: isLocaleList);
}

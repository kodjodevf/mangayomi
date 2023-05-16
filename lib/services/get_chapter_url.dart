// ignore_for_file: depend_o
import 'dart:async';
import 'dart:io';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
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
part 'get_chapter_url.g.dart';

class GetChapterUrlModel {
  Directory? path;
  List pageUrls = [];
  List<bool> isLocaleList = [];
  GetChapterUrlModel(
      {required this.path, required this.pageUrls, required this.isLocaleList});
}

@riverpod
Future<GetChapterUrlModel> getChapterUrl(
  GetChapterUrlRef ref, {
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
    pageUrls = await Comick().getChapterUrl(chapter: chapter);
  }

  /*************/
  /*mangathemesia*/
  /**************/

  else if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
    pageUrls = await MangaThemeSia().getChapterUrl(chapter: chapter);
  }

  /***********/
  /*mangakawaii*/
  /***********/

  else if (source == 'mangakawaii') {
    pageUrls = await MangaKawaii().getChapterUrl(chapter: chapter);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
    pageUrls = await Mmrcms().getChapterUrl(chapter: chapter);
  }

  /***********/
  /*mangahere*/
  /***********/

  else if (source == 'mangahere') {
    pageUrls = await Mangahere().getChapterUrl(chapter: chapter);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source == 'japscan') {
    pageUrls = await Japscan().getChapterUrl(chapter: chapter);
  }

  /***********/
  /*heancms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.heancms) {
    pageUrls = await HeanCms().getChapterUrl(chapter: chapter);
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

  return GetChapterUrlModel(
      path: path, pageUrls: pageUrls, isLocaleList: isLocaleList);
}

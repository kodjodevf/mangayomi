// ignore_for_file: depend_o
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/manga/reader/manga_reader_view.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms.dart';
import 'package:mangayomi/sources/multisrc/madara/src/madara.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/all/mangadex/src/mangadex.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_chapter_url.g.dart';

class GetChapterUrlModel {
  Directory? path;
  List<String> pageUrls = [];
  List<bool> isLocaleList = [];
  List<Uint8List?> archiveImages = [];
  List<UChapDataPreload> uChapDataPreload;
  GetChapterUrlModel(
      {required this.path,
      required this.pageUrls,
      required this.isLocaleList,
      required this.archiveImages,
      required this.uChapDataPreload});
}

@riverpod
Future<GetChapterUrlModel> getChapterUrl(
  GetChapterUrlRef ref, {
  required Chapter chapter,
}) async {
  List<UChapDataPreload> uChapDataPreloadp = [];
  Directory? path;
  List<String> pageUrls = [];
  final manga = chapter.manga.value!;
  List<bool> isLocaleList = [];
  String source = manga.source!.toLowerCase();
  final settings = isar.settings.getSync(227);
  List<ChapterPageurls>? chapterPageUrlsList =
      settings!.chapterPageUrlsList ?? [];
  final isarPageUrls =
      chapterPageUrlsList.where((element) => element.chapterId == chapter.id);
  final incognitoMode = ref.watch(incognitoModeStateProvider);
  final storageProvider = StorageProvider();
  path = await storageProvider.getMangaChapterDirectory(chapter);
  final mangaDirectory = await storageProvider.getMangaMainDirectory(chapter);

  List<Uint8List?> archiveImages = [];
  final isLocalArchive = (chapter.archivePath ?? '').isNotEmpty;
  if (!chapter.manga.value!.isLocalArchive!) {
    if (isarPageUrls.isNotEmpty &&
        isarPageUrls.first.urls != null &&
        isarPageUrls.first.urls!.isNotEmpty) {
      pageUrls = isarPageUrls.first.urls!;
    }

    /*********/
    /*comick*/
    /********/

    else if (getMangaTypeSource(source) == TypeSource.comick) {
      pageUrls = await Comick().getChapterUrl(chapter: chapter, ref: ref);
    }

    /*************/
    /*mangathemesia*/
    /**************/

    else if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
      pageUrls =
          await MangaThemeSia().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*mangakawaii*/
    /***********/

    else if (source == 'mangakawaii') {
      pageUrls = await MangaKawaii().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*mmrcms*/
    /***********/

    else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
      pageUrls = await Mmrcms().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*mangahere*/
    /***********/

    else if (source == 'mangahere') {
      pageUrls = await Mangahere().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*japscan*/
    /***********/

    else if (source == 'japscan') {
      pageUrls = await Japscan().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*heancms*/
    /***********/

    else if (getMangaTypeSource(source) == TypeSource.heancms) {
      pageUrls = await HeanCms().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*madara*/
    /***********/

    else if (getMangaTypeSource(source) == TypeSource.madara) {
      pageUrls = await Madara().getChapterUrl(chapter: chapter, ref: ref);
    }

    /***********/
    /*mangadex*/
    /***********/

    else if (getMangaTypeSource(source) == TypeSource.mangadex) {
      pageUrls = await MangaDex().getChapterUrl(chapter: chapter, ref: ref);
    }
  }

  if (pageUrls.isNotEmpty || isLocalArchive) {
    if (await File("${mangaDirectory!.path}${chapter.name}.cbz").exists() ||
        isLocalArchive) {
      final path = isLocalArchive
          ? chapter.archivePath
          : "${mangaDirectory.path}${chapter.name}.cbz";
      final local =
          await ref.watch(getArchiveDataFromFileProvider(path!).future);
      for (var image in local.images!) {
        archiveImages.add(image.image!);
        isLocaleList.add(true);
      }
    } else {
      for (var i = 0; i < pageUrls.length; i++) {
        archiveImages.add(null);
        if (await File("${path!.path}" "${padIndex(i + 1)}.jpg").exists()) {
          isLocaleList.add(true);
        } else {
          isLocaleList.add(false);
        }
      }
    }
    if (isLocalArchive) {
      for (var i = 0; i < archiveImages.length; i++) {
        pageUrls.add("");
      }
    }
    if (!incognitoMode) {
      List<ChapterPageurls>? chapterPageUrls = [];
      for (var chapterPageUrl in settings.chapterPageUrlsList ?? []) {
        if (chapterPageUrl.chapterId != chapter.id) {
          chapterPageUrls.add(chapterPageUrl);
        }
      }
      chapterPageUrls.add(ChapterPageurls()
        ..chapterId = chapter.id
        ..urls = pageUrls);
      isar.writeTxnSync(() => isar.settings
          .putSync(settings..chapterPageUrlsList = chapterPageUrls));
    }
    for (var i = 0; i < pageUrls.length; i++) {
      uChapDataPreloadp.add(UChapDataPreload(
          chapter,
          path,
          pageUrls[i],
          isLocaleList[i],
          archiveImages[i],
          i,
          false,
          false,
          GetChapterUrlModel(
              path: path,
              pageUrls: pageUrls,
              isLocaleList: isLocaleList,
              archiveImages: archiveImages,
              uChapDataPreload: uChapDataPreloadp)));
    }
  }

  return GetChapterUrlModel(
      path: path,
      pageUrls: pageUrls,
      isLocaleList: isLocaleList,
      archiveImages: archiveImages,
      uChapDataPreload: uChapDataPreloadp);
}

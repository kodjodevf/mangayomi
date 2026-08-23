import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:path/path.dart' as p;
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/settings_write.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_chapter_pages.g.dart';

class GetChapterPagesModel {
  Directory? path;
  List<PageUrl> pageUrls = [];
  List<bool> isLocaleList = [];
  List<Uint8List?> archiveImages = [];
  List<UChapDataPreload> uChapDataPreload;
  GetChapterPagesModel({
    required this.path,
    required this.pageUrls,
    required this.isLocaleList,
    required this.archiveImages,
    required this.uChapDataPreload,
  });
}

@riverpod
Future<GetChapterPagesModel> getChapterPages(
  Ref ref, {
  required Chapter chapter,
}) async {
  final keepAlive = ref.keepAlive();
  try {
    Directory? path;
    List<PageUrl> pageUrls = [];
    List<bool> isLocaleList = [];
    final settings = isar.settings.getSync(227);
    List<ChapterPageurls>? chapterPageUrlsList =
        settings!.chapterPageUrlsList ?? [];
    final isarPageUrls = chapterPageUrlsList
        .where((element) => element.chapterId == chapter.id)
        .firstOrNull;
    final incognitoMode = ref.read(incognitoModeStateProvider);
    final storageProvider = StorageProvider();
    final mangaDirectory = await storageProvider.getMangaMainDirectory(chapter);
    path = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDirectory,
    );

    List<Uint8List?> archiveImages = [];
    bool pagesFromCache = false;
    final isLocalArchive = (chapter.archivePath ?? '').isNotEmpty;
    final resolvedArchivePath = isLocalArchive
        ? await resolveLocalArchivePath(chapter.archivePath!)
        : null;

    // A downloaded chapter has to open from disk, not from its source. Finding
    // the local copy before any network call is what lets it open with the
    // extension uninstalled, the site down, or no connection at all: getPageList
    // used to run first and its failure took the whole chapter down even though
    // every page was already on disk.
    final downloaded = isLocalArchive
        ? null
        : await findDownloadedChapter(chapter);
    if (downloaded?.pagesDirectory != null) path = downloaded!.pagesDirectory;

    if (!chapter.manga.value!.isLocalArchive!) {
      if ((isarPageUrls?.urls?.isNotEmpty ?? false) &&
          (isarPageUrls?.chapterUrl ?? chapter.url) == chapter.url) {
        pagesFromCache = true;
        for (var i = 0; i < isarPageUrls!.urls!.length; i++) {
          Map<String, String>? headers;
          if (isarPageUrls.headers?.isNotEmpty ?? false) {
            headers = (jsonDecode(
              isarPageUrls.headers![i],
            ) as Map?)?.toMapStringString;
          }
          pageUrls.add(PageUrl(isarPageUrls.urls![i], headers: headers));
        }
      } else if (downloaded == null) {
        // Only ask the source when there is nothing on disk to read. The
        // extension is also resolved here rather than above, so a missing one
        // can't take down a chapter that never needed it.
        final source = getSource(
          chapter.manga.value!.lang!,
          chapter.manga.value!.source!,
          chapter.manga.value!.sourceId,
        )!;
        pageUrls = await getIsolateService.get<List<PageUrl>>(
          url: chapter.url!,
          source: source,
          serviceType: 'getPageList',
          proxyServer: ref.read(androidProxyServerStateProvider),
        );
      }
    }

    final chapterModel = GetChapterPagesModel(
      path: path,
      pageUrls: pageUrls,
      isLocaleList: isLocaleList,
      archiveImages: archiveImages,
      uChapDataPreload: [],
    );

    final archivePath = isLocalArchive
        ? resolvedArchivePath
        : downloaded?.archive?.path;

    if (pageUrls.isNotEmpty || archivePath != null || downloaded != null) {
      if (archivePath != null) {
        final local = await ref.read(
          getArchiveDataFromFileProvider(archivePath).future,
        );
        for (var image in local.images!) {
          archiveImages.add(image.image!);
          isLocaleList.add(true);
        }
      } else {
        // With no urls from the cache and none from the source, the folder on
        // disk is the only thing that knows how many pages there are.
        final pageCount = pageUrls.isNotEmpty
            ? pageUrls.length
            : downloaded!.pageCount;
        for (var i = 0; i < pageCount; i++) {
          archiveImages.add(null);
          if (await File(p.join(path!.path, '${padIndex(i)}.jpg')).exists()) {
            isLocaleList.add(true);
          } else {
            isLocaleList.add(false);
          }
        }
      }
      // The reader indexes pageUrls, isLocaleList and archiveImages together,
      // so the three have to agree: local pages carry no url, and an archive
      // is the authority on how many pages the chapter actually has.
      if (pageUrls.length > isLocaleList.length) {
        pageUrls.removeRange(isLocaleList.length, pageUrls.length);
      } else {
        for (var i = pageUrls.length; i < isLocaleList.length; i++) {
          pageUrls.add(PageUrl(""));
        }
      }
      if (isLocalArchive) {
        // Archives store placeholder urls only for the page count; skip the
        // write when the stored entry already matches.
        if ((isarPageUrls?.urls?.length ?? -1) == pageUrls.length &&
            (isarPageUrls?.chapterUrl ?? chapter.url) == chapter.url) {
          pagesFromCache = true;
        }
      }
      // Persisting the page-URL cache rewrites the entire (large) settings
      // row, so only do it when there is something new to store — never when
      // the pages came from that cache. The cache is also capped to the most
      // recent chapters so the row doesn't grow with reading history.
      // A downloaded chapter's urls are placeholders; storing them would make
      // it unreadable online once the download is deleted.
      if (!incognitoMode && !pagesFromCache && downloaded == null) {
        const maxCachedChapters = 40;
        final chapterPageHeaders = pageUrls
            .map((e) => e.headers == null ? null : jsonEncode(e.headers))
            .toList();
        // Re-read the row here rather than reuse the one loaded at the top of
        // this function. Fetching the pages ran several awaits, and writing the
        // row puts all of it back, so the old copy would undo every setting
        // changed while the chapter was loading.
        updateSettings((settings) {
          final chapterPageUrls = <ChapterPageurls>[];
          for (final chapterPageUrl in settings.chapterPageUrlsList ?? []) {
            if (chapterPageUrl.chapterId != chapter.id) {
              chapterPageUrls.add(chapterPageUrl);
            }
          }
          chapterPageUrls.add(
            ChapterPageurls()
              ..chapterId = chapter.id
              ..urls = pageUrls.map((e) => e.url).toList()
              ..chapterUrl = chapter.url
              ..headers = chapterPageHeaders.first != null
                  ? chapterPageHeaders.map((e) => e.toString()).toList()
                  : null,
          );
          if (chapterPageUrls.length > maxCachedChapters) {
            chapterPageUrls.removeRange(
              0,
              chapterPageUrls.length - maxCachedChapters,
            );
          }
          settings.chapterPageUrlsList = chapterPageUrls;
        });
      }
      for (var i = 0; i < pageUrls.length; i++) {
        chapterModel.uChapDataPreload.add(
          UChapDataPreload(
            chapter,
            path,
            pageUrls[i],
            isLocaleList[i],
            archiveImages[i],
            i,
            chapterModel,
            i,
          ),
        );
      }
    }
    keepAlive.close();
    return chapterModel;
  } catch (e) {
    keepAlive.close();
    rethrow;
  }
}

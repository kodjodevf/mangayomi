import 'dart:io';
import 'dart:typed_data';

import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_chapter_pages.g.dart';

class GetChapterPagesModel {
  Directory? path;
  List<PageUrl> pageUrls = [];
  List<bool> isLocaleList = [];
  List<Uint8List?> archiveImages = [];
  // Parallel to archiveImages: the real on-disk path for pages that are
  // standalone files (local image-folder chapters), so they never have to be
  // read into memory just to get a path back out. Null for every page that
  // isn't a plain folder page (archive entries, downloaded/remote pages).
  List<String?> localImagePaths = [];
  List<UChapDataPreload> uChapDataPreload;
  GetChapterPagesModel({
    required this.path,
    required this.pageUrls,
    required this.isLocaleList,
    required this.archiveImages,
    required this.uChapDataPreload,
    required this.localImagePaths,
  });
}

@riverpod
Future<GetChapterPagesModel> getChapterPages(
  Ref ref, {
  required Chapter chapter,
  bool forceRefresh = false,
}) async {
  final keepAlive = ref.keepAlive();
  try {
    Directory? path;
    List<PageUrl> pageUrls = [];
    List<bool> isLocaleList = [];
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
      final chapterCache = ChapterCache();
      final cachedPages = (!forceRefresh && downloaded == null)
          ? await chapterCache.getPageListFromCache(chapter)
          : null;

      if (cachedPages != null && cachedPages.isNotEmpty) {
        pagesFromCache = true;
        pageUrls = cachedPages;
      } else if (downloaded == null) {
        // Only ask the source when there is nothing on disk to read. The
        // extension is also resolved here rather than above, so a missing one
        // can't take down a chapter that never needed it.
        final source = getSource(
          chapter.manga.value!.lang!,
          chapter.manga.value!.source!,
          chapter.manga.value!.sourceId,
          installedOnly: true,
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
      localImagePaths: <String?>[],
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
          // Folder pages carry a real path instead of pre-read bytes (see
          // LocalImage.path) - keep archiveImages/localImagePaths parallel
          // to isLocaleList so index i always refers to the same page across
          // all three lists.
          archiveImages.add(image.image);
          chapterModel.localImagePaths.add(image.path);
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
          chapterModel.localImagePaths.add(null);
          if (await findDownloadedPageFileAsync(path!, i) != null) {
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
      if (!incognitoMode &&
          !pagesFromCache &&
          downloaded == null &&
          pageUrls.isNotEmpty) {
        await ChapterCache().putPageListToCache(chapter, pageUrls);
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
            localImagePath: i < chapterModel.localImagePaths.length
                ? chapterModel.localImagePaths[i]
                : null,
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

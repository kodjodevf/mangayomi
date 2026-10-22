import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/local_folders.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/extensions/others.dart';

/// Handles background chapter preloading, evicted archive page reloading,
/// ordered image prefetching, and wide-page splitting for the manga reader.
mixin ReaderPrefetchMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, ReaderMemoryManagement {
  bool isNextChapterPreloading = false;
  int _prefetchSessionId = 0;
  bool isLastPageTransition = false;
  final List<int> cropBorderCheckList = [];
  Timer? evictionAndPrefetchDebounce;

  int get pagePreloadAmount => ref.read(pagePreloadAmountStateProvider);

  Chapter get activeChapterForPrefetch;
  ReaderController get activeReaderControllerForPrefetch;
  int? get currentPrefetchPageViewIndex;
  bool get isReverseHorizontalForPrefetch;
  bool get isDoublePageActiveForPrefetch;
  int pageViewToActualIndexSyncForPrefetch(int pageViewIndex);

  void disposePrefetchMixin() {
    evictionAndPrefetchDebounce?.cancel();
  }

  void addLastPageTransition(Chapter chap) {
    if (isLastPageTransition) return;
    try {
      if (!mounted || pageCount == 0) return;
      if (pages.last.isLastChapter ?? false) return;

      final added = addLastChapterTransition(chap);
      if (added && mounted) {
        setState(() {
          isLastPageTransition = true;
        });
      }
    } catch (_) {}
  }

  void preloadNextChapterData(GetChapterPagesModel chapterData, Chapter chap) {
    try {
      if (chapterData.uChapDataPreload.isEmpty || !mounted) return;

      final firstChapter = chapterData.uChapDataPreload.first.chapter;
      if (firstChapter == null) return;

      preloadNextChapter(chapterData, chap).then((success) {
        if (success && mounted) {
          setState(() {});
        }
      });
    } catch (_) {}
  }

  /// Proactively starts loading adjacent chapters at reader init.
  void proactivePreload() {
    triggerNextChapterPreload();
  }

  /// Fires off next-chapter page fetching if not already in progress.
  Future<void> triggerNextChapterPreload() async {
    if (isNextChapterPreloading || isLastPageTransition) return;
    isNextChapterPreloading = true;
    final chapter = activeChapterForPrefetch;
    try {
      if (!mounted) {
        isNextChapterPreloading = false;
        return;
      }
      final nextChapter = activeReaderControllerForPrefetch.getNextChapter();
      if (isChapterLoaded(nextChapter)) {
        isNextChapterPreloading = false;
        return;
      }
      final value = await ref.read(
        getChapterPagesProvider(chapter: nextChapter).future,
      );
      if (mounted) {
        preloadNextChapterData(value, chapter);
      }
      isNextChapterPreloading = false;
    } on RangeError {
      isNextChapterPreloading = false;
      addLastPageTransition(chapter);
    } catch (_) {
      isNextChapterPreloading = false;
    }
  }

  /// Reloads a chapter's page image data if it was previously evicted by
  /// [ChapterPreloadManager.evictOldChapters].
  Future<void> checkAndReloadEvictedPages(Chapter currentChapter) async {
    if (!preloadManager.isChapterEvicted(currentChapter)) return;

    final chapterId = currentChapter.id;
    bool needsReload = false;
    for (final page in pages) {
      if (page.chapter?.id == chapterId &&
          !page.isTransitionPage &&
          page.isLocale == true &&
          page.archiveImage == null &&
          page.localImagePath == null) {
        needsReload = true;
        break;
      }
    }

    if (needsReload) {
      final isLocalArchive = (currentChapter.archivePath ?? '').isNotEmpty;
      final archivePath = isLocalArchive
          ? await resolveLocalArchivePath(currentChapter.archivePath!)
          : (await findDownloadedChapter(currentChapter))?.archive?.path;

      if (archivePath != null && await File(archivePath).exists()) {
        try {
          final local = await ref.read(
            getArchiveDataFromFileProvider(archivePath).future,
          );
          final images = local.images ?? [];
          for (final page in pages) {
            final imgIdx = page.index;
            if (page.chapter?.id == currentChapter.id &&
                !page.isTransitionPage &&
                imgIdx != null &&
                imgIdx < images.length) {
              page.archiveImage = images[imgIdx].image;
            }
          }
          preloadManager.markChapterAsLoaded(currentChapter);
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error reloading evicted chapter pages: $e');
          }
        }
      }
    }
  }

  /// Warms Flutter's [ImageCache] and pre-resolves each page's
  /// local/archive file path in reading order before the widget tree renders.
  Future<void> prefetchPagesInOrder() async {
    final sessionId = ++_prefetchSessionId;
    if (pages.isEmpty) return;
    final actualIdx = pageViewToActualIndexSyncForPrefetch(
      currentPrefetchPageViewIndex ?? 0,
    );
    final startIdx = actualIdx.clamp(0, pages.length - 1);

    final preloadAmount = ref.read(pagePreloadAmountStateProvider);
    final forwardLimit = (startIdx + preloadAmount).clamp(0, pages.length - 1);
    final backwardLimit = (startIdx - 2).clamp(0, pages.length - 1);

    final indices = [
      for (var i = startIdx; i <= forwardLimit; i++) i,
      for (var i = startIdx - 1; i >= backwardLimit; i--) i,
    ];

    final queue = List<int>.from(indices);

    Future<void> worker() async {
      while (queue.isNotEmpty) {
        if (sessionId != _prefetchSessionId || !mounted) return;
        final i = queue.removeAt(0);
        if (i >= pages.length) continue;
        final page = pages[i];
        if (page.isTransitionPage) continue;
        try {
          if (page.resolvedFilePath == null) {
            final path = await page.getLocalFilePath;
            if (path != null) {
              page.resolvedFilePath = path;
            }
          }

          final provider = page.getImageProvider(ref, true);
          if (provider is CustomExtendedNetworkImageProvider) {
            await provider.getNetworkImageData();
            if (page.resolvedFilePath == null) {
              final path = await page.getLocalFilePath;
              if (path != null) {
                page.resolvedFilePath = path;
              }
            }
          }
        } catch (_) {}
      }
    }

    await Future.wait([worker(), worker(), worker()]);
  }

  Future<void> handleEvictionsAndPrefetch() async {
    final chapter = activeChapterForPrefetch;
    await checkAndReloadEvictedPages(chapter);

    final evictedIndices = preloadManager.evictOldChapters(chapter);
    for (final evictedIdx in evictedIndices) {
      cropBorderCheckList.remove(evictedIdx);
    }

    unawaited(prefetchPagesInOrder());
  }

  void scheduleEvictionsAndPrefetch() {
    evictionAndPrefetchDebounce?.cancel();
    evictionAndPrefetchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      handleEvictionsAndPrefetch();
    });
  }

  void splitWidePage(int index, double width, double height) {
    if (index < 0 || index >= pages.length) return;
    final page = pages[index];
    if (page.srcRect != null || page.isTransitionPage) return;
    if (isDoublePageActiveForPrefetch) return;

    final isRTL = isReverseHorizontalForPrefetch;
    final dualPageInvert = ref.read(dualPageInvertStateProvider);
    final shouldInvert = isRTL ^ dualPageInvert;
    final halfWidth = width / 2;

    final Rect firstRect;
    final Rect secondRect;

    if (shouldInvert) {
      firstRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(0, 0, halfWidth, height);
    } else {
      firstRect = Rect.fromLTWH(0, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
    }

    final page1 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: firstRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    final page2 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: secondRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    setState(() {
      preloadManager.splitPage(index, page1, page2);
    });
  }
}

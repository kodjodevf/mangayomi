import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

/// Encapsulates double-page spread index conversions, orientation-aware
/// [PageMode] resolution, and dispose-safe synchronous index math for the
/// manga reader.
mixin ReaderDoublePageMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, ReaderMemoryManagement {
  Chapter get activeChapterForDoublePage;
  ReaderController get activeReaderControllerForDoublePage;
  GetChapterPagesModel get activeChapterUrlModelForDoublePage;
  ReaderMode get cachedReaderMode;
  ReaderMode? get activeReaderMode;
  PageMode get configuredPageMode;
  Orientation? get lastKnownOrientation;
  int? get currentDoublePageViewIndex;
  int get currentDoublePageDisplayIndex;

  /// Live inputs for [ReaderPageIndexMath], read via the current provider
  /// state. Not safe to call during dispose — use [indexMathSync] there.
  ReaderPageIndexMath get indexMath => ReaderPageIndexMath(
    isDoublePageActive: isDoublePageActive,
    singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
    pageCount: pages.length,
    pages: pages,
  );

  /// Same as [indexMath] but sourced entirely from cached/settings-only
  /// state, safe to call during dispose (reading a provider there would hit
  /// a Riverpod assertion error).
  ReaderPageIndexMath get indexMathSync => ReaderPageIndexMath(
    isDoublePageActive: isDoublePageActiveSync,
    singleFirst: settingsRepository.current.doublePageSingleFirstPage ?? false,
    pageCount: pages.length,
    pages: pages,
  );

  /// [index] is the page within the current chapter, as held by
  /// [currentDoublePageDisplayIndex] and the bottom bar slider.
  String currentIndexLabel(int index) => indexMath.chapterPageLabel(
    index,
    activeChapterForDoublePage.id,
    activeReaderControllerForDoublePage.getCachedPageLength(
      activeChapterUrlModelForDoublePage.pageUrls,
    ),
  );

  /// Where page [pageInChapter] of the current chapter sits in [pages], or
  /// -1 if it is not loaded.
  int actualIndexOfChapterPage(int pageInChapter) => pages.indexWhere(
    (p) =>
        !p.isTransitionPage &&
        p.chapter?.id == activeChapterForDoublePage.id &&
        p.index == pageInChapter,
  );

  /// Effective [PageMode] accounting for automatic double-page orientation detection.
  PageMode get effectivePageMode {
    final auto = ref.read(doublePageAutoStateProvider);
    if (auto && mounted) {
      final orientation =
          lastKnownOrientation ??
          (context.mounted ? MediaQuery.maybeOrientationOf(context) : null);
      if (orientation != null) {
        return orientation == Orientation.landscape
            ? PageMode.doublePage
            : PageMode.onePage;
      }
    }
    return configuredPageMode;
  }

  /// Safe version of [effectivePageMode] for use during dispose.
  PageMode get effectivePageModeSync {
    final auto = settingsRepository.current.doublePageAuto ?? false;
    if (auto) {
      final orientation =
          lastKnownOrientation ??
          (mounted && context.mounted
              ? MediaQuery.maybeOrientationOf(context)
              : null);
      if (orientation != null) {
        return orientation == Orientation.landscape
            ? PageMode.doublePage
            : PageMode.onePage;
      }
    }
    return configuredPageMode;
  }

  /// Whether double page mode is active (continuous or paged).
  /// Horizontal continuous mode does NOT use double page layout.
  /// Uses ref.read() so cannot be called during dispose.
  bool get isDoublePageActive {
    final currentMode = activeReaderMode ?? cachedReaderMode;
    return effectivePageMode == PageMode.doublePage &&
        !currentMode.isHorizontalContinuous;
  }

  /// Safe version of [isDoublePageActive] that uses cached reader mode.
  /// Safe to call during dispose without Riverpod assertion errors.
  bool get isDoublePageActiveSync =>
      effectivePageModeSync == PageMode.doublePage &&
      !cachedReaderMode.isHorizontalContinuous;

  /// Converts a page view index (from ExtendedPageController) to the actual
  /// index in the [pages] array for double page mode.
  int pageViewToActualIndex(int pageViewIndex) =>
      indexMath.pageViewToActualIndex(pageViewIndex);

  /// Safe version that uses cached reader mode for use in dispose.
  int pageViewToActualIndexSync(int pageViewIndex) =>
      indexMathSync.pageViewToActualIndex(pageViewIndex);

  /// Converts an actual [pages] array index to a page view index
  /// for double page mode.
  int actualToPageViewIndex(int actualIndex) =>
      indexMath.actualToPageViewIndex(actualIndex);

  /// Safe version of [actualToPageViewIndex] that uses cached reader mode and repository settings.
  int actualToPageViewIndexSync(int actualIndex) =>
      indexMathSync.actualToPageViewIndex(actualIndex);

  /// Returns the actual index in the [pages] array for the currently viewed page.
  /// Unlike [currentDoublePageDisplayIndex] (which is local to the active chapter, e.g. 0..N),
  /// this index spans the full continuous [pages] array across preloaded chapters.
  int getCurrentPagesActualIndex([PageMode? fromMode]) {
    final effectiveMode = fromMode ?? effectivePageMode;
    final currentMode = activeReaderMode ?? cachedReaderMode;
    final isDouble =
        effectiveMode == PageMode.doublePage &&
        !currentMode.isHorizontalContinuous;
    final curPvIdx = currentDoublePageViewIndex;
    if (curPvIdx != null) {
      if (isDouble) {
        final math = ReaderPageIndexMath(
          isDoublePageActive: true,
          singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
          pageCount: pages.length,
          pages: pages,
        );
        final actual = math.pageViewToActualIndex(curPvIdx);
        if (actual >= 0 && actual < pages.length) {
          return actual;
        }
      } else {
        if (curPvIdx >= 0 && curPvIdx < pages.length) {
          return curPvIdx;
        }
      }
    }
    final displayIdx = currentDoublePageDisplayIndex;
    final foundIdx = pages.indexWhere(
      (p) =>
          p.chapter?.id == activeChapterForDoublePage.id &&
          p.index == displayIdx,
    );
    if (foundIdx != -1) return foundIdx;
    return 0;
  }

  /// Total page count as seen by the page view controller.
  /// In double page mode, each PV page shows 2 actual pages (except PV 0 if singleFirst).
  int get pageViewPageCount => indexMath.pageViewPageCount;

  bool isContinuousMode([ReaderMode? mode]) {
    final readerMode = mode ?? activeReaderMode ?? cachedReaderMode;
    return readerMode.isContinuous;
  }
}

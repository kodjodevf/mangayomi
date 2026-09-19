import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';

/// Represents a single on-screen spread in double-page mode.
/// [firstIndex] is the primary page's index in the `pages` array.
/// [secondIndex] is the optional paired page's index in the `pages` array.
/// For a transition page or an isolated single page, [secondIndex] is `null`.
class DoublePageSpread {
  final int firstIndex;
  final int? secondIndex;

  const DoublePageSpread(this.firstIndex, [this.secondIndex]);

  bool get isSingle => secondIndex == null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoublePageSpread &&
          runtimeType == other.runtimeType &&
          firstIndex == other.firstIndex &&
          secondIndex == other.secondIndex;

  @override
  int get hashCode => Object.hash(firstIndex, secondIndex);

  @override
  String toString() => 'DoublePageSpread($firstIndex, $secondIndex)';
}

/// Pure index-conversion math for the reader's double-page mode: converting
/// between a page-view index (what the `PageController` sees - one entry per
/// on-screen spread) and an actual index into the loaded `pages` array (one
/// entry per image).
///
/// When [pages] is supplied, spread grouping is chapter-aware:
/// - Transition pages are always placed on their own spread.
/// - A chapter's pages never pair across chapters or across transition pages.
/// - If [singleFirst] is true, the first page of each chapter is shown solo.
///
/// When [pages] is omitted, falls back to the classic index math for a single
/// continuous stream of pages.
class ReaderPageIndexMath {
  ReaderPageIndexMath({
    required this.isDoublePageActive,
    required this.singleFirst,
    required this.pageCount,
    this.pages,
  }) {
    if (isDoublePageActive && pages != null && pages!.isNotEmpty) {
      _cachedSpreads = buildSpreads(pages!, singleFirst: singleFirst);
    }
  }

  final bool isDoublePageActive;

  /// Whether a double-page spread's first page is shown alone (so pairing
  /// starts on the second page instead of the first).
  final bool singleFirst;

  /// Number of pages currently loaded (`pages.length`).
  final int pageCount;

  /// Optional full list of loaded pages. Enables chapter-boundary &
  /// transition-aware spread grouping.
  final List<UChapDataPreload>? pages;

  List<DoublePageSpread>? _cachedSpreads;

  /// Returns the precomputed spreads, or builds them if not cached.
  List<DoublePageSpread> get spreads {
    if (!isDoublePageActive) {
      return List.generate(pageCount, (i) => DoublePageSpread(i));
    }
    if (_cachedSpreads != null) return _cachedSpreads!;
    if (pages != null && pages!.isNotEmpty) {
      _cachedSpreads = buildSpreads(pages!, singleFirst: singleFirst);
      return _cachedSpreads!;
    }
    // Fallback when `pages` list object is not provided:
    return _buildSyntheticSpreads(pageCount, singleFirst: singleFirst);
  }

  /// Builds chapter-aware and transition-aware double page spreads.
  static List<DoublePageSpread> buildSpreads(
    List<UChapDataPreload> pages, {
    bool singleFirst = false,
  }) {
    if (pages.isEmpty) return const [];

    final List<DoublePageSpread> result = [];
    int i = 0;
    final n = pages.length;

    while (i < n) {
      final current = pages[i];

      // Transition pages always stand alone
      if (current.isTransitionPage) {
        result.add(DoublePageSpread(i));
        i++;
        continue;
      }

      // We are in a chapter run. Gather all consecutive content pages of the same chapter.
      final chapterId = current.chapter?.id;
      final int runStart = i;
      while (i < n &&
          !pages[i].isTransitionPage &&
          pages[i].chapter?.id == chapterId) {
        i++;
      }
      final int runEnd = i; // exclusive

      // Group this chapter's pages into spreads
      int cIdx = runStart;
      if (singleFirst && cIdx < runEnd) {
        result.add(DoublePageSpread(cIdx));
        cIdx++;
      }

      while (cIdx < runEnd) {
        final p1 = pages[cIdx];
        if (_isPageWide(p1)) {
          result.add(DoublePageSpread(cIdx));
          cIdx++;
          continue;
        }

        if (cIdx + 1 < runEnd) {
          final p2 = pages[cIdx + 1];
          if (_isPageWide(p2)) {
            result.add(DoublePageSpread(cIdx));
            cIdx++;
          } else {
            result.add(DoublePageSpread(cIdx, cIdx + 1));
            cIdx += 2;
          }
        } else {
          result.add(DoublePageSpread(cIdx));
          cIdx++;
        }
      }
    }

    return result;
  }

  /// Checks if a page is a wide / landscape image (two-page spread).
  static bool _isPageWide(UChapDataPreload page) {
    if (page.isTransitionPage) return false;
    final w = page.loadedWidth;
    final h = page.loadedHeight;
    if (w != null && h != null && h > 0) {
      return w > h;
    }
    return false;
  }

  /// Builds synthetic spreads for a homogeneous chapter without full page objects.
  static List<DoublePageSpread> _buildSyntheticSpreads(
    int count, {
    bool singleFirst = false,
  }) {
    if (count <= 0) return const [];
    final List<DoublePageSpread> result = [];
    int i = 0;
    if (singleFirst && count > 0) {
      result.add(DoublePageSpread(0));
      i = 1;
    }
    while (i < count) {
      if (i + 1 < count) {
        result.add(DoublePageSpread(i, i + 1));
        i += 2;
      } else {
        result.add(DoublePageSpread(i));
        i++;
      }
    }
    return result;
  }

  /// Converts a page-view index (from the `PageController`) to the actual
  /// index in the pages array.
  int pageViewToActualIndex(int pageViewIndex) {
    if (!isDoublePageActive) return pageViewIndex;
    if (pageCount == 0) return 0;

    final s = spreads;
    if (s.isEmpty) return 0;
    final clampedPv = pageViewIndex.clamp(0, s.length - 1);
    return s[clampedPv].firstIndex;
  }

  /// Converts an actual pages-array index to a page-view index.
  int actualToPageViewIndex(int actualIndex) {
    if (!isDoublePageActive) return actualIndex;
    if (pageCount == 0) return 0;

    final s = spreads;
    if (s.isEmpty) return 0;
    final clampedActual = actualIndex.clamp(0, pageCount - 1);

    for (int i = 0; i < s.length; i++) {
      final spread = s[i];
      if (spread.firstIndex == clampedActual ||
          spread.secondIndex == clampedActual) {
        return i;
      }
    }

    // If not found in a specific spread, fallback to closest
    for (int i = s.length - 1; i >= 0; i--) {
      if (s[i].firstIndex <= clampedActual) return i;
    }
    return 0;
  }

  /// Total page count as seen by the page-view controller.
  int get pageViewPageCount {
    if (!isDoublePageActive) return pageCount;
    if (pageCount == 0) return 0;
    return spreads.length;
  }

  /// The page-number label for the bottom bar / page indicator, e.g. "12"
  /// or "12-13" for a double-page spread. [totalPages] is the manga-visible
  /// page count (`ReaderController.getPageLength`), which can differ from
  /// [pageCount] (the loaded `pages` array length, e.g. while prefetching).
  String currentIndexLabel(int index, int totalPages) {
    if (index < 0) return "1";
    if (!isDoublePageActive) return "${index + 1}";

    // Use spread if available
    if (pages != null && pages!.isNotEmpty) {
      final pvIndex = actualToPageViewIndex(index);
      final s = spreads;
      if (pvIndex < s.length) {
        final spread = s[pvIndex];
        final p1Obj = spread.firstIndex < pages!.length ? pages![spread.firstIndex] : null;
        final p2Obj = (spread.secondIndex != null && spread.secondIndex! < pages!.length)
            ? pages![spread.secondIndex!]
            : null;

        if (p1Obj != null && p1Obj.isTransitionPage) {
          return "";
        }

        final p1Num = p1Obj?.index != null ? p1Obj!.index! + 1 : spread.firstIndex + 1;
        if (p2Obj == null || p2Obj.isTransitionPage || p2Obj.chapter?.id != p1Obj?.chapter?.id) {
          return "$p1Num";
        }
        final p2Num = p2Obj.index != null ? p2Obj.index! + 1 : (spread.secondIndex! + 1);
        return "$p1Num-$p2Num";
      }
    }

    if (singleFirst) {
      if (index == 0) return "1";
      final pv = (index + 1) ~/ 2;
      final p1 = pv * 2;
      final p2 = p1 + 1;
      return p2 > totalPages ? "$p1" : "$p1-$p2";
    } else {
      final pv = index ~/ 2;
      final p1 = pv * 2 + 1;
      final p2 = p1 + 1;
      return p2 > totalPages ? "$p1" : "$p1-$p2";
    }
  }
}

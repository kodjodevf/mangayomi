/// Pure index-conversion math for the reader's double-page mode: converting
/// between a page-view index (what the `PageController` sees - one entry per
/// on-screen spread) and an actual index into the loaded `pages` array (one
/// entry per image).
///
/// Kept dependency-free (no `ref`, no widget state) so the reader's State
/// class only has to gather the three inputs - it still owns *when* those
/// inputs are read live (via a provider) versus from cached/settings-only
/// state (needed for the "Sync" call sites, which run during `dispose()`
/// where reading a provider is unsafe).
class ReaderPageIndexMath {
  const ReaderPageIndexMath({
    required this.isDoublePageActive,
    required this.singleFirst,
    required this.pageCount,
  });

  final bool isDoublePageActive;

  /// Whether a double-page spread's first page is shown alone (so pairing
  /// starts on the second page instead of the first).
  final bool singleFirst;

  /// Number of pages currently loaded (`pages.length`).
  final int pageCount;

  /// Converts a page-view index (from the `PageController`) to the actual
  /// index in the pages array.
  ///
  /// In double-page mode:
  ///   With [singleFirst]:
  ///     PV 0 -> pages[0] (first page shown solo)
  ///     PV n (n>0) -> pages[2n-1] (first page of the pair)
  ///   Without [singleFirst]:
  ///     PV n -> pages[2n] (first page of the pair)
  int pageViewToActualIndex(int pageViewIndex) {
    if (!isDoublePageActive) return pageViewIndex;
    if (pageCount == 0) return 0;
    if (singleFirst) {
      if (pageViewIndex <= 0) return 0;
      final idx = pageViewIndex * 2 - 1;
      return idx.clamp(0, pageCount - 1);
    }
    return (pageViewIndex * 2).clamp(0, pageCount - 1);
  }

  /// Converts an actual pages-array index to a page-view index.
  int actualToPageViewIndex(int actualIndex) {
    if (!isDoublePageActive) return actualIndex;
    if (singleFirst) {
      if (actualIndex <= 0) return 0;
      return (actualIndex + 1) ~/ 2;
    }
    return actualIndex ~/ 2;
  }

  /// Total page count as seen by the page-view controller. In double-page
  /// mode, each page-view page shows 2 actual pages (except page-view 0 if
  /// [singleFirst]).
  int get pageViewPageCount {
    if (!isDoublePageActive) return pageCount;
    if (pageCount == 0) return 0;
    if (singleFirst) {
      return 1 + ((pageCount - 1) / 2).ceil();
    }
    return (pageCount / 2).ceil();
  }

  /// The page-number label for the bottom bar / page indicator, e.g. "12"
  /// or "12-13" for a double-page spread. [totalPages] is the manga-visible
  /// page count (`ReaderController.getPageLength`), which can differ from
  /// [pageCount] (the loaded `pages` array length, e.g. while prefetching).
  String currentIndexLabel(int index, int totalPages) {
    if (index < 0) return "1";
    if (!isDoublePageActive) return "${index + 1}";
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

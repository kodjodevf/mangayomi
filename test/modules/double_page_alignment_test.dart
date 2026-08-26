import 'package:flutter_test/flutter_test.dart';

// Standalone functions mimicking the exact mathematical logic used in ReaderView and ImageViewWebtoon

int computePageViewPageCount({
  required int totalPages,
  required bool isDoublePageActive,
  required bool singleFirst,
}) {
  if (!isDoublePageActive) return totalPages;
  if (totalPages == 0) return 0;
  if (singleFirst) {
    return 1 + ((totalPages - 1) / 2).ceil();
  }
  return (totalPages / 2).ceil();
}

int pageViewToActualIndex({
  required int pageViewIndex,
  required int totalPages,
  required bool isDoublePageActive,
  required bool singleFirst,
}) {
  if (!isDoublePageActive) return pageViewIndex;
  if (totalPages == 0) return 0;
  if (singleFirst) {
    if (pageViewIndex <= 0) return 0;
    final idx = pageViewIndex * 2 - 1;
    return idx.clamp(0, totalPages - 1);
  }
  return (pageViewIndex * 2).clamp(0, totalPages - 1);
}

int actualToPageViewIndex({
  required int actualIndex,
  required bool isDoublePageActive,
  required bool singleFirst,
}) {
  if (!isDoublePageActive) return actualIndex;
  if (singleFirst) {
    if (actualIndex <= 0) return 0;
    return (actualIndex + 1) ~/ 2;
  }
  return actualIndex ~/ 2;
}

String computeCurrentIndexLabel({
  required int actualIndex,
  required int totalPages,
  required bool isDoublePage,
  required bool singleFirst,
}) {
  if (!isDoublePage) {
    return '${actualIndex + 1}';
  }
  if (singleFirst) {
    if (actualIndex == 0) {
      return '1';
    }
    final pv = (actualIndex + 1) ~/ 2;
    final p1 = pv * 2;
    final p2 = p1 + 1;
    return p2 > totalPages ? '$p1' : '$p1-$p2';
  } else {
    final pv = actualIndex ~/ 2;
    final p1 = pv * 2 + 1;
    final p2 = p1 + 1;
    return p2 > totalPages ? '$p1' : '$p1-$p2';
  }
}

(int, int?) getDoublePagePairIndices({
  required int pageViewIndex,
  required int totalPages,
  required bool singleFirst,
}) {
  int index1;
  int? index2;
  if (singleFirst) {
    if (pageViewIndex == 0) {
      index1 = 0;
      index2 = null;
    } else {
      index1 = pageViewIndex * 2 - 1;
      index2 = index1 + 1;
    }
  } else {
    index1 = pageViewIndex * 2;
    index2 = index1 + 1;
  }
  return (
    index1 < totalPages ? index1 : -1,
    (index2 != null && index2 < totalPages) ? index2 : null,
  );
}

void main() {
  group('Double Page PageCount (Issue #167)', () {
    test('Standard double page count (singleFirst = false)', () {
      expect(computePageViewPageCount(totalPages: 0, isDoublePageActive: true, singleFirst: false), 0);
      expect(computePageViewPageCount(totalPages: 1, isDoublePageActive: true, singleFirst: false), 1);
      expect(computePageViewPageCount(totalPages: 2, isDoublePageActive: true, singleFirst: false), 1);
      expect(computePageViewPageCount(totalPages: 3, isDoublePageActive: true, singleFirst: false), 2);
      expect(computePageViewPageCount(totalPages: 4, isDoublePageActive: true, singleFirst: false), 2);
      expect(computePageViewPageCount(totalPages: 20, isDoublePageActive: true, singleFirst: false), 10);
      expect(computePageViewPageCount(totalPages: 21, isDoublePageActive: true, singleFirst: false), 11);
    });

    test('Shifted double page count (singleFirst = true)', () {
      expect(computePageViewPageCount(totalPages: 0, isDoublePageActive: true, singleFirst: true), 0);
      expect(computePageViewPageCount(totalPages: 1, isDoublePageActive: true, singleFirst: true), 1);
      expect(computePageViewPageCount(totalPages: 2, isDoublePageActive: true, singleFirst: true), 2); // p0 solo, p1 solo
      expect(computePageViewPageCount(totalPages: 3, isDoublePageActive: true, singleFirst: true), 2); // p0 solo, (p1, p2)
      expect(computePageViewPageCount(totalPages: 4, isDoublePageActive: true, singleFirst: true), 3); // p0 solo, (p1, p2), p3 solo
      expect(computePageViewPageCount(totalPages: 20, isDoublePageActive: true, singleFirst: true), 11); // p0 solo, 9 pairs, p19 solo
      expect(computePageViewPageCount(totalPages: 21, isDoublePageActive: true, singleFirst: true), 11); // p0 solo, 10 pairs
    });
  });

  group('Double Page Index Mapping (Issue #167)', () {
    test('pageViewToActualIndex mapping with singleFirst = false', () {
      const total = 20;
      expect(pageViewToActualIndex(pageViewIndex: 0, totalPages: total, isDoublePageActive: true, singleFirst: false), 0);
      expect(pageViewToActualIndex(pageViewIndex: 1, totalPages: total, isDoublePageActive: true, singleFirst: false), 2);
      expect(pageViewToActualIndex(pageViewIndex: 2, totalPages: total, isDoublePageActive: true, singleFirst: false), 4);
      expect(pageViewToActualIndex(pageViewIndex: 9, totalPages: total, isDoublePageActive: true, singleFirst: false), 18);
    });

    test('pageViewToActualIndex mapping with singleFirst = true', () {
      const total = 20;
      expect(pageViewToActualIndex(pageViewIndex: 0, totalPages: total, isDoublePageActive: true, singleFirst: true), 0); // page 0
      expect(pageViewToActualIndex(pageViewIndex: 1, totalPages: total, isDoublePageActive: true, singleFirst: true), 1); // page 1 (paired with 2)
      expect(pageViewToActualIndex(pageViewIndex: 2, totalPages: total, isDoublePageActive: true, singleFirst: true), 3); // page 3 (paired with 4)
      expect(pageViewToActualIndex(pageViewIndex: 3, totalPages: total, isDoublePageActive: true, singleFirst: true), 5); // page 5 (paired with 6)
      expect(pageViewToActualIndex(pageViewIndex: 10, totalPages: total, isDoublePageActive: true, singleFirst: true), 19); // page 19
    });

    test('actualToPageViewIndex mapping with singleFirst = false', () {
      expect(actualToPageViewIndex(actualIndex: 0, isDoublePageActive: true, singleFirst: false), 0);
      expect(actualToPageViewIndex(actualIndex: 1, isDoublePageActive: true, singleFirst: false), 0);
      expect(actualToPageViewIndex(actualIndex: 2, isDoublePageActive: true, singleFirst: false), 1);
      expect(actualToPageViewIndex(actualIndex: 3, isDoublePageActive: true, singleFirst: false), 1);
      expect(actualToPageViewIndex(actualIndex: 18, isDoublePageActive: true, singleFirst: false), 9);
      expect(actualToPageViewIndex(actualIndex: 19, isDoublePageActive: true, singleFirst: false), 9);
    });

    test('actualToPageViewIndex mapping with singleFirst = true', () {
      expect(actualToPageViewIndex(actualIndex: 0, isDoublePageActive: true, singleFirst: true), 0); // first page is alone in PV 0
      expect(actualToPageViewIndex(actualIndex: 1, isDoublePageActive: true, singleFirst: true), 1); // pages 1 and 2 are in PV 1
      expect(actualToPageViewIndex(actualIndex: 2, isDoublePageActive: true, singleFirst: true), 1);
      expect(actualToPageViewIndex(actualIndex: 3, isDoublePageActive: true, singleFirst: true), 2); // pages 3 and 4 are in PV 2
      expect(actualToPageViewIndex(actualIndex: 4, isDoublePageActive: true, singleFirst: true), 2);
      expect(actualToPageViewIndex(actualIndex: 19, isDoublePageActive: true, singleFirst: true), 10);
    });
  });

  group('Double Page Pair Construction (Issue #167)', () {
    test('singleFirst = true correctly isolates first page and pairs the rest', () {
      const total = 5;
      final pair0 = getDoublePagePairIndices(pageViewIndex: 0, totalPages: total, singleFirst: true);
      expect(pair0, (0, null)); // Page 1 alone

      final pair1 = getDoublePagePairIndices(pageViewIndex: 1, totalPages: total, singleFirst: true);
      expect(pair1, (1, 2)); // Pages 2 and 3

      final pair2 = getDoublePagePairIndices(pageViewIndex: 2, totalPages: total, singleFirst: true);
      expect(pair2, (3, 4)); // Pages 4 and 5
    });

    test('singleFirst = false pairs from the very first page', () {
      const total = 5;
      final pair0 = getDoublePagePairIndices(pageViewIndex: 0, totalPages: total, singleFirst: false);
      expect(pair0, (0, 1)); // Pages 1 and 2

      final pair1 = getDoublePagePairIndices(pageViewIndex: 1, totalPages: total, singleFirst: false);
      expect(pair1, (2, 3)); // Pages 3 and 4

      final pair2 = getDoublePagePairIndices(pageViewIndex: 2, totalPages: total, singleFirst: false);
      expect(pair2, (4, null)); // Page 5 alone at end
    });
  });

  group('Double Page Index Label (Issue #167)', () {
    test('Label formatting with singleFirst = false', () {
      const total = 20;
      expect(computeCurrentIndexLabel(actualIndex: 0, totalPages: total, isDoublePage: true, singleFirst: false), '1-2');
      expect(computeCurrentIndexLabel(actualIndex: 1, totalPages: total, isDoublePage: true, singleFirst: false), '1-2');
      expect(computeCurrentIndexLabel(actualIndex: 2, totalPages: total, isDoublePage: true, singleFirst: false), '3-4');
      expect(computeCurrentIndexLabel(actualIndex: 19, totalPages: total, isDoublePage: true, singleFirst: false), '19-20');
    });

    test('Label formatting with singleFirst = true', () {
      const total = 20;
      expect(computeCurrentIndexLabel(actualIndex: 0, totalPages: total, isDoublePage: true, singleFirst: true), '1');
      expect(computeCurrentIndexLabel(actualIndex: 1, totalPages: total, isDoublePage: true, singleFirst: true), '2-3');
      expect(computeCurrentIndexLabel(actualIndex: 2, totalPages: total, isDoublePage: true, singleFirst: true), '2-3');
      expect(computeCurrentIndexLabel(actualIndex: 3, totalPages: total, isDoublePage: true, singleFirst: true), '4-5');
      expect(computeCurrentIndexLabel(actualIndex: 19, totalPages: total, isDoublePage: true, singleFirst: true), '20');
    });
  });

  group('Double Page Startup & Mode Transition Consistency', () {
    test('Opening chapter in double page mode correctly maps saved actualIndex to pageViewIndex', () {
      // User saved reading progress is actual page 10 (0-indexed, so 11th page)
      const savedActualIndex = 10;

      // Standard double page (singleFirst = false):
      // Pages (0,1)->PV0, (2,3)->PV1, (4,5)->PV2, (6,7)->PV3, (8,9)->PV4, (10,11)->PV5
      final pvStandard = actualToPageViewIndex(
        actualIndex: savedActualIndex,
        isDoublePageActive: true,
        singleFirst: false,
      );
      expect(pvStandard, 5);

      // Verify that PV 5 maps back to the spread containing page 10
      final actualStandard = pageViewToActualIndex(
        pageViewIndex: pvStandard,
        totalPages: 20,
        isDoublePageActive: true,
        singleFirst: false,
      );
      expect(actualStandard, 10);

      // Shifted double page (singleFirst = true):
      // Page 0->PV0, (1,2)->PV1, (3,4)->PV2, (5,6)->PV3, (7,8)->PV4, (9,10)->PV5
      final pvSingleFirst = actualToPageViewIndex(
        actualIndex: savedActualIndex,
        isDoublePageActive: true,
        singleFirst: true,
      );
      expect(pvSingleFirst, 5);

      // Verify that PV 5 maps back to the spread containing page 10
      // In PV 5, the first page is 5 * 2 - 1 = 9 (pages 9 & 10)
      final actualSingleFirst = pageViewToActualIndex(
        pageViewIndex: pvSingleFirst,
        totalPages: 20,
        isDoublePageActive: true,
        singleFirst: true,
      );
      expect(actualSingleFirst, 9);
      final pair = getDoublePagePairIndices(
        pageViewIndex: pvSingleFirst,
        totalPages: 20,
        singleFirst: true,
      );
      expect(pair, (9, 10)); // exactly contains page 10
    });

    test('Toggling page mode preserves the active page', () {
      // Currently on actual page 7
      const currentActual = 7;

      // Switch from single page to double page (standard):
      final toDoubleStandard = actualToPageViewIndex(
        actualIndex: currentActual,
        isDoublePageActive: true,
        singleFirst: false,
      );
      expect(toDoubleStandard, 3); // Pair (6, 7) is in PV 3

      // Switch from single page to double page (single first):
      final toDoubleSingleFirst = actualToPageViewIndex(
        actualIndex: currentActual,
        isDoublePageActive: true,
        singleFirst: true,
      );
      expect(toDoubleSingleFirst, 4); // Pair (7, 8) is in PV 4

      // Switch from double page back to single page:
      final toSingle = currentActual;
      expect(toSingle, 7);
    });

    test('Toggling singleFirst while reading preserves the active page spread', () {
      // User is viewing actual page 6 (which is page 7 in 1-based)
      const currentActual = 6;

      // When singleFirst was false, PV was 3 (pages 6 and 7)
      final pvBefore = actualToPageViewIndex(
        actualIndex: currentActual,
        isDoublePageActive: true,
        singleFirst: false,
      );
      expect(pvBefore, 3);

      // User toggles singleFirst = true:
      final pvAfter = actualToPageViewIndex(
        actualIndex: currentActual,
        isDoublePageActive: true,
        singleFirst: true,
      );
      expect(pvAfter, 3); // (currentActual + 1) ~/ 2 = 7 ~/ 2 = 3 (pages 5 and 6)
      final pairAfter = getDoublePagePairIndices(
        pageViewIndex: pvAfter,
        totalPages: 20,
        singleFirst: true,
      );
      expect(pairAfter, (5, 6)); // still contains page 6!
    });
  });
}

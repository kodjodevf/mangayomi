import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/row_pan.dart';

/// A zoomed page taller than the screen is read row by row before the page
/// turns, from the keyboard (#120) and the tap zones (#578).
void main() {
  const view = Size(1000, 800);
  const shown = Size(2000, 2000);

  test('the next row is one screen down, from its start', () {
    // At the end of the first row, left to right.
    final target = rowPanTarget(
      translation: const Offset(-1000, 0),
      shown: shown,
      view: view,
      down: true,
      rightToLeft: false,
    );
    expect(target, const Offset(0, -800));
  });

  test('right to left, a row starts at the right edge', () {
    final target = rowPanTarget(
      translation: Offset.zero,
      shown: shown,
      view: view,
      down: true,
      rightToLeft: true,
    );
    expect(target, const Offset(-1000, -800));
  });

  test('the last row stops at the bottom of the page', () {
    final target = rowPanTarget(
      translation: const Offset(-1000, -800),
      shown: shown,
      view: view,
      down: true,
      rightToLeft: false,
    );
    expect(target, const Offset(0, -1200));
  });

  test('going back, the row above from its end, not past the top', () {
    final target = rowPanTarget(
      translation: const Offset(0, -500),
      shown: shown,
      view: view,
      down: false,
      rightToLeft: false,
    );
    expect(target, const Offset(-1000, 0));
  });

  test('a page no wider than the screen only moves down', () {
    final target = rowPanTarget(
      translation: const Offset(100, 0),
      shown: const Size(800, 2000),
      view: view,
      down: true,
      rightToLeft: false,
    );
    expect(target, const Offset(100, -800));
  });
}

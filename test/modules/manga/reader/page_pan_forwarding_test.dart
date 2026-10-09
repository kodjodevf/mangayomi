import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/src/page_pan_forwarding.dart';

void main() {
  group('a pan past the image edge scrolls the PageView with the finger', () {
    test('left-to-right reader: dragging left goes to the next page', () {
      expect(
        pageScrollDeltaForPan(AxisDirection.right, const Offset(-30, 0)),
        30,
      );
    });

    test('right-to-left reader: dragging right goes to the next page', () {
      // A reversed horizontal PageView. This used to scroll towards the
      // previous page, then snap back on release.
      expect(
        pageScrollDeltaForPan(AxisDirection.left, const Offset(30, 0)),
        30,
      );
      expect(
        pageScrollDeltaForPan(AxisDirection.left, const Offset(-30, 0)),
        -30,
      );
    });

    test('vertical reader follows vertical movement, not horizontal', () {
      expect(
        pageScrollDeltaForPan(AxisDirection.down, const Offset(40, -30)),
        30,
      );
      expect(
        pageScrollDeltaForPan(AxisDirection.up, const Offset(40, -30)),
        -30,
      );
    });
  });

  group('releasing the drag', () {
    test('a slow release settles on the nearest page', () {
      expect(settlePage(3.3, AxisDirection.right, Offset.zero), 3);
      expect(settlePage(3.7, AxisDirection.left, Offset.zero), 4);
    });

    test('a fling turns the page in its direction, even dragged a little', () {
      // Right-to-left: a fling to the right moves to the next page.
      expect(settlePage(3.1, AxisDirection.left, const Offset(800, 0)), 4);
      expect(settlePage(3.9, AxisDirection.left, const Offset(-800, 0)), 3);
      // Left-to-right: a fling to the left moves to the next page.
      expect(settlePage(3.1, AxisDirection.right, const Offset(-800, 0)), 4);
    });

    test('a fling without having moved the page stays on it', () {
      expect(settlePage(3, AxisDirection.left, const Offset(800, 0)), 3);
    });
  });
}

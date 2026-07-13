import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';

void main() {
  group('ReaderMode capabilities', () {
    test('keeps Vertical Continuous and Webtoon concrete modes separate', () {
      expect(ReaderMode.verticalContinuous.isVerticalContinuous, isTrue);
      expect(ReaderMode.webtoon.isVerticalContinuous, isFalse);
      expect(ReaderMode.webtoon.isWebtoon, isTrue);
      expect(ReaderMode.verticalContinuous.isWebtoon, isFalse);
    });

    test('shares only continuous scrolling capabilities', () {
      expect(ReaderMode.verticalContinuous.usesContinuousScroller, isTrue);
      expect(ReaderMode.webtoon.usesContinuousScroller, isTrue);
      expect(ReaderMode.horizontalContinuous.usesContinuousScroller, isTrue);
      expect(ReaderMode.vertical.usesContinuousScroller, isFalse);

      expect(
        ReaderMode.verticalContinuous.usesVerticalContinuousScroller,
        isTrue,
      );
      expect(ReaderMode.webtoon.usesVerticalContinuousScroller, isTrue);
      expect(
        ReaderMode.horizontalContinuous.usesVerticalContinuousScroller,
        isFalse,
      );
    });

    test('exposes mode-specific settings capabilities', () {
      expect(ReaderMode.verticalContinuous.supportsPageGaps, isTrue);
      expect(ReaderMode.horizontalContinuous.supportsPageGaps, isTrue);
      expect(ReaderMode.webtoon.supportsPageGaps, isFalse);

      expect(ReaderMode.webtoon.supportsWebtoonSidePadding, isTrue);
      expect(ReaderMode.verticalContinuous.supportsWebtoonSidePadding, isFalse);
    });
  });
}

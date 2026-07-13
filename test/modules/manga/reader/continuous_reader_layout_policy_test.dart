import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/continuous_reader_layout_policy.dart';

void main() {
  group('ContinuousReaderLayoutPolicy', () {
    test('Vertical Continuous inherits Fit Width without Webtoon padding', () {
      const policy = ContinuousReaderLayoutPolicy.verticalContinuous(
        scaleType: ScaleType.fitWidth,
        showPageGaps: true,
      );

      expect(policy.fillAvailableWidth, isTrue);
      expect(policy.sidePaddingPercent, 0);
      expect(policy.showPageGaps, isTrue);
    });

    test('Vertical Continuous preserves intrinsic width for other scales', () {
      const policy = ContinuousReaderLayoutPolicy.verticalContinuous(
        scaleType: ScaleType.fitScreen,
        showPageGaps: false,
      );

      expect(policy.fillAvailableWidth, isFalse);
      expect(policy.sidePaddingPercent, 0);
      expect(policy.showPageGaps, isFalse);
    });

    test('Webtoon keeps intrinsic sizing, side padding, and no gaps', () {
      const policy = ContinuousReaderLayoutPolicy.webtoon(
        sidePaddingPercent: 12,
      );

      expect(policy.fillAvailableWidth, isFalse);
      expect(policy.sidePaddingPercent, 12);
      expect(policy.showPageGaps, isFalse);
    });

    test('Horizontal Continuous keeps its existing gap policy', () {
      const policy = ContinuousReaderLayoutPolicy.horizontal(
        showPageGaps: true,
      );

      expect(policy.fillAvailableWidth, isFalse);
      expect(policy.sidePaddingPercent, 0);
      expect(policy.showPageGaps, isTrue);
    });
  });
}

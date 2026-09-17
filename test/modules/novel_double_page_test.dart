import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/novel/utils/novel_paginator.dart';

void main() {
  group('NovelPaginator Tests', () {
    test('Empty content returns single empty page and 0 spreads', () {
      final res = NovelPaginator.paginate(
        htmlContent: '',
        pageWidth: 400,
        pageHeight: 600,
        fontSize: 16,
        lineHeight: 1.5,
      );
      expect(res.pageCount, 1);
      expect(res.spreadCount, 1);
      expect(res.leftPageForSpread(0), '');
      expect(res.rightPageForSpread(0), isNull);
    });

    test('Multiple paragraphs are paginated across pages and spreads', () {
      final buffer = StringBuffer('<div id="readerViewContent">');
      for (int i = 0; i < 30; i++) {
        buffer.write(
          '<p data-tts-index="$i">Paragraph $i: This is a sample paragraph in the novel to test pagination across spreads in double page mode. It should be long enough to occupy multiple lines on a mobile or tablet viewport screen.</p>',
        );
      }
      buffer.write('</div>');

      final res = NovelPaginator.paginate(
        htmlContent: buffer.toString(),
        pageWidth: 400,
        pageHeight: 500,
        fontSize: 16,
        lineHeight: 1.5,
      );

      expect(res.pageCount, greaterThan(1));
      expect(res.spreadCount, greaterThan(1));

      // Check left and right page for spread 0
      final left = res.leftPageForSpread(0);
      final right = res.rightPageForSpread(0);
      expect(left.isNotEmpty, isTrue);
      expect(right != null && right.isNotEmpty, isTrue);

      // Check spread labels
      expect(res.pageLabelForSpread(0), startsWith('1-2 /'));

      // Check TTS block mapping
      expect(res.blockToPageMap.containsKey(0), isTrue);
      expect(res.spreadForBlock(0), 0);
      expect(res.spreadForBlock(29), greaterThanOrEqualTo(0));

      // Check progress mapping
      expect(res.spreadForProgress(0.0), 0);
      expect(res.spreadForProgress(1.0), res.spreadCount - 1);
      expect(res.progressForSpread(0), 0.0);
    });

    test('Extremely long paragraph is split into multiple parts', () {
      final longText = List.generate(
        40,
        (i) => 'Sentence number $i describes an intense scene in the novel.',
      ).join(' ');

      final html =
          '<div id="readerViewContent"><p data-tts-index="0">$longText</p></div>';

      final res = NovelPaginator.paginate(
        htmlContent: html,
        pageWidth: 300,
        pageHeight: 400,
        fontSize: 16,
        lineHeight: 1.5,
      );

      // Long paragraph should be split across at least 2 pages
      expect(res.pageCount, greaterThan(1));
    });
  });
}

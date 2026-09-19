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

    test('Korean / CJK novel text pagination splits naturally without overflowing', () {
      final koreanText = StringBuffer('<div id="readerViewContent">');
      for (int i = 0; i < 20; i++) {
        koreanText.write(
          '<p data-tts-index="$i">제${i + 1}장: 깊은 어둠 속에서 푸른 안개가 천천히 피어올랐다. 소년은 검자루를 단단히 쥐고 숨을 죽인 채 전방의 기척을 주시했다. 바람조차 불지 않는 고요 속에서 심장 박동 소리만이 귀를 때렸다.</p>',
        );
      }
      koreanText.write('</div>');

      final res = NovelPaginator.paginate(
        htmlContent: koreanText.toString(),
        pageWidth: 400,
        pageHeight: 600,
        fontSize: 18,
        lineHeight: 1.6,
        removeExtraSpacing: true,
      );

      expect(res.pageCount, greaterThan(1));
      expect(res.spreadCount, greaterThan(1));
      expect(res.leftPageForSpread(0).contains('제1장'), isTrue);
    });

    test('Nested div containers are unwrapped and individual paragraphs paginated', () {
      const nestedHtml = '''
<div id="readerViewContent">
  <div class="chapter-container">
    <div class="content-body">
      <p data-tts-index="0">첫 번째 문단입니다.</p>
      <p data-tts-index="1">두 번째 문단입니다.</p>
      <p data-tts-index="2">세 번째 문단입니다.</p>
    </div>
  </div>
</div>
''';

      final res = NovelPaginator.paginate(
        htmlContent: nestedHtml,
        pageWidth: 300,
        pageHeight: 200,
        fontSize: 16,
        lineHeight: 1.5,
      );

      expect(res.blockToPageMap.containsKey(0), isTrue);
      expect(res.blockToPageMap.containsKey(1), isTrue);
      expect(res.blockToPageMap.containsKey(2), isTrue);
    });

    test('Pagination with custom fontFamily and textAlign works seamlessly', () {
      const sampleHtml =
          '<div id="readerViewContent"><p>테스트 문장입니다. 정렬과 폰트 설정이 적용되는지 검증합니다.</p></div>';

      final res = NovelPaginator.paginate(
        htmlContent: sampleHtml,
        pageWidth: 400,
        pageHeight: 600,
        fontSize: 16,
        lineHeight: 1.5,
        fontFamily: 'Roboto',
      );

      expect(res.pageCount, 1);
      expect(res.pages.first.contains('테스트 문장'), isTrue);
    });
  });
}

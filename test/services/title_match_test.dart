import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/discovery/title_match.dart';

/// A library title comes from whichever source it was added from, and those
/// disagree with a metadata database about punctuation, romanisation and how
/// much of a subtitle to keep. Taking the first search hit and trusting it is
/// how a lookup ends up confidently describing a different series.
void main() {
  group('normalising', () {
    test('case and punctuation do not count', () {
      expect(normalizeTitle('Chainsaw Man!'), 'chainsaw man');
      expect(normalizeTitle('Re:Zero'), 're zero');
      expect(normalizeTitle('  Spy x  Family  '), 'spy x family');
    });

    test('a script without spaces survives as one token', () {
      // Erasing it would score every Japanese title as empty.
      expect(normalizeTitle('チェンソーマン'), 'チェンソーマン');
    });
  });

  group('similarity', () {
    test('the same title, differently punctuated, is the same title', () {
      expect(titleSimilarity('Chainsaw Man', 'chainsaw-man'), 1);
      expect(titleSimilarity('Re:Zero', 'Re Zero'), 1);
    });

    test('a subtitled entry scores below the title itself', () {
      // The whole point: both share every word of the shorter one.
      final exact = titleSimilarity('Chainsaw Man', 'Chainsaw Man');
      final subtitled = titleSimilarity(
        'Chainsaw Man',
        'Chainsaw Man: Buddy Stories',
      );
      expect(subtitled, lessThan(exact));
      expect(subtitled, greaterThan(0));
    });

    test('unrelated titles score nothing', () {
      expect(titleSimilarity('Chainsaw Man', 'Just Listen to the Song'), 0);
    });

    test('an empty side scores nothing rather than throwing', () {
      expect(titleSimilarity('', 'Chainsaw Man'), 0);
      expect(titleSimilarity('!!!', 'Chainsaw Man'), 0);
    });
  });

  group('picking a candidate', () {
    test('the exact title wins over one that merely contains it', () {
      // Kitsu returns the subtitled entries alongside the series itself.
      final best = bestTitleMatch('Chainsaw Man', [
        ['Chainsaw Man: Buddy Stories'],
        ['Chainsaw Man', 'チェンソーマン'],
      ]);
      expect(best, 1);
    });

    test('a match on any of an entry alternate names counts', () {
      // A library holding the Japanese title still finds the entry whose
      // English title is different but which lists both.
      final best = bestTitleMatch('Ore dake Level Up na Ken', [
        ['Some other series'],
        ['Solo Leveling', 'Ore dake Level Up na Ken'],
      ]);
      expect(best, 1);
    });

    test('nothing close enough is null, not the first hit', () {
      // The reason this exists. Relations of the wrong series look exactly as
      // confident as relations of the right one.
      final best = bestTitleMatch('A Series Nobody Has', [
        ['Chainsaw Man'],
        ['Solo Leveling'],
      ]);
      expect(best, isNull);
    });

    test('an earlier candidate wins a tie', () {
      // The search comes back in the database's relevance order, which is a
      // better tiebreak than position in a loop.
      final best = bestTitleMatch('Chainsaw Man', [
        ['Chainsaw Man'],
        ['Chainsaw Man'],
      ]);
      expect(best, 0);
    });

    test('no candidates is null', () {
      expect(bestTitleMatch('anything', const []), isNull);
    });

    test('the floor can be relaxed by a caller that wants a guess', () {
      const candidates = [
        ['Chainsaw Man: Buddy Stories: Extra Long Subtitle Here'],
      ];
      expect(bestTitleMatch('Chainsaw Man', candidates), isNull);
      expect(bestTitleMatch('Chainsaw Man', candidates, floor: 0.1), 0);
    });
  });
}

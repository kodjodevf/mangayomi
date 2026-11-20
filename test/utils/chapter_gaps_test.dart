import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/chapter_gaps.dart';

Chapter _chapter(String name) => Chapter(name: name, mangaId: 1, url: name);

List<Chapter> _chapters(Iterable<String> names) => names.map(_chapter).toList();

void main() {
  group('missingNumberRanges', () {
    test('gives each run of absent numbers', () {
      expect(missingNumberRanges([1, 2, 4, 7, 8, 12]), [
        (first: 3, last: 3),
        (first: 5, last: 6),
        (first: 9, last: 11),
      ]);
    });

    test('a decimal extra counts for its whole chapter', () {
      expect(missingNumberRanges([1, 2, 2.5, 3]), isEmpty);
      expect(missingNumberRanges([1, 3.5]), [(first: 2, last: 2)]);
    });

    test('order and duplicates do not matter', () {
      expect(missingNumberRanges([5, 1, 5, 3]), [
        (first: 2, last: 2),
        (first: 4, last: 4),
      ]);
    });

    test('nothing is missing from fewer than two numbers', () {
      expect(missingNumberRanges([]), isEmpty);
      expect(missingNumberRanges([42]), isEmpty);
    });

    test('negative numbers are left out', () {
      expect(missingNumberRanges([-1, 2, 3]), isEmpty);
    });

    test('numberCount adds the runs up', () {
      expect(missingNumberRanges([1, 2, 4, 7, 8, 12]).numberCount, 6);
    });
  });

  group('formatChapterNumberRanges', () {
    test('writes single numbers, pairs and runs', () {
      expect(
        formatChapterNumberRanges([
          (first: 3, last: 3),
          (first: 5, last: 6),
          (first: 9, last: 11),
        ]),
        '3, 5, 6, 9–11',
      );
    });
  });

  group('missingNumbersBetween', () {
    List<ChapterNumberRange> between(
      String from,
      String to, [
      List<String> others = const [],
    ]) => missingNumbersBetween(
      'Series',
      _chapter(from),
      _chapter(to),
      _chapters([from, to, ...others]),
    );

    test('gives the numbers skipped from one chapter to the next', () {
      expect(between('Chapter 99', 'Chapter 101'), [(first: 100, last: 100)]);
      expect(between('Chapter 10', 'Chapter 14'), [(first: 11, last: 13)]);
    });

    test('nothing is missing between consecutive chapters', () {
      expect(between('Chapter 99', 'Chapter 100'), isEmpty);
      expect(between('Chapter 12', 'Chapter 12.5'), isEmpty);
      expect(between('Chapter 12.5', 'Chapter 13'), isEmpty);
    });

    test('a chapter the series has is not missing, only filtered out', () {
      // Chapter 100 exists, from a hidden scanlator or filtered as read.
      expect(between('Chapter 99', 'Chapter 101', ['Chapter 100']), isEmpty);
      expect(between('Chapter 10', 'Chapter 14', ['Chapter 12']), [
        (first: 11, last: 11),
        (first: 13, last: 13),
      ]);
    });

    test('going back, or to a chapter with no number, skips nothing', () {
      expect(between('Chapter 101', 'Chapter 99'), isEmpty);
      expect(between('Chapter 3', 'Epilogue'), isEmpty);
      expect(between('Prologue', 'Chapter 5'), isEmpty);
    });

    test('a new season starts its numbering over', () {
      expect(between('Season 1 Episode 12', 'Season 2 Episode 1'), isEmpty);
      expect(between('Season 1 Episode 12', 'Season 2 Episode 15'), isEmpty);
    });
  });

  group('recognizedChapterNumbers', () {
    test('leaves out chapters with no number', () {
      expect(
        recognizedChapterNumbers(
          'Series',
          _chapters(['Chapter 1', 'Special', 'Chapter 3']),
        ),
        [1, 3],
      );
    });
  });
}

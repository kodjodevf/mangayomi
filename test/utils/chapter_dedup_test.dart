import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// The two numbers `ChapterRecognition` offers are not interchangeable, and
/// picking the wrong one is what makes decimal chapters disappear.
///
/// `parseChapterNumber` is the sort key and truncates on purpose.
/// `rawSeasonAndNumber` keeps the fraction, and is what anything deciding
/// whether two chapters are the same chapter has to use.
void main() {
  final recognition = ChapterRecognition();

  double? exact(String name) =>
      recognition.rawSeasonAndNumber('One Piece', name).$2;

  int key(String name) => recognition.parseChapterNumber('One Piece', name);

  group('the sort key cannot tell decimal chapters apart', () {
    test('12, 12.1 and 12.5 share one sort key', () {
      // Not a bug in the key: it is what makes them sort together. It is a bug
      // to build a de-duplication key out of it.
      expect(key('Chapter 12'), key('Chapter 12.1'));
      expect(key('Chapter 12'), key('Chapter 12.5'));
    });
  });

  group('the exact number can', () {
    test('12, 12.1 and 12.5 are three different chapters', () {
      expect(exact('Chapter 12'), isNot(exact('Chapter 12.1')));
      expect(exact('Chapter 12'), isNot(exact('Chapter 12.5')));
      expect(exact('Chapter 12.1'), isNot(exact('Chapter 12.5')));
    });

    test('a composite key built from it keeps them apart', () {
      // This is the shape update_manga_detail_providers builds, and the shape
      // that decides whether a chapter reaches the library at all.
      String composite(String name) => '${exact(name)}::scanlator';
      final keys = {
        composite('Chapter 12'),
        composite('Chapter 12.1'),
        composite('Chapter 12.5'),
      };
      expect(keys.length, 3);
    });

    test('the same composite key from the sort key collapses to one', () {
      String composite(String name) => '${key(name)}::scanlator';
      final keys = {
        composite('Chapter 12'),
        composite('Chapter 12.1'),
        composite('Chapter 12.5'),
      };
      expect(keys.length, 1);
    });

    test('a name with no number is null, not zero', () {
      // Otherwise every Special and Prologue is a duplicate of every other.
      expect(exact('Special'), isNull);
      expect(exact('Prologue'), isNull);
    });

    test('a whole chapter is still itself', () {
      expect(exact('Chapter 12'), 12);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

void main() {
  final recognition = ChapterRecognition();

  int number(String name, {String title = 'One Piece'}) =>
      recognition.parseChapterNumber(title, name);

  group('parseChapterNumber keeps the fraction', () {
    test('a decimal chapter is not the same chapter as its whole number', () {
      // The bug behind #812: 1, 1.1 and 1.5 all parsed to 1, so the refresh
      // de-duplicated them and only the first survived into the library.
      expect(number('Chapter 1'), isNot(number('Chapter 1.1')));
      expect(number('Chapter 1'), isNot(number('Chapter 1.5')));
      expect(number('Chapter 1.1'), isNot(number('Chapter 1.5')));
    });

    test('decimal chapters sort between their neighbours', () {
      expect(number('Chapter 1'), lessThan(number('Chapter 1.5')));
      expect(number('Chapter 1.5'), lessThan(number('Chapter 2')));
    });

    test('a whole chapter is still ordered by its number', () {
      expect(number('Chapter 2'), lessThan(number('Chapter 10')));
      expect(number('Chapter 9'), lessThan(number('Chapter 10')));
    });

    test('the same name always gives the same key', () {
      expect(number('Chapter 12.5'), number('Chapter 12.5'));
    });

    test('a name with no number at all is zero', () {
      expect(number('Oneshot'), 0);
    });
  });

  group('parseChapterNumber understands the notations it always did', () {
    test('ch. notation', () {
      expect(number('Ch.15'), number('Chapter 15'));
    });

    test('volume noise does not become the chapter number', () {
      expect(number('Vol.2 Ch.3'), number('Chapter 3'));
    });

    test('the item title is stripped before parsing', () {
      expect(number('One Piece 1044', title: 'One Piece'), number('Chapter 1044'));
    });

    test('lettered chapters land between whole numbers', () {
      expect(number('Chapter 4'), lessThan(number('Chapter 4a')));
      expect(number('Chapter 4a'), lessThan(number('Chapter 5')));
    });

    test('extra, omake and special sit just below the next chapter', () {
      for (final suffix in ['extra', 'omake', 'special']) {
        expect(number('Chapter 7 $suffix'), greaterThan(number('Chapter 7')));
        expect(number('Chapter 7 $suffix'), lessThan(number('Chapter 8')));
      }
    });
  });

  group('season encoding', () {
    test('a later season sorts above an earlier one', () {
      expect(
        number('Season 1 Episode 12', title: 'Show'),
        lessThan(number('Season 2 Episode 1', title: 'Show')),
      );
    });

    test('a season key stays clear of the chapters below it', () {
      // The stride has to be wider than any scaled chapter number, or a high
      // chapter in season 1 would overtake season 2.
      expect(
        number('Season 1 Episode 9999', title: 'Show'),
        lessThan(number('Season 2 Episode 1', title: 'Show')),
      );
    });
  });

  group('parseEpisodeNumber stays whole, for trackers', () {
    int episode(String name) => recognition.parseEpisodeNumber('One Piece', name);

    test('a whole chapter is its own number, not a scaled key', () {
      expect(episode('Chapter 15'), 15);
    });

    test('a decimal chapter truncates, since trackers count whole chapters', () {
      expect(episode('Chapter 15.5'), 15);
    });

    test('season is not encoded into it', () {
      expect(recognition.parseEpisodeNumber('Show', 'Season 2 Episode 3'), 3);
    });
  });
}

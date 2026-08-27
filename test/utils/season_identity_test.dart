import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// Reported after updating 0.8.6 -> 0.8.9: whole seasons disappearing.
///
/// On AniWorld, "Clevatess" has season 1 with 12 episodes and season 2 with 8,
/// and only season 1 survived a library update. "Code Geass" has 12 films plus
/// 25 episodes in each of two seasons, and only season 2 survived.
///
/// Both are the same fault. The key deciding whether two chapters are the same
/// chapter was built from the episode number alone, so season 2 episode 1 was
/// season 1 episode 1, and whichever arrived second was skipped before it
/// reached the library. Which half survives depends only on the order the
/// source lists them in, which is why two shows lost opposite halves.
void main() {
  final recognition = ChapterRecognition();

  String? identity(String show, String name, [String? scanlator]) =>
      recognition.chapterIdentityKey(show, name, scanlator);

  group('a season is part of a chapter identity', () {
    test('the same episode number in two seasons is two chapters', () {
      expect(
        identity('Clevatess', 'Staffel 1 Folge 1'),
        isNot(identity('Clevatess', 'Staffel 2 Folge 1')),
      );
    });

    test('a shorter second season survives the first', () {
      // Clevatess: 12 then 8. The 8 collided and vanished.
      final keys = <String?>{
        for (var e = 1; e <= 12; e++)
          identity('Clevatess', 'Staffel 1 Folge $e'),
        for (var e = 1; e <= 8; e++)
          identity('Clevatess', 'Staffel 2 Folge $e'),
      };
      expect(keys, hasLength(20));
    });

    test('two full seasons of the same length both survive', () {
      // Code Geass: 25 and 25. One of them vanished entirely.
      final keys = <String?>{
        for (var e = 1; e <= 25; e++)
          identity('Code Geass', 'Season 1 Episode $e'),
        for (var e = 1; e <= 25; e++)
          identity('Code Geass', 'Season 2 Episode $e'),
      };
      expect(keys, hasLength(50));
    });

    test('de-duplication within one season still works', () {
      // Or this trades one bug for another.
      expect(
        identity('Clevatess', 'Staffel 1 Folge 3'),
        identity('Clevatess', 'Staffel 1 Folge 3'),
      );
    });
  });

  group('what the key refuses to answer', () {
    test('a name with no number is not an identity', () {
      // Otherwise every Special is the same chapter as every other one, which
      // is the same bug in a different shape.
      expect(identity('Code Geass', 'Special'), isNull);
      expect(identity('Code Geass', 'Prologue'), isNull);
    });

    test('decimal chapters stay apart', () {
      expect(
        identity('One Piece', 'Chapter 12'),
        isNot(identity('One Piece', 'Chapter 12.5')),
      );
    });

    test('the scanlator separates releases, and is optional', () {
      expect(
        identity('One Piece', 'Chapter 12', 'A'),
        isNot(identity('One Piece', 'Chapter 12', 'B')),
      );
      // Omitted when deciding whether read state carries over: the same
      // episode from another group is still that episode.
      expect(
        identity('One Piece', 'Chapter 12'),
        identity('One Piece', 'Chapter 12'),
      );
    });
  });
}

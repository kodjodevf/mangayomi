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

  group('Spanish season and episode names', () {
    // Cuevana names episodes "T1 - Episodio 3". Neither word was recognised,
    // so the first bare number, the season, became the episode: every
    // episode of a season was episode 1 and all but one were dropped. Loki
    // showed two episodes, one per season.
    (int, double?) parsed(String name) =>
        recognition.rawSeasonAndNumber('Loki', name);

    test('"T" is a season and "Episodio" an episode', () {
      expect(parsed('T1 - Episodio 3'), (1, 3.0));
      expect(parsed('T2 - Episodio 6'), (2, 6.0));
    });

    test('two seasons of Loki keep all their episodes', () {
      final keys = <String?>{
        for (var e = 1; e <= 6; e++) identity('Loki', 'T1 - Episodio $e'),
        for (var e = 1; e <= 6; e++) identity('Loki', 'T2 - Episodio $e'),
      };
      expect(keys, hasLength(12));
    });

    test('words merely containing a "t" are not seasons', () {
      expect(parsed('Part 2'), (0, 2.0));
      expect(parsed('Chapter 12'), (0, 12.0));
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

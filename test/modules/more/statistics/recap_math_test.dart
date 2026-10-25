import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';

RecapSeries _series(
  int id, {
  String name = 'Series',
  List<String> genres = const [],
  String? source = 'Source',
  int? dateAdded,
  int chaptersRead = 0,
  int seconds = 0,
}) => RecapSeries(
  id: id,
  name: name,
  genres: genres,
  source: source,
  dateAdded: dateAdded,
  chaptersRead: chaptersRead,
  seconds: seconds,
);

List<RecapSeries> _withGenre(String genre, int hits, {int total = 10}) => [
  for (var i = 0; i < total; i++)
    _series(i, genres: i < hits ? [genre] : ['Other$i']),
];

ReadingLog _log(
  int mangaId,
  DateTime at, {
  ReadingLogKind kind = ReadingLogKind.completion,
  int seconds = 0,
  int? chapterId,
}) => ReadingLog(
  mangaId: mangaId,
  chapterId: chapterId,
  itemType: ItemType.manga,
  at: at.millisecondsSinceEpoch,
  kind: kind,
  seconds: seconds,
);

Badge _badge(List<Badge> badges, BadgeId id) =>
    badges.firstWhere((b) => b.id == id);

List<Badge> _badges({
  List<RecapSeries> favs = const [],
  int clearedCount = 0,
  int peakHour = -1,
  DateTime? since,
  int maxDayCompletions = 0,
  DateTime? now,
}) => badgesFor(
  favs: favs,
  clearedCount: clearedCount,
  peakHour: peakHour,
  since: since,
  maxDayCompletions: maxDayCompletions,
  now: now ?? DateTime(2026, 10, 25),
);

void main() {
  group('level', () {
    test('37,709 chapters is level 97, 707 short of 98', () {
      expect(levelFor(37709), 97);
      expect(unitsForLevel(98), 38416);
      expect(unitsForLevel(98) - 37709, 707);
    });

    test('small counts', () {
      expect(levelFor(0), 0);
      expect(levelFor(3), 0);
      expect(levelFor(4), 1);
      expect(levelFor(15), 1);
      expect(levelFor(16), 2);
    });
  });

  group('rankSkills', () {
    test('share thresholds', () {
      expect(rankSkills(_withGenre('Action', 9)).first.rank, SkillRank.sss);
      expect(rankSkills(_withGenre('Action', 9)).first.share, 0.9);
      expect(rankSkills(_withGenre('Action', 7)).first.rank, SkillRank.ss);
      expect(rankSkills(_withGenre('Action', 5)).first.rank, SkillRank.s);
      final one = rankSkills(_withGenre('Action', 1));
      expect(one.firstWhere((s) => s.genre == 'Action').rank, SkillRank.c);
    });

    test('drops format tags, merges case and spacing, keeps top 7', () {
      final favs = [
        for (var i = 0; i < 10; i++)
          _series(
            i,
            genres: [
              'Manhwa',
              ' webtoons ',
              'Full Color',
              if (i < 8) 'Action',
              if (i < 6) ' action ',
              if (i < 5) 'fantasy',
              for (var g = 0; g < 6; g++)
                if (i <= g) 'G$g',
            ],
          ),
      ];

      final skills = rankSkills(favs);

      expect(skills, hasLength(7));
      expect(skills.first.genre, 'Action');
      expect(skills.first.count, 8);
      expect(
        skills.map((s) => s.genre.toLowerCase()),
        isNot(contains('manhwa')),
      );
      expect(
        skills.map((s) => s.genre.toLowerCase()),
        isNot(contains('webtoons')),
      );
      final counts = skills.map((s) => s.count).toList();
      expect(counts, [...counts]..sort((a, b) => b.compareTo(a)));
    });
  });

  group('classify', () {
    test('most matching bucket wins', () {
      final favs = [
        for (var i = 0; i < 3; i++) _series(i, genres: ['Regression']),
        for (var i = 3; i < 5; i++) _series(i, genres: ['Murim']),
      ];
      expect(classify(favs), ReaderClass.regressor);
    });

    test('ties go to list order', () {
      final favs = [
        for (var i = 0; i < 2; i++) _series(i, genres: ['Murim']),
        for (var i = 2; i < 4; i++) _series(i, genres: ['Reincarnation']),
      ];
      expect(classify(favs), ReaderClass.regressor);
    });

    test('a title counts for every bucket it matches', () {
      final favs = [
        _series(1, name: 'Return of the Mount Hua Sect'),
        _series(2, genres: ['Romance']),
      ];
      // Regressor 1, Murim 1, Romantic 1: tie → Regressor.
      expect(classify(favs), ReaderClass.regressor);
      expect(
        classify([
          _series(1, name: 'Return of the Mount Hua Sect'),
          _series(2, genres: ['Wuxia']),
        ]),
        ReaderClass.murimMaster,
      );
    });

    test('nothing matches → wanderer', () {
      expect(
        classify([
          _series(1, genres: ['Comedy']),
        ]),
        ReaderClass.wanderer,
      );
      expect(classify(const []), ReaderClass.wanderer);
    });
  });

  group('epithetFor', () {
    test('a source with 25% or more makes you its disciple', () {
      final favs = [
        for (var i = 0; i < 100; i++)
          _series(i, source: i < 30 ? 'Asura Scans' : 'Other ${i % 5}'),
      ];
      final epithet = epithetFor(favs);
      expect(epithet.disciple, isTrue);
      expect(epithet.source, 'Asura Scans');
    });

    test('below 25% you wander, counting sources', () {
      final favs = [
        for (var i = 0; i < 100; i++)
          _series(i, source: i < 20 ? 'Top' : 'Other ${i % 5}'),
      ];
      final epithet = epithetFor(favs);
      expect(epithet.disciple, isFalse);
      expect(epithet.sourceCount, 6);
    });
  });

  group('badgesFor', () {
    test('Regressor unlocks at 25 series', () {
      List<RecapSeries> favs(int n) => [
        for (var i = 0; i < n; i++) _series(i, genres: ['Regression']),
      ];
      expect(
        _badge(_badges(favs: favs(25)), BadgeId.regressor).unlocked,
        isTrue,
      );
      expect(_badge(_badges(favs: favs(25)), BadgeId.regressor).value, 25);
      expect(
        _badge(_badges(favs: favs(24)), BadgeId.regressor).unlocked,
        isFalse,
      );
    });

    test('Source Loyalist and Marathoner carry a label', () {
      final favs = [
        for (var i = 0; i < 100; i++) _series(i, source: 'Asura Scans'),
        _series(100, name: 'Long One', chaptersRead: 300),
      ];
      final badges = _badges(favs: favs);
      expect(_badge(badges, BadgeId.sourceLoyalist).unlocked, isTrue);
      expect(_badge(badges, BadgeId.sourceLoyalist).label, 'Asura Scans');
      expect(_badge(badges, BadgeId.marathoner).unlocked, isTrue);
      expect(_badge(badges, BadgeId.marathoner).label, 'Long One');
      expect(_badge(badges, BadgeId.marathoner).value, 300);
    });

    test('peak hour picks dawn or night', () {
      expect(
        _badge(_badges(peakHour: 5), BadgeId.dawnCultivator).unlocked,
        isTrue,
      );
      expect(
        _badge(_badges(peakHour: 9), BadgeId.dawnCultivator).unlocked,
        isTrue,
      );
      expect(
        _badge(_badges(peakHour: 10), BadgeId.dawnCultivator).unlocked,
        isFalse,
      );
      expect(_badge(_badges(peakHour: 10), BadgeId.nightOwl).unlocked, isFalse);
      expect(_badge(_badges(peakHour: 0), BadgeId.nightOwl).unlocked, isTrue);
      expect(_badge(_badges(peakHour: 4), BadgeId.nightOwl).unlocked, isTrue);
    });

    test('Veteran at exactly two years', () {
      final now = DateTime(2026, 10, 25);
      expect(
        _badge(
          _badges(since: DateTime(2024, 10, 25), now: now),
          BadgeId.veteran,
        ).unlocked,
        isTrue,
      );
      expect(
        _badge(
          _badges(since: DateTime(2024, 10, 26), now: now),
          BadgeId.veteran,
        ).unlocked,
        isFalse,
      );
    });

    test('Binger, Completionist and Collector thresholds', () {
      expect(
        _badge(_badges(maxDayCompletions: 100), BadgeId.binger).unlocked,
        isTrue,
      );
      expect(
        _badge(_badges(maxDayCompletions: 99), BadgeId.binger).unlocked,
        isFalse,
      );
      expect(
        _badge(_badges(clearedCount: 10), BadgeId.completionist).unlocked,
        isTrue,
      );
      expect(
        _badge(_badges(clearedCount: 9), BadgeId.completionist).unlocked,
        isFalse,
      );
      final library = [for (var i = 0; i < 500; i++) _series(i)];
      expect(
        _badge(_badges(favs: library), BadgeId.collector).unlocked,
        isTrue,
      );
      expect(
        _badge(_badges(favs: library.sublist(1)), BadgeId.collector).unlocked,
        isFalse,
      );
    });
  });

  test('derive on empty input', () {
    final data = deriveStatusWindow(
      favs: const [],
      units: 0,
      clearedCount: 0,
      clockMs: const [],
      firstLogMs: null,
      maxDayCompletions: 0,
      now: DateTime(2026, 10, 25),
    );

    expect(data.level, 0);
    expect(data.prevLevelAt, 0);
    expect(data.nextLevelAt, 4);
    expect(data.skills, isEmpty);
    expect(data.bonded, isEmpty);
    expect(data.since, isNull);
    expect(data.readerClass, ReaderClass.wanderer);
    expect(data.epithet.disciple, isFalse);
    expect(data.epithet.sourceCount, 0);
    expect(data.hourHistogram, List.filled(24, 0));
    expect(data.weekdayHistogram, List.filled(7, 0));
    expect(data.badges, hasLength(BadgeId.values.length));
    expect(data.badges.every((b) => !b.unlocked), isTrue);
    expect(peakHour(data.hourHistogram), -1);
  });

  test('derive picks since, bonded order and clock', () {
    final monday9am = DateTime(2026, 10, 19, 9);
    final data = deriveStatusWindow(
      favs: [
        _series(
          1,
          name: 'A',
          seconds: 100,
          chaptersRead: 1,
          dateAdded: DateTime(2023, 1, 1).millisecondsSinceEpoch,
        ),
        _series(2, name: 'B', seconds: 100, chaptersRead: 5),
        _series(3, name: 'C', seconds: 500),
        _series(4, name: 'Unread'),
      ],
      units: 6,
      clearedCount: 0,
      clockMs: [
        monday9am.millisecondsSinceEpoch,
        monday9am.millisecondsSinceEpoch,
      ],
      firstLogMs: DateTime(2022, 6, 1).millisecondsSinceEpoch,
      maxDayCompletions: 0,
      now: DateTime(2026, 10, 25),
    );

    expect(data.since, DateTime(2022, 6, 1));
    expect(data.totalSeconds, 700);
    expect(data.libraryCount, 4);
    expect(data.bonded.map((s) => s.name), ['C', 'B', 'A']);
    expect(data.hourHistogram[9], 2);
    expect(data.weekdayHistogram[0], 2);
    expect(_badge(data.badges, BadgeId.dawnCultivator).unlocked, isTrue);
    expect(_badge(data.badges, BadgeId.veteran).unlocked, isTrue);
  });

  group('aggregateMonth', () {
    final series = {
      1: _series(1, name: 'One', genres: ['Action']),
      2: _series(2, name: 'Two', genres: ['Romance']),
    };

    MonthStats aggregate(
      List<ReadingLog> rows, {
      Set<int> seenBefore = const {},
      Set<int> caughtUpIds = const {},
      int? previousSeconds,
    }) => aggregateMonth(
      month: DateTime(2026, 10),
      rows: rows,
      seenBefore: seenBefore,
      series: series,
      caughtUpIds: caughtUpIds,
      previousSeconds: previousSeconds,
    );

    test('month buckets by local date', () {
      final stats = aggregate([
        _log(1, DateTime(2026, 10, 29, 12)),
        _log(1, DateTime(2026, 10, 30, 8)),
        _log(1, DateTime(2026, 10, 31, 23, 30)),
        _log(1, DateTime(2026, 11, 1, 0, 30)),
      ]);

      expect(stats.month, DateTime(2026, 10));
      expect(stats.daysRead, {29, 30, 31});
      expect(stats.longestStreak, 3);
      expect(stats.completions, 3);
    });

    test('totals, new series, biggest day and unknown ids', () {
      final stats = aggregate(
        [
          _log(
            1,
            DateTime(2026, 10, 2, 10),
            kind: ReadingLogKind.time,
            seconds: 600,
          ),
          _log(1, DateTime(2026, 10, 2, 11), chapterId: 7),
          _log(1, DateTime(2026, 10, 2, 12), chapterId: 7),
          _log(
            2,
            DateTime(2026, 10, 5, 22),
            kind: ReadingLogKind.time,
            seconds: 60,
          ),
          _log(2, DateTime(2026, 10, 5, 22, 30)),
          _log(
            99,
            DateTime(2026, 10, 6, 9),
            kind: ReadingLogKind.time,
            seconds: 9999,
          ),
          _log(99, DateTime(2026, 10, 6, 9)),
        ],
        seenBefore: {1},
        caughtUpIds: {2},
        previousSeconds: 300,
      );

      expect(stats.seconds, 660);
      expect(stats.completions, 3);
      expect(stats.seriesCount, 2);
      expect(stats.newSeriesCount, 1);
      expect(stats.biggestDay?.day, DateTime(2026, 10, 2));
      expect(stats.biggestDay?.completions, 2);
      expect(stats.daysRead, {2, 5});
      expect(stats.longestStreak, 1);
      expect(stats.top?.id, 1);
      expect(stats.top?.seconds, 600);
      expect(stats.top?.chaptersRead, 2);
      expect(stats.finishedIds, [2]);
      expect(
        stats.genres.map((g) => g.genre),
        containsAll(['Action', 'Romance']),
      );
      expect(stats.hourHistogram[22], 2);
      expect(stats.previousSeconds, 300);
    });

    test('empty month', () {
      final stats = aggregate(const []);
      expect(stats.seconds, 0);
      expect(stats.biggestDay, isNull);
      expect(stats.top, isNull);
      expect(stats.longestStreak, 0);
      expect(stats.genres, isEmpty);
    });
  });
}

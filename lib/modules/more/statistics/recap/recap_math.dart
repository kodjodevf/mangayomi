import 'dart:math';

import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';

/// `floor(sqrt(units) / 2)`: level L starts at `(2L)^2` units.
int levelFor(int units) {
  if (units <= 0) return 0;
  var level = sqrt(units) ~/ 2;
  // Guard against floating-point drift at exact squares.
  while (unitsForLevel(level + 1) <= units) {
    level++;
  }
  while (level > 0 && unitsForLevel(level) > units) {
    level--;
  }
  return level;
}

int unitsForLevel(int level) => (2 * level) * (2 * level);

/// Format tags that aren't genres.
const _formatTags = {
  'manhwa',
  'manga',
  'manhua',
  'webtoon',
  'webtoons',
  'full color',
  'full colour',
  'long strip',
};

SkillRank _rankFor(double share) {
  if (share >= 0.80) return SkillRank.sss;
  if (share >= 0.65) return SkillRank.ss;
  if (share >= 0.50) return SkillRank.s;
  if (share >= 0.25) return SkillRank.a;
  if (share >= 0.15) return SkillRank.b;
  if (share >= 0.10) return SkillRank.c;
  return SkillRank.d;
}

/// Top 7 genres by how many of [favs] carry them.
List<Skill> rankSkills(List<RecapSeries> favs) {
  if (favs.isEmpty) return const [];
  final counts = <String, int>{};
  final display = <String, String>{};
  for (final series in favs) {
    final seen = <String>{};
    for (final raw in series.genres) {
      final name = raw.trim();
      final key = name.toLowerCase();
      if (key.isEmpty || _formatTags.contains(key) || !seen.add(key)) continue;
      counts[key] = (counts[key] ?? 0) + 1;
      display.putIfAbsent(key, () => name);
    }
  }
  final keys = counts.keys.toList()
    ..sort((a, b) {
      final byCount = counts[b]!.compareTo(counts[a]!);
      return byCount != 0 ? byCount : a.compareTo(b);
    });
  return [
    for (final key in keys.take(7))
      Skill(
        genre: display[key]!,
        count: counts[key]!,
        share: counts[key]! / favs.length,
        rank: _rankFor(counts[key]! / favs.length),
      ),
  ];
}

/// Keywords matched at the start of a word in a series' title or genres.
const _classKeywords = {
  ReaderClass.regressor: [
    'regression',
    'return',
    'reincarnation',
    'rebirth',
    'reborn',
    'transmigrat',
  ],
  ReaderClass.murimMaster: [
    'murim',
    'martial arts',
    'wuxia',
    'cultivation',
    'sect',
  ],
  ReaderClass.hunter: ['system', 'dungeon', 'hunter', 'level', 'tower'],
  ReaderClass.archmage: ['magic', 'mage', 'wizard'],
  ReaderClass.romantic: ['romance', 'shoujo', 'josei'],
  ReaderClass.villain: ['villain'],
};

final _classPatterns = {
  for (final entry in _classKeywords.entries)
    entry.key: RegExp(
      '\\b(${entry.value.map(RegExp.escape).join('|')})',
      caseSensitive: false,
    ),
};

bool _matches(RecapSeries series, ReaderClass readerClass) =>
    _classPatterns[readerClass]!.hasMatch(
      '${series.name}\n${series.genres.join('\n')}',
    );

ReaderClass classify(List<RecapSeries> favs) {
  var best = ReaderClass.wanderer;
  var bestCount = 0;
  for (final readerClass in _classKeywords.keys) {
    final count = favs.where((s) => _matches(s, readerClass)).length;
    if (count > bestCount) {
      best = readerClass;
      bestCount = count;
    }
  }
  return best;
}

Map<String, int> _sourceCounts(List<RecapSeries> favs) {
  final counts = <String, int>{};
  for (final series in favs) {
    final source = series.source;
    if (source == null || source.isEmpty) continue;
    counts[source] = (counts[source] ?? 0) + 1;
  }
  return counts;
}

MapEntry<String, int>? _topEntry(Map<String, int> counts) {
  MapEntry<String, int>? top;
  for (final entry in counts.entries) {
    if (top == null ||
        entry.value > top.value ||
        (entry.value == top.value && entry.key.compareTo(top.key) < 0)) {
      top = entry;
    }
  }
  return top;
}

Epithet epithetFor(List<RecapSeries> favs) {
  final counts = _sourceCounts(favs);
  final top = _topEntry(counts);
  final disciple = top != null && top.value * 4 >= favs.length;
  return Epithet(
    disciple: disciple,
    source: disciple ? top.key : null,
    sourceCount: counts.length,
  );
}

int _fullYearsBetween(DateTime from, DateTime to) {
  var years = to.year - from.year;
  final anniversary = DateTime(
    to.year,
    from.month,
    from.day,
    from.hour,
    from.minute,
  );
  if (anniversary.isAfter(to)) years--;
  return max(0, years);
}

List<Badge> badgesFor({
  required List<RecapSeries> favs,
  required int clearedCount,
  required int peakHour,
  required DateTime? since,
  required int maxDayCompletions,
  required DateTime now,
}) {
  final regressors = favs
      .where((s) => _matches(s, ReaderClass.regressor))
      .length;
  final topSource = _topEntry(_sourceCounts(favs));
  RecapSeries? longest;
  for (final series in favs) {
    if (longest == null || series.chaptersRead > longest.chaptersRead) {
      longest = series;
    }
  }
  final longestCount = longest?.chaptersRead ?? 0;
  final years = since == null ? 0 : _fullYearsBetween(since, now);

  return [
    Badge(id: BadgeId.regressor, unlocked: regressors >= 25, value: regressors),
    Badge(
      id: BadgeId.sourceLoyalist,
      unlocked: (topSource?.value ?? 0) >= 100,
      value: topSource?.value ?? 0,
      label: topSource?.key,
    ),
    Badge(
      id: BadgeId.marathoner,
      unlocked: longestCount >= 300,
      value: longestCount,
      label: longestCount > 0 ? longest!.name : null,
    ),
    Badge(
      id: BadgeId.collector,
      unlocked: favs.length >= 500,
      value: favs.length,
    ),
    Badge(
      id: BadgeId.dawnCultivator,
      unlocked: peakHour >= 5 && peakHour <= 9,
      value: peakHour,
    ),
    Badge(
      id: BadgeId.nightOwl,
      unlocked: peakHour >= 0 && peakHour <= 4,
      value: peakHour,
    ),
    Badge(
      id: BadgeId.completionist,
      unlocked: clearedCount >= 10,
      value: clearedCount,
    ),
    Badge(id: BadgeId.veteran, unlocked: years >= 2, value: years),
    Badge(
      id: BadgeId.binger,
      unlocked: maxDayCompletions >= 100,
      value: maxDayCompletions,
    ),
  ];
}

/// Local hour of day, 24 buckets.
List<int> hourHistogram(Iterable<int> epochMs) {
  final hist = List.filled(24, 0);
  for (final ms in epochMs) {
    hist[DateTime.fromMillisecondsSinceEpoch(ms).hour]++;
  }
  return hist;
}

/// Local weekday, 7 buckets, Monday first.
List<int> weekdayHistogram(Iterable<int> epochMs) {
  final hist = List.filled(7, 0);
  for (final ms in epochMs) {
    hist[DateTime.fromMillisecondsSinceEpoch(ms).weekday - 1]++;
  }
  return hist;
}

/// The busiest bucket (earliest on ties), or -1 when [hist] is all zero.
int peakHour(List<int> hist) {
  var peak = -1;
  var best = 0;
  for (var i = 0; i < hist.length; i++) {
    if (hist[i] > best) {
      best = hist[i];
      peak = i;
    }
  }
  return peak;
}

StatusWindowData deriveStatusWindow({
  required List<RecapSeries> favs,
  required int units,
  required int clearedCount,
  required List<int> clockMs,
  required int? firstLogMs,
  required int maxDayCompletions,
  required DateTime now,
}) {
  final level = levelFor(units);
  final starts = [
    for (final series in favs)
      if ((series.dateAdded ?? 0) > 0) series.dateAdded!,
    if ((firstLogMs ?? 0) > 0) firstLogMs!,
  ];
  final since = starts.isEmpty
      ? null
      : DateTime.fromMillisecondsSinceEpoch(starts.reduce(min));
  final hours = hourHistogram(clockMs);
  final bonded = favs.where((s) => s.seconds > 0 || s.chaptersRead > 0).toList()
    ..sort((a, b) {
      final bySeconds = b.seconds.compareTo(a.seconds);
      return bySeconds != 0
          ? bySeconds
          : b.chaptersRead.compareTo(a.chaptersRead);
    });

  return StatusWindowData(
    level: level,
    units: units,
    nextLevelAt: unitsForLevel(level + 1),
    prevLevelAt: unitsForLevel(level),
    totalSeconds: favs.fold(0, (sum, s) => sum + s.seconds),
    libraryCount: favs.length,
    clearedCount: clearedCount,
    since: since,
    readerClass: classify(favs),
    epithet: epithetFor(favs),
    skills: rankSkills(favs),
    bonded: bonded.take(5).toList(),
    hourHistogram: hours,
    weekdayHistogram: weekdayHistogram(clockMs),
    badges: badgesFor(
      favs: favs,
      clearedCount: clearedCount,
      peakHour: peakHour(hours),
      since: since,
      maxDayCompletions: maxDayCompletions,
      now: now,
    ),
  );
}

int _longestRun(Set<int> days) {
  var longest = 0;
  for (final day in days) {
    if (days.contains(day - 1)) continue;
    var length = 1;
    while (days.contains(day + length)) {
      length++;
    }
    longest = max(longest, length);
  }
  return longest;
}

/// One month's Episode from its log rows. Rows outside [month] (local time)
/// or for a series missing from [series] are ignored.
MonthStats aggregateMonth({
  required DateTime month,
  required List<ReadingLog> rows,
  required Set<int> seenBefore,
  required Map<int, RecapSeries> series,
  required Set<int> caughtUpIds,
  required int? previousSeconds,
}) {
  final start = DateTime(month.year, month.month);
  var seconds = 0;
  var completions = 0;
  final secondsById = <int, int>{};
  final completionsById = <int, int>{};
  final completionsByDay = <int, int>{};
  final lastCompletion = <int, int>{};
  final daysRead = <int>{};
  final clock = <int>[];

  for (final row in rows) {
    final id = row.mangaId;
    if (id == null || !series.containsKey(id)) continue;
    final at = DateTime.fromMillisecondsSinceEpoch(row.at);
    if (at.year != start.year || at.month != start.month) continue;
    daysRead.add(at.day);
    clock.add(row.at);
    secondsById.putIfAbsent(id, () => 0);
    completionsById.putIfAbsent(id, () => 0);
    if (row.kind == ReadingLogKind.time) {
      seconds += row.seconds;
      secondsById[id] = secondsById[id]! + row.seconds;
    } else {
      completions++;
      completionsById[id] = completionsById[id]! + 1;
      completionsByDay[at.day] = (completionsByDay[at.day] ?? 0) + 1;
      lastCompletion[id] = max(lastCompletion[id] ?? 0, row.at);
    }
  }

  ({DateTime day, int completions})? biggestDay;
  for (final entry in completionsByDay.entries) {
    if (biggestDay == null ||
        entry.value > biggestDay.completions ||
        (entry.value == biggestDay.completions &&
            entry.key < biggestDay.day.day)) {
      biggestDay = (
        day: DateTime(start.year, start.month, entry.key),
        completions: entry.value,
      );
    }
  }

  int? topId;
  for (final id in secondsById.keys) {
    if (topId == null) {
      topId = id;
      continue;
    }
    final bySeconds = secondsById[id]!.compareTo(secondsById[topId]!);
    if (bySeconds > 0 ||
        (bySeconds == 0 && completionsById[id]! > completionsById[topId]!)) {
      topId = id;
    }
  }

  final finished = lastCompletion.keys.where(caughtUpIds.contains).toList()
    ..sort((a, b) => lastCompletion[b]!.compareTo(lastCompletion[a]!));

  return MonthStats(
    month: start,
    seconds: seconds,
    completions: completions,
    seriesCount: secondsById.length,
    newSeriesCount: secondsById.keys
        .where((id) => !seenBefore.contains(id))
        .length,
    biggestDay: biggestDay,
    daysRead: daysRead,
    longestStreak: _longestRun(daysRead),
    top: topId == null
        ? null
        : series[topId]!.copyWith(
            seconds: secondsById[topId],
            chaptersRead: completionsById[topId],
          ),
    genres: rankSkills([for (final id in secondsById.keys) series[id]!]),
    hourHistogram: hourHistogram(clock),
    finishedIds: finished,
    previousSeconds: previousSeconds,
  );
}

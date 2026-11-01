enum SkillRank { sss, ss, s, a, b, c, d }

/// A genre shown as a skill bar: [share] is the fraction of favourite series
/// carrying it.
class Skill {
  final String genre;
  final int count;
  final double share;
  final SkillRank rank;

  const Skill({
    required this.genre,
    required this.count,
    required this.share,
    required this.rank,
  });
}

/// Ties between classes go to declaration order.
enum ReaderClass {
  regressor,
  murimMaster,
  hunter,
  archmage,
  romantic,
  villain,
  wanderer,
}

enum BadgeId {
  regressor,
  sourceLoyalist,
  marathoner,
  collector,
  dawnCultivator,
  nightOwl,
  completionist,
  veteran,
  binger,
}

class Badge {
  final BadgeId id;
  final bool unlocked;

  /// The real number behind the badge (series, chapters, hour, years…).
  final int value;

  /// Source name for Source Loyalist, series name for Marathoner.
  final String? label;

  const Badge({
    required this.id,
    required this.unlocked,
    required this.value,
    this.label,
  });
}

/// One favourite series as the recap sees it.
class RecapSeries {
  final int id;
  final String name;
  final List<String> genres;
  final String? source;

  /// Epoch milliseconds.
  final int? dateAdded;
  final int chaptersRead;
  final int seconds;
  final int? lastReadMs;
  final bool cleared;

  const RecapSeries({
    required this.id,
    required this.name,
    this.genres = const [],
    this.source,
    this.dateAdded,
    this.chaptersRead = 0,
    this.seconds = 0,
    this.lastReadMs,
    this.cleared = false,
  });

  RecapSeries copyWith({int? chaptersRead, int? seconds}) => RecapSeries(
    id: id,
    name: name,
    genres: genres,
    source: source,
    dateAdded: dateAdded,
    chaptersRead: chaptersRead ?? this.chaptersRead,
    seconds: seconds ?? this.seconds,
    lastReadMs: lastReadMs,
    cleared: cleared,
  );
}

/// "Disciple of [source]" when [disciple], else "Wanderer of [sourceCount]
/// sources".
class Epithet {
  final bool disciple;
  final String? source;
  final int sourceCount;

  const Epithet({
    required this.disciple,
    required this.source,
    required this.sourceCount,
  });
}

class StatusWindowData {
  final int level;
  final int units;
  final int nextLevelAt;
  final int prevLevelAt;
  final int totalSeconds;
  final int libraryCount;
  final int clearedCount;
  final DateTime? since;
  final ReaderClass readerClass;
  final Epithet epithet;
  final List<Skill> skills;

  /// Every read series by how long you've been reading it ([bondMs]), then
  /// chapters, then time.
  final List<RecapSeries> bonded;

  /// 24 buckets, local hour.
  final List<int> hourHistogram;

  /// 7 buckets, Monday first.
  final List<int> weekdayHistogram;
  final List<Badge> badges;

  const StatusWindowData({
    required this.level,
    required this.units,
    required this.nextLevelAt,
    required this.prevLevelAt,
    required this.totalSeconds,
    required this.libraryCount,
    required this.clearedCount,
    required this.since,
    required this.readerClass,
    required this.epithet,
    required this.skills,
    required this.bonded,
    required this.hourHistogram,
    required this.weekdayHistogram,
    required this.badges,
  });
}

class MonthStats {
  /// First day of the month, local time.
  final DateTime month;
  final int seconds;
  final int completions;
  final int seriesCount;
  final int newSeriesCount;
  final ({DateTime day, int completions})? biggestDay;

  /// Days of the month with any reading.
  final Set<int> daysRead;
  final int longestStreak;

  /// The month's #1, carrying this month's seconds and completions.
  final RecapSeries? top;
  final List<Skill> genres;
  final List<int> hourHistogram;

  /// Series finished or caught up this month, latest first.
  final List<int> finishedIds;
  final int? previousSeconds;

  const MonthStats({
    required this.month,
    required this.seconds,
    required this.completions,
    required this.seriesCount,
    required this.newSeriesCount,
    required this.biggestDay,
    required this.daysRead,
    required this.longestStreak,
    required this.top,
    required this.genres,
    required this.hourHistogram,
    required this.finishedIds,
    required this.previousSeconds,
  });
}

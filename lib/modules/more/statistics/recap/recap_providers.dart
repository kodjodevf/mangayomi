import 'dart:math';

import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/reading_log_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'recap_providers.g.dart';

/// Upper bound for "every log row": the log stores epoch milliseconds.
const _endOfTime = 9007199254740991;

class EpisodeSummary {
  /// First day of the month, local time.
  final DateTime month;
  final int seconds;
  final int completions;

  /// Up to 4 series, most read first, for the list tile's covers.
  final List<int> coverMangaIds;

  const EpisodeSummary({
    required this.month,
    required this.seconds,
    required this.completions,
    required this.coverMangaIds,
  });
}

RecapSeries _toSeries(
  Manga manga, {
  int chaptersRead = 0,
  int seconds = 0,
  int? lastReadMs,
  bool cleared = false,
}) => RecapSeries(
  id: manga.id!,
  name: manga.name ?? '',
  genres: manga.genre ?? const [],
  source: manga.source,
  dateAdded: manga.dateAdded,
  chaptersRead: chaptersRead,
  seconds: seconds,
  lastReadMs: lastReadMs,
  cleared: cleared,
);

/// Cleared keeps the classic screen's definition: status Completed, at least
/// one chapter, every chapter read.
Future<Set<int>> _clearedIds(ItemType itemType) async {
  final ids = <int>{};
  for (final id in await mangaRepository.getCompletedFavoriteIds(itemType)) {
    if (await chapterRepository.countByMangaIdAsync(id) == 0) continue;
    if (await chapterRepository.countUnreadByMangaId(id) == 0) ids.add(id);
  }
  return ids;
}

/// Log rows of favourites only: rows of series removed from the library
/// don't count.
Future<List<ReadingLog>> _favouriteRows(
  ItemType itemType,
  Set<int> favouriteIds, {
  int fromMs = 0,
  int toMs = _endOfTime,
}) async => (await readingLogRepository.getRange(
  itemType,
  fromMs,
  toMs,
)).where((r) => favouriteIds.contains(r.mangaId)).toList();

int _dayKey(int ms) {
  final at = DateTime.fromMillisecondsSinceEpoch(ms);
  return at.year * 10000 + at.month * 100 + at.day;
}

@riverpod
Future<StatusWindowData> statusWindow(
  Ref ref, {
  required ItemType itemType,
}) async {
  final mangas = mangaRepository.getFavoritesByItemType(itemType);
  final favouriteIds = {for (final m in mangas) m.id!};

  final readIds = await chapterRepository.readMangaIdsByFavoriteItemType(
    itemType,
  );
  final readCounts = <int, int>{};
  for (final id in readIds) {
    if (id != null) readCounts[id] = (readCounts[id] ?? 0) + 1;
  }

  final seconds = <int, int>{};
  final lastRead = <int, int>{};
  for (final history in await historyRepository.getAllByItemType(itemType)) {
    final id = history.mangaId;
    if (id == null || !favouriteIds.contains(id)) continue;
    seconds[id] = (seconds[id] ?? 0) + (history.readingTimeSeconds ?? 0);
    final date = int.tryParse(history.date ?? '');
    if (date != null && date > 0) lastRead[id] = max(lastRead[id] ?? 0, date);
  }

  final cleared = await _clearedIds(itemType);
  final favs = [
    for (final manga in mangas)
      _toSeries(
        manga,
        chaptersRead: readCounts[manga.id] ?? 0,
        seconds: seconds[manga.id] ?? 0,
        lastReadMs: lastRead[manga.id],
        cleared: cleared.contains(manga.id),
      ),
  ];

  final rows = await _favouriteRows(itemType, favouriteIds);
  final completionsPerDay = <int, int>{};
  for (final row in rows) {
    if (row.kind != ReadingLogKind.completion) continue;
    final key = _dayKey(row.at);
    completionsPerDay[key] = (completionsPerDay[key] ?? 0) + 1;
  }

  return deriveStatusWindow(
    favs: favs,
    units: readIds.length,
    clearedCount: cleared.length,
    // Before the log has entries, the best clock we have is each series'
    // last read.
    clockMs: rows.isNotEmpty
        ? [for (final r in rows) r.at]
        : lastRead.values.toList(),
    firstLogMs: rows.isEmpty ? null : rows.map((r) => r.at).reduce(min),
    maxDayCompletions: completionsPerDay.values.fold(0, max),
    now: DateTime.now(),
  );
}

@riverpod
Future<({List<EpisodeSummary> months, StatusWindowData prologue})> episodeList(
  Ref ref, {
  required ItemType itemType,
}) async {
  final prologue = await ref.watch(
    statusWindowProvider(itemType: itemType).future,
  );
  final favouriteIds = {
    for (final m in mangaRepository.getFavoritesByItemType(itemType)) m.id!,
  };
  final rows = await _favouriteRows(itemType, favouriteIds);

  final byMonth = <DateTime, List<ReadingLog>>{};
  for (final row in rows) {
    final at = DateTime.fromMillisecondsSinceEpoch(row.at);
    byMonth.putIfAbsent(DateTime(at.year, at.month), () => []).add(row);
  }

  final months = [
    for (final entry in byMonth.entries) _summarize(entry.key, entry.value),
  ]..sort((a, b) => b.month.compareTo(a.month));
  return (months: months, prologue: prologue);
}

EpisodeSummary _summarize(DateTime month, List<ReadingLog> rows) {
  var seconds = 0;
  var completions = 0;
  final secondsById = <int, int>{};
  final completionsById = <int, int>{};
  for (final row in rows) {
    final id = row.mangaId!;
    if (row.kind == ReadingLogKind.time) {
      seconds += row.seconds;
      secondsById[id] = (secondsById[id] ?? 0) + row.seconds;
    } else {
      completions++;
      completionsById[id] = (completionsById[id] ?? 0) + 1;
    }
  }
  final ids = {...secondsById.keys, ...completionsById.keys}.toList()
    ..sort((a, b) {
      final bySeconds = (secondsById[b] ?? 0).compareTo(secondsById[a] ?? 0);
      return bySeconds != 0
          ? bySeconds
          : (completionsById[b] ?? 0).compareTo(completionsById[a] ?? 0);
    });
  return EpisodeSummary(
    month: month,
    seconds: seconds,
    completions: completions,
    coverMangaIds: ids.take(4).toList(),
  );
}

@riverpod
Future<MonthStats> episode(
  Ref ref, {
  required ItemType itemType,
  required int year,
  required int month,
}) async {
  final start = DateTime(year, month);
  final end = DateTime(year, month + 1);
  final previous = DateTime(year, month - 1);

  final series = {
    for (final m in mangaRepository.getFavoritesByItemType(itemType))
      m.id!: _toSeries(m),
  };
  final favouriteIds = series.keys.toSet();
  final rows = await _favouriteRows(
    itemType,
    favouriteIds,
    fromMs: start.millisecondsSinceEpoch,
    toMs: end.millisecondsSinceEpoch,
  );
  final seenBefore = (await readingLogRepository.mangaIdsBefore(
    itemType,
    start.millisecondsSinceEpoch,
  )).whereType<int>().toSet();

  // Finished this month: nothing unread now, and no completion after the
  // month, so the last one fell inside it.
  final completedLater = await readingLogRepository.mangaIdsCompletedFrom(
    itemType,
    end.millisecondsSinceEpoch,
  );
  final caughtUpIds = <int>{};
  for (final id in rows.map((r) => r.mangaId!).toSet()) {
    if (completedLater.contains(id)) continue;
    if (await chapterRepository.countUnreadByMangaId(id) == 0) {
      caughtUpIds.add(id);
    }
  }

  final previousTime = (await _favouriteRows(
    itemType,
    favouriteIds,
    fromMs: previous.millisecondsSinceEpoch,
    toMs: start.millisecondsSinceEpoch,
  )).where((r) => r.kind == ReadingLogKind.time);

  return aggregateMonth(
    month: start,
    rows: rows,
    seenBefore: seenBefore,
    series: series,
    caughtUpIds: caughtUpIds,
    previousSeconds: previousTime.isEmpty
        ? null
        : previousTime.fold<int>(0, (sum, r) => sum + r.seconds),
  );
}

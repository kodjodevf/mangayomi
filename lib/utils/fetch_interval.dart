import 'dart:math';

import 'package:mangayomi/models/chapter.dart';

/// Computes the fetch interval and next expected update date for a manga.
///
/// Uses the median of intervals between recent chapter upload dates
/// (falling back to fetch/updatedAt dates) to determine a reliable
/// release cadence. The interval is clamped to [1, maxInterval] days.
class FetchInterval {
  FetchInterval._();

  /// Maximum interval in days.
  static const int maxInterval = 28;

  /// Grace period in days for the fetch window.
  static const int _gracePeriod = 1;

  /// Calculates the fetch interval in days from a list of chapters.
  ///
  /// - Takes the last N **distinct** dates (N = 3 if ≤8 chapters, else 10)
  /// - Computes pairwise day-gaps, sorts them, picks the **median**
  /// - Falls back to fetch dates (`updatedAt`) if upload dates are insufficient
  /// - Defaults to 7 days if still insufficient
  /// - Clamps to [1, [maxInterval]]
  static int calculateInterval(List<Chapter> chapters) {
    final chapterWindow = chapters.length <= 8 ? 3 : 10;

    // ── Upload dates (primary signal) ──
    final uploadDates =
        chapters
            .where((c) {
              final ms = int.tryParse(c.dateUpload ?? '');
              return ms != null && ms > 0;
            })
            .map((c) => int.parse(c.dateUpload!))
            .toList()
          ..sort((a, b) => b.compareTo(a)); // descending

    final distinctUploadDays = _distinctDays(
      uploadDates,
    ).take(chapterWindow).toList();

    if (distinctUploadDays.length >= 3) {
      return _medianInterval(distinctUploadDays);
    }

    // ── Fetch / updatedAt dates (fallback signal) ──
    final fetchDates =
        chapters
            .where((c) => c.updatedAt != null && c.updatedAt! > 0)
            .map((c) => c.updatedAt!)
            .toList()
          ..sort((a, b) => b.compareTo(a)); // descending

    final distinctFetchDays = _distinctDays(
      fetchDates,
    ).take(chapterWindow).toList();

    if (distinctFetchDays.length >= 3) {
      return _medianInterval(distinctFetchDays);
    }

    // ── Not enough data → default 7 days ──
    return 7;
  }

  /// Computes the next expected update timestamp (milliseconds since epoch)
  /// for a manga.
  ///
  /// [lastUpdate]    – epoch millis when chapters were last synced
  /// [interval]      – fetch interval in days (from [calculateInterval])
  /// [currentNextUpdate] – previously stored next-update epoch millis (0 if none)
  /// [now]           – current DateTime (injectable for testing)
  static int calculateNextUpdate({
    required int lastUpdate,
    required int interval,
    int currentNextUpdate = 0,
    DateTime? now,
  }) {
    final dateTime = now ?? DateTime.now();

    // If existing nextUpdate is within the grace window, keep it.
    if (currentNextUpdate > 0) {
      final window = getWindow(dateTime);
      if (currentNextUpdate >= window.$1 &&
          currentNextUpdate <= window.$2 + 1) {
        return currentNextUpdate;
      }
    }

    final latestDate = lastUpdate > 0
        ? DateTime.fromMillisecondsSinceEpoch(lastUpdate)
        : dateTime;
    final latestDay = DateTime(
      latestDate.year,
      latestDate.month,
      latestDate.day,
    );

    final nowDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final timeSinceLatest = nowDay.difference(latestDay).inDays;

    final effectiveInterval = interval < 0
        ? interval.abs()
        : _increaseInterval(interval, timeSinceLatest, increaseWhenOver: 10);

    final cycle = effectiveInterval > 0
        ? timeSinceLatest ~/ effectiveInterval
        : 0;

    return latestDay
        .add(Duration(days: (cycle + 1) * interval.abs()))
        .millisecondsSinceEpoch;
  }

  /// Computes the expected next update [DateTime] for a manga, suitable
  /// for the calendar screen.
  ///
  /// [lastChapterDateMs] – epoch millis of last chapter upload date
  /// [lastUpdateMs]      – epoch millis of when manga was last updated/synced
  /// [interval]          – fetch interval in days
  static DateTime? computeExpectedDate({
    required int? lastChapterDateMs,
    required int? lastUpdateMs,
    required int? interval,
    DateTime? now,
  }) {
    if (interval == null || interval <= 0) return null;

    final dateTime = now ?? DateTime.now();

    // Use the most recent of: last chapter upload date, last manga update
    final referenceMs = [
      if (lastChapterDateMs != null && lastChapterDateMs > 0) lastChapterDateMs,
      if (lastUpdateMs != null && lastUpdateMs > 0) lastUpdateMs,
    ];
    if (referenceMs.isEmpty) return null;

    final latestMs = referenceMs.reduce(max);
    final latestDate = DateTime.fromMillisecondsSinceEpoch(latestMs);
    final latestDay = DateTime(
      latestDate.year,
      latestDate.month,
      latestDate.day,
    );

    final nowDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final timeSinceLatest = nowDay.difference(latestDay).inDays;

    if (timeSinceLatest < 0) {
      // Latest date is in the future, next update = latestDay + interval
      return latestDay.add(Duration(days: interval));
    }

    // Find which cycle we're in and return start of next cycle
    final effectiveInterval = _increaseInterval(
      interval,
      timeSinceLatest,
      increaseWhenOver: 10,
    );
    final cycle = effectiveInterval > 0
        ? timeSinceLatest ~/ effectiveInterval
        : 0;
    return latestDay.add(Duration(days: (cycle + 1) * interval));
  }

  /// Returns the fetch window as (lowerBound, upperBound) in epoch millis.
  /// Today ± [_gracePeriod] day(s).
  static (int, int) getWindow(DateTime dateTime) {
    final today = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final lower = today.subtract(Duration(days: _gracePeriod));
    final upper = today.add(Duration(days: _gracePeriod));
    return (lower.millisecondsSinceEpoch, upper.millisecondsSinceEpoch - 1);
  }

  // ── Private helpers ──

  /// Doubles the interval progressively if too many check cycles
  /// have been missed (>10).
  static int _increaseInterval(
    int delta,
    int timeSinceLatest, {
    required int increaseWhenOver,
  }) {
    if (delta >= maxInterval) return maxInterval;

    final cycle = (timeSinceLatest ~/ delta) + 1;
    if (cycle > increaseWhenOver) {
      return _increaseInterval(
        min(delta * 2, maxInterval),
        timeSinceLatest,
        increaseWhenOver: increaseWhenOver,
      );
    }
    return delta;
  }

  /// Deduplicates epoch-millis timestamps to distinct calendar days,
  /// preserving order. Returns day-start epoch millis.
  static Iterable<int> _distinctDays(List<int> epochMillis) sync* {
    final seen = <int>{};
    for (final ms in epochMillis) {
      final day = DateTime.fromMillisecondsSinceEpoch(ms);
      final dayKey = DateTime(
        day.year,
        day.month,
        day.day,
      ).millisecondsSinceEpoch;
      if (seen.add(dayKey)) {
        yield dayKey;
      }
    }
  }

  /// Computes pairwise day-gaps from a list of distinct day-start
  /// epoch-millis (descending order), sorts them, and returns the median.
  /// Clamps to [1, [maxInterval]].
  static int _medianInterval(List<int> distinctDays) {
    final ranges = <int>[];
    for (var i = 0; i + 1 < distinctDays.length; i++) {
      final daysDiff =
          (DateTime.fromMillisecondsSinceEpoch(distinctDays[i]).difference(
            DateTime.fromMillisecondsSinceEpoch(distinctDays[i + 1]),
          )).inDays.abs();
      ranges.add(daysDiff);
    }
    ranges.sort();
    // Median: middle element (upper-median for even length)
    final median = ranges[(ranges.length - 1) ~/ 2];
    return median.clamp(1, maxInterval);
  }
}

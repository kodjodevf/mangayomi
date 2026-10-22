// Download scheduling, concurrency, and queue-record lifecycle - the part
// of the old downloadChapter god-function that has nothing to do with
// Riverpod, HTTP, or the filesystem. Split out so it can be reasoned about
// (and tested) as a standalone concurrency primitive.
import 'dart:async';
import 'dart:math';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/download_manager/download_queue_order.dart';

final _scheduledDownloadIds = <int>{};

bool isDownloadScheduled(int? id) => _scheduledDownloadIds.contains(id);

/// Claims [id] for scheduling. Returns false if it was already scheduled,
/// so the caller can no-op instead of starting a second concurrent attempt
/// for the same chapter.
bool scheduleDownload(int id) => _scheduledDownloadIds.add(id);

void unscheduleDownload(int? id) => _scheduledDownloadIds.remove(id);

/// Delay before releasing the next queued download from the gate. With rate
/// limiting off ([baseSeconds] 0) there is no artificial delay — the gate's
/// concurrency limit and per-source serialization already prevent hammering, so
/// downloads should start as soon as a slot is free. Otherwise it is the chosen
/// base plus 25% to 100% random jitter, spacing requests out and varying them so
/// a source is less likely to IP-block or wear a plugin out. See #621.
Duration downloadStartDelay(int baseSeconds) {
  if (baseSeconds <= 0) return Duration.zero;
  final base = baseSeconds * 1000;
  final jitter = (base * (0.25 + Random().nextDouble() * 0.75)).round();
  return Duration(milliseconds: base + jitter);
}

/// Reset a failed/aborted download to a plain, tappable "not downloaded" state
/// so it shows a retry-able icon instead of a progress bar frozen at its last
/// value. Any partial file is cleaned up on the next attempt.
Future<void> markDownloadFailed(Chapter chapter) async {
  final record = downloadRepository.getById(chapter.id!);
  if (record == null || (record.isDownload ?? false)) return;
  await downloadRepository.save(
    record
      ..isStartDownload = false
      ..succeeded = 0
      ..failed = 1,
  );
}

/// True when a download was cancelled while it was queued. cancelDownloads
/// deletes the record, so a missing record for a chapter we were about to
/// download means "cancelled" — bail instead of resurrecting it. This matters
/// because every download is fired up front and then waits in the gate; a
/// cancel that lands while it waits must actually stop it.
bool isDownloadCancelled(Chapter chapter) =>
    downloadRepository.getById(chapter.id!) == null;

/// Key identifying the source a chapter belongs to, used to serialize
/// downloads from the same source. Falls back to a per-chapter unique key when
/// the source can't be resolved, so an unknown source never over-serializes.
String chapterSourceKey(Chapter chapter) {
  if (!chapter.manga.isLoaded) {
    try {
      chapter.manga.loadSync();
    } catch (_) {}
  }
  final m = chapter.manga.value;
  if (m?.source == null) return 'chapter-${chapter.id}';
  return '${m!.source}|${m.lang}|${m.sourceId}';
}

/// A download waiting for a slot in [DownloadGate]. [id] is the download's id
/// (== chapter id), used to honor the manual queue order.
class _GateWaiter {
  _GateWaiter(this.id, this.sourceKey, this.completer);
  final int id;
  final String sourceKey;
  final Completer<void> completer;
}

/// App-wide gate every download passes through before doing network work.
/// It bounds how many downloads run at once, keeps a single source strictly
/// serial (#645), spaces launches apart with a jittered delay (#621), and hands
/// out slots in the user's manual queue order (#514) — all independent of how
/// the download was triggered (per-chapter icon, "download all", or the queue
/// processor).
class DownloadGate {
  DownloadGate._();
  static final DownloadGate instance = DownloadGate._();

  int _active = 0;
  int _maxConcurrent = 1;
  int _delaySeconds = 0;
  final Set<String> _activeSources = <String>{};
  final List<_GateWaiter> _waiters = <_GateWaiter>[];

  Future<void> acquire({
    required int id,
    required String sourceKey,
    required int maxConcurrent,
    required int delaySeconds,
  }) {
    _maxConcurrent = maxConcurrent < 1 ? 1 : maxConcurrent;
    _delaySeconds = delaySeconds;
    final completer = Completer<void>();
    _waiters.add(_GateWaiter(id, sourceKey, completer));
    _dispatch();
    return completer.future;
  }

  void release(String sourceKey) {
    if (_active > 0) _active--;
    _activeSources.remove(sourceKey);
    _dispatch();
  }

  /// Reorder the waiting list by the user's saved manual order (#514), re-read
  /// each dispatch so dragging a chapter up takes effect on what's still
  /// waiting. Ids not in the saved order keep their current relative order,
  /// after the ranked ones, so a plain queue behaves exactly as before.
  void _reorderWaiters() {
    final order = DownloadQueueOrder.order;
    if (order.isEmpty || _waiters.length < 2) return;
    final rank = <int, int>{};
    for (var j = 0; j < order.length; j++) {
      rank[order[j]] = j;
    }
    final decorated = [
      for (var j = 0; j < _waiters.length; j++) (pos: j, w: _waiters[j]),
    ];
    decorated.sort((a, b) {
      final ra = rank[a.w.id] ?? (order.length + a.pos);
      final rb = rank[b.w.id] ?? (order.length + b.pos);
      return ra.compareTo(rb);
    });
    _waiters
      ..clear()
      ..addAll(decorated.map((e) => e.w));
  }

  void _dispatch() {
    // Only worth reordering when a slot is actually free to grant; skipping it
    // when full keeps a big "download all" burst from doing O(n^2) sorting.
    if (_active < _maxConcurrent) _reorderWaiters();
    var i = 0;
    while (i < _waiters.length && _active < _maxConcurrent) {
      final waiter = _waiters[i];
      // Source already downloading — leave this one queued, try the next.
      if (_activeSources.contains(waiter.sourceKey)) {
        i++;
        continue;
      }
      _waiters.removeAt(i);
      _active++;
      _activeSources.add(waiter.sourceKey);
      // Reserve the slot now but only release the waiter after the start delay,
      // so launches stay spaced out instead of bursting.
      Future.delayed(downloadStartDelay(_delaySeconds), () {
        if (!waiter.completer.isCompleted) waiter.completer.complete();
      });
    }
  }
}

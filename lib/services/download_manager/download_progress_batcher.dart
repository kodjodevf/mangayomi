import 'dart:async';

class DownloadProgressUpdate {
  const DownloadProgressUpdate({
    required this.chapterId,
    required this.succeeded,
    required this.isCompleted,
    this.isFailed = false,
  });

  final int chapterId;
  final int succeeded;
  final bool isCompleted;
  final bool isFailed;

  bool get isTerminal => isCompleted || isFailed;
}

typedef DownloadProgressPersist =
    Future<void> Function(List<DownloadProgressUpdate> updates);

/// Coalesces progress events from all active downloads into bounded writes.
class DownloadProgressBatcher {
  DownloadProgressBatcher({
    required this.persist,
    this.interval = const Duration(milliseconds: 250),
  });

  final DownloadProgressPersist persist;
  final Duration interval;
  final Map<int, DownloadProgressUpdate> _pending = {};
  final Set<int> _terminalChapters = {};
  Timer? _timer;
  Future<void>? _flushFuture;
  bool _disposed = false;

  void update(DownloadProgressUpdate update) {
    if (_disposed) return;
    if (_terminalChapters.contains(update.chapterId)) return;

    final previous = _pending[update.chapterId];
    if (previous?.isTerminal == true) return;
    if (previous != null &&
        !update.isCompleted &&
        update.succeeded < previous.succeeded) {
      return;
    }

    _pending[update.chapterId] = update;
    if (update.isTerminal) {
      _terminalChapters.add(update.chapterId);
      unawaited(flushNow());
    } else {
      _scheduleFlush();
    }
  }

  void reset(int chapterId) {
    if (_disposed) return;
    _pending.remove(chapterId);
    _terminalChapters.remove(chapterId);
  }

  Future<void> flushNow() async {
    _timer?.cancel();
    _timer = null;
    await _flushLoop();
  }

  Future<void> dispose() async {
    if (_disposed) return;
    await flushNow();
    _disposed = true;
    _timer?.cancel();
    _timer = null;
    _pending.clear();
    _terminalChapters.clear();
  }

  void _scheduleFlush() {
    if (_timer != null || _disposed) return;
    _timer = Timer(interval, () {
      _timer = null;
      unawaited(flushNow());
    });
  }

  Future<void> _flushLoop() {
    final active = _flushFuture;
    if (active != null) return active;

    final future = _runFlushLoop();
    _flushFuture = future;
    return future.whenComplete(() {
      if (identical(_flushFuture, future)) {
        _flushFuture = null;
      }
    });
  }

  Future<void> _runFlushLoop() async {
    while (_pending.isNotEmpty) {
      final updates = List<DownloadProgressUpdate>.unmodifiable(
        _pending.values,
      );
      _pending.clear();
      await persist(updates);
    }
  }
}

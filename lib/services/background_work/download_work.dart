import 'dart:async';

import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/services/background_work/background_work.dart';
import 'package:mangayomi/services/download_manager/download_gate.dart';

/// Keeps the background work notification in step with the downloads of this
/// session: begun with the first, ended with the last, counting the chapters
/// done since the queue started and showing the one furthest along.
class DownloadWork {
  DownloadWork._();

  static final instance = DownloadWork._();

  /// Every download scheduled since the queue was last empty.
  final _seen = <int>{};
  StreamSubscription<List<Download>>? _progress;

  void start() {
    scheduledDownloads.addListener(_onScheduled);
    // Progress is written to the queue records, not to the scheduled set.
    _progress = downloadRepository.watchPendingStarted().listen(
      (_) => _report(),
    );
  }

  void dispose() {
    scheduledDownloads.removeListener(_onScheduled);
    unawaited(_progress?.cancel());
  }

  void _onScheduled() {
    final scheduled = scheduledDownloads.value;
    if (scheduled.isEmpty) {
      _seen.clear();
      BackgroundWork.end(BackgroundWorkKind.download);
      return;
    }
    if (_seen.isEmpty) BackgroundWork.begin(BackgroundWorkKind.download);
    _seen.addAll(scheduled);
    _report(force: true);
  }

  void _report({bool force = false}) {
    final scheduled = scheduledDownloads.value;
    if (scheduled.isEmpty) return;
    if (!force && !BackgroundWork.wantsReport) return;
    Download? current;
    for (final id in scheduled) {
      final record = downloadRepository.getById(id);
      if (record == null) continue;
      if (current == null ||
          (record.succeeded ?? 0) > (current.succeeded ?? 0)) {
        current = record;
      }
    }
    final total = current?.total ?? 0;
    String? detail;
    if (current != null && BackgroundWork.showsDetail) {
      final chapter = current.chapter;
      if (!chapter.isLoaded) chapter.loadSync();
      final manga = chapter.value?.manga;
      if (manga != null && !manga.isLoaded) manga.loadSync();
      detail = [manga?.value?.name, chapter.value?.name].nonNulls.join(' - ');
    }
    BackgroundWork.report(
      BackgroundWorkKind.download,
      BackgroundWorkProgress(
        done: _seen.length - scheduled.length,
        total: _seen.length,
        current: total > 0 ? (current!.succeeded ?? 0) / total : null,
        detail: detail,
      ),
    );
  }
}

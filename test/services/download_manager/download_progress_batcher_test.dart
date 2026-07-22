import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/download_manager/download_progress_batcher.dart';

void main() {
  test('coalesces progress updates by chapter', () async {
    final batches = <List<DownloadProgressUpdate>>[];
    final batcher = DownloadProgressBatcher(
      interval: const Duration(hours: 1),
      persist: (updates) async => batches.add(updates),
    );

    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 10,
        isCompleted: false,
      ),
    );
    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 25,
        isCompleted: false,
      ),
    );
    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 2,
        succeeded: 50,
        isCompleted: false,
      ),
    );

    await batcher.flushNow();

    expect(batches, hasLength(1));
    expect(
      batches.single.map((update) => update.chapterId),
      containsAll(<int>[1, 2]),
    );
    expect(
      batches.single.firstWhere((update) => update.chapterId == 1).succeeded,
      25,
    );
  });

  test(
    'terminal progress flushes immediately and wins over stale progress',
    () async {
      final batches = <List<DownloadProgressUpdate>>[];
      final batcher = DownloadProgressBatcher(
        interval: const Duration(hours: 1),
        persist: (updates) async => batches.add(updates),
      );

      batcher.update(
        const DownloadProgressUpdate(
          chapterId: 1,
          succeeded: 50,
          isCompleted: false,
        ),
      );
      batcher.update(
        const DownloadProgressUpdate(
          chapterId: 1,
          succeeded: 100,
          isCompleted: true,
        ),
      );
      await batcher.flushNow();
      batcher.update(
        const DownloadProgressUpdate(
          chapterId: 1,
          succeeded: 90,
          isCompleted: false,
        ),
      );
      await batcher.flushNow();

      expect(batches, hasLength(1));
      expect(batches.single.single.succeeded, 100);
      expect(batches.single.single.isCompleted, isTrue);
    },
  );

  test('failed progress is terminal', () async {
    final batches = <List<DownloadProgressUpdate>>[];
    final batcher = DownloadProgressBatcher(
      interval: const Duration(hours: 1),
      persist: (updates) async => batches.add(updates),
    );

    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 40,
        isCompleted: false,
      ),
    );
    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 40,
        isCompleted: false,
        isFailed: true,
      ),
    );
    await batcher.flushNow();
    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 90,
        isCompleted: false,
      ),
    );
    await batcher.flushNow();

    expect(batches, hasLength(1));
    expect(batches.single.single.isFailed, isTrue);
  });

  test('does not regress progress within a batch', () async {
    final batches = <List<DownloadProgressUpdate>>[];
    final batcher = DownloadProgressBatcher(
      interval: const Duration(hours: 1),
      persist: (updates) async => batches.add(updates),
    );

    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 80,
        isCompleted: false,
      ),
    );
    batcher.update(
      const DownloadProgressUpdate(
        chapterId: 1,
        succeeded: 20,
        isCompleted: false,
      ),
    );
    await batcher.flushNow();

    expect(batches.single.single.succeeded, 80);
  });
}

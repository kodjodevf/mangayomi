import 'dart:async';
import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';

void fakeWorker(SendPort mainPort) {
  final port = ReceivePort();
  mainPort.send(port.sendPort);
  port.listen((dynamic task) {
    final reply = task.replyPort as SendPort;
    reply.send(DownloadProgress(0, 100, ItemType.anime));
    if (task.taskId != 'blocked') reply.send(DownloadComplete());
  });
}

void brokenWorker(SendPort mainPort) =>
    throw StateError('Test startup failure');

void main() {
  test(
    'cancellation during cold worker initialization prevents submission',
    () async {
      final pool = DownloadIsolatePool.forTesting(workerEntryPoint: fakeWorker);
      final cancelled = Completer<Exception>();
      try {
        final submission = pool.submitFileDownload(
          taskId: 'cold',
          pageUrls: [],
          concurrentDownloads: 1,
          itemType: ItemType.anime,
          onProgress: (_) => fail('Cancelled task started'),
          onComplete: () => fail('Cancelled task completed'),
          onError: cancelled.complete,
        );
        pool.cancelTask('cold');
        await submission;
        expect(
          await cancelled.future.timeout(const Duration(seconds: 5)),
          isA<Exception>(),
        );
        expect(pool.pendingTasks, 0);
      } finally {
        pool.dispose();
      }
    },
  );
  test(
    'cancelling active and waiting tasks settles callers and releases worker',
    () async {
      final pool = DownloadIsolatePool.forTesting(workerEntryPoint: fakeWorker);
      final started = Completer<void>();
      final cancelled = Completer<Exception>();
      final queuedCancelled = Completer<Exception>();
      final completed = Completer<void>();
      try {
        final firstInit = pool.initialize();
        expect(identical(firstInit, pool.initialize()), isTrue);
        await firstInit;
        await pool.submitFileDownload(
          taskId: 'blocked',
          pageUrls: [],
          concurrentDownloads: 1,
          itemType: ItemType.anime,
          onProgress: (_) {
            if (!started.isCompleted) started.complete();
          },
          onComplete: () => fail('Cancelled task completed'),
          onError: cancelled.complete,
        );
        await started.future.timeout(const Duration(seconds: 5));
        await pool.submitFileDownload(
          taskId: 'queued',
          pageUrls: [],
          concurrentDownloads: 1,
          itemType: ItemType.anime,
          onProgress: (_) {},
          onComplete: () => fail('Cancelled waiting task completed'),
          onError: queuedCancelled.complete,
        );
        pool.cancelTask('queued');
        expect(
          await queuedCancelled.future.timeout(const Duration(seconds: 5)),
          isA<Exception>(),
        );
        expect(pool.pendingTasks, 0);
        pool.cancelTask('blocked');
        expect(
          await cancelled.future.timeout(const Duration(seconds: 5)),
          isA<Exception>(),
        );
        await pool.submitFileDownload(
          taskId: 'next',
          pageUrls: [],
          concurrentDownloads: 1,
          itemType: ItemType.anime,
          onProgress: (_) {},
          onComplete: completed.complete,
          onError: completed.completeError,
        );
        await completed.future.timeout(const Duration(seconds: 5));
      } finally {
        pool.dispose();
      }
    },
  );

  test('worker startup errors surface instead of hanging forever', () async {
    final pool = DownloadIsolatePool.forTesting(workerEntryPoint: brokenWorker);
    try {
      await expectLater(
        pool.initialize().timeout(const Duration(seconds: 5)),
        throwsA(isA<DownloadPoolException>()),
      );
      // Initialization failure is retryable, not a cached failed Future.
      await expectLater(
        pool.initialize().timeout(const Duration(seconds: 5)),
        throwsA(isA<DownloadPoolException>()),
      );
    } finally {
      pool.dispose();
    }
  });
}

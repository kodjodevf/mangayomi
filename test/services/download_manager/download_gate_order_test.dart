import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/download_manager/download_gate.dart';
import 'package:mangayomi/services/download_manager/download_queue_order.dart';

void main() {
  late Directory databaseDirectory;
  late Isar database;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    databaseDirectory = await Directory.systemTemp.createTemp(
      'mangayomi-download-gate-',
    );
    database = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: databaseDirectory.path,
      name: 'download_gate_test',
    );
    app.isar = database;
    database.writeTxnSync(() => database.settings.putSync(Settings(id: 227)));
    downloadsPaused.value = false;
  });

  tearDown(() async {
    downloadsPaused.value = false;
    await database.close(deleteFromDisk: true);
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  /// Asks the gate for a slot for each id, one source, one at a time, and
  /// records the order the slots are handed out in.
  Future<List<int>> runThroughGate(
    List<int> arrivals, {
    List<int> lateArrivals = const [],
  }) async {
    final granted = <int>[];
    final done = Completer<void>();
    final total = arrivals.length + lateArrivals.length;
    void request(int id) {
      DownloadGate.instance
          .acquire(
            id: id,
            sourceKey: 'source',
            maxConcurrent: 1,
            delaySeconds: 0,
          )
          .then((_) async {
            granted.add(id);
            // The first download is running: the late ones reach the gate now.
            if (granted.length == 1) lateArrivals.forEach(request);
            await Future<void>.delayed(Duration.zero);
            DownloadGate.instance.release('source');
            if (granted.length == total) done.complete();
          });
    }

    arrivals.forEach(request);
    await done.future;
    return granted;
  }

  test('waiting downloads start in the order the queue screen lists', () async {
    // Queued newest first (as a chapter list sorted descending would), with a
    // retried chapter reaching the gate after the rest.
    final granted = await runThroughGate([110, 109, 108], lateArrivals: [101]);
    // 110 had the gate to itself; everything after goes top to bottom.
    expect(granted, [110, 101, 108, 109]);

    final listed = DownloadQueueOrder.sorted([
      for (final id in [110, 109, 108, 101])
        Download(
          id: id,
          succeeded: 0,
          failed: 0,
          total: 100,
          isDownload: false,
          isStartDownload: true,
        ),
    ]).map((d) => d.id);
    expect(listed, [101, 108, 109, 110]);
  });

  test('a manual order still comes first', () async {
    DownloadQueueOrder.setOrder([109]);
    await dbWriteQueue.run(() {});
    final granted = await runThroughGate([101], lateArrivals: [110, 108, 109]);
    expect(granted, [101, 109, 108, 110]);
  });

  test('pausing turns away waiting and new downloads', () async {
    final first = DownloadGate.instance.acquire(
      id: 1,
      sourceKey: 'source',
      maxConcurrent: 1,
      delaySeconds: 0,
    );
    final waiting = DownloadGate.instance.acquire(
      id: 2,
      sourceKey: 'source',
      maxConcurrent: 1,
      delaySeconds: 0,
    );
    await first;

    downloadsPaused.value = true;
    DownloadGate.instance.pause();
    await expectLater(waiting, throwsA(isA<DownloadsPausedException>()));
    await expectLater(
      DownloadGate.instance.acquire(
        id: 3,
        sourceKey: 'source',
        maxConcurrent: 1,
        delaySeconds: 0,
      ),
      throwsA(isA<DownloadsPausedException>()),
    );
    DownloadGate.instance.release('source');

    downloadsPaused.value = false;
    await DownloadGate.instance.acquire(
      id: 3,
      sourceKey: 'source',
      maxConcurrent: 1,
      delaySeconds: 0,
    );
    DownloadGate.instance.release('source');
  });

  test('moves a download or a whole series to the top or the bottom', () {
    // Series A: 1, 3, 5. Series B: 2, 4.
    final ids = [1, 2, 3, 4, 5];
    bool seriesA(int id) => id.isOdd;
    expect(DownloadQueueOrder.move(ids, (id) => id == 4, toTop: true), [
      4, 1, 2, 3, 5, //
    ]);
    expect(DownloadQueueOrder.move(ids, (id) => id == 1, toTop: false), [
      2, 3, 4, 5, 1, //
    ]);
    expect(DownloadQueueOrder.move(ids, seriesA, toTop: true), [
      1, 3, 5, 2, 4, //
    ]);
    expect(DownloadQueueOrder.move(ids, seriesA, toTop: false), [
      2, 4, 1, 3, 5, //
    ]);
  });
}

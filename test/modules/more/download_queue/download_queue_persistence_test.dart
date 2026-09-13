import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/download_repository.dart';

void main() {
  late Directory databaseDirectory;
  late Isar database;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    databaseDirectory = await Directory.systemTemp.createTemp(
      'mangayomi-download-queue-',
    );
    database = await Isar.open(
      [MangaSchema, ChapterSchema, DownloadSchema, SettingsSchema, SourceSchema],
      directory: databaseDirectory.path,
      name: 'download_queue_test',
    );
    app.isar = database;
    database.writeTxnSync(() => database.settings.putSync(Settings(id: 227)));
  });

  tearDown(() async {
    await database.close(deleteFromDisk: true);
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  test('enqueue waits for persistence and preserves queue entries', () async {
    final first = Chapter(id: 316, mangaId: 1, name: 'Episode 316');
    final second = Chapter(id: 1211, mangaId: 2, name: 'Episode 1211');
    database.writeTxnSync(() => database.chapters.putAllSync([first, second]));
    await downloadRepository.enqueue(first);
    final active = downloadRepository.getById(316)!..succeeded = 42;
    await downloadRepository.save(active);

    final release = Completer<void>();
    final blocked = dbWriteQueue.run(() => release.future);
    var saved = false;
    final pending = downloadRepository.enqueue(second).then((_) => saved = true);
    await Future<void>.delayed(Duration.zero);
    expect(saved, isFalse);
    release.complete();
    await blocked;
    await pending;

    await Future.wait([
      downloadRepository.enqueue(first),
      downloadRepository.enqueue(second),
    ]);
    expect(downloadRepository.getAll(), hasLength(2));
    expect(downloadRepository.getById(316)?.succeeded, 42);
  });

  test('starting the queue never deletes existing entries', () async {
    final chapters = [
      Chapter(id: 316, mangaId: 1, name: 'Episode 316'),
      Chapter(id: 1, mangaId: 2, name: 'Episode 1'),
    ];
    database.writeTxnSync(() => database.chapters.putAllSync(chapters));
    for (final chapter in chapters) {
      await downloadRepository.enqueue(chapter);
    }
    final started = <int>[];
    final container = ProviderContainer(
      overrides: [
        downloadChapterProvider.overrideWith((ref, argument) async {
          started.add(argument.chapter.id!);
        }),
      ],
    );
    addTearDown(container.dispose);

    await container.read(processDownloadsProvider().future);
    await dbWriteQueue.run(() {});
    expect(started.toSet(), {1, 316});
    expect(downloadRepository.getAll(), hasLength(2));
    expect(await downloadRepository.getPendingStarted(), hasLength(2));
  });

  test('enqueue retries failures without resetting completed entries', () async {
    final chapter = Chapter(id: 1, mangaId: 1, name: 'Episode 1');
    database.writeTxnSync(() => database.chapters.putSync(chapter));
    await downloadRepository.enqueue(chapter);
    await downloadRepository.save(
      downloadRepository.getById(1)!
        ..failed = 1
        ..isStartDownload = false,
    );
    await downloadRepository.enqueue(chapter);
    expect(downloadRepository.getById(1)?.failed, 0);
    expect(downloadRepository.getById(1)?.isStartDownload, true);

    await downloadRepository.save(
      downloadRepository.getById(1)!
        ..succeeded = 100
        ..isDownload = true,
    );
    await downloadRepository.enqueue(chapter);
    expect(downloadRepository.getById(1)?.isDownload, true);
    expect(downloadRepository.getById(1)?.succeeded, 100);
  });
}

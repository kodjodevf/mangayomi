import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

void main() {
  late Directory directory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('manga_repository');
    isar = await Isar.open(
      [MangaSchema, ChapterSchema],
      directory: directory.path,
      name: 'manga_repository_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('save queues behind an active async Isar write', () async {
    final transactionStarted = Completer<void>();
    final releaseTransaction = Completer<void>();
    final activeTransaction = isar.writeTxn(() async {
      transactionStarted.complete();
      await releaseTransaction.future;
    });
    await transactionStarted.future;

    final manga = Manga(
      source: 'test',
      author: 'author',
      artist: 'artist',
      genre: const [],
      imageUrl: '',
      lang: 'en',
      link: '/test',
      name: 'Test',
      status: Status.unknown,
      description: '',
      sourceId: 1,
    )..favorite = true;

    final save = mangaRepository.save(manga);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    releaseTransaction.complete();
    await activeTransaction;
    await save;

    expect(manga.id, isNotNull);
    expect(isar.mangas.getSync(manga.id!)?.favorite, true);
  });
}

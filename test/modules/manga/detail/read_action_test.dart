import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/read_action.dart';
import 'package:mangayomi/providers/storage_provider.dart';

void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('mangayomi-read-action-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
  });

  tearDown(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  /// A series whose source lists its chapters newest first, the first
  /// [read] of them (by number) marked read.
  Future<Manga> series({required int read}) async {
    final manga = Manga(
      source: 'Demo',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/series',
      name: 'Series',
      status: Status.ongoing,
      description: '',
      sourceId: null,
    );
    await db.writeTxn(() async {
      await db.mangas.put(manga);
      for (var i = 6; i >= 1; i--) {
        final chapter = Chapter(
          mangaId: manga.id,
          name: 'Chapter $i',
          isRead: i <= read,
        );
        await db.chapters.put(chapter);
        chapter.manga.value = manga;
        await chapter.manga.save();
      }
    });
    return (await db.mangas.get(manga.id!))!;
  }

  test('without history, the first unread chapter by number', () async {
    final manga = await series(read: 2);
    expect(firstUnreadChapterFor(manga)?.name, 'Chapter 3');
  });

  test('nothing read starts at the first chapter, not the newest', () async {
    final manga = await series(read: 0);
    expect(firstUnreadChapterFor(manga)?.name, 'Chapter 1');
  });

  test('all read falls back to the first chapter', () async {
    final manga = await series(read: 6);
    expect(firstUnreadChapterFor(manga)?.name, 'Chapter 1');
  });

  /// Records [name] as the chapter last opened in [manga].
  Future<void> lastOpened(Manga manga, String name) async {
    final chapter = manga.chapters.firstWhere((c) => c.name == name);
    await db.writeTxn(() async {
      final history = History(
        itemType: manga.itemType,
        chapterId: chapter.id,
        mangaId: manga.id,
        date: '1',
      )..chapter.value = chapter;
      await db.historys.put(history);
      await history.chapter.save();
    });
  }

  test('resumes the last opened chapter while it is unread', () async {
    final manga = await series(read: 3);
    await lastOpened(manga, 'Chapter 4');
    expect(resumeTargetFor(manga, incognito: false)?.name, 'Chapter 4');
  });

  test('a finished chapter resumes at the next one, even if read', () async {
    final manga = await series(read: 5);
    await lastOpened(manga, 'Chapter 4');
    expect(resumeTargetFor(manga, incognito: false)?.name, 'Chapter 5');
  });

  test('a finished last chapter resumes at itself', () async {
    final manga = await series(read: 6);
    await lastOpened(manga, 'Chapter 6');
    expect(resumeTargetFor(manga, incognito: false)?.name, 'Chapter 6');
  });
}

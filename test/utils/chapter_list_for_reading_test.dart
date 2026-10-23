import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

void main() {
  late Directory directory;
  late Manga manga;

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

  /// Chapters 1 to 4 of a series, chapter 2 in two copies (scanlators A and
  /// B), chapters 1 and 3 read, and the unread filter on when [unreadOnly].
  Future<void> seed(
    void Function(Settings) configure, {
    bool unreadOnly = false,
  }) async {
    manga = Manga(
      source: 'test',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: '',
      lang: 'en',
      link: '/test',
      name: 'Test',
      status: Status.ongoing,
      description: '',
      sourceId: 1,
    );
    final chapters = [
      for (final (name, scanlator, read) in [
        ('Chapter 1', 'A', true),
        ('Chapter 2', 'A', false),
        ('Chapter 2', 'B', false),
        ('Chapter 3', 'B', true),
        ('Chapter 4', 'B', false),
      ])
        Chapter(
          mangaId: 1,
          name: name,
          url: '/$name/$scanlator',
          scanlator: scanlator,
          isRead: read,
        ),
    ];
    await isar.writeTxn(() async {
      final settings = Settings();
      if (unreadOnly) {
        settings.chapterFilterUnreadList = [
          ChapterFilterUnread(mangaId: 1, type: 1),
        ];
      }
      configure(settings);
      await isar.settings.put(settings);
      manga.id = 1;
      await isar.mangas.put(manga);
      for (final c in chapters) {
        await isar.chapters.put(c);
        c.manga.value = manga;
        await c.manga.save();
      }
    });
    manga.chapters.loadSync();
  }

  List<String> names(List<Chapter> list) => [
    for (final c in list) '${c.name}/${c.scanlator}',
  ];

  Chapter chapter(String name, String scanlator) => manga.chapters.firstWhere(
    (c) => c.name == name && c.scanlator == scanlator,
  );

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('chapter_list');
    isar = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        SettingsSchema,
        SourceSchema,
        DownloadSchema,
      ],
      directory: directory.path,
      name: 'chapter_list_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('by default one copy per number, the first one', () async {
    await seed((_) {});
    expect(names(manga.getChapterListForReading()), [
      'Chapter 1/A',
      'Chapter 2/A',
      'Chapter 3/B',
      'Chapter 4/B',
    ]);
  });

  test('the copy from the scanlator being read is kept', () async {
    await seed((_) {});
    expect(
      names(manga.getChapterListForReading(current: chapter('Chapter 3', 'B'))),
      ['Chapter 1/A', 'Chapter 2/B', 'Chapter 3/B', 'Chapter 4/B'],
    );
  });

  test('every copy when duplicates are not skipped', () async {
    await seed((s) => s.skipDuplicateChapters = false);
    expect(manga.getChapterListForReading(), hasLength(5));
  });

  test('read chapters are skipped, but not the one being read', () async {
    await seed((s) => s.skipReadChapters = true);
    expect(
      names(manga.getChapterListForReading(current: chapter('Chapter 3', 'B'))),
      ['Chapter 2/B', 'Chapter 3/B', 'Chapter 4/B'],
    );
  });

  test('filtered chapters stay when they are not skipped', () async {
    await seed((_) {}, unreadOnly: true);
    expect(names(manga.getChapterListForReading()), [
      'Chapter 2/A',
      'Chapter 4/B',
    ]);

    final settings = isar.settings.getSync(227)!..skipFilteredChapters = false;
    await isar.writeTxn(() => isar.settings.put(settings));
    expect(manga.getChapterListForReading(), hasLength(4));
  });
}

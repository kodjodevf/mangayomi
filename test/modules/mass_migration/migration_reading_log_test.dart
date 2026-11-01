import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/mass_migration/services/mass_migration_service.dart';

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
    directory = Directory.systemTemp.createTempSync('migration_log');
    isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
        ReadingLogSchema,
        DownloadSchema,
        SourceSchema,
        SettingsSchema,
        TrackPreferenceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
        BackupPasswordFallbackSchema,
        TrackerLibraryCacheSchema,
      ],
      directory: directory.path,
      name: 'migration_log_${directory.path.hashCode}',
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  testWidgets('migration keeps reading time and remaps log chapters', (
    tester,
  ) async {
    late WidgetRef widgetRef;
    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            widgetRef = ref;
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.runAsync(() async {
      final manga = Manga(
        source: 'Old',
        author: '',
        artist: '',
        genre: const [],
        imageUrl: '',
        lang: 'en',
        link: '/old',
        name: 'Series',
        status: Status.ongoing,
        description: '',
        sourceId: 1,
        favorite: true,
      );
      late Chapter second;
      isar.writeTxnSync(() {
        isar.settings.putSync(Settings());
        isar.mangas.putSync(manga);
        final first = Chapter(
          mangaId: manga.id,
          name: 'Chapter 1',
          isRead: true,
        )..manga.value = manga;
        second = Chapter(mangaId: manga.id, name: 'Chapter 2', isRead: true)
          ..manga.value = manga;
        isar.chapters.putAllSync([first, second]);
        first.manga.saveSync();
        second.manga.saveSync();
        isar.historys.putSync(
          History(
            mangaId: manga.id,
            chapterId: second.id,
            itemType: ItemType.manga,
            date: '1700000000000',
            readingTimeSeconds: 600,
          )..chapter.value = second,
        );
        isar.readingLogs.putSync(
          ReadingLog(
            mangaId: manga.id,
            chapterId: second.id,
            itemType: ItemType.manga,
            at: 1700000000000,
            kind: ReadingLogKind.completion,
          ),
        );
      });
      final oldManga = isar.mangas.getSync(manga.id!)!;
      final preview = MManga(
        name: 'Series',
        link: '/new',
        chapters: [
          MChapter(name: 'Chapter 2', url: '/c2'),
          MChapter(name: 'Chapter 1', url: '/c1'),
        ],
      );

      await migrateLibraryItem(
        ref: widgetRef,
        oldManga: oldManga,
        selectedManga: preview,
        preview: preview,
        destinationSource: Source(id: 2, name: 'New', lang: 'en'),
      );

      final newSecond = isar.chapters
          .filter()
          .mangaIdEqualTo(manga.id)
          .nameEqualTo('Chapter 2')
          .findFirstSync()!;
      expect(newSecond.id, isNot(second.id));
      final history = isar.historys.where().findFirstSync()!;
      expect(history.readingTimeSeconds, 600);
      final log = isar.readingLogs.where().findFirstSync()!;
      expect(log.mangaId, manga.id);
      expect(log.chapterId, newSecond.id);
    });
  });
}

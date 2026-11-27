import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/router/router.dart';
import 'package:material_ui/material_ui.dart';

class _NoRouterLocation extends RouterCurrentLocationState {
  @override
  String? build() => null;

  @override
  void refresh() {}
}

Future<(BuildContext, WidgetRef)> _pumpShell(WidgetTester tester) async {
  late BuildContext ctx;
  late WidgetRef widgetRef;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        routerCurrentLocationStateProvider.overrideWith(_NoRouterLocation.new),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) {
            ctx = context;
            widgetRef = ref;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return (ctx, widgetRef);
}

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
    directory = Directory.systemTemp.createTempSync('kotatsu_restore');
    isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
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
      name: 'kotatsu_restore_${directory.path.hashCode}',
    );
    await isar.writeTxn(() async {
      await isar.settings.put(Settings());
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  testWidgets(
    'Kotatsu restore preserves tracker preferences while replacing library data',
    (tester) async {
      isar.writeTxnSync(() {
        isar.trackPreferences.putAllSync([
          TrackPreference(
            syncId: 2,
            username: '12345',
            displayName: 'AniListUser',
            oAuth: 'secret-oauth-token',
            prefs: '{"scoreFormat":"POINT_10"}',
          ),
          TrackPreference(syncId: -1),
        ]);

        final oldCategory = Category(
          id: 5,
          name: 'Old Category',
          forItemType: ItemType.manga,
        );
        isar.categorys.putSync(oldCategory);

        final oldManga = Manga(
          id: 10,
          source: 'OldSrc',
          author: '',
          artist: '',
          genre: const [],
          imageUrl: '',
          lang: 'en',
          link: '/old',
          name: 'Old Manga',
          status: Status.unknown,
          description: '',
          sourceId: 1,
          favorite: true,
        );
        isar.mangas.putSync(oldManga);

        final oldChapter = Chapter(
          id: 20,
          mangaId: 10,
          name: 'Old Ch 1',
          url: '/old-ch1',
        )..manga.value = oldManga;
        isar.chapters.putSync(oldChapter);
        oldChapter.manga.saveSync();

        isar.downloads.putSync(
          Download(
            id: 20,
            succeeded: 1,
            failed: 0,
            total: 1,
            isDownload: true,
            isStartDownload: false,
          )..chapter.value = oldChapter,
        );
        isar.historys.putSync(
          History(
            id: 30,
            mangaId: 10,
            chapterId: 20,
            itemType: ItemType.manga,
            date: '1000',
          )..chapter.value = oldChapter,
        );
        isar.updates.putSync(
          Update(id: 40, mangaId: 10, chapterName: 'Old Ch 1', date: '1000')
            ..chapter.value = oldChapter,
        );
        isar.tracks.putSync(
          Track(
            id: 50,
            mangaId: 10,
            syncId: 2,
            mediaId: 999,
            status: TrackStatus.reading,
          ),
        );
      });

      final (ctx, ref) = await _pumpShell(tester);
      await tester.runAsync(() async {
        final path = '${directory.path}/kotatsu_2026-11-27.zip';
        final archive = Archive()
          ..addFile(
            ArchiveFile.string(
              'categories',
              jsonEncode([
                {'category_id': 42, 'title': 'Reading', 'sort_key': 1},
              ]),
            ),
          )
          ..addFile(
            ArchiveFile.string(
              'favourites',
              jsonEncode([
                {
                  'manga_id': 9001,
                  'category_id': 42,
                  'manga': {
                    'id': 9001,
                    'title': 'Kotatsu Alpha',
                    'url': '/kotatsu-alpha',
                    'source': 'MANGADEX',
                    'author': 'Author A',
                    'large_cover_url': 'https://example.com/cover.jpg',
                    'state': 'ongoing',
                    'tags': [
                      {'title': 'Action'},
                    ],
                  },
                },
              ]),
            ),
          );
        File(path).writeAsBytesSync(ZipEncoder().encode(archive));
        await ref.read(
          doRestoreProvider(path: path, context: ctx, merge: false).future,
        );
      });
      BotToast.cleanAll();
      await tester.pumpAndSettle();

      final prefs = trackRepository.getAllPreferences();
      expect(prefs, hasLength(2));
      final anilistPref = trackRepository.getPreferenceById(2)!;
      expect(anilistPref.oAuth, 'secret-oauth-token');
      expect(anilistPref.displayName, 'AniListUser');
      expect(trackRepository.getPreferenceById(-1), isNotNull);

      final categories = categoryRepository.getAll();
      expect(categories.map((c) => c.name), ['Reading']);
      final mangas = mangaRepository.getAll();
      expect(mangas, hasLength(1));
      expect(mangas.single.name, 'Kotatsu Alpha');
      expect(mangas.single.categories, [categories.single.id]);

      expect(chapterRepository.getAll(), isEmpty);
      expect(downloadRepository.getAll(), isEmpty);
      expect(historyRepository.getAll(), isEmpty);
      expect(updateRepository.getAll(), isEmpty);
      expect(trackRepository.getAll(), isEmpty);
    },
  );
}

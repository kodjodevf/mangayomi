import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/reading_log.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_format.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupAnime.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupAniyomi.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupChapter.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupHistory.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupManga.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupMihon.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupSource.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/tachiyomi_restore_service.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/router/router.dart';

/// The real one subscribes to the app's router, which these tests don't
/// build; restore only asks it to refresh.
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
        localizationsDelegates: AppLocalizations.localizationsDelegates,
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

BackupHistory _history(String url, int lastRead, int readDuration) =>
    BackupHistory(
      url: url,
      lastRead: Int64(lastRead),
      readDuration: Int64(readDuration),
    );

/// One series with two read chapters whose lastModifiedAt is 0, as Madomi
/// writes them, plus the history entries carrying the real reading time.
BackupMihon _backup() => BackupMihon(
  backupManga: [
    BackupManga(
      source: Int64(7),
      url: '/series',
      title: 'Series',
      favorite: true,
      chapters: [
        BackupChapter(url: '/c1', name: 'Ch 1', read: true),
        BackupChapter(url: '/c2', name: 'Ch 2', read: true),
      ],
      history: [
        _history('/c1', 1700000000000, 3600000),
        _history('/c2', 1710000000000, 1800000),
      ],
    ),
  ],
  backupSources: [BackupSource(sourceId: Int64(7), name: 'Src')],
);

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
    directory = Directory.systemTemp.createTempSync('madomi_import');
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
      name: 'madomi_import_${directory.path.hashCode}',
    );
    await isar.writeTxn(() async {
      await isar.settings.put(Settings());
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Future<void> restore(
    WidgetTester tester,
    WidgetRef ref,
    BuildContext ctx, {
    required bool merge,
    String name = 'madomi_2026-10-20.tachibk',
    List<int>? bytes,
  }) async {
    await tester.runAsync(() async {
      final path = '${directory.path}/$name';
      File(path).writeAsBytesSync(
        GZipEncoder().encodeBytes(bytes ?? _backup().writeToBuffer()),
      );
      await ref.read(
        doRestoreProvider(path: path, context: ctx, merge: merge).future,
      );
    });
  }

  History seriesHistory() {
    final manga = mangaRepository.getAll().singleWhere(
      (m) => m.name == 'Series',
    );
    return historyRepository.findFirstByMangaId(manga.id)!;
  }

  test('summarizeBackupHistory sums durations and picks latest lastRead', () {
    expect(
      summarizeBackupHistory([
        _history('/c1', 1700000000000, 3600000),
        _history('/c2', 1710000000000, 1800000),
      ]),
      (seconds: 5400, lastReadMs: 1710000000000),
    );
    expect(summarizeBackupHistory([]), (seconds: 0, lastReadMs: null));
  });

  test('checkBackupType accepts any .tachibk', () {
    expect(
      checkBackupType('/x/madomi_2026-10-20.tachibk', Archive()),
      BackupType.aniyomi,
    );
    expect(
      checkBackupType('/x/xyz.jmir.tachiyomi.mi_2026.tachibk', Archive()),
      BackupType.aniyomi,
    );
    expect(checkBackupType('/x/neko_2026.tachibk', Archive()), BackupType.neko);
  });

  testWidgets('a backup from an unrecognised fork restores its anime too', (
    tester,
  ) async {
    // Anime forks (Animetail, Kuukiyomi…) name files their own way; the
    // anime must not be dropped silently.
    final backup = BackupAniyomi(
      backupManga: _backup().backupManga,
      backupSources: _backup().backupSources,
      backupAnime: [
        BackupAnime(
          source: Int64(8),
          url: '/show',
          title: 'Show',
          favorite: true,
        ),
      ],
      backupAnimeSources: [BackupSource(sourceId: Int64(8), name: 'AnimeSrc')],
    );
    final (ctx, ref) = await _pumpShell(tester);
    await restore(
      tester,
      ref,
      ctx,
      merge: false,
      name: 'animetail_2026-10-20.tachibk',
      bytes: backup.writeToBuffer(),
    );

    final restored = {for (final m in mangaRepository.getAll()) m.name: m};
    expect(restored['Series']?.itemType, ItemType.manga);
    expect(restored['Show']?.itemType, ItemType.anime);
  });

  testWidgets('replace restore writes reading time and lastRead date', (
    tester,
  ) async {
    final (ctx, ref) = await _pumpShell(tester);
    await restore(tester, ref, ctx, merge: false);

    final history = seriesHistory();
    expect(history.readingTimeSeconds, 5400);
    expect(history.date, '1710000000000');
    expect(history.chapter.value?.url, '/c2');
  });

  testWidgets('merge restore over existing history keeps max and later date', (
    tester,
  ) async {
    final (ctx, ref) = await _pumpShell(tester);
    await restore(tester, ref, ctx, merge: false);
    isar.writeTxnSync(() {
      final history = seriesHistory()
        ..readingTimeSeconds = 1000
        ..date = '1720000000000';
      isar.historys.putSync(history);
    });

    await restore(tester, ref, ctx, merge: true);

    final history = seriesHistory();
    expect(history.readingTimeSeconds, 5400);
    expect(history.date, '1720000000000');
  });

  testWidgets('replace restore clears the reading log', (tester) async {
    final (ctx, ref) = await _pumpShell(tester);
    isar.writeTxnSync(
      () => isar.readingLogs.putSync(
        ReadingLog(
          mangaId: 999,
          itemType: ItemType.manga,
          at: 1,
          kind: ReadingLogKind.completion,
        ),
      ),
    );

    await restore(tester, ref, ctx, merge: false);

    expect(isar.readingLogs.countSync(), 0);
  });

  testWidgets('merge restore twice keeps max', (tester) async {
    final (ctx, ref) = await _pumpShell(tester);
    await restore(tester, ref, ctx, merge: true);
    await restore(tester, ref, ctx, merge: true);

    expect(seriesHistory().readingTimeSeconds, 5400);
    expect(isar.historys.countSync(), 1);
  });
}

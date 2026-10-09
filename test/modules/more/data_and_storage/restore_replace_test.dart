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
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupManga.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupMihon.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupSource.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/router/router.dart';

Manga _manga(String name) => Manga(
  source: 'src',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: '/$name',
  name: name,
  status: Status.unknown,
  description: '',
  sourceId: 1,
  favorite: true,
);

/// The real one subscribes to the app's router, which these tests don't
/// build; restore only asks it to refresh.
class _NoRouterLocation extends RouterCurrentLocationState {
  @override
  String? build() => null;

  @override
  void refresh() {}
}

Iterable<String?> _library() => mangaRepository.getAll().map((m) => m.name);

/// Pumps an app shell and hands back the context and ref doRestore needs,
/// as the restore screens pass them.
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
    directory = Directory.systemTemp.createTempSync('restore_replace');
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
      name: 'restore_replace_${directory.path.hashCode}',
    );
    await isar.writeTxn(() async {
      await isar.settings.put(Settings());
      await isar.mangas.put(_manga('Old'));
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  testWidgets('replace with a mangayomi backup swaps the library', (
    tester,
  ) async {
    final (ctx, ref) = await _pumpShell(tester);

    await tester.runAsync(() async {
      await isar.writeTxn(() async {
        await isar.mangas.clear();
        await isar.mangas.put(_manga('New'));
      });
      final path = await writeMangayomiBackupZip(
        list: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        directory: directory.path,
        encrypt: false,
      );
      await isar.writeTxn(() async {
        await isar.mangas.clear();
        await isar.mangas.put(_manga('Old'));
      });

      await ref.read(
        doRestoreProvider(path: path, context: ctx, merge: false).future,
      );
    });

    expect(_library(), ['New']);
  });

  testWidgets('replace with a Mihon backup swaps the library', (tester) async {
    final (ctx, ref) = await _pumpShell(tester);

    await tester.runAsync(() async {
      final backup = BackupMihon(
        backupManga: [
          BackupManga()
            ..source = Int64(7)
            ..url = '/new'
            ..title = 'New'
            ..favorite = true,
        ],
        backupSources: [
          BackupSource()
            ..sourceId = Int64(7)
            ..name = 'Src',
        ],
      );
      final path = '${directory.path}/mihon_test.tachibk';
      File(
        path,
      ).writeAsBytesSync(GZipEncoder().encodeBytes(backup.writeToBuffer()));

      await ref.read(
        doRestoreProvider(path: path, context: ctx, merge: false).future,
      );
    });

    expect(_library(), ['New']);
  });

  testWidgets('a restore that fails says so, and keeps the library', (
    tester,
  ) async {
    // The restore flows announce success once doRestore returns. A failure
    // it swallowed used to be followed by "Replaced your library with N
    // series" while nothing had changed.
    final (ctx, ref) = await _pumpShell(tester);

    final error = await tester.runAsync(() async {
      final path = '${directory.path}/mangayomi_broken.backup';
      final archive = Archive()
        ..addFile(
          ArchiveFile.string(
            'mangayomi_broken.backup.db',
            '{"version": "99", "manga": []}',
          ),
        );
      File(path).writeAsBytesSync(ZipEncoder().encode(archive));
      try {
        await ref.read(
          doRestoreProvider(path: path, context: ctx, merge: false).future,
        );
        return null;
      } catch (e) {
        return e;
      }
    });

    expect(error, isNotNull);
    expect(_library(), ['Old']);
  });
}

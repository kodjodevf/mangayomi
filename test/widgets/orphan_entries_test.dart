import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/history/history_screen.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/updates/updates_screen.dart';
import 'package:shiori/shiori.dart';

/// A chapter can outlive its series, and an entry its chapter. Those entries
/// have nothing to show and are dropped; the tab must still build.
void main() {
  late Directory directory;

  Widget host(Widget child, dynamic overrides) => ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: buildShioriTheme(
        brightness: Brightness.light,
        colors: FlexColor.schemesList[2].light,
        tintSurfaces: false,
        blendLevel: 10,
        density: ShioriDensity.phone,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );

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
    directory = Directory.systemTemp.createTempSync('orphan_entries');
    isar = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        UpdateSchema,
        HistorySchema,
        SettingsSchema,
        SourceSchema,
        DownloadSchema,
      ],
      directory: directory.path,
      name: 'orphan_entries_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()..id = 227));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  /// A chapter whose series is gone.
  Chapter orphanChapter() {
    final chapter = Chapter(mangaId: 999, name: 'Chapter 1', dateUpload: '0');
    isar.writeTxnSync(() => isar.chapters.putSync(chapter));
    return chapter;
  }

  testWidgets('updates: a chapter whose series is gone', (tester) async {
    final chapter = orphanChapter();
    final update = Update(mangaId: 999, chapterName: 'Chapter 1', date: '0');
    update.chapter.value = chapter;
    isar.writeTxnSync(() {
      isar.updates.putSync(update);
      update.chapter.saveSync();
    });
    await tester.pumpWidget(
      host(
        const UpdateTab(itemType: ItemType.manga, query: '', isLoading: false),
        [
          getAllUpdateStreamProvider(
            itemType: ItemType.manga,
            search: '',
          ).overrideWith((ref) => Stream.value([update])),
        ],
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('history: a chapter or a series that is gone', (tester) async {
    final chapter = orphanChapter();
    final entries = [
      History(
        mangaId: 999,
        chapterId: chapter.id,
        date: '0',
        itemType: ItemType.manga,
      ),
      History(
        mangaId: 999,
        chapterId: 12345,
        date: '0',
        itemType: ItemType.manga,
      ),
    ];
    await tester.pumpWidget(
      host(const HistoryTab(itemType: ItemType.manga, query: ''), [
        getAllHistoryStreamProvider(
          itemType: ItemType.manga,
          search: '',
        ).overrideWith((ref) => Stream.value(entries)),
      ]),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

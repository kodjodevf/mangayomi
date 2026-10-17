import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:shiori/shiori.dart';

void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    dir = await Directory.systemTemp.createTemp('mangayomi-detail-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
    final manga = Manga(
      source: 'Demo',
      author: 'Author',
      artist: '',
      genre: const ['Drama'],
      imageUrl: null,
      lang: 'en',
      link: '/series',
      name: 'Series',
      status: Status.ongoing,
      description: 'A description.',
      sourceId: null,
      favorite: true,
    );
    await db.writeTxn(() async {
      await db.mangas.put(manga);
      for (var i = 3; i >= 1; i--) {
        final chapter = Chapter(
          mangaId: manga.id,
          name: 'Chapter $i',
          isRead: i == 1,
        );
        await db.chapters.put(chapter);
        chapter.manga.value = manga;
        await chapter.manga.save();
      }
    });
  });

  tearDownAll(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  // Opened straight from a fresh database, with no sort or filter saved for
  // the series (they used to be created only by tapping its card), the page
  // used to fail on a null check.
  testWidgets('opens on a fresh database and offers the next chapter', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final manga = await tester.runAsync(() => db.mangas.where().findFirst());
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildShioriTheme(
            brightness: Brightness.dark,
            colors: FlexColor.schemesList[2].dark,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MangaReaderDetail(mangaId: manga!.id!),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(tester.takeException(), isNull);
    expect(find.text('Series'), findsWidgets);
    expect(find.textContaining('Chapter 2'), findsWidgets);
    expect(find.text('No estimate'), findsOneWidget);
  });
}

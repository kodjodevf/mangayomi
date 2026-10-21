import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/updates/updates_screen.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:shiori/shiori.dart';

void main() {
  test('a missing cover is drawn without a request', () {
    // It was a white image fetched from Wikimedia.
    expect(toImgUrl(''), startsWith('data:image/png;base64,'));
    expect(toImgUrl('https://a.test/c.jpg'), 'https://a.test/c.jpg');
  });

  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    dir = await Directory.systemTemp.createTemp('mangayomi-updates-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
    // A series its source gave no cover.
    final manga = Manga(
      source: 'Demo',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/series',
      name: 'Coverless',
      status: Status.ongoing,
      description: '',
      sourceId: null,
      favorite: true,
    );
    await db.writeTxn(() async {
      await db.mangas.put(manga);
      final chapter = Chapter(mangaId: manga.id, name: 'Chapter 1');
      await db.chapters.put(chapter);
      chapter.manga.value = manga;
      await chapter.manga.save();
      final update = Update(
        mangaId: manga.id,
        chapterName: chapter.name,
        date: '${DateTime.now().millisecondsSinceEpoch}',
      );
      await db.updates.put(update);
      update.chapter.value = chapter;
      await update.chapter.save();
    });
  });

  tearDownAll(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  testWidgets('lists a new chapter of a series with no cover', (tester) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const UpdatesScreen()),
            ],
          ),
          theme: buildShioriTheme(
            brightness: Brightness.dark,
            colors: FlexColor.schemesList[2].dark,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
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
    expect(find.text('Coverless'), findsOneWidget);
  });
}

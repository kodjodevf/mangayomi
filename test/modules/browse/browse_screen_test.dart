import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:shiori/shiori.dart';

void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    dir = await Directory.systemTemp.createTemp('mangayomi-browse-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
    await db.writeTxn(
      () => db.sources.put(
        Source(
          id: 1,
          name: 'Demo',
          lang: 'en',
          isAdded: true,
          isActive: true,
          itemType: ItemType.manga,
        ),
      ),
    );
  });

  tearDownAll(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('a swipe moves from the sources to the extensions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 860);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const BrowseScreen()),
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
    await settle(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(BrowseScreen)),
    )!;

    // Global Search is the app bar's icon; the field that repeated it is
    // gone.
    expect(find.byTooltip(l10n.global_search), findsOneWidget);
    expect(find.byType(SourcesScreen), findsOneWidget);

    await tester.fling(find.byType(SourcesScreen), const Offset(-300, 0), 1000);
    await settle(tester);

    expect(find.byType(ExtensionScreen), findsOneWidget);
    expect(find.byType(SourcesScreen), findsNothing);
  });
}

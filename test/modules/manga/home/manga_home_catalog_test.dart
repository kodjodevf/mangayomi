import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:mangayomi/modules/manga/home/widget/mangas_card_selector.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

void main() {
  late Directory directory;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    directory = await Directory.systemTemp.createTemp('mangayomi-catalog-');
    db = await StorageProvider().initDB(directory.path);
    app.isar = db;
    await settingsRepository.update(
      (settings) => settings.mangaHomeDisplayType = DisplayType.list,
    );
  });

  tearDownAll(() async {
    await db.close(deleteFromDisk: true);
    if (await directory.exists()) await directory.delete(recursive: true);
  });

  for (final brightness in Brightness.values) {
    testWidgets('the toolbar fits or scrolls at 200% in ${brightness.name}', (
      tester,
    ) async {
      await _openCatalog(tester, width: 280, scale: 2, brightness: brightness);
      final toolbar = find.byType(SingleChildScrollView);
      final viewport = tester.getRect(toolbar);
      final popular = tester.getRect(find.text('Popular'));
      final latest = tester.getRect(find.text('Latest'));
      expect(popular.bottom, lessThan(viewport.bottom));
      expect(latest.bottom, lessThan(viewport.bottom));
      expect(popular.center.dy, latest.center.dy);
      expect(_toolbarPosition(tester).maxScrollExtent, greaterThan(0));

      final rightEdge = Offset(viewport.right - 12, viewport.center.dy);
      for (var swipe = 0; swipe < 5; swipe++) {
        await tester.dragFrom(rightEdge, const Offset(-245, 0));
        await tester.pumpAndSettle();
      }
      final position = _toolbarPosition(tester);
      expect(position.pixels, closeTo(position.maxScrollExtent, 1));
      expect(find.text('North Fiction').hitTestable(), findsOneWidget);

      tester.view.physicalSize = const Size(1280, 640);
      await tester.pumpAndSettle();
      expect(_toolbarPosition(tester).maxScrollExtent, 0);
      expect(find.text('Popular').hitTestable(), findsOneWidget);
      expect(find.text('Filter').hitTestable(), findsOneWidget);
      expect(find.text('North Fiction').hitTestable(), findsOneWidget);
    });
  }

  testWidgets('the active source controls paging and category filtering', (
    tester,
  ) async {
    await _openCatalog(tester);
    expect(find.text('Popular north page 1'), findsOneWidget);
    await _tap(tester, find.text('Load more'));
    expect(find.text('Popular north page 2'), findsOneWidget);

    await _tap(tester, find.text('Filter'));
    expect(find.text('Catalog source'), findsNothing);
    await _tap(tester, find.text('Category'));
    await _tap(tester, find.text('Mystery'));
    await _tap(tester, _applyFilter);
    expect(find.text('Filtered north mystery'), findsOneWidget);

    Focus.of(tester.element(find.text('North Fiction'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await _tap(tester, find.text('South Documentaries'));
    expect(find.text('Popular south page 1'), findsOneWidget);
    expect(find.text('Popular north page 2'), findsNothing);
    expect(find.text('Filtered north mystery'), findsNothing);

    await _tap(tester, find.text('Filter'));
    expect(find.text('All'), findsOneWidget);
    await _tap(tester, find.text('Category'));
    expect(find.text('Mystery'), findsNothing);
    await _tap(tester, find.text('Nature'));
    await _tap(tester, _applyFilter);
    expect(find.text('Filtered south nature'), findsOneWidget);

    await _tap(tester, _toolbarFilter);
    await _tap(tester, find.text('Reset'));
    await _tap(tester, _applyFilter);
    expect(find.text('Filtered south all'), findsOneWidget);
    await _tap(tester, find.text('Latest'));
    expect(find.text('Latest south page 1'), findsOneWidget);
  });

  testWidgets('an extension without a source selector keeps its filters', (
    tester,
  ) async {
    await _openCatalog(tester, multiSource: false);
    expect(find.byType(MangasCardSelector), findsNWidgets(3));
    await _tap(tester, find.text('Filter'));
    await _tap(tester, find.text('Category'));
    await _tap(tester, find.text('Mystery'));
    await _tap(tester, _applyFilter);
    expect(find.text('Filtered north mystery'), findsOneWidget);
  });
}

Finder get _toolbarFilter => find.descendant(
  of: find.byType(MangasCardSelector),
  matching: find.text('Filter'),
);

Finder get _applyFilter => find.descendant(
  of: find.byType(FilterSheetBody),
  matching: find.text('Filter'),
);

ScrollPosition _toolbarPosition(WidgetTester tester) => tester
    .state<ScrollableState>(
      find.descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byType(Scrollable),
      ),
    )
    .position;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openCatalog(
  WidgetTester tester, {
  double width = 840,
  double scale = 1,
  Brightness brightness = Brightness.light,
  bool multiSource = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 640);
  addTearDown(tester.view.reset);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await _settle(tester);
  });
  final scheme = FlexColor.schemesList[2];
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildShioriTheme(
          brightness: brightness,
          colors: brightness == Brightness.light ? scheme.light : scheme.dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: MangaHomeScreen(
          source: Source(
            id: multiSource ? 1 : 2,
            name: 'Demo',
            lang: 'en',
            itemType: ItemType.anime,
            sourceCode:
                '$_fixtureScript\n'
                'const multiSource = $multiSource;',
          )..sourceCodeLanguage = SourceCodeLanguage.javascript,
        ),
      ),
    ),
  );
  await _settle(tester);
}

Future<void> _settle(WidgetTester tester) async {
  // The Isar watcher's initial transaction crosses the native event loop.
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 25)),
    );
    await tester.pumpAndSettle();
  }
}

const _fixtureScript = r'''
class DefaultExtension extends MProvider {
  get supportsLatest() { return true; }

  select(type, name, choices) {
    return {
      type_name: "SelectFilter", type, name, state: 0,
      values: choices.map(([name, value]) => ({
        type_name: "SelectOption", name, value,
      })),
    };
  }

  category(key) {
    const choice = key === "south" ? ["Nature", "nature"] : ["Mystery", "mystery"];
    return this.select("Category", "Category", [["All", "all"], choice]);
  }

  getFilterList() {
    return multiSource
      ? [this.select("SourceSelector", "Catalog source", [
          ["North Fiction", "north"], ["South Documentaries", "south"],
        ])]
      : [this.category("north")];
  }

  async getSourceFilters(key) { return [this.category(key)]; }

  result(name, hasNextPage = false) {
    return {list: [{name, link: name}], hasNextPage};
  }

  async getPopular(page, key = "north") {
    return this.result(`Popular ${key} page ${page}`, page === 1);
  }

  async getLatestUpdates(page, key = "north") {
    return this.result(`Latest ${key} page ${page}`);
  }

  async search(query, page, filters) {
    const value = (type) => {
      const filter = filters.find((entry) => entry.type === type);
      return filter?.values[filter.state].value;
    };
    return this.result(`Filtered ${value("SourceSelector") ?? "north"} ${value("Category")}`);
  }
}
''';

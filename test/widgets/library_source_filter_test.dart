import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

Manga _manga(String source) => Manga(
  source: source,
  author: null,
  artist: null,
  genre: const [],
  imageUrl: null,
  lang: 'en',
  link: '/$source',
  name: 'A title from $source',
  status: Status.ongoing,
  description: null,
  sourceId: null,
  favorite: true,
);

class _Opener extends StatefulWidget {
  const _Opener(this.settings, this.entries);
  final Settings settings;
  final List<Manga> entries;

  @override
  State<_Opener> createState() => _OpenerState();
}

class _OpenerState extends State<_Opener> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => showLibrarySettingsSheet(
        context: context,
        vsync: this,
        settings: widget.settings,
        itemType: ItemType.manga,
        entries: widget.entries,
      ),
      child: const Text('open'),
    ),
  );
}

void main() {
  late Directory directory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The binding answers every request with a 400: step out of it for the
    // one download of the Isar core.
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('library_source_filter');
    isar = await Isar.open(
      [
        SettingsSchema,
        MangaSchema,
        ChapterSchema,
        CategorySchema,
        DownloadSchema,
        SourceSchema,
        TrackSchema,
      ],
      directory: directory.path,
      name: 'source_filter_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()..id = 227));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Future<AppLocalizations> open(
    WidgetTester tester, {
    required List<String> picked,
    required List<Manga> library,
  }) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final settings = isar.settings.getSync(227)!
      ..libraryFilterMangasSourceIds = picked;
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
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: _Opener(settings, library),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return AppLocalizations.of(tester.element(find.byType(_Opener)))!;
  }

  String title(AppLocalizations l10n) =>
      '${l10n.filter} ${l10n.manga_extensions}';

  testWidgets('every extension of the library is offered again, the picked '
      'one ticked, in order', (tester) async {
    final l10n = await open(
      tester,
      picked: ['Beta'],
      library: [_manga('gamma'), _manga('Beta'), _manga('Alpha')],
    );
    await tester.tap(find.text(title(l10n)));
    await tester.pumpAndSettle();

    final offered = [
      for (final s in ['Alpha', 'Beta', 'gamma'])
        tester.getTopLeft(find.text(s).last).dy,
    ];
    expect(offered, orderedEquals([...offered]..sort()));
    final ticked = tester
        .widgetList<Checkbox>(find.byType(Checkbox))
        .map((c) => c.value)
        .toList();
    expect(ticked.where((v) => v == true), hasLength(1));
  });

  testWidgets('the filter stays there to be lifted when the library holds '
      'one extension', (tester) async {
    final l10n = await open(
      tester,
      picked: ['Alpha'],
      library: [_manga('Alpha')],
    );
    expect(find.text(title(l10n)), findsOneWidget);
  });

  testWidgets('with one extension and nothing picked, there is nothing to '
      'filter', (tester) async {
    final l10n = await open(
      tester,
      picked: const [],
      library: [_manga('Alpha')],
    );
    expect(find.text(title(l10n)), findsNothing);
  });
}

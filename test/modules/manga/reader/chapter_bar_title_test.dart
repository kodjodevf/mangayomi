import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/modules/reader_common/widgets/chapter_bar_title.dart';
import 'package:shiori/shiori.dart';

class _ByNumber extends ChapterNumberDisplay {
  @override
  Set<int> build() => {7};
}

void main() {
  Future<void> pump(WidgetTester tester, Chapter? chapter) => tester.pumpWidget(
    ProviderScope(
      overrides: [chapterNumberDisplayProvider.overrideWith(_ByNumber.new)],
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
        home: Scaffold(
          appBar: AppBar(title: ChapterBarTitle(chapter: chapter)),
        ),
      ),
    ),
  );

  testWidgets('names the series, and the episode as its list does', (
    tester,
  ) async {
    final manga = Manga(
      source: 'test',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: '',
      lang: 'en',
      link: '',
      name: 'Frieren',
      status: Status.ongoing,
      description: '',
      sourceId: null,
      itemType: ItemType.anime,
    )..id = 7;
    final episode = Chapter(
      mangaId: 7,
      name: 'Frieren Episode 3 - Killing magic',
    );
    episode.manga.value = manga;

    await pump(tester, episode);
    expect(find.text('Frieren'), findsOneWidget);
    expect(find.text('Episode 3'), findsOneWidget);
  });

  testWidgets('says nothing of a chapter it does not know', (tester) async {
    await pump(tester, null);
    expect(find.byType(Text), findsNothing);
  });
}

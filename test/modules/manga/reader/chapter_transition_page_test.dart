import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/modules/manga/reader/widgets/chapter_transition_page.dart';
import 'package:shiori/shiori.dart';

class _ByTitle extends ChapterNumberDisplay {
  @override
  Set<int> build() => {};
}

void main() {
  Future<AppLocalizations> pump(
    WidgetTester tester, {
    required String current,
    String? next,
  }) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [chapterNumberDisplayProvider.overrideWith(_ByTitle.new)],
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
            body: ChapterTransitionPage(
              currentChapter: Chapter(mangaId: 1, name: current),
              nextChapter: next == null
                  ? null
                  : Chapter(mangaId: 1, name: next),
              mangaName: 'Frieren',
              readerMode: ReaderMode.vertical,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return AppLocalizations.of(
      tester.element(find.byType(ChapterTransitionPage)),
    )!;
  }

  testWidgets('offers the next chapter as a button', (tester) async {
    final l10n = await pump(tester, current: 'Chapter 12', next: 'Chapter 13');
    expect(tester.takeException(), isNull);
    expect(
      find.widgetWithText(ShioriButton, l10n.next_chapter),
      findsOneWidget,
    );
    expect(find.text(l10n.missing_chapters(1)), findsNothing);
  });

  testWidgets('flags chapters missing between the two', (tester) async {
    final l10n = await pump(tester, current: 'Chapter 12', next: 'Chapter 15');
    expect(find.text(l10n.missing_chapters(2)), findsOneWidget);
  });

  testWidgets('at the end of a series, leads back to it', (tester) async {
    final l10n = await pump(tester, current: 'Chapter 12');
    expect(find.text(l10n.no_next_chapter), findsOneWidget);
    expect(
      find.widgetWithText(ShioriButton, l10n.back_to_series),
      findsOneWidget,
    );
  });
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:shiori/shiori.dart';

class _NotFullScreen extends FullScreenReaderState {
  @override
  bool build() => false;
}

void main() {
  Future<List<String>> pump(
    WidgetTester tester, {
    bool visible = true,
    bool withMenu = true,
  }) async {
    final calls = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fullScreenReaderStateProvider.overrideWith(_NotFullScreen.new),
        ],
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
            body: Stack(
              children: [
                ReaderAppBar(
                  chapter: Chapter(mangaId: 1, name: 'Chapter 12'),
                  mangaName: 'Frieren',
                  chapterTitle: 'Chapter 12',
                  isVisible: visible,
                  isBookmarked: false,
                  showChapterList: false,
                  backgroundColor: (c) => c.shiori.color.ink1,
                  onBackPressed: () => calls.add('back'),
                  onBookmarkPressed: () => calls.add('bookmark'),
                  onRefreshPressed: withMenu
                      ? () => calls.add('refresh')
                      : null,
                  onWebViewPressed: withMenu
                      ? () => calls.add('webview')
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return calls;
  }

  testWidgets('says where you are, and keeps reload and web in a menu', (
    tester,
  ) async {
    final calls = await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderAppBar)),
    )!;
    expect(find.text('Frieren'), findsOneWidget);
    expect(find.text('Chapter 12'), findsOneWidget);
    expect(find.byTooltip(l10n.refresh), findsNothing);

    await tester.tap(find.byType(ShioriMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.webview));
    await tester.pumpAndSettle();
    expect(calls, ['webview']);
  });

  testWidgets('with nothing for the menu, there is no menu', (tester) async {
    await pump(tester, withMenu: false);
    expect(find.byType(ShioriMenuButton), findsNothing);
  });

  testWidgets('hidden, it slides away and takes no taps', (tester) async {
    final calls = await pump(tester, visible: false);
    await tester.tap(find.byType(BackButton), warnIfMissed: false);
    expect(calls, isEmpty);
    final slide = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
    expect(slide.offset, const Offset(0, -1));
    // Out of focus too: a remote cannot land on a hidden button.
    final gate = tester.widget<ExcludeFocus>(
      find.descendant(
        of: find.byType(ReaderChromeGate),
        matching: find.byType(ExcludeFocus),
      ),
    );
    expect(gate.excluding, isTrue);
  });
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_picker.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:shiori/shiori.dart';

class _NoCrop extends CropBordersState {
  @override
  bool build() => false;
}

class _DefaultLtr extends DefaultReadingModeState {
  @override
  ReaderMode build() => ReaderMode.ltr;
}

void main() {
  final paged = StateProvider<ReaderMode?>((_) => ReaderMode.ltr);
  final continuous = StateProvider<ReaderMode?>(
    (_) => ReaderMode.verticalContinuous,
  );

  Future<List<String>> pump(
    WidgetTester tester, {
    bool visible = true,
    bool vertical = false,
  }) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final calls = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cropBordersStateProvider.overrideWith(_NoCrop.new),
          defaultReadingModeStateProvider.overrideWith(_DefaultLtr.new),
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
                ReaderBottomBar(
                  chapter: Chapter(mangaId: 1, name: 'Chapter 12'),
                  isVisible: visible,
                  hasPreviousChapter: false,
                  hasNextChapter: true,
                  onNextChapter: () => calls.add('next'),
                  onSliderChanged: (_, _) {},
                  onSliderChangeEnd: (_) {},
                  onReaderModeChanged: (m, _) => calls.add('mode ${m.name}'),
                  onPageModeToggle: () => calls.add('double'),
                  onSettingsPressed: () => calls.add('settings'),
                  currentReaderModeProvider: vertical ? continuous : paged,
                  currentPageListenable: ValueNotifier(3),
                  currentPageMode: PageMode.onePage,
                  isReverseHorizontal: false,
                  totalPages: 24,
                  currentIndexLabel: (i) => '${i + 1}',
                  backgroundColor: (c) => c.shiori.color.ink1,
                  autoScrollEnabled: ValueNotifier(false),
                  onAutoScrollPressed: () => calls.add('auto-scroll'),
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

  testWidgets('one panel: the slider between the chapters, actions under it', (
    tester,
  ) async {
    final calls = await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderBottomBar)),
    )!;
    expect(tester.takeException(), isNull);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    // The chapter list sits in the panel, within reach.
    expect(find.byTooltip(l10n.chapters), findsOneWidget);

    // No previous chapter: that button does nothing.
    await tester.tap(find.byTooltip(l10n.previous_chapter));
    await tester.tap(find.byTooltip(l10n.next_chapter));
    await tester.tap(find.byTooltip(l10n.settings));
    expect(calls, ['next', 'settings']);
  });

  testWidgets('hidden, it slides down and takes no taps', (tester) async {
    final calls = await pump(tester, visible: false);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderBottomBar)),
    )!;
    await tester.tap(find.byTooltip(l10n.settings), warnIfMissed: false);
    expect(calls, isEmpty);
    expect(
      tester.widget<AnimatedSlide>(find.byType(AnimatedSlide)).offset,
      const Offset(0, 1),
    );
  });

  testWidgets('the mode button opens the picker; a tile picks and closes', (
    tester,
  ) async {
    final calls = await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderBottomBar)),
    )!;
    await tester.tap(find.byTooltip(RegExp(l10n.reading_mode)));
    await tester.pumpAndSettle();
    expect(find.byType(ReaderModePicker), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ReaderModePicker),
        matching: find.byWidgetPredicate(
          (w) => w is ReaderModeGlyph && w.mode == ReaderMode.webtoon,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(calls, ['mode webtoon']);
    expect(find.byType(ReaderModePicker), findsNothing);
  });

  testWidgets('auto-scroll has a button where it runs, and only there', (
    tester,
  ) async {
    var calls = await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderBottomBar)),
    )!;
    expect(find.byTooltip(l10n.auto_scroll), findsNothing);

    calls = await pump(tester, vertical: true);
    await tester.tap(find.byTooltip(l10n.auto_scroll));
    expect(calls, ['auto-scroll']);
  });
}

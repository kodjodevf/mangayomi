import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<List<String>> pump(WidgetTester tester, {bool reverse = false}) async {
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home:
            ReaderKeyboardHandler(
              onPreviousPage: () => calls.add('previous page'),
              onNextPage: () => calls.add('next page'),
              onPreviousChapter: () => calls.add('previous chapter'),
              onNextChapter: () => calls.add('next chapter'),
              onToggleUI: () => calls.add('bars'),
              onZoomIn: () => calls.add('zoom in'),
              onZoomOut: () => calls.add('zoom out'),
              onZoomReset: () => calls.add('fit'),
              onShowShortcuts: () => calls.add('shortcuts'),
            ).wrapWithKeyboardListener(
              isReverseHorizontal: reverse,
              child: const SizedBox.expand(),
            ),
      ),
    );
    await tester.pump();
    return calls;
  }

  testWidgets('shift on its own no longer changes chapter', (tester) async {
    final calls = await pump(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.shiftRight);
    expect(calls, isEmpty);

    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    expect(calls, ['next chapter', 'previous chapter']);
  });

  testWidgets('space turns the page, shift space turns it back', (
    tester,
  ) async {
    final calls = await pump(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(calls, ['next page', 'previous page']);
  });

  testWidgets('bars, zoom and the list of shortcuts have keys', (tester) async {
    final calls = await pump(tester);
    for (final key in [
      LogicalKeyboardKey.keyM,
      LogicalKeyboardKey.equal,
      LogicalKeyboardKey.minus,
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.f1,
    ]) {
      await tester.sendKeyEvent(key);
    }
    expect(calls, ['bars', 'zoom in', 'zoom out', 'fit', 'shortcuts']);
  });

  testWidgets('right to left, the arrows follow the pages', (tester) async {
    final calls = await pump(tester, reverse: true);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    expect(calls, ['next page']);
  });

  testWidgets('the list shows each shortcut, zoom only where there is one', (
    tester,
  ) async {
    late BuildContext host;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            host = context;
            return const SizedBox.expand();
          },
        ),
      ),
    );
    final l10n = AppLocalizations.of(host)!;

    showReaderShortcuts(host);
    await tester.pumpAndSettle();
    expect(find.text(l10n.keyboard_shortcuts), findsOneWidget);
    expect(find.text(l10n.shortcut_zoom_in), findsOneWidget);
    expect(find.text('Space'), findsOneWidget);
    await tester.tap(find.text(MaterialLocalizations.of(host).okButtonLabel));
    await tester.pumpAndSettle();

    showReaderShortcuts(host, zoom: false);
    await tester.pumpAndSettle();
    expect(find.text(l10n.shortcut_zoom_in), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<void> pump(WidgetTester tester, int type, {VoidCallback? onTap}) =>
      tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListTileChapterFilter(
              label: 'Downloaded',
              type: type,
              onTap: onTap ?? () {},
            ),
          ),
        ),
      );

  testWidgets('each state has its own mark', (tester) async {
    await pump(tester, 0);
    expect(
      find.byIcon(Symbols.check_box_outline_blank_rounded),
      findsOneWidget,
    );

    await pump(tester, 1);
    await tester.pumpAndSettle();
    expect(find.byIcon(Symbols.check_box_rounded), findsOneWidget);

    await pump(tester, 2);
    await tester.pumpAndSettle();
    expect(find.byIcon(Symbols.disabled_by_default_rounded), findsOneWidget);
  });

  testWidgets('excluded is said, not shown as a dash', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, 2);
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byType(ListTileChapterFilter)),
      matchesSemantics(
        label: 'Downloaded',
        value: 'Excluded',
        hasCheckedState: true,
        isCheckStateMixed: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
        isButton: true,
        hasSelectedState: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('a tap cycles the state', (tester) async {
    var taps = 0;
    await pump(tester, 0, onTap: () => taps++);

    await tester.tap(find.text('Downloaded'));

    expect(taps, 1);
  });
}

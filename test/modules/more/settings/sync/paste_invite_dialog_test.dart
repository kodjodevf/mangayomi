import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/modules/more/settings/sync/device_sync/join_host.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          theme: buildShioriTheme(
            brightness: Brightness.light,
            colors: FlexColor.schemesList[2].light,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: TextButton(
                onPressed: () => pasteInvite(context, ref),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the field outlives the closing dialog', (tester) async {
    await openDialog(tester);
    await tester.enterText(find.byType(TextField), 'not a link');
    await tester.tap(find.text('Cancel'));
    // Every frame of the closing animation, the field still reads its text.
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('a text that is not an invite is refused in place', (
    tester,
  ) async {
    await openDialog(tester);
    await tester.enterText(find.byType(TextField), 'https://example.com');
    await tester.tap(find.text('Pair'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

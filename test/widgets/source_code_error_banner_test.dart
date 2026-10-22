import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/browse/widgets/source_code_error_banner.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/source_code_errors.dart';
import 'package:shiori/shiori.dart';

class _Developer extends DeveloperModeState {
  _Developer(this.on);
  final bool on;
  @override
  bool build() => on;
}

void main() {
  final broken = Source(
    id: 4343,
    name: 'Broken',
    lang: 'en',
    baseUrl: 'https://broken.test',
    sourceCode: '',
  );

  Future<void> pump(WidgetTester tester, {required bool developer}) =>
      tester.pumpWidget(
        ProviderScope(
          overrides: [
            developerModeStateProvider.overrideWith(
              () => _Developer(developer),
            ),
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
            home: Scaffold(body: SourceCodeErrorBanner(source: broken)),
          ),
        ),
      );

  setUp(() => SourceCodeErrors.notifier.value = const {});

  testWidgets('in developer mode, the failure is on the page', (tester) async {
    await pump(tester, developer: true);
    expect(find.byType(SelectableText), findsNothing);

    // The screen falls back, and says why.
    expect(getFilterList(source: broken), isEmpty);
    await tester.pump();

    final l10n = AppLocalizations.of(
      tester.element(find.byType(SourceCodeErrorBanner)),
    )!;
    expect(find.text(l10n.source_code_error_title), findsOneWidget);
    expect(find.textContaining('Filters'), findsWidgets);
    expect(find.byType(SelectableText), findsOneWidget);
    expect(find.text(l10n.edit_code), findsOneWidget);

    await tester.tap(find.byTooltip(l10n.dismiss));
    await tester.pump();
    expect(find.text(l10n.source_code_error_title), findsNothing);
  });

  testWidgets('a reader, outside developer mode, sees nothing', (tester) async {
    await pump(tester, developer: false);
    getFilterList(source: broken);
    await tester.pump();
    expect(find.byType(SelectableText), findsNothing);
    expect(SourceCodeErrors.of(broken.id), isNotNull);
  });
}

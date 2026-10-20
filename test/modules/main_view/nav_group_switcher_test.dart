import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';
import 'package:shiori/shiori.dart';

class _Grouping extends NavGroupingState {
  _Grouping(this.value);
  final bool value;
  @override
  bool build() => value;
}

Widget _app({required bool grouped, required List<String> visible}) {
  Widget screen(String route) => Scaffold(
    body: Column(
      children: [
        Text('at $route'),
        NavGroupSwitcher(route: route),
      ],
    ),
  );
  final router = GoRouter(
    initialLocation: '/MangaLibrary',
    routes: [
      for (final r in ['/MangaLibrary', '/AnimeLibrary', '/NovelLibrary'])
        GoRoute(path: r, builder: (_, _) => screen(r)),
    ],
  );
  return ProviderScope(
    overrides: [
      navGroupingProvider.overrideWith(() => _Grouping(grouped)),
      visibleNavDestinationsProvider.overrideWithValue(visible),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      theme: buildShioriTheme(
        brightness: Brightness.dark,
        colors: FlexColor.schemesList[2].dark,
        tintSurfaces: false,
        blendLevel: 10,
        density: ShioriDensity.phone,
      ),
    ),
  );
}

void main() {
  const all = ['/MangaLibrary', '/AnimeLibrary', '/NovelLibrary', '/more'];

  testWidgets('switches between the visible libraries, in the user order', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        grouped: true,
        visible: const ['/NovelLibrary', '/MangaLibrary', '/more'],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ShioriSegmentedControl<String>), findsOneWidget);
    // Anime is hidden, so it is not offered; Novel comes first, as ordered.
    expect(find.text('Anime'), findsNothing);
    expect(
      tester.getTopLeft(find.text('Novel')).dx,
      lessThan(tester.getTopLeft(find.text('Manga')).dx),
    );

    await tester.tap(find.text('Novel'));
    await tester.pumpAndSettle();
    expect(find.text('at /NovelLibrary'), findsOneWidget);
  });

  testWidgets('shows nothing when the navigation is not grouped', (
    tester,
  ) async {
    await tester.pumpWidget(_app(grouped: false, visible: all));
    await tester.pumpAndSettle();
    expect(find.byType(ShioriSegmentedControl<String>), findsNothing);
  });

  testWidgets('shows nothing with a single visible library', (tester) async {
    await tester.pumpWidget(
      _app(grouped: true, visible: const ['/MangaLibrary', '/more']),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ShioriSegmentedControl<String>), findsNothing);
  });
}

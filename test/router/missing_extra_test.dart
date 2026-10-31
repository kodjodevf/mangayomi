import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/router/missing_extra_page.dart';
import 'package:mangayomi/router/router.dart';
import 'package:shiori/shiori.dart';

class _Developer extends DeveloperModeState {
  _Developer(this.on);
  final bool on;
  @override
  bool build() => on;
}

/// A home page and a source page taking a record, as '/mangaHome' does.
Future<GoRouter> _pump(WidgetTester tester, {bool developer = false}) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (_, state) => transitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Text('home')),
        ),
      ),
      GoRoute(
        path: '/source',
        pageBuilder: (_, state) => transitionPage(
          key: state.pageKey,
          child: routeChild<(String?, bool)>(
            route: 'source',
            builder: (extra) => Scaffold(body: Text('source ${extra.$1}')),
            extra: state.extra,
          ),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        developerModeStateProvider.overrideWith(() => _Developer(developer)),
      ],
      child: MaterialApp.router(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  return router;
}

void main() {
  testWidgets('a route given its extra shows it', (tester) async {
    final router = await _pump(tester);
    router.push('/source', extra: ('MangaDex', false));
    await tester.pumpAndSettle();
    expect(find.text('source MangaDex'), findsOneWidget);
  });

  testWidgets('a route without its extra says so rather than crashing, and '
      'goes back', (tester) async {
    final router = await _pump(tester);
    router.push('/source');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(MissingExtraPage), findsOneWidget);
    // Not the route's details, outside developer mode.
    expect(find.textContaining('expected'), findsNothing);

    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('in developer mode, what the route got is on the page', (
    tester,
  ) async {
    final router = await _pump(tester, developer: true);
    router.push('/source');
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Route "source" expected (String?, bool)'),
      findsOneWidget,
    );
  });

  testWidgets('a nullable extra may be null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: routeChild<String?>(
          route: 'library',
          builder: (extra) => Text('library ${extra ?? 'all'}'),
          extra: null,
        ),
      ),
    );
    expect(find.text('library all'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_swipe.dart';

class _Grouping extends NavGroupingState {
  @override
  bool build() => true;
}

const _libraries = ['/MangaLibrary', '/AnimeLibrary', '/NovelLibrary'];

/// The three libraries, each [body] under a [NavGroupSwipe]; [location]
/// says where the router is.
Widget _app(GoRouter router) => ProviderScope(
  overrides: [
    navGroupingProvider.overrideWith(_Grouping.new),
    visibleNavDestinationsProvider.overrideWithValue(_libraries),
  ],
  child: MaterialApp.router(routerConfig: router),
);

GoRouter _router(Widget Function(String route) body) => GoRouter(
  initialLocation: '/AnimeLibrary',
  routes: [
    for (final r in _libraries)
      GoRoute(
        path: r,
        builder: (_, _) => Scaffold(
          body: NavGroupSwipe(route: r, child: body(r)),
        ),
      ),
  ],
);

String _location(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;

void main() {
  testWidgets('a swipe opens the next or the previous library', (tester) async {
    final router = _router((r) => ListView(children: [Text('at $r')]));
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    // Toward the start side, as a page turns: the next one.
    await tester.fling(
      find.text('at /AnimeLibrary'),
      const Offset(-300, 0),
      1500,
    );
    await tester.pumpAndSettle();
    expect(_location(router), '/NovelLibrary');

    // Back toward the end side: the previous one.
    await tester.fling(
      find.text('at /NovelLibrary'),
      const Offset(300, 0),
      1500,
    );
    await tester.pumpAndSettle();
    expect(_location(router), '/AnimeLibrary');
  });

  testWidgets('a short slow swipe stays', (tester) async {
    final router = _router((r) => ListView(children: [Text('at $r')]));
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    await tester.drag(find.text('at /AnimeLibrary'), const Offset(-30, 0));
    await tester.pumpAndSettle();
    expect(_location(router), '/AnimeLibrary');
  });

  testWidgets('category pages keep their swipe, and switch past the last', (
    tester,
  ) async {
    final router = _router(
      (r) => PageView(children: [Text('$r page 1'), Text('$r page 2')]),
    );
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    // Within the pages: the next page, same library.
    await tester.fling(
      find.text('/AnimeLibrary page 1'),
      const Offset(-300, 0),
      1500,
    );
    await tester.pumpAndSettle();
    expect(find.text('/AnimeLibrary page 2'), findsOneWidget);
    expect(_location(router), '/AnimeLibrary');

    // Past the last page: the next library.
    await tester.drag(find.text('/AnimeLibrary page 2'), const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(_location(router), '/NovelLibrary');
  });

  testWidgets('the ends of the switcher go no further', (tester) async {
    final router = _router((r) => ListView(children: [Text('at $r')]));
    router.go('/NovelLibrary');
    await tester.pumpWidget(_app(router));
    await tester.pumpAndSettle();

    await tester.fling(
      find.text('at /NovelLibrary'),
      const Offset(-300, 0),
      1500,
    );
    await tester.pumpAndSettle();
    expect(_location(router), '/NovelLibrary');
  });
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/router/router.dart';
import 'package:shiori/shiori.dart';

/// Pushes '/next' and returns the opacities of the fades around its page a
/// little into the transition.
Future<List<double>> _fadesMidway(WidgetTester tester, GoRoute next) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (_, state) => transitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Text('home')),
        ),
      ),
      next,
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(
      theme: buildShioriTheme(
        brightness: Brightness.dark,
        colors: FlexColor.schemesList[2].dark,
        tintSurfaces: false,
        blendLevel: 10,
        density: ShioriDensity.phone,
      ),
      routerConfig: router,
    ),
  );
  router.push('/next');
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 150));
  return tester
      .widgetList<FadeTransition>(
        find.ancestor(
          of: find.text('next'),
          matching: find.byType(FadeTransition),
        ),
      )
      .map((fade) => fade.opacity.value)
      .toList();
}

void main() {
  testWidgets('a page built by transitionPage moves on the theme\'s axis', (
    tester,
  ) async {
    final fades = await _fadesMidway(
      tester,
      GoRoute(
        path: '/next',
        pageBuilder: (_, state) => transitionPage(
          key: state.pageKey,
          child: const Scaffold(body: Text('next')),
        ),
      ),
    );

    // Halfway through, the incoming page is fading in.
    expect(fades.any((o) => o > 0 && o < 1), isTrue);
  });

  testWidgets('a route left to go_router has no transition, hence the '
      'explicit page builders', (tester) async {
    // go_router looks for a MaterialApp above it, does not find this one,
    // and falls back to a page with no transition. If this ever starts to
    // move, the explicit page builders in router.dart can go.
    final fades = await _fadesMidway(
      tester,
      GoRoute(
        path: '/next',
        builder: (_, _) => const Scaffold(body: Text('next')),
      ),
    );

    expect(fades, isEmpty);
  });
}

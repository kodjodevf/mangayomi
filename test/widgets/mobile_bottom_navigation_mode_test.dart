import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_bottom_navigation.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SizedBox()),
      ],
    );
  });

  tearDown(() => router.dispose());

  Widget app({required bool useFloatingNav}) {
    const destinations = ['/browse', '/more'];
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) => MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MainMobileBottomNavigation(
              isLongPressed: false,
              location: '/browse',
              currentIndex: 0,
              dest: destinations,
              route: router,
              ref: ref,
              useFloatingNav: useFloatingNav,
              buildNavigationWidgetsMobile: (ref, dest, context) => const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Browse',
                ),
                NavigationDestination(
                  icon: Icon(Icons.more_horiz),
                  label: 'More',
                ),
              ],
              onDestinationSelected: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('uses the standard attached bar when the preference is off', (
    tester,
  ) async {
    await tester.pumpWidget(app(useFloatingNav: false));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingNavBar), findsNothing);
  });

  testWidgets('uses the floating bar when the preference is on', (
    tester,
  ) async {
    await tester.pumpWidget(app(useFloatingNav: true));

    expect(find.byType(FloatingNavBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}

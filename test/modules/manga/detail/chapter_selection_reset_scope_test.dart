import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_selection_reset_scope.dart';

void main() {
  late GoRouter router;
  late ProviderContainer container;

  Future<void> openDetail(WidgetTester tester) async {
    router = GoRouter(
      routes: [
        // The libraries are branches of the shell, as in the app's router, and
        // the detail page sits outside of it.
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => shell,
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(path: '/', builder: (_, _) => const Text('home')),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/library',
                  builder: (_, state) => Text('library ${state.extra}'),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/detail',
          builder: (_, _) =>
              const ChapterSelectionResetScope(child: Text('detail')),
        ),
      ],
    );
    container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: Consumer(
          builder: (context, ref, _) {
            // Listens, as the shell does while the detail page is open.
            ref.watch(isLongPressedStateProvider);
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    router.push('/detail');
    await tester.pumpAndSettle();
    container.read(isLongPressedStateProvider.notifier).update(true);
    await tester.pumpAndSettle();
  }

  testWidgets('going back ends the selection', (tester) async {
    await openDetail(tester);

    router.pop();
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(container.read(isLongPressedStateProvider), isFalse);
  });

  testWidgets('searching a genre in the library ends it, without an error', (
    tester,
  ) async {
    await openDetail(tester);

    router.go('/library', extra: 'Action');
    await tester.pumpAndSettle();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('library Action'), findsOneWidget);
    expect(find.text('detail'), findsNothing);
    expect(container.read(isLongPressedStateProvider), isFalse);
  });

  testWidgets('a page the router leaves ends it too, without an error', (
    tester,
  ) async {
    await openDetail(tester);

    router.go('/');
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('home'), findsOneWidget);
    expect(container.read(isLongPressedStateProvider), isFalse);
  });
}

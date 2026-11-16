import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/core/app_layers.dart';

/// A page that counts its taps: the count lives as long as its state.
class _Counter extends StatefulWidget {
  const _Counter(this.source);
  final String source;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  var taps = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => setState(() => taps++),
      child: Text('${widget.source} $taps'),
    ),
  );
}

void main() {
  testWidgets('a page and its extra outlive a cover coming and going', (
    tester,
  ) async {
    // The lock screen, as main.dart's builder adds it.
    final locked = ValueNotifier(false);
    addTearDown(locked.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Text('home')),
        GoRoute(
          path: '/source',
          // A record, as '/mangaHome' takes: it does not survive the router
          // being built again.
          builder: (_, state) {
            final extra = state.extra as (String, bool)?;
            return extra == null
                ? const Text('extra lost')
                : _Counter(extra.$1);
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => ValueListenableBuilder(
          valueListenable: locked,
          builder: (_, isLocked, _) => AppLayers(
            app: child!,
            covers: [
              if (isLocked)
                const ColoredBox(key: ValueKey('lock'), color: Colors.black),
            ],
          ),
        ),
      ),
    );
    router.push('/source', extra: ('Demo', false));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Demo 0'));
    await tester.pump();
    expect(find.text('Demo 1'), findsOneWidget);

    locked.value = true;
    await tester.pump();
    locked.value = false;
    await tester.pumpAndSettle();

    expect(find.text('extra lost'), findsNothing);
    expect(find.text('Demo 1'), findsOneWidget);
  });
}

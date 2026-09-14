import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Where the shell's reserved bottom inset is still readable, and where it is
/// not.
///
/// The filter sheet needs that reservation to keep its controls clear of the
/// floating bar, and reading it from the wrong place silently yields zero, so
/// the padding is applied and nothing moves.
void main() {
  const reserved = 90.0;

  /// The shell: a Scaffold with extendBody and a bottom bar, whose body holds
  /// a navigator, which holds a screen with a Scaffold and bottom bar of its
  /// own. That is the library.
  Widget shell({
    required void Function(double) onScreenInset,
    required void Function(double) onPushedInset,
  }) {
    return MediaQuery(
      data: const MediaQueryData(padding: EdgeInsets.only(bottom: reserved)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: const SizedBox(height: reserved),
          body: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                bottomNavigationBar: const SizedBox(height: 40),
                body: Builder(
                  builder: (inner) {
                    onScreenInset(MediaQuery.paddingOf(inner).bottom);
                    return TextButton(
                      onPressed: () => Navigator.of(inner).push(
                        MaterialPageRoute<void>(
                          builder: (pushed) {
                            onPushedInset(MediaQuery.paddingOf(pushed).bottom);
                            return const SizedBox();
                          },
                        ),
                      ),
                      child: const Text('open'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('a screen with its own bottom bar cannot see the reservation', (
    tester,
  ) async {
    var screenInset = -1.0;
    await tester.pumpWidget(
      shell(onScreenInset: (v) => screenInset = v, onPushedInset: (_) {}),
    );
    await tester.pumpAndSettle();

    // This is the trap. Scaffold strips padding.bottom from its own body when
    // it has a bottomNavigationBar, so anything asking from in here gets zero
    // and pads by nothing at all.
    expect(screenInset, 0);
  });

  testWidgets('a route pushed on the navigator can', (tester) async {
    var pushedInset = -1.0;
    await tester.pumpWidget(
      shell(onScreenInset: (_) {}, onPushedInset: (v) => pushedInset = v),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // The sheet is pushed here, a sibling of the screen rather than a child of
    // its Scaffold, so the shell's reservation is intact.
    expect(pushedInset, reserved);
  });
}

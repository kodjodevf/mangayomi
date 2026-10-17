import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori_widgetbook/main.dart';
import 'package:widgetbook/widgetbook.dart';

/// Every use case with its route path, built the way Widgetbook builds it:
/// the names from the top folder down, kebab-cased.
Iterable<(WidgetbookUseCase, String)> _useCases(
  List<WidgetbookNode> nodes, [
  List<String> parents = const [],
]) sync* {
  for (final node in nodes) {
    final names = [...parents, node.name];
    if (node is WidgetbookUseCase) {
      yield (node, names.join('/').replaceAll(' ', '-').toLowerCase());
    }
    yield* _useCases(node.children ?? const [], names);
  }
}

void main() {
  final useCases = _useCases(catalogue).toList();

  test('the catalogue lists every component', () {
    expect(useCases.length, greaterThanOrEqualTo(16));
  });

  // Opening each use case catches a component that throws, overflows or
  // asserts before anyone browses to it.
  for (final (_, path) in useCases) {
    testWidgets('renders $path', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(ShioriCatalogue(initialRoute: '/?path=$path'));
      // The skeletons breathe forever, so settle on a fixed time instead.
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);
      expect(find.byType(ErrorWidget), findsNothing);
      // A path that matches nothing falls back to the home page, which the
      // package doesn't export, hence the name.
      expect(
        find.byWidgetPredicate(
          (w) => w.runtimeType.toString() == 'DefaultHomePage',
        ),
        findsNothing,
      );
    });
  }
}

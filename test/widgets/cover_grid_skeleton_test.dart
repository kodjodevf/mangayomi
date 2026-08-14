import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/cover_grid_skeleton.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';

Widget _host(Widget child, {bool disableAnimations = false}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  testWidgets('goes through the real grid so the geometry matches', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const CoverGridSkeleton(gridSize: 3, itemCount: 6)),
    );
    await tester.pump();

    // Not a lookalike grid: the same widget the covers land in, so the
    // delegate, spacing and padding cannot drift apart.
    final grid = tester.widget<GridViewWidget>(find.byType(GridViewWidget));
    expect(grid.gridSize, 3);
    expect(grid.itemCount, 6);
  });

  testWidgets('passes the aspect ratio through unchanged', (tester) async {
    await tester.pumpWidget(
      _host(const CoverGridSkeleton(childAspectRatio: 0.642)),
    );
    await tester.pump();

    final grid = tester.widget<GridViewWidget>(find.byType(GridViewWidget));
    expect(grid.childAspectRatio, 0.642);
  });

  testWidgets('settles when the platform asks for reduced motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const CoverGridSkeleton(), disableAnimations: true),
    );

    // pumpAndSettle times out against a repeating animation, so this failing
    // is the signal that the reduce-motion path stopped being honoured.
    await tester.pumpAndSettle();
    expect(find.byType(GridViewWidget), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/browse/widgets/tv_browse_tab_strip.dart';

void main() {
  testWidgets('six long TV tabs stay reachable at 960x540', (tester) async {
    tester.view.physicalSize = const Size(960, 540);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int? selectedIndex;
    const labels = [
      'Manga Sources Catalogue',
      'Anime Sources Catalogue',
      'Novel Sources Catalogue',
      'Manga Extensions Catalogue',
      'Anime Extensions Catalogue',
      'Novel Extensions Catalogue',
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: TvBrowseTabStrip(
              labels: labels,
              selectedIndex: 0,
              onSelected: (index) => selectedIndex = index,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);

    final lastLabel = find.text(labels.last);
    final lastLabelContext = tester.element(lastLabel);
    Focus.of(lastLabelContext).requestFocus();
    await tester.pumpAndSettle();

    expect(Focus.of(lastLabelContext).hasFocus, isTrue);
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, greaterThan(0));

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(selectedIndex, labels.length - 1);
    expect(tester.takeException(), isNull);
  });
}

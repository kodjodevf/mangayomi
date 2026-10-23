import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/deferred_cover_image.dart';

void main() {
  testWidgets('a scroll ending during layout rebuilds after the frame', (
    tester,
  ) async {
    var stopDuringLayout = false;
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: ListView(
          controller: controller,
          children: [
            DeferredCoverImage(
              width: 10,
              height: 10,
              builder: (_) => const Text('cover'),
            ),
            // Ends the scroll while laying out, as a list settling its
            // position does.
            LayoutBuilder(
              builder: (context, constraints) {
                if (stopDuringLayout) {
                  controller.position.isScrollingNotifier.value = false;
                }
                return const SizedBox(height: 10);
              },
            ),
          ],
        ),
      ),
    );

    controller.position.isScrollingNotifier.value = true;
    await tester.pump();
    stopDuringLayout = true;
    tester.binding.buildOwner!.reassemble(tester.binding.rootElement!);
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('cover'), findsOneWidget);
  });
}

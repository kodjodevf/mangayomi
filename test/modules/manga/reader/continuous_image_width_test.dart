import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/widgets/continuous_image_width.dart';

void main() {
  testWidgets('fills available width only when requested', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Future<double> pumpWidth(bool fillAvailableWidth) async {
      const imageKey = Key('image');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ContinuousImageWidth(
                  fillAvailableWidth: fillAvailableWidth,
                  child: const SizedBox(key: imageKey, width: 720, height: 100),
                ),
              ],
            ),
          ),
        ),
      );
      return tester.getSize(find.byKey(imageKey)).width;
    }

    expect(await pumpWidth(false), 720);
    expect(await pumpWidth(true), 1200);
  });
}

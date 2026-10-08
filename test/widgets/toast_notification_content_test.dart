import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/toast_notification_content.dart';

void main() {
  for (final width in <double>[320, 390, 430]) {
    testWidgets('keeps the error readable at ${width.toInt()} px', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 568);
      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: ToastNotificationContent(
                    message: 'Cloudflare verification required (HTTP 403)',
                    maxLines: 2,
                    action: Semantics(
                      label: 'Resolve Cloudflare challenge',
                      button: true,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.public, size: 18),
                        label: const Text('Resolve challenge'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.text('Cloudflare verification required (HTTP 403)'),
        findsOneWidget,
      );
      expect(find.text('Resolve challenge'), findsOneWidget);
      expect(
        tester
            .getSize(find.text('Cloudflare verification required (HTTP 403)'))
            .width,
        greaterThan(150),
      );
      expect(
        tester.getTopLeft(find.text('Resolve challenge')).dy,
        greaterThan(
          tester
              .getBottomLeft(
                find.text('Cloudflare verification required (HTTP 403)'),
              )
              .dy,
        ),
      );
    });
  }

  testWidgets('keeps the setup path visible on a narrow screen', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    const guidance = 'Cloudflare check. Add bypass URL: Settings > General.';
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: ListTile(
                leading: Icon(Icons.bug_report),
                title: ToastNotificationContent(message: guidance, maxLines: 6),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    final text = tester.widget<Text>(find.text(guidance));
    expect(text.maxLines, 6);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(
      tester
          .renderObject<RenderParagraph>(find.text(guidance))
          .didExceedMaxLines,
      isFalse,
    );
  });
}

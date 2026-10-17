import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/router/router.dart';

void main() {
  testWidgets('real Cloudflare toast keeps its message and action readable', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: const Scaffold(body: SizedBox.expand()),
      ),
    );

    final cancel = botToast(
      'Cloudflare verification required (HTTP 403)',
      second: 100,
      hasCloudFlare: true,
      url: 'https://example.com',
      maxLines: 2,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final message = find.text('Cloudflare verification required (HTTP 403)');
    final action = find.text('Resolve challenge');
    final accessibleAction = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics &&
          widget.properties.label == 'Resolve Cloudflare challenge',
    );
    expect(message, findsOneWidget);
    expect(action, findsOneWidget);
    expect(accessibleAction, findsOneWidget);
    expect(
      tester.widget<Semantics>(accessibleAction).properties.onTap,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(message).width, greaterThan(150));
    expect(
      tester.getTopLeft(action).dy,
      greaterThan(tester.getBottomLeft(message).dy),
    );

    cancel();
    await tester.pump(const Duration(milliseconds: 250));
  });

  testWidgets('real Cloudflare toast handles large RTL text', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final botToastBuilder = BotToastInit();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: botToastBuilder(context, child),
            ),
          );
        },
        navigatorObservers: [BotToastNavigatorObserver()],
        home: const Scaffold(body: SizedBox.expand()),
      ),
    );

    final cancel = botToast(
      'Cloudflare verification required (HTTP 403)',
      second: 100,
      hasCloudFlare: true,
      url: 'https://example.com',
      maxLines: 2,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final action = find.text('Resolve challenge');
    expect(action, findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(tester.getRect(action).right, lessThanOrEqualTo(320));
    expect(
      tester
          .getSize(find.widgetWithText(OutlinedButton, 'Resolve challenge'))
          .height,
      greaterThanOrEqualTo(44),
    );

    cancel();
    await tester.pump(const Duration(milliseconds: 250));
  });
}

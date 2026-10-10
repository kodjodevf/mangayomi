import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_seek_indicator.dart';

void main() {
  const surfaceSize = Size(320, 568);

  testWidgets('shows compact forward feedback at the outer edge', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    await tester.pumpWidget(
      _indicatorApp(forward: true, onChanged: (_) {}, onSubmitted: (_) {}),
    );

    expect(find.text('+10'), findsOneWidget);
    expect(find.text('10s'), findsNothing);
    expect(find.byIcon(Icons.forward_10), findsNothing);
    expect(
      find.byKey(const ValueKey('mobile-seek-forward-chevron-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-seek-forward-chevron-1')),
      findsOneWidget,
    );
    final counterShadow = tester
        .widget<Text>(find.text('+10'))
        .style!
        .shadows!
        .single;
    expect(counterShadow.color, const Color(0x30000000));
    expect(counterShadow.blurRadius, 3);
    expect(counterShadow.offset, const Offset(0, 1));
    expect(tester.getCenter(find.text('+10')).dx, greaterThanOrEqualTo(210));
    expect(
      tester.getCenter(find.text('+10')).dy,
      closeTo(surfaceSize.height / 2, 0.1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mirrors backward feedback at the outer edge', (tester) async {
    await _setSurfaceSize(tester, surfaceSize);
    await tester.pumpWidget(
      _indicatorApp(forward: false, onChanged: (_) {}, onSubmitted: (_) {}),
    );

    expect(find.text('-10'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mobile-seek-backward-chevron-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-seek-backward-chevron-1')),
      findsOneWidget,
    );
    expect(tester.getCenter(find.text('-10')).dx, lessThanOrEqualTo(110));
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps landscape feedback outside display cutouts', (
    tester,
  ) async {
    const landscapeSize = Size(844, 390);
    const insets = EdgeInsets.only(left: 59, right: 47);
    await _setSurfaceSize(tester, landscapeSize);

    await tester.pumpWidget(
      _indicatorApp(
        forward: false,
        compactPortrait: false,
        indicatorWidth: landscapeSize.width / 2,
        viewPadding: insets,
        onChanged: (_) {},
        onSubmitted: (_) {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 220));

    for (var index = 0; index < 2; index++) {
      final chevron = tester.getRect(
        find.byKey(ValueKey('mobile-seek-backward-chevron-$index')),
      );
      expect(chevron.left, greaterThanOrEqualTo(insets.left));
    }

    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        compactPortrait: false,
        indicatorWidth: landscapeSize.width / 2,
        viewPadding: insets,
        onChanged: (_) {},
        onSubmitted: (_) {},
      ),
    );
    await tester.pump(const Duration(milliseconds: 220));

    for (var index = 0; index < 2; index++) {
      final chevron = tester.getRect(
        find.byKey(ValueKey('mobile-seek-forward-chevron-$index')),
      );
      expect(
        chevron.right,
        lessThanOrEqualTo(landscapeSize.width - insets.right),
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('aligns landscape feedback with the player control band', (
    tester,
  ) async {
    const landscapeSize = Size(844, 390);
    const insets = EdgeInsets.only(left: 59, right: 47, bottom: 21);
    await _setSurfaceSize(tester, landscapeSize);

    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        compactPortrait: false,
        indicatorWidth: landscapeSize.width / 2,
        viewPadding: insets,
        onChanged: (_) {},
        onSubmitted: (_) {},
      ),
    );

    final expectedCenter =
        (insets.top +
            landscapeSize.height -
            insets.bottom -
            mobilePlayerBottomControlsBottomPadding) /
        2;
    final feedbackCenter = tester.getCenter(find.text('+10')).dy;
    expect(feedbackCenter, closeTo(expectedCenter, 0.1));
    expect(feedbackCenter, lessThan(landscapeSize.height / 2));
    expect(tester.getSize(_gestureSurface).height, landscapeSize.height);
    expect(tester.takeException(), isNull);
  });

  testWidgets('accumulates consecutive taps and submits the latest total', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    final changed = <Duration>[];
    final submitted = <Duration>[];
    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        onChanged: changed.add,
        onSubmitted: submitted.add,
      ),
    );

    for (var index = 0; index < 3; index++) {
      await tester.tap(_gestureSurface);
      await tester.pump();
    }

    expect(find.text('+40'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mobile-seek-forward-chevron-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-seek-forward-chevron-1')),
      findsOneWidget,
    );
    expect(changed, const [
      Duration(seconds: 20),
      Duration(seconds: 30),
      Duration(seconds: 40),
    ]);

    await tester.pump(
      MobileSeekIndicator.submitDelay - const Duration(milliseconds: 1),
    );
    expect(submitted, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(submitted, const [Duration(seconds: 40)]);
  });

  testWidgets('resets the submit delay after each consecutive tap', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    final submitted = <Duration>[];
    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        onChanged: (_) {},
        onSubmitted: submitted.add,
      ),
    );

    await tester.tap(_gestureSurface);
    await tester.pump(
      MobileSeekIndicator.submitDelay - const Duration(milliseconds: 1),
    );
    await tester.tap(_gestureSurface);
    await tester.pump(
      MobileSeekIndicator.submitDelay - const Duration(milliseconds: 1),
    );
    expect(submitted, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    expect(submitted, const [Duration(seconds: 30)]);
  });

  testWidgets('cancels a pending seek when the indicator is disposed', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    final submitted = <Duration>[];
    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        onChanged: (_) {},
        onSubmitted: submitted.add,
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(MobileSeekIndicator.submitDelay);

    expect(submitted, isEmpty);
  });

  testWidgets('does not schedule another seek after submission', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    final changed = <Duration>[];
    final submitted = <Duration>[];
    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        onChanged: changed.add,
        onSubmitted: submitted.add,
      ),
    );

    await tester.pump(MobileSeekIndicator.submitDelay);
    await tester.tap(_gestureSurface);
    await tester.pump(MobileSeekIndicator.submitDelay);

    expect(changed, isEmpty);
    expect(submitted, const [Duration(seconds: 10)]);
  });

  testWidgets('respects a custom seek interval without overflowing', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    final changed = <Duration>[];
    await tester.pumpWidget(
      _indicatorApp(
        forward: true,
        skipDuration: 5,
        textScaler: const TextScaler.linear(2),
        onChanged: changed.add,
        onSubmitted: (_) {},
      ),
    );

    expect(find.text('+5'), findsOneWidget);
    expect(
      MediaQuery.textScalerOf(tester.element(find.text('+5'))).scale(10),
      20,
    );
    await tester.tap(_gestureSurface);
    await tester.pump();
    expect(find.text('+10'), findsOneWidget);
    expect(changed, const [Duration(seconds: 10)]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the tap surface clear and restarts the chevron pulse', (
    tester,
  ) async {
    await _setSurfaceSize(tester, surfaceSize);
    await tester.pumpWidget(
      _indicatorApp(forward: true, onChanged: (_) {}, onSubmitted: (_) {}),
    );

    expect(find.byType(InkWell), findsNothing);
    await tester.pump(const Duration(milliseconds: 220));
    expect(_opacity(tester, 'mobile-seek-forward-chevron-0'), 0);

    await tester.tap(_gestureSurface);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(_opacity(tester, 'mobile-seek-forward-chevron-0'), greaterThan(0.8));
    expect(find.text('+20'), findsOneWidget);
  });
}

final _gestureSurface = find.byKey(
  const ValueKey('mobile-seek-gesture-surface'),
);

double _opacity(WidgetTester tester, String key) {
  return tester.widget<Opacity>(find.byKey(ValueKey(key))).opacity;
}

Widget _indicatorApp({
  required bool forward,
  required ValueChanged<Duration> onChanged,
  required ValueChanged<Duration> onSubmitted,
  int skipDuration = 10,
  TextScaler textScaler = TextScaler.noScaling,
  EdgeInsets viewPadding = EdgeInsets.zero,
  double indicatorWidth = 160,
  bool compactPortrait = true,
}) {
  final indicator = SizedBox(
    width: indicatorWidth,
    child: MobileSeekIndicator(
      forward: forward,
      compactPortrait: compactPortrait,
      skipDuration: skipDuration,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    ),
  );

  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: textScaler, viewPadding: viewPadding),
      child: child!,
    ),
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: forward
            ? [const Spacer(), indicator]
            : [indicator, const Spacer()],
      ),
    ),
  );
}

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  await TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(size);
  addTearDown(
    () => TestWidgetsFlutterBinding.ensureInitialized().setSurfaceSize(null),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
      find.byKey(const ValueKey('mobile-seek-forward-single-chevron')),
      findsOneWidget,
    );
    expect(tester.getCenter(find.text('+10')).dx, greaterThanOrEqualTo(220));
    expect(tester.takeException(), isNull);
  });

  testWidgets('mirrors backward feedback at the outer edge', (tester) async {
    await _setSurfaceSize(tester, surfaceSize);
    await tester.pumpWidget(
      _indicatorApp(forward: false, onChanged: (_) {}, onSubmitted: (_) {}),
    );

    expect(find.text('-10'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mobile-seek-backward-single-chevron')),
      findsOneWidget,
    );
    expect(tester.getCenter(find.text('-10')).dx, lessThanOrEqualTo(100));
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
      await tester.tap(find.byType(InkWell));
      await tester.pump();
    }

    expect(find.text('+40'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('mobile-seek-forward-double-chevron')),
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

    await tester.tap(find.byType(InkWell));
    await tester.pump(
      MobileSeekIndicator.submitDelay - const Duration(milliseconds: 1),
    );
    await tester.tap(find.byType(InkWell));
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
    await tester.tap(find.byType(InkWell));
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
    await tester.tap(find.byType(InkWell));
    await tester.pump();
    expect(find.text('+10'), findsOneWidget);
    expect(changed, const [Duration(seconds: 10)]);
    expect(tester.takeException(), isNull);
  });
}

Widget _indicatorApp({
  required bool forward,
  required ValueChanged<Duration> onChanged,
  required ValueChanged<Duration> onSubmitted,
  int skipDuration = 10,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  final indicator = SizedBox(
    width: 160,
    child: MobileSeekIndicator(
      forward: forward,
      skipDuration: skipDuration,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    ),
  );

  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
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

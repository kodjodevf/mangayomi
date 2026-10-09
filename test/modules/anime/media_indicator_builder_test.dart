import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/widgets/indicator_builder.dart';

void main() {
  testWidgets('places mobile media indicators below the portrait header', (
    tester,
  ) async {
    const size = Size(390, 844);
    const insets = EdgeInsets.only(top: 47, bottom: 34);
    await _setSurfaceSize(tester, size);

    for (final isVolume in [true, false]) {
      final value = ValueNotifier(0.5);
      await tester.pumpWidget(
        _testApp(
          size: size,
          insets: insets,
          child: MediaIndicatorBuilder(
            value: value,
            isVolumeIndicator: isVolume,
            adaptiveMobilePlacement: true,
            showAtZero: true,
          ),
        ),
      );

      final indicator = find.byKey(
        ValueKey(
          isVolume ? 'volume-indicator-card' : 'brightness-indicator-card',
        ),
      );
      final expectedTop = math.max(insets.top + 72, size.height * 0.18);
      expect(tester.getTopLeft(indicator).dy, closeTo(expectedTop, 0.1));
      expect(tester.getCenter(indicator).dx, size.width / 2);
      expect(tester.getSize(indicator), const Size(210, 42));

      value.value = 0;
      await tester.pump();
      expect(indicator, findsOneWidget);

      value.dispose();
    }
  });

  testWidgets('preserves the existing desktop placement by default', (
    tester,
  ) async {
    const size = Size(390, 844);
    await _setSurfaceSize(tester, size);
    final value = ValueNotifier(0.5);
    addTearDown(value.dispose);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: MediaIndicatorBuilder(value: value, isVolumeIndicator: true),
      ),
    );

    final indicator = find.byKey(const ValueKey('volume-indicator-card'));
    expect(tester.getTopLeft(indicator).dy, 80);
  });

  testWidgets('keeps adaptive landscape placement near the top controls', (
    tester,
  ) async {
    const size = Size(568, 320);
    await _setSurfaceSize(tester, size);
    final value = ValueNotifier(0.5);
    addTearDown(value.dispose);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: MediaIndicatorBuilder(
          value: value,
          isVolumeIndicator: true,
          adaptiveMobilePlacement: true,
        ),
      ),
    );

    final indicator = find.byKey(const ValueKey('volume-indicator-card'));
    expect(tester.getTopLeft(indicator).dy, 72);
  });
}

Widget _testApp({
  required Size size,
  required Widget child,
  EdgeInsets insets = EdgeInsets.zero,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: size, padding: insets, viewPadding: insets),
      child: Scaffold(body: child),
    ),
  );
}

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}

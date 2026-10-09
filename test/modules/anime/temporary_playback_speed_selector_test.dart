import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/widgets/temporary_playback_speed_selector.dart';

void main() {
  testWidgets('shows only the currently selected temporary speed', (
    tester,
  ) async {
    const size = Size(844, 390);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(_testApp(size: size, speed: 2.0));

    expect(find.text('2x'), findsOneWidget);
    expect(find.text('3x'), findsNothing);
    expect(find.text('2.5x'), findsNothing);
    expect(find.text('1.5x'), findsNothing);
    expect(find.text('1x'), findsNothing);
    expect(find.text('0.75x'), findsNothing);
    expect(find.text('0.5x'), findsNothing);
    expect(find.text('0.25x'), findsNothing);

    final indicator = find.byKey(const ValueKey('temporary-speed-indicator'));
    expect(tester.getSize(indicator), const Size(58, 34));
    expect(tester.getCenter(indicator).dx, size.width / 2);
    expect(tester.getTopLeft(indicator).dy, 12);
  });

  testWidgets('places the portrait indicator above the bottom controls', (
    tester,
  ) async {
    const size = Size(390, 844);
    const insets = EdgeInsets.only(top: 47, bottom: 34);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(_testApp(size: size, insets: insets, speed: 2.0));

    final indicator = tester.getRect(
      find.byKey(const ValueKey('temporary-speed-indicator')),
    );
    expect(indicator.center.dx, size.width / 2);
    expect(
      indicator.bottom,
      size.height -
          insets.bottom -
          TemporaryPlaybackSpeedSelector.portraitBottomClearance,
    );
    expect(indicator.top, greaterThan(size.height / 2));
  });

  testWidgets('remains readable and announces once with large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    const size = Size(320, 568);
    const insets = EdgeInsets.only(top: 44, bottom: 34);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        insets: insets,
        speed: 0.25,
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('0.25x'), findsOneWidget);
    expect(find.bySemanticsLabel('Playback speed: 0.25x'), findsOneWidget);
    final indicator = tester.getRect(
      find.byKey(const ValueKey('temporary-speed-indicator')),
    );
    expect(indicator.center.dx, size.width / 2);
    expect(
      indicator.bottom,
      size.height -
          insets.bottom -
          TemporaryPlaybackSpeedSelector.portraitBottomClearance,
    );
    semantics.dispose();
  });
}

Widget _testApp({
  required Size size,
  required double speed,
  EdgeInsets insets = EdgeInsets.zero,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        padding: insets,
        viewPadding: insets,
        textScaler: textScaler,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: TemporaryPlaybackSpeedSelector(speed: speed),
        ),
      ),
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

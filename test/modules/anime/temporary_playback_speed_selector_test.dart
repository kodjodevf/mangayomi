import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/widgets/temporary_playback_speed_selector.dart';

void main() {
  testWidgets('shows only the currently selected temporary speed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SizedBox.expand(
            child: TemporaryPlaybackSpeedSelector(speed: 2.0),
          ),
        ),
      ),
    );

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
    expect(tester.getCenter(indicator).dx, 400);
    expect(tester.getTopLeft(indicator).dy, 12);
  });

  testWidgets('remains readable and announces once with large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: const Scaffold(
          body: SizedBox.expand(
            child: TemporaryPlaybackSpeedSelector(speed: 0.25),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('0.25x'), findsOneWidget);
    expect(find.bySemanticsLabel('Playback speed: 0.25x'), findsOneWidget);
    semantics.dispose();
  });
}

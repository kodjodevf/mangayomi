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
            child: TemporaryPlaybackSpeedSelector(
              position: Offset(120, 160),
              speed: 2.0,
            ),
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
  });
}

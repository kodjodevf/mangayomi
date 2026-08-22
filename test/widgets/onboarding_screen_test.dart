import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/onboarding/onboarding_screen.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  tearDown(() => debugIsTvOverride = null);

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // The screen only reads the repo list to append to it, and writing
          // goes through Isar, which is not open in a test.
          for (final type in ItemType.values)
            extensionsRepoStateProvider(type)
                .overrideWith(() => _StubRepoState()),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  ButtonStyleButton addButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  testWidgets('offers a way out without adding anything', (tester) async {
    await pump(tester);
    // A first-run screen that can only be left by supplying a repository would
    // trap anyone who does not have one to hand.
    expect(find.widgetWithText(TextButton, 'Skip for now'), findsOneWidget);
  });

  testWidgets('cannot add an empty repository', (tester) async {
    await pump(tester);
    expect(addButton(tester).onPressed, isNull);
  });

  testWidgets('cannot add something that is not a url', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField), 'not a url');
    await tester.pump();
    expect(addButton(tester).onPressed, isNull);
  });

  testWidgets('accepts an absolute url', (tester) async {
    await pump(tester);
    await tester.enterText(
      find.byType(TextField),
      'https://example.invalid/index.json',
    );
    await tester.pump();
    expect(addButton(tester).onPressed, isNotNull);
  });

  testWidgets('asks which library the repository stocks, manga first', (
    tester,
  ) async {
    await pump(tester);
    // Repositories are per item type, so a wrong guess would file the sources
    // where the user will not look for them.
    final picker = tester.widget<SegmentedButton<ItemType>>(
      find.byType(SegmentedButton<ItemType>),
    );
    expect(picker.selected, {ItemType.manga});
    expect(picker.segments.map((s) => s.value), ItemType.values);
  });

  group('on a TV', () {
    setUp(() => debugIsTvOverride = true);

    testWidgets('picks the item type with pills, not a segmented button', (
      tester,
    ) async {
      await pump(tester);
      // A SegmentedButton's segments are not reliably reachable with a d-pad.
      expect(find.byType(SegmentedButton<ItemType>), findsNothing);
      expect(find.byType(TvPill), findsNWidgets(ItemType.values.length));
    });

    testWidgets('the url field takes focus, so OK opens the keyboard', (
      tester,
    ) async {
      await pump(tester);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofocus, isTrue);
    });

    testWidgets('says the repository can be added later instead', (
      tester,
    ) async {
      await pump(tester);
      // Typing a url on a remote is miserable; leaving now has to look like a
      // real option rather than a failure.
      expect(
        find.text('You can add one later under More, Source repositories.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Skip for now'), findsOneWidget);
    });

    testWidgets('the phone layout keeps the segmented button', (tester) async {
      debugIsTvOverride = false;
      await pump(tester);
      expect(find.byType(SegmentedButton<ItemType>), findsOneWidget);
      expect(find.byType(TvPill), findsNothing);
      expect(
        find.text('You can add one later under More, Source repositories.'),
        findsNothing,
      );
    });
  });
}

class _StubRepoState extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => const [];
}

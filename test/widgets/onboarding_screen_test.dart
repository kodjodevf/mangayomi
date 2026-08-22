import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/onboarding_screen.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  tearDown(() => debugIsTvOverride = null);

  Future<void> pump(WidgetTester tester, {Brightness? brightness}) async {
    // The TV layout is taller than the default 800x600 surface, which puts the
    // step buttons outside the viewport where a tap cannot reach them.
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // The screen only reads the repo list to append to it, and writing
          // goes through Isar, which is not open in a test.
          for (final type in ItemType.values)
            extensionsRepoStateProvider(type)
                .overrideWith(() => _StubRepoState()),
          // Read and written as the steps advance, and both go through Isar,
          // which is not open in a test.
          hideItemsStateProvider.overrideWith(_StubHideItems.new),
          mergeLibraryNavMobileStateProvider.overrideWith(_StubMergeNav.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(brightness: brightness ?? Brightness.dark),
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  ButtonStyleButton addButton(WidgetTester tester) =>
      tester.widget<FilledButton>(find.byType(FilledButton));

  /// Walks past the library and navigation steps to the repository step.
  Future<void> toRepoStep(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FilledButton, 'Next'));
    await tester.pumpAndSettle();
    if (find.widgetWithText(FilledButton, 'Next').evaluate().isNotEmpty) {
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('offers a way out without adding anything', (tester) async {
    await pump(tester);
    // A first-run screen that can only be left by supplying a repository would
    // trap anyone who does not have one to hand.
    expect(find.widgetWithText(TextButton, 'Skip for now'), findsOneWidget);
  });

  testWidgets('cannot add an empty repository', (tester) async {
    await pump(tester);
    await toRepoStep(tester);
    expect(addButton(tester).onPressed, isNull);
  });

  testWidgets('cannot add something that is not a url', (tester) async {
    await pump(tester);
    await toRepoStep(tester);
    await tester.enterText(find.byType(TextField), 'not a url');
    await tester.pump();
    expect(addButton(tester).onPressed, isNull);
  });

  testWidgets('accepts an absolute url', (tester) async {
    await pump(tester);
    await toRepoStep(tester);
    await tester.enterText(
      find.byType(TextField),
      'https://example.invalid/index.json',
    );
    await tester.pump();
    expect(addButton(tester).onPressed, isNotNull);
  });

  group('the steps', () {
    testWidgets('opens by asking which libraries the user reads', (
      tester,
    ) async {
      await pump(tester);
      expect(find.text('Welcome to Mangayomi'), findsOneWidget);
      for (final label in ['Manga', 'Anime', 'Novel']) {
        expect(find.widgetWithText(FilterChip, label), findsOneWidget);
      }
    });

    testWidgets('asks how the libraries sit in the bar, then for a repo', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'A tab each'), findsOneWidget);
      expect(
        find.widgetWithText(FilterChip, 'One Library tab'),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Add a source'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('skips arranging a bar that holds one library', (tester) async {
      await pump(tester);
      // Two off, one left. There is nothing to arrange, so asking would be
      // asking for the sake of it.
      await tester.tap(find.widgetWithText(FilterChip, 'Anime'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilterChip, 'Novel'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsNothing);
      expect(find.text('Add a source'), findsOneWidget);
    });

    testWidgets('keeps at least one library selected', (tester) async {
      await pump(tester);
      // Turning them all off would leave a bar with no library in it.
      for (final label in ['Manga', 'Anime', 'Novel']) {
        await tester.tap(find.widgetWithText(FilterChip, label));
        await tester.pump();
      }
      final selected = tester
          .widgetList<FilterChip>(find.byType(FilterChip))
          .where((chip) => chip.selected);
      expect(selected, isNotEmpty);
    });

    testWidgets('only offers a repo type the user actually reads', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.widgetWithText(FilterChip, 'Novel'));
      await tester.pump();
      await toRepoStep(tester);
      expect(find.widgetWithText(FilterChip, 'Manga'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Anime'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Novel'), findsNothing);
    });
  });

  group('the app mark', () {
    Image logo(WidgetTester tester) =>
        tester.widget<Image>(find.byType(Image).first);

    String asset(WidgetTester tester) =>
        (logo(tester).image as AssetImage).assetName;

    testWidgets('is the silhouette, tinted white, on a dark theme', (
      tester,
    ) async {
      await pump(tester, brightness: Brightness.dark);
      expect(asset(tester), 'assets/app_icons/icon.png');
      expect(logo(tester).color, Colors.white);
    });

    testWidgets('is the real app icon, untinted, on a light theme', (
      tester,
    ) async {
      // Both full colour icons are drawn on a white tile, so they suit a light
      // background and would read as a bright block on a dark one.
      await pump(tester, brightness: Brightness.light);
      expect(asset(tester), 'assets/app_icons/icon-red.png');
      expect(logo(tester).color, isNull);
    });
  });

  group('on a TV', () {
    setUp(() => debugIsTvOverride = true);

    testWidgets('chooses with pills, not chips', (tester) async {
      await pump(tester);
      // A chip row is not reliably reachable with a d-pad.
      expect(find.byType(FilterChip), findsNothing);
      expect(find.byType(TvPill), findsNWidgets(ItemType.values.length));
    });

    testWidgets('the url field takes focus, so OK opens the keyboard', (
      tester,
    ) async {
      await pump(tester);
      await toRepoStep(tester);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.autofocus, isTrue);
    });

    testWidgets('says the repository can be added later instead', (
      tester,
    ) async {
      await pump(tester);
      await toRepoStep(tester);
      // Typing a url on a remote is miserable; leaving now has to look like a
      // real option rather than a failure.
      expect(
        find.text('You can add one later under More, Source repositories.'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextButton, 'Skip for now'), findsOneWidget);
    });

    testWidgets('the phone layout keeps chips and loses the hint', (
      tester,
    ) async {
      debugIsTvOverride = false;
      await pump(tester);
      expect(find.byType(FilterChip), findsNWidgets(ItemType.values.length));
      expect(find.byType(TvPill), findsNothing);
      await toRepoStep(tester);
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

class _StubHideItems extends HideItemsState {
  @override
  List<String> build() => const ['/trackerLibrary'];

  @override
  void set(List<String> values) => state = values;
}

class _StubMergeNav extends MergeLibraryNavMobileState {
  @override
  bool build() => false;

  @override
  void set(bool value) => state = value;
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/onboarding/onboarding_screen.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

const _goodUrl = 'https://example.invalid/index.json';

void main() {
  tearDown(() => debugIsTvOverride = null);

  Future<void> pump(
    WidgetTester tester, {
    Brightness? brightness,
    bool disableAnimations = false,
    double textScale = 1,
  }) async {
    // Phone width, because the arrange step is skipped at 600dp and wider,
    // and tall, because the TV layout overflows the default 600 and puts the
    // step buttons outside the viewport where a tap cannot reach them.
    tester.view.physicalSize = const Size(400, 2400);
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
          // A repository that resolves, so the steps after adding one can be
          // reached without a network.
          getRepoInfosProvider(jsonUrl: _goodUrl).overrideWith(
            (ref) async => Repo(name: 'Test repo', jsonUrl: _goodUrl),
          ),
          // Reads Isar, which is not open in a test.
          localFoldersStateProvider.overrideWith(_StubLocalFolders.new),
          hideItemsStateProvider.overrideWith(_StubHideItems.new),
          mergeLibraryNavMobileStateProvider.overrideWith(_StubMergeNav.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(brightness: brightness ?? Brightness.dark),
          // Mounted from builder, not home, because that is how main.dart
          // mounts it: outside the Navigator, with no Overlay above it.
          home: const SizedBox.shrink(),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: disableAnimations,
              textScaler: TextScaler.linear(textScale),
            ),
            child: const OnboardingScreen(),
          ),
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
      // A tab each, so the preview bar names every chosen library.
      expect(find.text('Library'), findsNothing);

      await tester.tap(find.widgetWithText(FilterChip, 'One Library tab'));
      await tester.pumpAndSettle();
      // Merged, so they collapse into one entry in the preview, and the bar
      // that tapping it swaps in is drawn underneath.
      expect(find.text('Library'), findsOneWidget);
      // By its label, not its icon: the step's own back button is an
      // arrow_back too and would match either way.
      expect(find.text('Go back'), findsOneWidget);
      for (final label in ['Manga', 'Anime', 'Novel']) {
        expect(find.text(label), findsWidgets);
      }

      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Add a source'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('skips arranging on a wide screen, where it is ignored', (
      tester,
    ) async {
      // The merge setting is read as mergeLibraryNavMobile && !isTablet, so on
      // anything 600dp or wider the answer would be stored and then ignored.
      await pump(tester);
      tester.view.physicalSize = const Size(900, 2400);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsNothing);
      expect(find.text('Add a source'), findsOneWidget);
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

  group('choices do not resize', () {
    testWidgets('a chip is the same width selected and not', (tester) async {
      await pump(tester);
      final chip = find.widgetWithText(FilterChip, 'Anime');
      final before = tester.getSize(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      // A tick appearing on selection changed every chip's width and made the
      // row jump about as the user tapped through it.
      expect(tester.getSize(chip), before);
    });
  });

  group('edge cases', () {
    testWidgets('lands on the library the repo was filed under, not the one '
        'the picker happens to show', (tester) async {
      await pump(tester);
      await toRepoStep(tester);
      await tester.enterText(find.byType(TextField), _goodUrl);
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add repository'));
      await tester.pumpAndSettle();
      // Filed under Manga. Moving the picker afterwards must not redirect the
      // landing to a library with nothing in it.
      await tester.tap(find.widgetWithText(FilterChip, 'Anime'));
      await tester.pumpAndSettle();
      debugPrint(
        'PROBE: ${tester.widgetList<Text>(find.byType(Text)).map((t) => t.data).toList()}',
      );
      expect(find.widgetWithText(TextButton, 'Continue'), findsOneWidget);
    });

    testWidgets('a failed repo says what to do, not what threw', (
      tester,
    ) async {
      await pump(tester);
      await toRepoStep(tester);
      await tester.enterText(find.byType(TextField), 'https://example.invalid');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add repository'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Exception'), findsNothing);
      expect(
        find.text(
          "Couldn't read that repository. Check the address and your "
          'connection.',
        ),
        findsOneWidget,
      );
    });
  });

  group('files you already have', () {
    testWidgets('are offered beside the repository, not under it', (
      tester,
    ) async {
      // The one thing the app can do with nothing installed and no
      // connection. Somebody who already has files should not have to skip
      // past an empty screen to use them.
      await pump(tester);
      await toRepoStep(tester);
      expect(
        find.widgetWithText(OutlinedButton, 'Add a folder'),
        findsOneWidget,
      );
      expect(find.text('Or use files you already have'), findsOneWidget);
    });

    testWidgets('are not offered before the source step', (tester) async {
      await pump(tester);
      expect(find.widgetWithText(OutlinedButton, 'Add a folder'), findsNothing);
    });
  });

  group('restoring instead', () {
    testWidgets('the first step offers it, the later ones do not', (
      tester,
    ) async {
      // A backup carries repositories, library and settings, so it answers
      // every question here. It belongs where it can save the walk, not after
      // it.
      await pump(tester);
      expect(
        find.widgetWithText(OutlinedButton, 'Restore a backup'),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(OutlinedButton, 'Restore a backup'),
        findsNothing,
      );
    });
  });

  group('motion', () {
    Future<int> framesToChangeStep(
      WidgetTester tester, {
      required bool disableAnimations,
    }) async {
      await pump(tester, disableAnimations: disableAnimations);
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      final frames = await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsOneWidget);
      return frames;
    }

    // Settling takes 5 frames animated and 3 with animations off. The numbers
    // matter less than the gap: the step has to change either way, and it must
    // not spend a quarter of a second doing it when the platform asked for
    // stillness.
    testWidgets('a step change is animated', (tester) async {
      expect(
        await framesToChangeStep(tester, disableAnimations: false),
        greaterThanOrEqualTo(5),
      );
    });

    testWidgets('and is not when the platform asks for stillness', (
      tester,
    ) async {
      expect(
        await framesToChangeStep(tester, disableAnimations: true),
        lessThan(5),
      );
    });
  });

  group('floating widgets', () {
    testWidgets('the back arrow can show its tooltip', (tester) async {
      // The screen renders in MaterialApp.builder, outside the router's
      // Navigator, so it has no Overlay unless one is given to it. Without
      // that the first hover over this button throws.
      await pump(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      final back = find.widgetWithIcon(IconButton, Icons.arrow_back);
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: tester.getCenter(back));
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(back));
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    });
  });

  group('going back', () {
    testWidgets('the first step has nothing to go back to', (tester) async {
      await pump(tester);
      expect(find.widgetWithIcon(IconButton, Icons.arrow_back), findsNothing);
    });

    testWidgets('walks back through the steps it walked forward', (
      tester,
    ) async {
      await pump(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Add a source'), findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Mangayomi'), findsOneWidget);
      expect(find.widgetWithIcon(IconButton, Icons.arrow_back), findsNothing);
    });

    testWidgets('skips the arrange step on the way back too', (tester) async {
      await pump(tester);
      // One library, so arranging was skipped going forward and going back
      // through it would show a step that was never offered.
      await tester.tap(find.widgetWithText(FilterChip, 'Anime'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilterChip, 'Novel'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      expect(find.text('Add a source'), findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Your libraries'), findsNothing);
      expect(find.text('Welcome to Mangayomi'), findsOneWidget);
    });
  });

  group('the step indicator', () {
    Iterable<double> dotWidths(WidgetTester tester) => tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((c) => (c.constraints?.maxWidth) ?? 0);

    testWidgets('shows one mark per step that will actually be asked', (
      tester,
    ) async {
      await pump(tester);
      expect(dotWidths(tester).length, 3);
    });

    testWidgets('drops to two when the arrange step will be skipped', (
      tester,
    ) async {
      // Three marks followed by two questions would be a small lie about how
      // long this takes.
      await pump(tester);
      await tester.tap(find.widgetWithText(FilterChip, 'Anime'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilterChip, 'Novel'));
      await tester.pumpAndSettle();
      expect(dotWidths(tester).length, 2);
    });

    testWidgets('marks the step you are on, and moves with you', (
      tester,
    ) async {
      await pump(tester);
      expect(dotWidths(tester).first, greaterThan(dotWidths(tester).last));

      await tester.tap(find.widgetWithText(FilledButton, 'Next'));
      await tester.pumpAndSettle();
      final widths = dotWidths(tester).toList();
      expect(widths[1], greaterThan(widths[0]));
    });
  });

  group('large text', () {
    testWidgets('the first step still fits at double size', (tester) async {
      // Wrap and a scroll view should cope, but nobody had tried it.
      await pump(tester, textScale: 2);
      expect(tester.takeException(), isNull);
      expect(find.widgetWithText(FilledButton, 'Next'), findsOneWidget);
    });

    testWidgets('and so does the source step, which carries the most', (
      tester,
    ) async {
      await pump(tester, textScale: 2);
      await toRepoStep(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(TextField), findsOneWidget);
    });
  });

  group('contrast', () {
    for (final brightness in Brightness.values) {
      testWidgets('a selected chip reads against its fill on $brightness', (
        tester,
      ) async {
        await pump(tester, brightness: brightness);
        final scheme = ThemeData(brightness: brightness).colorScheme;
        final chip = tester.widget<FilterChip>(
          find.widgetWithText(FilterChip, 'Manga'),
        );
        // The default pairs a secondary-container fill with an on-surface
        // label, which lands dark on dark under some light schemes.
        expect(chip.selectedColor, scheme.primary);
        expect(chip.labelStyle?.color, scheme.onPrimary);
      });
    }
  });

  group('the preview bar', () {
    for (final brightness in Brightness.values) {
      testWidgets('the current entry reads against the bar on $brightness', (
        tester,
      ) async {
        await pump(tester, brightness: brightness);
        await tester.tap(find.widgetWithText(FilledButton, 'Next'));
        await tester.pumpAndSettle();
        final scheme = ThemeData(brightness: brightness).colorScheme;
        // Bare primary is a pale blue on the light schemes and came out
        // fainter than the entries it was supposed to stand out from.
        final current = tester.widget<Text>(
          find
              .descendant(of: find.byType(Column), matching: find.text('Manga'))
              .first,
        );
        // The label sits on the bar, not on the indicator, so it has to read
        // against the bar's colour.
        expect(current.style?.color, scheme.onSurface);
      });
    }
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

    testWidgets('is the same silhouette, tinted black, on a light theme', (
      tester,
    ) async {
      // The mark is a silhouette, so it vanishes into one background or the
      // other unless the tint is flipped with the theme.
      await pump(tester, brightness: Brightness.light);
      expect(asset(tester), 'assets/app_icons/icon.png');
      expect(logo(tester).color, Colors.black);
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
        find.text('You can add one later in Settings, under Browse.'),
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
        find.text('You can add one later in Settings, under Browse.'),
        findsNothing,
      );
    });
  });
}

class _StubRepoState extends ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) => const [];

  // Without this the real one writes to Isar, throws, and the screen reports
  // the add as failed.
  @override
  void set(List<Repo> value) => state = value;
}

class _StubLocalFolders extends LocalFoldersState {
  @override
  List<LocalFolder> build() => const [];

  @override
  void set(List<LocalFolder> value) => state = value;
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

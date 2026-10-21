import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

ThemeData _theme({ShioriDensity density = ShioriDensity.phone}) =>
    buildShioriTheme(
      brightness: Brightness.dark,
      colors: FlexColor.schemesList[2].dark,
      tintSurfaces: false,
      blendLevel: 10,
      density: density,
    );

Widget _host(
  Widget child, {
  ShioriDensity density = ShioriDensity.phone,
  bool disableAnimations = false,
}) => MaterialApp(
  theme: _theme(density: density),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Scaffold(body: child),
  ),
);

void main() {
  group('ShioriBadge', () {
    testWidgets('draws nothing for zero', (tester) async {
      await tester.pumpWidget(_host(const ShioriBadge(0)));

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('caps large counts', (tester) async {
      await tester.pumpWidget(_host(const ShioriBadge(1200)));

      expect(find.text('999+'), findsOneWidget);
    });

    testWidgets('sits on the accent', (tester) async {
      await tester.pumpWidget(_host(const ShioriBadge(3)));
      final box = tester.widget<DecoratedBox>(
        find.ancestor(of: find.text('3'), matching: find.byType(DecoratedBox)),
      );

      expect(
        (box.decoration as BoxDecoration).color,
        _theme().colorScheme.primary,
      );
    });
  });

  testWidgets('ShioriStatusChip shows its label', (tester) async {
    await tester.pumpWidget(
      _host(
        const ShioriStatusChip(
          kind: ShioriStatusKind.offline,
          label: 'Offline',
          icon: Symbols.cloud_off_rounded,
        ),
      ),
    );

    expect(find.text('Offline'), findsOneWidget);
    expect(find.byIcon(Symbols.cloud_off_rounded), findsOneWidget);
  });

  group('ShioriButton', () {
    testWidgets('a primary button is filled with the accent', (tester) async {
      await tester.pumpWidget(
        _host(ShioriButton(label: 'Resume', onPressed: () {})),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(FilledButton),
          matching: find.byType(Material),
        ),
      );

      expect(material.color, _theme().colorScheme.primary);
    });

    testWidgets('is never smaller than the density allows', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriButton.quiet(label: 'Cancel', onPressed: () {}),
          density: ShioriDensity.tv,
        ),
      );

      expect(
        tester.getSize(find.byType(TextButton)).height,
        greaterThanOrEqualTo(ShioriDensity.tv.minTarget),
      );
    });

    testWidgets('without a callback it is disabled', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriButton(label: 'Resume', onPressed: null)),
      );

      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).enabled,
        isFalse,
      );
    });

    testWidgets('a destructive primary uses the error colour', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriButton(label: 'Delete', destructive: true, onPressed: () {}),
        ),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(FilledButton),
          matching: find.byType(Material),
        ),
      );

      expect(material.color, _theme().colorScheme.error);
    });
  });

  group('ShioriSectionHeader', () {
    testWidgets('is announced as a heading, with its count', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const ShioriSectionHeader(title: 'Chapters', count: 127)),
      );

      expect(find.textContaining('Chapters · 127'), findsOneWidget);
      expect(
        tester.getSemantics(find.textContaining('Chapters · 127')),
        isSemantics(isHeader: true, label: 'Chapters · 127'),
      );
      handle.dispose();
    });

    testWidgets('an overline is written in capitals', (tester) async {
      await tester.pumpWidget(
        _host(
          const ShioriSectionHeader(title: 'Continue reading', overline: true),
        ),
      );

      expect(find.text('CONTINUE READING'), findsOneWidget);
    });

    testWidgets('runs its action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _host(
          ShioriSectionHeader(
            title: 'Updates',
            actionLabel: 'Show all',
            onAction: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('Show all'));

      expect(tapped, isTrue);
    });
  });

  testWidgets('ShioriEmptyState offers the next step', (tester) async {
    var browsed = false;
    await tester.pumpWidget(
      _host(
        ShioriEmptyState(
          icon: Symbols.collections_bookmark_rounded,
          title: 'Your library is empty',
          message: 'Add series from a source to see them here.',
          actionLabel: 'Browse sources',
          onAction: () => browsed = true,
        ),
      ),
    );

    expect(find.text('Your library is empty'), findsOneWidget);
    expect(
      find.text('Add series from a source to see them here.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Browse sources'));
    expect(browsed, isTrue);
  });

  group('ShioriSkeleton', () {
    testWidgets('breathes while animations are allowed', (tester) async {
      await tester.pumpWidget(_host(const ShioriSkeleton.line(width: 80)));

      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('holds still for reduced motion', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriSkeleton.line(width: 80), disableAnimations: true),
      );

      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('a cover placeholder is 2:3', (tester) async {
      await tester.pumpWidget(
        _host(const SizedBox(width: 120, child: ShioriSkeleton.cover())),
      );
      final size = tester.getSize(find.byType(ShioriSkeleton));

      expect(size.width / size.height, closeTo(coverAspect, 0.001));
    });
  });

  group('ShioriToastCard', () {
    testWidgets('is as tall as its content when given the whole screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Align(
            alignment: Alignment.topCenter,
            child: ShioriToastCard(
              message: 'Source is not installed',
              tone: ShioriToastTone.warning,
              actions: [ShioriToastAction('Migrate', () {})],
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(ShioriToastCard)).height,
        lessThan(200),
      );
    });

    testWidgets('shows the message and runs its actions', (tester) async {
      var undone = false;
      await tester.pumpWidget(
        _host(
          ShioriToastCard(
            message: 'Chapter marked as read',
            tone: ShioriToastTone.success,
            actions: [ShioriToastAction('Undo', () => undone = true)],
          ),
        ),
      );

      expect(find.text('Chapter marked as read'), findsOneWidget);
      expect(find.byIcon(Symbols.check_circle_rounded), findsOneWidget);
      await tester.tap(find.text('Undo'));
      expect(undone, isTrue);
    });

    testWidgets('actions are full targets, and a semantic label stays '
        'actionable', (tester) async {
      final handle = tester.ensureSemantics();
      var resolved = false;
      await tester.pumpWidget(
        _host(
          ShioriToastCard(
            message: 'Verification required',
            actions: [
              ShioriToastAction(
                'Resolve',
                () => resolved = true,
                semanticLabel: 'Resolve the verification',
              ),
            ],
          ),
        ),
      );

      final button = find.widgetWithText(TextButton, 'Resolve');
      expect(
        tester.getSize(button).height,
        greaterThanOrEqualTo(ShioriDensity.phone.minTarget),
      );
      final node = find.semantics.byLabel('Resolve the verification');
      expect(node, findsOne);
      tester.semantics.tap(node);
      expect(resolved, isTrue);
      handle.dispose();
    });

    // Carried over from the toast it replaced: on a phone, an action beside
    // the message squeezed a long error down to a couple of characters per
    // line, so actions sit under it instead.
    for (final width in <double>[320, 390, 430]) {
      testWidgets('keeps the message readable at ${width.toInt()} px', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 568);
        addTearDown(tester.view.reset);
        const message = 'Cloudflare verification required (HTTP 403)';
        await tester.pumpWidget(
          _host(
            Align(
              alignment: Alignment.bottomCenter,
              child: ShioriToastCard(
                message: message,
                maxLines: 2,
                tone: ShioriToastTone.warning,
                actions: [ShioriToastAction('Resolve challenge', () {})],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.text(message)).width, greaterThan(150));
        expect(
          tester.getTopLeft(find.text('Resolve challenge')).dy,
          greaterThan(tester.getBottomLeft(find.text(message)).dy),
        );
      });
    }

    testWidgets('fits six lines of guidance on a narrow screen', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);
      const guidance = 'Cloudflare check. Add bypass URL: Settings > General.';
      await tester.pumpWidget(
        _host(
          const Align(
            alignment: Alignment.bottomCenter,
            child: ShioriToastCard(message: guidance),
          ),
        ),
      );

      expect(
        tester
            .renderObject<RenderParagraph>(find.text(guidance))
            .didExceedMaxLines,
        isFalse,
      );
    });

    testWidgets('can go without an icon', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriToastCard(message: 'Saved', showIcon: false)),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('is announced when it appears', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(const ShioriToastCard(message: 'Download finished')),
      );

      expect(
        tester.getSemantics(find.text('Download finished')),
        matchesSemantics(isLiveRegion: true, label: 'Download finished'),
      );
      handle.dispose();
    });
  });

  group('showShioriConfirm', () {
    Future<bool?> open(WidgetTester tester, {String tap = 'Delete'}) async {
      bool? result;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showShioriConfirm(
                context,
                title: 'Delete downloads?',
                message: '12 chapters will be removed from this device.',
                confirmLabel: 'Delete',
                destructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Delete downloads?'), findsOneWidget);
      await tester.tap(find.text(tap));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('confirming resolves to true', (tester) async {
      expect(await open(tester), isTrue);
    });

    testWidgets("cancel is the platform's own label and resolves to false", (
      tester,
    ) async {
      expect(await open(tester, tap: 'Cancel'), isFalse);
    });

    testWidgets('dialogs take the sheet radius', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriDialog(title: 'Rename category')),
      );
      final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));

      expect(
        (dialog.shape! as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(ShioriShape.sheet),
      );
    });
  });

  testWidgets('showShioriSheet opens with its title', (tester) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showShioriSheet<void>(
              context,
              title: 'Filter',
              builder: (_) => const Text('Unread only'),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('Unread only'), findsOneWidget);
  });

  group('ShioriCover', () {
    testWidgets('without an image it shows the title', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 120,
            child: ShioriCover(image: null, title: 'Frieren'),
          ),
        ),
      );

      expect(find.text('Frieren'), findsOneWidget);
      expect(find.byIcon(Symbols.image_rounded), findsOneWidget);
    });

    testWidgets('shows unread, downloaded and progress', (tester) async {
      await tester.pumpWidget(
        _host(
          const SizedBox(
            width: 120,
            child: ShioriCover(
              image: null,
              title: 'Frieren',
              unread: 3,
              downloaded: true,
              progress: 0.5,
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      expect(find.byIcon(Symbols.download_done_rounded), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is FractionallySizedBox && w.widthFactor == 0.5,
        ),
        findsOneWidget,
      );
    });

    testWidgets('is a button named after the series', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 120,
            child: ShioriCover(image: null, title: 'Frieren', onTap: () {}),
          ),
        ),
      );

      expect(find.bySemanticsLabel(RegExp('^Frieren')), findsWidgets);
      handle.dispose();
    });

    testWidgets('a tap runs onTap', (tester) async {
      var opened = false;
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 120,
            child: ShioriCover(
              image: null,
              title: 'Frieren',
              onTap: () => opened = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(ShioriCover));

      expect(opened, isTrue);
    });
  });

  group('ShioriCoverGrid', () {
    Future<int> columns(
      WidgetTester tester,
      double width,
      ShioriDensity d,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _host(const ShioriCoverGrid.skeleton(itemCount: 24), density: d),
      );
      final grid = tester.renderObject<RenderSliverGrid>(
        find.byType(SliverGrid),
      );
      final layout = grid.gridDelegate.getLayout(grid.constraints);
      return (layout as SliverGridRegularTileLayout).crossAxisCount;
    }

    testWidgets('a phone gets three columns', (tester) async {
      expect(await columns(tester, 390, ShioriDensity.phone), 3);
    });

    testWidgets('a wide window gets more', (tester) async {
      expect(
        await columns(tester, 1280, ShioriDensity.desktop),
        greaterThan(6),
      );
    });

    testWidgets('the skeleton draws its placeholders', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriCoverGrid.skeleton(itemCount: 6)),
      );

      expect(find.byType(ShioriSkeleton), findsWidgets);
    });
  });

  testWidgets('ShioriIcon fills when selected', (tester) async {
    await tester.pumpWidget(
      _host(const ShioriIcon(Symbols.home_rounded, selected: true)),
    );

    expect(tester.widget<Icon>(find.byType(Icon)).fill, 1);
  });

  group('ShioriListRow', () {
    testWidgets('shows title and subtitle, and is at least a row tall', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          ShioriListRow(
            title: 'Vagabond',
            subtitle: 'Chapter 327',
            onTap: () => taps++,
          ),
        ),
      );
      expect(find.text('Vagabond'), findsOneWidget);
      expect(find.text('Chapter 327'), findsOneWidget);
      expect(
        tester.getSize(find.byType(ShioriListRow)).height,
        greaterThanOrEqualTo(ShioriDensity.phone.rowHeight),
      );
      await tester.tap(find.text('Vagabond'));
      expect(taps, 1);
    });

    testWidgets('a dimmed row mutes its title', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriListRow(title: 'Read', dimmed: true)),
      );
      final colors = _theme().extension<ShioriTokens>()!.color;
      expect(
        tester.widget<Text>(find.text('Read')).style!.color,
        colors.fgMuted,
      );
    });

    testWidgets('a thumbnail holds 2:3 and has its own target', (tester) async {
      var opened = false;
      await tester.pumpWidget(
        _host(
          Center(
            child: ShioriThumbnail(
              height: 60,
              onTap: () => opened = true,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(ShioriThumbnail)), const Size(40, 60));
      await tester.tap(find.byType(ShioriThumbnail));
      expect(opened, isTrue);
    });
  });

  testWidgets('an overlay label is white on the scrim in any theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const Center(child: ShioriOverlayLabel('3 / 20'))),
    );
    expect(tester.widget<Text>(find.text('3 / 20')).style!.color, Colors.white);
    final box = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('3 / 20'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    expect((box.decoration as BoxDecoration).color, ShioriScrim.underText);
  });

  group('ShioriSegmentedControl', () {
    testWidgets('marks the selected segment and reports a new choice', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      String? picked;
      await tester.pumpWidget(
        _host(
          ShioriSegmentedControl<String>(
            segments: const [
              ShioriSegment(value: 'manga', label: 'Manga'),
              ShioriSegment(value: 'anime', label: 'Anime'),
            ],
            selected: 'manga',
            onSelected: (v) => picked = v,
          ),
        ),
      );
      expect(
        tester.getSemantics(find.text('Manga')),
        isSemantics(isButton: true, isSelected: true, hasSelectedState: true),
      );
      await tester.tap(find.text('Anime'));
      expect(picked, 'anime');
      // Tapping the current one is not a change.
      picked = null;
      await tester.tap(find.text('Manga'));
      expect(picked, isNull);
      handle.dispose();
    });

    testWidgets('each segment is a full target', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriSegmentedControl<int>(
            segments: const [
              ShioriSegment(value: 0, label: 'A'),
              ShioriSegment(value: 1, label: 'B'),
            ],
            selected: 0,
            onSelected: (_) {},
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(ShioriSegmentedControl<int>)).height,
        greaterThanOrEqualTo(ShioriDensity.phone.minTarget),
      );
    });
  });

  group('ShioriProgressBar', () {
    testWidgets('is the accent on ink3, its value clamped', (tester) async {
      await tester.pumpWidget(
        _host(const ShioriProgressBar(value: 1.4, height: 4)),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      final tokens = _theme().extension<ShioriTokens>()!;
      expect(bar.value, 1.0);
      expect(bar.minHeight, 4);
      expect(bar.color, tokens.color.accent);
      expect(bar.backgroundColor, tokens.color.ink3);
    });

    testWidgets('runs on its own without a value', (tester) async {
      await tester.pumpWidget(_host(const ShioriProgressBar()));
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, isNull);
    });
  });

  group('ShioriSegmentedControl badge', () {
    testWidgets('shows a count after the label, and nothing at zero', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          ShioriSegmentedControl<int>(
            segments: const [
              ShioriSegment(value: 0, label: 'Manga'),
              ShioriSegment(value: 1, label: 'Anime', badge: 4),
            ],
            selected: 0,
            onSelected: (_) {},
          ),
        ),
      );

      expect(find.text('4'), findsOneWidget);
      expect(find.byType(ShioriBadge), findsOneWidget);
    });
  });

  group('ShioriTabIndicator', () {
    testWidgets('paints a pill around the current tab', (tester) async {
      await tester.pumpWidget(
        _host(
          const DefaultTabController(
            length: 2,
            child: TabBar(
              tabs: [
                Tab(text: 'Sources'),
                Tab(text: 'Extensions'),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final bar = tester.widget<TabBar>(find.byType(TabBar));
      expect(bar.indicator, isNull);
      expect(
        Theme.of(tester.element(find.byType(TabBar))).tabBarTheme.indicator,
        isA<ShioriTabIndicator>(),
      );
    });
  });

  group('ShioriOverlayPill', () {
    testWidgets('names its value and reacts to a tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          ShioriOverlayPill(
            icon: Symbols.speed_rounded,
            label: '1.5×',
            tooltip: 'Playback speed',
            onTap: () => taps++,
          ),
        ),
      );

      expect(find.text('1.5×'), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Playback speed')),
        matchesSemantics(
          label: 'Playback speed',
          value: '1.5×',
          isButton: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      await tester.tap(find.text('1.5×'));
      expect(taps, 1);
    });

    testWidgets('takes a target of the density size', (tester) async {
      await tester.pumpWidget(
        _host(
          Center(
            child: ShioriOverlayPill(label: 'FR', onTap: () {}),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(InkWell)).height,
        greaterThanOrEqualTo(ShioriDensity.phone.minTarget),
      );
    });

    testWidgets('an emphasized pill sits on the accent', (tester) async {
      await tester.pumpWidget(
        _host(ShioriOverlayPill(label: 'Next', emphasized: true, onTap: () {})),
      );
      final box = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(
        (box.decoration! as BoxDecoration).color,
        _theme().extension<ShioriTokens>()!.color.accent,
      );
    });
  });

  group('ShioriOverlayIconButton', () {
    testWidgets('a disabled button says so and ignores taps', (tester) async {
      await tester.pumpWidget(
        _host(
          const ShioriOverlayIconButton(
            icon: Icon(Symbols.skip_next_rounded),
            tooltip: 'Next episode',
            onPressed: null,
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(ShioriOverlayIconButton)),
        matchesSemantics(
          label: 'Next episode',
          isButton: true,
          hasEnabledState: true,
        ),
      );
    });

    testWidgets('the emphasized one is a disc of twice its glyph', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          Center(
            child: ShioriOverlayIconButton(
              icon: const Icon(Symbols.play_arrow_rounded),
              tooltip: 'Play',
              emphasized: true,
              size: 32,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(AnimatedContainer)),
        const Size(64, 64),
      );
    });
  });

  testWidgets('ShioriGestureGauge reads its level in percent', (tester) async {
    await tester.pumpWidget(
      _host(
        const Center(
          child: ShioriGestureGauge(
            value: 0.42,
            icon: Symbols.volume_up_rounded,
            label: 'Volume',
          ),
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(ShioriGestureGauge)),
      matchesSemantics(label: 'Volume', value: '42 %'),
    );
  });

  testWidgets('ShioriOverlayPanel draws on the panel scrim', (tester) async {
    await tester.pumpWidget(
      _host(const ShioriOverlayPanel(child: Text('12:04'))),
    );
    final box = tester.widget<DecoratedBox>(
      find
          .ancestor(of: find.text('12:04'), matching: find.byType(DecoratedBox))
          .last,
    );

    expect((box.decoration as BoxDecoration).color, ShioriScrim.panel);
  });

  testWidgets('a page transition steps aside under reduced motion', (
    tester,
  ) async {
    const child = SizedBox(key: ValueKey('page'));
    late Widget built;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            built = const ShioriPageTransitionsBuilder().buildTransitions(
              MaterialPageRoute<void>(builder: (_) => child),
              context,
              kAlwaysCompleteAnimation,
              kAlwaysDismissedAnimation,
              child,
            );
            return const SizedBox();
          },
        ),
      ),
    );

    expect(built, same(child));
  });

  group('ShioriFadeThroughStack', () {
    Widget stack(int index, {bool lazy = false}) => _host(
      ShioriFadeThroughStack(
        index: index,
        lazy: lazy,
        children: const [_Counted('a'), _Counted('b')],
      ),
    );

    testWidgets('builds a lazy child only once it is shown', (tester) async {
      _Counted.inits.clear();
      await tester.pumpWidget(stack(0, lazy: true));
      expect(_Counted.inits, ['a']);

      await tester.pumpWidget(stack(1, lazy: true));
      await tester.pumpAndSettle();
      expect(_Counted.inits, ['a', 'b']);
    });

    testWidgets('keeps every child mounted across switches', (tester) async {
      _Counted.inits.clear();
      await tester.pumpWidget(stack(0));
      await tester.pumpWidget(stack(1));
      await tester.pumpAndSettle();
      await tester.pumpWidget(stack(0));
      await tester.pumpAndSettle();
      // Each was created once; going back did not remount the first.
      expect(_Counted.inits, unorderedEquals(['a', 'b']));
      expect(find.text('a', skipOffstage: false), findsOneWidget);
    });

    testWidgets('fades the new child in over the old one, which stays drawn', (
      tester,
    ) async {
      await tester.pumpWidget(stack(0));
      await tester.pumpWidget(stack(1));
      await tester.pump(const Duration(milliseconds: 20));
      double opacityOf(String label) => tester
          .widget<Opacity>(
            find
                .ancestor(
                  of: find.text(label, skipOffstage: false),
                  matching: find.byType(Opacity),
                )
                .first,
          )
          .opacity;
      // Never a moment with neither on screen.
      expect(opacityOf('a'), 1);
      expect(opacityOf('b'), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(opacityOf('b'), 1);
    });
  });
}

class _Counted extends StatefulWidget {
  const _Counted(this.label);

  final String label;
  static final inits = <String>[];

  @override
  State<_Counted> createState() => _CountedState();
}

class _CountedState extends State<_Counted> {
  @override
  void initState() {
    super.initState();
    _Counted.inits.add(widget.label);
  }

  @override
  Widget build(BuildContext context) => Text(widget.label);
}

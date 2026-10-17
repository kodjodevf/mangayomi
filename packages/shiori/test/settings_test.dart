import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

Widget _host(Widget child, {ShioriDensity density = ShioriDensity.phone}) =>
    MaterialApp(
      theme: buildShioriTheme(
        brightness: Brightness.dark,
        colors: FlexColor.schemesList[2].dark,
        tintSurfaces: false,
        blendLevel: 10,
        density: density,
      ),
      home: Scaffold(body: ListView(children: [child])),
    );

const _modes = [
  ShioriChoice('ltr', 'Left to right'),
  ShioriChoice('rtl', 'Right to left'),
  ShioriChoice('webtoon', 'Webtoon', subtitle: 'One long strip'),
];

void main() {
  group('ShioriValueRow', () {
    testWidgets('shows the current value without being opened', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriValueRow<String>(
            title: 'Reading mode',
            value: 'rtl',
            options: _modes,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Reading mode'), findsOneWidget);
      expect(find.text('Right to left'), findsOneWidget);
    });

    testWidgets('picking an option sets it and closes the sheet', (
      tester,
    ) async {
      String? picked;
      await tester.pumpWidget(
        _host(
          ShioriValueRow<String>(
            title: 'Reading mode',
            value: 'rtl',
            options: _modes,
            onChanged: (v) => picked = v,
          ),
        ),
      );

      await tester.tap(find.text('Reading mode'));
      await tester.pumpAndSettle();
      // The current option is checked; the others are not.
      expect(find.byIcon(Symbols.check_rounded), findsOneWidget);
      expect(find.text('One long strip'), findsOneWidget);

      await tester.tap(find.text('Webtoon'));
      await tester.pumpAndSettle();

      expect(picked, 'webtoon');
      expect(find.text('One long strip'), findsNothing);
    });

    testWidgets('dismissing the sheet changes nothing', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        _host(
          ShioriValueRow<String>(
            title: 'Reading mode',
            value: 'rtl',
            options: _modes,
            onChanged: (_) => calls++,
          ),
        ),
      );

      await tester.tap(find.text('Reading mode'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('picking the current option again is not a change', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        _host(
          ShioriValueRow<String>(
            title: 'Reading mode',
            value: 'rtl',
            options: _modes,
            onChanged: (_) => calls++,
          ),
        ),
      );

      await tester.tap(find.text('Reading mode'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Right to left').last);
      await tester.pumpAndSettle();

      expect(calls, 0);
    });

    testWidgets('without onChanged it is disabled', (tester) async {
      await tester.pumpWidget(
        _host(
          const ShioriValueRow<String>(
            title: 'Reading mode',
            value: 'rtl',
            options: _modes,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.text('Reading mode'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
    });
  });

  testWidgets('showShioriChoice narrows a long list by its search field', (
    tester,
  ) async {
    String? picked;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => picked = await showShioriChoice<String>(
              context,
              title: 'Font',
              searchHint: 'Search',
              options: [
                for (final name in ['Inter', 'Lora', 'Noto Sans', 'Noto Serif'])
                  ShioriChoice(name, name),
              ],
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'noto');
    await tester.pump();

    expect(find.text('Inter'), findsNothing);
    expect(find.text('Noto Serif'), findsOneWidget);

    await tester.tap(find.text('Noto Serif'));
    await tester.pumpAndSettle();

    expect(picked, 'Noto Serif');
  });

  testWidgets('showShioriMultiChoice returns what is checked on confirm', (
    tester,
  ) async {
    Set<String>? result;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showShioriMultiChoice(
              context,
              title: 'Languages',
              options: const [
                ShioriChoice('en', 'English'),
                ShioriChoice('fr', 'French'),
                ShioriChoice('ja', 'Japanese'),
              ],
              selected: {'en'},
              confirmLabel: 'Done',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.tap(find.text('Japanese'));
    await tester.pump();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(result, {'ja'});
  });

  testWidgets('ShioriSwitchRow toggles from anywhere on the row', (
    tester,
  ) async {
    bool? value;
    await tester.pumpWidget(
      _host(
        ShioriSwitchRow(
          title: 'Keep screen on',
          subtitle: 'While reading',
          value: false,
          onChanged: (v) => value = v,
        ),
      ),
    );

    await tester.tap(find.text('While reading'));

    expect(value, isTrue);
  });

  testWidgets('on TV the switch is larger and the row its one stop', (
    tester,
  ) async {
    bool? value;
    await tester.pumpWidget(
      _host(
        Column(
          children: [
            ShioriSwitchRow(
              title: 'Keep screen on',
              value: false,
              onChanged: (v) => value = v,
            ),
            TextButton(onPressed: () {}, child: const Text('Next')),
          ],
        ),
        density: ShioriDensity.tv,
      ),
    );

    final scale = tester.widget<Transform>(
      find
          .ancestor(of: find.byType(Switch), matching: find.byType(Transform))
          .first,
    );
    expect(
      scale.transform.getMaxScaleOnAxis(),
      closeTo(ShioriDensity.tv.typeScale, 0.001),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(value, isTrue);

    // One focus stop: the next Tab goes past the switch to the button.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(focused.findAncestorWidgetOfExactType<TextButton>(), isNotNull);
  });

  group('ShioriSliderRow', () {
    testWidgets('shows its value in the row', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriSliderRow(
            title: 'Speed',
            value: 1.5,
            min: 0.5,
            max: 3,
            valueLabel: (v) => '${v}x',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('1.5x'), findsOneWidget);
    });

    testWidgets('offers a reset only away from the default', (tester) async {
      var resets = 0;
      Widget row(double value) => _host(
        ShioriSliderRow(
          title: 'Speed',
          value: value,
          min: 0.5,
          max: 3,
          onChanged: (_) {},
          defaultValue: 1,
          onReset: () => resets++,
          resetTooltip: 'Reset',
        ),
      );

      await tester.pumpWidget(row(1));
      expect(find.byTooltip('Reset'), findsNothing);

      await tester.pumpWidget(row(2));
      await tester.tap(find.byTooltip('Reset'));

      expect(resets, 1);
    });
  });

  testWidgets('ShioriSliderRow steps with the remote on TV and lets go', (
    tester,
  ) async {
    var value = 5.0;
    await tester.pumpWidget(
      _host(
        Column(
          children: [
            StatefulBuilder(
              builder: (context, setState) => ShioriSliderRow(
                title: 'Preload',
                value: value,
                min: 1,
                max: 20,
                divisions: 19,
                onChanged: (v) => setState(() => value = v),
              ),
            ),
            ShioriSettingRow(title: 'Next', onTap: () {}),
          ],
        ),
        density: ShioriDensity.tv,
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(value, 7);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(
      find.ancestor(
        of: find.byWidget(focused.widget),
        matching: find.widgetWithText(ListTile, 'Next'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('ShioriSliderRow steps one division with − and +', (
    tester,
  ) async {
    var value = 16.0;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) => ShioriSliderRow(
            title: 'Font size',
            value: value,
            min: 8,
            max: 40,
            divisions: 32,
            stepTooltips: ('Smaller', 'Larger'),
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Larger'));
    await tester.pump();
    await tester.tap(find.byTooltip('Larger'));
    await tester.pump();
    await tester.tap(find.byTooltip('Smaller'));
    await tester.pump();

    expect(value, 17);
  });

  group('showShioriPrompt', () {
    /// Opens the prompt; the returned function reads what it resolved to.
    Future<String? Function()> open(
      WidgetTester tester, {
      String initial = '',
      String? Function(String)? validator,
    }) async {
      String? result;
      await tester.pumpWidget(
        _host(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showShioriPrompt(
                context,
                title: 'Rename',
                confirmLabel: 'Save',
                initialValue: initial,
                validator: validator,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return () => result;
    }

    ShioriButton save(WidgetTester tester) =>
        tester.widget<ShioriButton>(find.widgetWithText(ShioriButton, 'Save'));

    testWidgets('cannot save an empty name', (tester) async {
      await open(tester);

      expect(save(tester).onPressed, isNull);

      await tester.enterText(find.byType(TextField), 'Shelf');
      await tester.pump();

      expect(save(tester).onPressed, isNotNull);
    });

    testWidgets('shows the validator error and keeps the dialog', (
      tester,
    ) async {
      await open(
        tester,
        validator: (t) => t == 'Default' ? 'Already exists' : null,
      );
      await tester.enterText(find.byType(TextField), 'Default');
      await tester.pump();

      expect(find.text('Already exists'), findsOneWidget);
      expect(save(tester).onPressed, isNull);
    });

    testWidgets('Enter confirms with the text', (tester) async {
      final result = await open(tester, initial: 'Old');
      await tester.enterText(find.byType(TextField), 'New');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(result(), 'New');
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('Cancel resolves to null', (tester) async {
      final result = await open(tester, initial: 'Old');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result(), isNull);
      expect(find.byType(TextField), findsNothing);
    });
  });

  group('ShioriMenuButton', () {
    testWidgets('runs the item picked and closes', (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(
        _host(
          Align(
            alignment: Alignment.topRight,
            child: ShioriMenuButton(
              tooltip: 'More',
              items: [
                ShioriMenuItem(
                  label: 'Refresh',
                  icon: Symbols.refresh_rounded,
                  onSelected: () => refreshed++,
                ),
                null,
                ShioriMenuItem(
                  label: 'Delete',
                  destructive: true,
                  onSelected: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      expect(find.byType(Divider), findsOneWidget);

      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();

      expect(refreshed, 1);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('drops dividers that separate nothing', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriMenuButton(
            tooltip: 'More',
            items: [
              null,
              ShioriMenuItem(label: 'Share', onSelected: () {}),
              null,
              null,
              ShioriMenuItem(label: 'Migrate', onSelected: () {}),
              null,
            ],
          ),
        ),
      );

      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('lines labels up when only some entries have icons', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          ShioriMenuButton(
            tooltip: 'More',
            items: [
              ShioriMenuItem(
                label: 'Refresh',
                icon: Symbols.refresh_rounded,
                onSelected: () {},
              ),
              ShioriMenuItem(label: 'Downloaded only', onSelected: () {}),
            ],
          ),
        ),
      );

      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Downloaded only')).dx,
        tester.getTopLeft(find.text('Refresh')).dx,
      );
    });

    testWidgets('marks the checked item', (tester) async {
      await tester.pumpWidget(
        _host(
          ShioriMenuButton(
            tooltip: 'Sort',
            items: [
              ShioriMenuItem(label: 'A–Z', checked: true, onSelected: () {}),
              ShioriMenuItem(
                label: 'Newest',
                checked: false,
                onSelected: () {},
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byTooltip('Sort'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.check_rounded), findsOneWidget);
    });

    testWidgets('opens and picks from the keyboard', (tester) async {
      var picked = 0;
      await tester.pumpWidget(
        _host(
          ShioriMenuButton(
            tooltip: 'More',
            items: [
              ShioriMenuItem(label: 'Refresh', onSelected: () => picked++),
            ],
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Refresh'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(picked, 1);
    });
  });

  testWidgets('ShioriSettingsGroup labels its rows as a header', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const ShioriSettingsGroup(
          title: 'Downloads',
          footer: 'Only over Wi-Fi.',
          children: [ShioriSettingRow(title: 'Location')],
        ),
      ),
    );

    expect(find.text('DOWNLOADS'), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('DOWNLOADS'),
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.header ?? false),
        ),
      ),
      findsOneWidget,
    );
    expect(find.text('Only over Wi-Fi.'), findsOneWidget);
  });

  testWidgets('rows are taller on TV', (tester) async {
    await tester.pumpWidget(
      _host(
        const ShioriSettingRow(title: 'Location'),
        density: ShioriDensity.tv,
      ),
    );

    expect(
      tester.getSize(find.byType(ListTile)).height,
      greaterThanOrEqualTo(ShioriDensity.tv.rowHeight),
    );
  });

  testWidgets('row icons grow with the text on TV', (tester) async {
    await tester.pumpWidget(
      _host(
        const ShioriSettingRow(title: 'Location', icon: Symbols.folder_rounded),
        density: ShioriDensity.tv,
      ),
    );

    expect(
      tester.getSize(find.byIcon(Symbols.folder_rounded)).width,
      closeTo(24 * ShioriDensity.tv.typeScale, 0.01),
    );
  });

  testWidgets('ShioriLoading says what it waits for', (tester) async {
    await tester.pumpWidget(_host(const ShioriLoading(label: 'Restoring…')));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Restoring…'), findsOneWidget);
  });
}

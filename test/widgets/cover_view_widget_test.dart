import 'dart:typed_data';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:shiori/shiori.dart';

// A 1×1 transparent PNG, so the cover takes its image branch without a
// network.
final _pixel = MemoryImage(
  Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]),
);

final _theme = buildShioriTheme(
  brightness: Brightness.dark,
  colors: FlexColor.schemesList[2].dark,
  tintSurfaces: false,
  blendLevel: 10,
  density: ShioriDensity.phone,
);

Widget _host(Widget child) => MaterialApp(
  theme: _theme,
  home: Scaffold(
    body: Center(child: SizedBox(width: 120, height: 180, child: child)),
  ),
);

void main() {
  testWidgets('a selected cover is veiled in the accent and checked', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        CoverViewWidget(
          image: _pixel,
          isLongPressed: true,
          onTap: () {},
          children: const [],
        ),
      ),
    );
    expect(find.byIcon(Symbols.check_circle_rounded), findsOneWidget);
    final veil = tester.widget<ColoredBox>(
      find
          .ancestor(
            of: find.byIcon(Symbols.check_circle_rounded),
            matching: find.byType(ColoredBox),
          )
          .first,
    );
    final accent = _theme.extension<ShioriTokens>()!.color.accent;
    expect(veil.color, accent.withValues(alpha: Alphas.secondary));
  });

  testWidgets('an unselected cover shows no check', (tester) async {
    await tester.pumpWidget(
      _host(
        CoverViewWidget(
          image: _pixel,
          isLongPressed: false,
          onTap: () {},
          children: const [],
        ),
      ),
    );
    expect(find.byIcon(Symbols.check_circle_rounded), findsNothing);
  });

  testWidgets('progress draws a track as wide as the progress', (tester) async {
    await tester.pumpWidget(
      _host(
        CoverViewWidget(
          image: _pixel,
          progress: 0.25,
          onTap: () {},
          children: const [],
        ),
      ),
    );
    final bar = find.byType(FractionallySizedBox);
    expect(bar, findsOneWidget);
    expect(tester.widget<FractionallySizedBox>(bar).widthFactor, 0.25);
  });

  testWidgets('the cover is clipped to the cover radius', (tester) async {
    await tester.pumpWidget(
      _host(CoverViewWidget(image: _pixel, onTap: () {}, children: const [])),
    );
    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CoverViewWidget),
        matching: find.byType(Material),
      ),
    );
    expect(material.borderRadius, BorderRadius.circular(ShioriShape.cover));
  });

  testWidgets('taps reach the callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        CoverViewWidget(image: _pixel, onTap: () => taps++, children: const []),
      ),
    );
    await tester.tap(find.byType(InkWell));
    expect(taps, 1);
  });

  testWidgets('a title over the cover is white on a scrim, in any theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(Stack(children: const [BottomTextWidget(text: 'Vagabond')])),
    );
    final text = tester.widget<Text>(find.text('Vagabond'));
    expect(text.style!.color, Colors.white);
    expect(text.style!.fontFamily, shioriFontFamily);
  });

  testWidgets('a title under the cover takes the foreground colour', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const BottomTextWidget(text: 'Vagabond', isComfortableGrid: true)),
    );
    final text = tester.widget<Text>(find.text('Vagabond'));
    expect(text.style!.color, _theme.extension<ShioriTokens>()!.color.fg);
  });

  testWidgets('a toned badge chip takes its status colours', (tester) async {
    final unread = _theme.extension<ShioriTokens>()!.color.unread;
    await tester.pumpWidget(_host(EntryBadgeChip(label: '12', tone: unread)));
    final box = tester.widget<Container>(
      find.ancestor(of: find.text('12'), matching: find.byType(Container)),
    );
    expect((box.decoration! as BoxDecoration).color, unread.background);
    expect(
      tester.widget<Text>(find.text('12')).style!.color,
      unread.foreground,
    );
  });
}

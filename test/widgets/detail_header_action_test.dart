import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_header_action.dart';
import 'package:mangayomi/modules/widgets/cover_hero.dart';
import 'package:shiori/shiori.dart';

final _theme = buildShioriTheme(
  brightness: Brightness.light,
  colors: FlexColor.schemesList[2].light,
  tintSurfaces: false,
  blendLevel: 10,
  density: ShioriDensity.phone,
);

Widget _host(Widget child) => MaterialApp(
  theme: _theme,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  final colors = _theme.extension<ShioriTokens>()!.color;

  testWidgets('an active action is the legible accent, its icon filled', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        DetailHeaderAction(
          icon: Symbols.favorite_rounded,
          label: 'In library',
          active: true,
          onPressed: () {},
        ),
      ),
    );
    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, colors.accentInk);
    expect(icon.fill, 1);
    expect(
      tester.widget<Text>(find.text('In library')).style!.color,
      colors.accentInk,
    );
  });

  testWidgets('an inactive action is muted, and a full target', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        DetailHeaderAction(
          icon: Symbols.favorite_rounded,
          label: 'Add to library',
          onPressed: () => taps++,
        ),
      ),
    );
    expect(tester.widget<Icon>(find.byType(Icon)).color, colors.fgMuted);
    expect(
      tester.getSize(find.byType(InkWell)).height,
      greaterThanOrEqualTo(ShioriDensity.phone.minTarget),
    );
    await tester.tap(find.text('Add to library'));
    expect(taps, 1);
  });

  test('both ends of the cover flight agree on the tag', () {
    expect(coverHeroTag(7), coverHeroTag(7));
    expect(coverHeroTag(7), isNot(coverHeroTag(8)));
  });
}

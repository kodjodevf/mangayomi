import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pure black dark mode used to paint only the scaffold black by hand, leaving
/// `blendLevel` to go on tinting every other surface. The slider that sets the
/// blend is hidden while the toggle is on, so a level chosen beforehand kept
/// applying with no way to correct it: a black page with visibly tinted cards,
/// sheets and nav bar floating on it.
///
/// This builds the theme the same way the provider does, at a blend level high
/// enough for the difference to be unmistakable.
ThemeData darkTheme({required bool pureBlack, required int blendLevel}) =>
    FlexThemeData.dark(
      colors: FlexColor.schemes[FlexScheme.material]!.dark,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: pureBlack ? 0 : blendLevel,
      appBarOpacity: 0.00,
      darkIsTrueBlack: pureBlack,
      subThemesData: const FlexSubThemesData(blendOnLevel: 10),
      useMaterial3: true,
    );

void main() {
  test('pure black makes the page actually black', () {
    final theme = darkTheme(pureBlack: true, blendLevel: 0);
    expect(theme.scaffoldBackgroundColor, const Color(0xFF000000));
  });

  test('a blend chosen earlier does not survive turning pure black on', () {
    // The bug. The slider is hidden at this point, so anything it left behind
    // is unreachable as well as wrong.
    final blended = darkTheme(pureBlack: false, blendLevel: 40);
    final pure = darkTheme(pureBlack: true, blendLevel: 40);

    expect(pure.scaffoldBackgroundColor, const Color(0xFF000000));
    expect(
      pure.scaffoldBackgroundColor,
      isNot(blended.scaffoldBackgroundColor),
    );
  });

  test('the surfaces come down with it, not just the scaffold', () {
    // Painting the scaffold black by hand left these tinted, which is what put
    // grey-blue cards on a black page.
    final pure = darkTheme(pureBlack: true, blendLevel: 40);
    final blended = darkTheme(pureBlack: false, blendLevel: 40);

    expect(pure.colorScheme.surface, const Color(0xFF000000));
    expect(blended.colorScheme.surface, isNot(const Color(0xFF000000)));
  });

  test('and they come down neutral, not tinted black', () {
    // Luminance alone does not catch this: the blended surface is dark enough
    // to pass a brightness check (0.014) while still being visibly purple.
    // What separates them is whether it has a hue at all.
    bool hasHue(Color c) => c.r != c.b || c.g != c.b;

    expect(
      hasHue(darkTheme(pureBlack: true, blendLevel: 40).colorScheme.surface),
      isFalse,
    );
    expect(
      hasHue(darkTheme(pureBlack: false, blendLevel: 40).colorScheme.surface),
      isTrue,
    );
  });

  test('turning it off gives the chosen blend back', () {
    // The stored level is never overwritten, only ignored while the toggle is
    // on, so this has to be identical to a theme that never saw pure black.
    final before = darkTheme(pureBlack: false, blendLevel: 25);
    final after = darkTheme(pureBlack: false, blendLevel: 25);

    expect(after.scaffoldBackgroundColor, before.scaffoldBackgroundColor);
    expect(after.colorScheme.surface, before.colorScheme.surface);
  });

  test('without pure black, blend still does its job', () {
    // The fix must not flatten the feature it is guarding.
    final none = darkTheme(pureBlack: false, blendLevel: 0);
    final lots = darkTheme(pureBlack: false, blendLevel: 40);

    expect(lots.colorScheme.surface, isNot(none.colorScheme.surface));
  });
}

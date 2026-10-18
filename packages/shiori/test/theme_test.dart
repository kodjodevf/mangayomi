import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

ThemeData build(
  Brightness brightness, {
  bool tint = false,
  bool pureBlack = false,
  int blendLevel = 10,
  FlexSchemeData? scheme,
  ShioriDensity density = ShioriDensity.phone,
}) {
  final data = scheme ?? FlexColor.schemesList[2];
  return buildShioriTheme(
    brightness: brightness,
    colors: brightness == Brightness.light ? data.light : data.dark,
    tintSurfaces: tint,
    blendLevel: blendLevel,
    density: density,
    pureBlack: pureBlack,
  );
}

/// WCAG relative contrast between two opaque colours.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  group('neutral surfaces, the default', () {
    for (final brightness in Brightness.values) {
      test('${brightness.name}: every surface role is the neutral ramp', () {
        final theme = build(brightness);
        final n = ShioriNeutrals.of(brightness);
        final cs = theme.colorScheme;

        expect(theme.scaffoldBackgroundColor, n.ground);
        expect(cs.surface, n.ground);
        expect(cs.surfaceContainer, n.base);
        expect(cs.surfaceContainerHigh, n.high);
        expect(cs.surfaceContainerHighest, n.highest);
        expect(cs.onSurface, n.fg);
        expect(cs.onSurfaceVariant, n.fgMuted);
      });

      test('${brightness.name}: the palette still drives the accent', () {
        final data = FlexColor.schemesList[2];
        final palette = brightness == Brightness.light ? data.light : data.dark;

        expect(build(brightness).colorScheme.primary, palette.primary);
      });

      test(
        '${brightness.name}: the blend level no longer changes anything',
        () {
          expect(
            build(brightness, blendLevel: 40).colorScheme.surfaceContainer,
            build(brightness, blendLevel: 0).colorScheme.surfaceContainer,
          );
        },
      );
    }

    test('two palettes share the same surfaces', () {
      final blue = build(Brightness.dark, scheme: FlexColor.schemesList[2]);
      final red = build(Brightness.dark, scheme: FlexColor.schemesList[0]);

      expect(
        blue.colorScheme.surfaceContainer,
        red.colorScheme.surfaceContainer,
      );
      expect(blue.colorScheme.primary, isNot(red.colorScheme.primary));
    });

    test('pure black takes the ground to black', () {
      final theme = build(Brightness.dark, pureBlack: true);

      expect(theme.scaffoldBackgroundColor, const Color(0xFF000000));
      expect(theme.colorScheme.surface, const Color(0xFF000000));
    });

    test('pure black does nothing to the light theme', () {
      expect(
        build(Brightness.light, pureBlack: true).scaffoldBackgroundColor,
        ShioriNeutrals.light.ground,
      );
    });
  });

  group('tinted surfaces, the opt-in', () {
    test('surfaces follow the palette again', () {
      final tinted = build(Brightness.dark, tint: true, blendLevel: 30);

      expect(
        tinted.colorScheme.surfaceContainer,
        isNot(ShioriNeutrals.dark.base),
      );
    });

    test('the blend level matters again', () {
      expect(
        build(
          Brightness.dark,
          tint: true,
          blendLevel: 40,
        ).scaffoldBackgroundColor,
        isNot(
          build(
            Brightness.dark,
            tint: true,
            blendLevel: 0,
          ).scaffoldBackgroundColor,
        ),
      );
    });
  });

  group('every theme carries the tokens', () {
    for (final tint in [false, true]) {
      for (final brightness in Brightness.values) {
        test('${brightness.name}, tinted: $tint', () {
          final theme = build(brightness, tint: tint);
          final tokens = theme.extension<ShioriTokens>();

          expect(tokens, isNotNull);
          expect(tokens!.color.ink0, theme.scaffoldBackgroundColor);
          expect(tokens.color.accent, theme.colorScheme.primary);
          expect(theme.textTheme.bodyMedium?.fontFamily, shioriFontFamily);
        });
      }
    }

    test('density scales the type', () {
      final phone = build(Brightness.dark).extension<ShioriTokens>()!;
      final tv = build(
        Brightness.dark,
        density: ShioriDensity.tv,
      ).extension<ShioriTokens>()!;

      expect(tv.text.body.fontSize, greaterThan(phone.text.body.fontSize!));
    });
  });

  group('contrast', () {
    for (final (name, neutrals) in [
      ('light', ShioriNeutrals.light),
      ('dark', ShioriNeutrals.dark),
      ('pure black', ShioriNeutrals.pureBlack),
    ]) {
      test('$name: text reads on every surface it sits on', () {
        for (final surface in [neutrals.ground, neutrals.base, neutrals.high]) {
          expect(contrast(neutrals.fg, surface), greaterThanOrEqualTo(7));
          expect(
            contrast(neutrals.fgMuted, surface),
            greaterThanOrEqualTo(4.5),
            reason: 'secondary text is still body text, so AA applies',
          );
        }
      });
    }

    test('the label on an accent fill is legible on every palette', () {
      // Black or white, whichever contrasts more with the fill, never falls
      // below 4.58:1, so even small text on an accent clears AA.
      for (final scheme in FlexColor.schemesList) {
        for (final brightness in Brightness.values) {
          final accent = build(brightness, scheme: scheme).colorScheme.primary;
          expect(
            contrast(ShioriColors.onFill(accent), accent),
            greaterThanOrEqualTo(4.5),
            reason: '${scheme.name} ${brightness.name}',
          );
        }
      }
    });

    test('every status pair reads, in both brightnesses', () {
      for (final brightness in Brightness.values) {
        final c = build(brightness).extension<ShioriTokens>()!.color;
        for (final (name, s) in [
          ('offline', c.offline),
          ('completed', c.completed),
          ('newChapter', c.newChapter),
          ('error', c.error),
          ('downloaded', c.downloaded),
        ]) {
          expect(
            contrast(s.foreground, s.background),
            greaterThanOrEqualTo(4.5),
            reason: '$name ${brightness.name}',
          );
        }
      }
    });
  });

  group('shapes come from the tokens', () {
    for (final tint in [false, true]) {
      test('tinted: $tint', () {
        final theme = build(Brightness.dark, tint: tint);

        expect(
          (theme.dialogTheme.shape as RoundedRectangleBorder).borderRadius,
          BorderRadius.circular(ShioriShape.sheet),
        );
        expect(
          (theme.bottomSheetTheme.shape as RoundedRectangleBorder).borderRadius,
          const BorderRadius.vertical(top: Radius.circular(ShioriShape.sheet)),
        );
        // FlexColorScheme leaves the card shape to Material when the radius
        // asked for is Material 3's own default, which is Shiori's too.
        expect(theme.cardTheme.shape, isNull);
        expect(ShioriShape.card, 12);
      });
    }
  });

  testWidgets('a theme Shiori did not build still yields tokens', (
    tester,
  ) async {
    late ShioriTokens tokens;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Builder(
          builder: (context) {
            tokens = context.shiori;
            return const SizedBox();
          },
        ),
      ),
    );
    final scheme = ThemeData(brightness: Brightness.dark).colorScheme;
    expect(tokens.color.accent, scheme.primary);
    expect(tokens.color.fg, scheme.onSurface);
    expect(tokens.density, ShioriDensity.phone);
  });

  group('rows and named styles', () {
    test('list tiles take the type scale and the density', () {
      for (final density in ShioriDensity.values) {
        final theme = build(Brightness.dark, density: density);
        final tokens = theme.extension<ShioriTokens>()!;
        expect(theme.listTileTheme.minTileHeight, density.rowHeight);
        expect(
          theme.listTileTheme.subtitleTextStyle!.color,
          tokens.color.fgMuted,
        );
        expect(
          theme.listTileTheme.titleTextStyle!.fontSize,
          tokens.text.body.fontSize,
        );
      }
    });

    test('caption is muted meta, groupLabel is the accent overline', () {
      final tokens = build(Brightness.light).extension<ShioriTokens>()!;
      expect(tokens.caption.fontSize, tokens.text.meta.fontSize);
      expect(tokens.caption.color, tokens.color.fgMuted);
      expect(tokens.groupLabel.color, tokens.color.accentInk);
      expect(tokens.groupLabel.fontSize, tokens.text.overline.fontSize);
    });

    test('a divider is a hairline', () {
      final theme = build(Brightness.dark);
      final tokens = theme.extension<ShioriTokens>()!;
      expect(theme.dividerTheme.color, tokens.color.hairline);
      expect(theme.dividerTheme.thickness, 0.5);
      expect(theme.dividerColor, tokens.color.hairline);
    });

    test('pages move on Shiori\'s axis, Apple keeps Cupertino\'s', () {
      final builders = build(Brightness.dark).pageTransitionsTheme.builders;
      for (final platform in TargetPlatform.values) {
        final apple =
            platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
        expect(
          builders[platform],
          apple
              ? isA<CupertinoPageTransitionsBuilder>()
              : isA<ShioriPageTransitionsBuilder>(),
        );
      }
    });

    test('tabs mark the current one with an accent pill', () {
      final theme = build(Brightness.dark);
      final tokens = theme.extension<ShioriTokens>()!;
      expect(theme.tabBarTheme.labelColor, tokens.color.accentInk);
      expect(theme.tabBarTheme.unselectedLabelColor, tokens.color.fgMuted);
      expect(theme.tabBarTheme.dividerColor, Colors.transparent);
      final indicator = theme.tabBarTheme.indicator! as ShioriTabIndicator;
      expect(
        indicator.color,
        tokens.color.accent.withValues(alpha: Alphas.accentTint),
      );
    });
  });

  test('Material text roles take Shiori sizes, scaled by the density', () {
    for (final density in ShioriDensity.values) {
      final theme = build(Brightness.dark, density: density);
      final t = theme.extension<ShioriTokens>()!.text;
      expect(theme.textTheme.bodyLarge!.fontSize, t.body.fontSize);
      expect(theme.textTheme.bodySmall!.fontSize, t.meta.fontSize);
      expect(theme.textTheme.headlineSmall!.fontSize, t.seriesTitle.fontSize);
      expect(theme.appBarTheme.titleTextStyle!.fontSize, t.section.fontSize);
      expect(theme.textTheme.bodyLarge!.fontFamily, shioriFontFamily);
    }
  });

  group('the accent as a word', () {
    for (final brightness in Brightness.values) {
      test('${brightness.name}: accentInk reads at 4.5:1 on the ground, '
          'on every palette', () {
        final failures = <String>[];
        for (final scheme in FlexColor.schemesList) {
          for (final tint in [false, true]) {
            final c = build(
              brightness,
              scheme: scheme,
              tint: tint,
            ).extension<ShioriTokens>()!.color;
            final ratio = contrast(c.accentInk, c.ink0);
            if (ratio < 4.5) {
              failures.add('${scheme.name} (tint $tint): $ratio');
            }
          }
        }
        expect(failures, isEmpty);
      });
    }

    test('an accent that already reads is left alone', () {
      const deep = Color(0xFF1A3A8F);
      expect(ShioriColors.legibleOn(deep, const Color(0xFFFFFFFF)), deep);
    });
  });

  test('the reference scale is the scale with no density', () {
    final phone = build(Brightness.dark).extension<ShioriTokens>()!.text;
    expect(ShioriType.reference.body.fontSize, phone.body.fontSize);
    final tv = build(
      Brightness.dark,
      density: ShioriDensity.tv,
    ).extension<ShioriTokens>()!.text;
    expect(tv.body.fontSize, greaterThan(ShioriType.reference.body.fontSize!));
  });
}

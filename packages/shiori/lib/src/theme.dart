import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

/// The sub-theme settings both brightnesses share.
///
/// Shapes come from [ShioriShape], so every Material dialog, sheet, card,
/// menu and field in the app takes Shiori's radii without its screen being
/// touched. Tinting the surfaces changes colour only, never shape.
const _subThemes = FlexSubThemesData(
  blendOnLevel: 10,
  thinBorderWidth: 2.0,
  unselectedToggleIsColored: true,
  inputDecoratorRadius: ShioriShape.card,
  // Material chips are filters and choices, which Shiori draws as pills.
  chipRadius: ShioriShape.pill,
  cardRadius: ShioriShape.card,
  popupMenuRadius: ShioriShape.card,
  menuRadius: ShioriShape.card,
  tooltipRadius: ShioriShape.badge,
  snackBarRadius: ShioriShape.card,
  dialogRadius: ShioriShape.sheet,
  datePickerDialogRadius: ShioriShape.sheet,
  timePickerDialogRadius: ShioriShape.sheet,
  bottomSheetRadius: ShioriShape.sheet,
);

/// Builds the app's theme for one brightness.
///
/// [colors] is the user's palette. With [tintSurfaces] off, the Shiori
/// default, it only drives the accent roles and every surface comes from
/// [ShioriNeutrals]; [blendLevel] then has nothing to blend and is ignored.
/// With it on, the palette colours the surfaces too, at [blendLevel], as the
/// app did before Shiori.
///
/// Either way the theme is set in [shioriFontFamily] and carries
/// [ShioriTokens], so `context.shiori` always works.
ThemeData buildShioriTheme({
  required Brightness brightness,
  required FlexSchemeColor colors,
  required bool tintSurfaces,
  required int blendLevel,
  required ShioriDensity density,
  bool pureBlack = false,
}) {
  final light = brightness == Brightness.light;
  final pure = !light && pureBlack;

  if (tintSurfaces) {
    final theme = light
        ? FlexThemeData.light(
            colors: colors,
            surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
            blendLevel: blendLevel,
            appBarOpacity: 0.00,
            subThemesData: _subThemes,
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            fontFamily: shioriFontFamily,
          )
        : FlexThemeData.dark(
            colors: colors,
            surfaceMode: FlexSurfaceMode.level,
            // Pure black means pure black: a blend chosen beforehand would
            // otherwise go on tinting every surface that is not the
            // scaffold. The stored level is left alone, so turning pure
            // black off restores it.
            blendLevel: pure ? 0 : blendLevel,
            appBarOpacity: 0.00,
            darkIsTrueBlack: pure,
            subThemesData: _subThemes,
            useMaterial3ErrorColors: true,
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            fontFamily: shioriFontFamily,
          );
    return _withTokens(theme, density);
  }

  final neutrals = ShioriNeutrals.of(brightness, pureBlack: pure);
  // The palette's full Material 3 scheme, so primary, secondary, tertiary
  // and their containers are exactly what the palette produces; only the
  // surface roles are swapped for the neutral ramp.
  final paletteScheme = light
      ? FlexColorScheme.light(
          colors: colors,
          useMaterial3: true,
          useMaterial3ErrorColors: true,
        ).toScheme
      : FlexColorScheme.dark(
          colors: colors,
          useMaterial3: true,
          useMaterial3ErrorColors: true,
        ).toScheme;
  final scheme = neutrals.applyTo(paletteScheme);

  final theme = light
      ? FlexThemeData.light(
          colorScheme: scheme,
          blendLevel: 0,
          scaffoldBackground: neutrals.ground,
          appBarOpacity: 0.00,
          subThemesData: _subThemes,
          useMaterial3ErrorColors: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: shioriFontFamily,
        )
      : FlexThemeData.dark(
          colorScheme: scheme,
          blendLevel: 0,
          scaffoldBackground: neutrals.ground,
          appBarOpacity: 0.00,
          subThemesData: _subThemes,
          useMaterial3ErrorColors: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: shioriFontFamily,
        );
  return _withTokens(theme, density);
}

ThemeData _withTokens(ThemeData theme, ShioriDensity density) {
  final colors = ShioriColors.fromScheme(
    theme.colorScheme,
    ground: theme.scaffoldBackgroundColor,
  );
  final text = ShioriType.scaled(density.typeScale);
  return theme.copyWith(
    textTheme: _materialTextTheme(theme.textTheme, text),
    // App bars title a screen in the section size: the screen's own large
    // title, where it has one, is set in the content.
    // A rule between rows is a hairline, as everywhere Shiori draws one;
    // Material's default is a full-strength outline.
    dividerColor: colors.hairline,
    dividerTheme: DividerThemeData(color: colors.hairline, thickness: 0.5),
    appBarTheme: theme.appBarTheme.copyWith(
      titleTextStyle: text.section.copyWith(color: colors.fg),
    ),
    // A floating action is the screen's main one: the accent, as a primary
    // button, read on it with onAccent and round as a pill. Material's own
    // primary container drew it a darker shade than every other button.
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.accent,
      foregroundColor: colors.onAccent,
      extendedTextStyle: text.row.copyWith(fontWeight: FontWeight.w700),
      shape: const StadiumBorder(),
    ),
    // Tabs read as a quiet row of labels: the current one in the foreground
    // with an accent pill under it, the rest muted, and no full-width rule.
    tabBarTheme: TabBarThemeData(
      labelColor: colors.fg,
      unselectedLabelColor: colors.fgMuted,
      labelStyle: text.row.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: text.row,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      indicator: UnderlineTabIndicator(
        borderRadius: BorderRadius.circular(ShioriShape.pill),
        borderSide: BorderSide(color: colors.accent, width: 3),
      ),
    ),
    // Rows, the bulk of every settings screen: a title in the body size, a
    // muted caption under it, icons that step back from the text.
    listTileTheme: ListTileThemeData(
      titleTextStyle: text.body.copyWith(
        color: colors.fg,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      subtitleTextStyle: text.meta.copyWith(color: colors.fgMuted),
      leadingAndTrailingTextStyle: text.meta.copyWith(color: colors.fgMuted),
      iconColor: colors.fgMuted,
      selectedColor: colors.accentInk,
      minTileHeight: density.rowHeight,
      contentPadding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
    ),
    extensions: [
      ...theme.extensions.values,
      ShioriTokens(color: colors, density: density),
    ],
  );
}

/// Material's text roles mapped onto Shiori's scale, so a widget that still
/// asks for `titleMedium` or `bodySmall` gets a Shiori size and weight. Only
/// size, weight, height and tracking move; colour stays the theme's.
TextTheme _materialTextTheme(TextTheme base, ShioriType t) {
  TextStyle? onto(TextStyle? style, TextStyle role, {FontWeight? weight}) =>
      style?.copyWith(
        fontSize: role.fontSize,
        fontWeight: weight ?? role.fontWeight,
        height: role.height,
        letterSpacing: role.letterSpacing,
      );
  return base.copyWith(
    headlineLarge: onto(base.headlineLarge, t.screenTitle),
    headlineMedium: onto(base.headlineMedium, t.screenTitle),
    headlineSmall: onto(base.headlineSmall, t.seriesTitle),
    titleLarge: onto(base.titleLarge, t.seriesTitle, weight: FontWeight.w700),
    titleMedium: onto(base.titleMedium, t.section, weight: FontWeight.w600),
    titleSmall: onto(base.titleSmall, t.row),
    bodyLarge: onto(base.bodyLarge, t.body),
    bodyMedium: onto(base.bodyMedium, t.row, weight: FontWeight.w400),
    bodySmall: onto(base.bodySmall, t.meta, weight: FontWeight.w400),
    labelLarge: onto(base.labelLarge, t.row, weight: FontWeight.w600),
    labelMedium: onto(base.labelMedium, t.meta),
    labelSmall: onto(base.labelSmall, t.badge, weight: FontWeight.w600),
  );
}

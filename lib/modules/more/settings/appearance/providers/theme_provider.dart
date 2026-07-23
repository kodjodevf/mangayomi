import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'blend_level_state_provider.dart';
import 'flex_scheme_color_state_provider.dart';
import 'pure_black_dark_mode_state_provider.dart';
import 'app_font_family.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Material draws a focused InkWell's highlight from the ambient
/// [ThemeData.focusColor], and the default is nearly invisible on a TV
/// across a room. Tinting it with the scheme's primary makes every focusable
/// built on an InkResponse legible with a remote: popup menu buttons and
/// their items, list tiles, icon buttons. Off-TV the theme is untouched.
ThemeData _tvFocus(ThemeData theme) => isTv
    ? theme.copyWith(
        focusColor: theme.colorScheme.primary.withValues(alpha: 0.45),
      )
    : theme;

/// Provides the light theme for the app, recomputed only when
/// flex scheme colors, blend level, or font family change.
final lightThemeProvider = Provider<ThemeData>((ref) {
  final colors = ref.watch(flexSchemeColorStateProvider);
  final blendLevel = ref.watch(blendLevelStateProvider).toInt();
  final fontFamily = ref.watch(appFontFamilyProvider);

  return _tvFocus(
    FlexThemeData.light(
      colors: colors,
      surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
      blendLevel: blendLevel,
      appBarOpacity: 0.00,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        thinBorderWidth: 2.0,
        unselectedToggleIsColored: true,
        inputDecoratorRadius: 24.0,
        chipRadius: 24.0,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: fontFamily,
    ),
  );
});

/// Provides the dark theme for the app, recomputed only when
/// flex scheme colors, blend level, font family, or pure-black toggle change.
final darkThemeProvider = Provider<ThemeData>((ref) {
  final colors = ref.watch(flexSchemeColorStateProvider);
  final blendLevel = ref.watch(blendLevelStateProvider).toInt();
  final fontFamily = ref.watch(appFontFamilyProvider);
  final pureBlack = ref.watch(pureBlackDarkModeStateProvider);

  return _tvFocus(
    FlexThemeData.dark(
      colors: colors,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: blendLevel,
      appBarOpacity: 0.00,
      scaffoldBackground: pureBlack ? Colors.black : null,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        thinBorderWidth: 2.0,
        unselectedToggleIsColored: true,
        inputDecoratorRadius: 24.0,
        chipRadius: 24.0,
      ),
      useMaterial3ErrorColors: true,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: fontFamily,
    ),
  );
});

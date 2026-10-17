import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blend_level_state_provider.dart';
import 'flex_scheme_color_state_provider.dart';
import 'pure_black_dark_mode_state_provider.dart';
import 'tint_surfaces_state_provider.dart';

import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Material draws a focused InkWell's highlight from the ambient
/// [ThemeData.focusColor], and the default is nearly invisible on a TV
/// across a room. Tinting it with the scheme's primary makes every focusable
/// built on an InkResponse legible with a remote: popup menu buttons and
/// their items, list tiles, icon buttons. Off-TV the theme is untouched.
ThemeData _tvFocus(ThemeData theme) {
  if (!isTv) return theme;
  // A focused button drew only a faint focusColor overlay, which is invisible on
  // a filled button (e.g. a dialog's Add/OK) — you can't tell it is focused.
  // Add a high-contrast ring on the focused state so any button reads clearly on
  // a TV, filled or not. Buttons that carry no border otherwise (Text/Elevated/
  // Filled) get the ring only while focused.
  final ring = WidgetStateProperty.resolveWith<BorderSide?>(
    (states) => states.contains(WidgetState.focused)
        ? BorderSide(color: theme.colorScheme.onSurface, width: 2.5)
        : null,
  );
  ButtonStyle withRing(ButtonStyle? base) =>
      (base ?? const ButtonStyle()).copyWith(side: ring);
  return theme.copyWith(
    focusColor: theme.colorScheme.primary.withValues(alpha: Alphas.tvFocus),
    textButtonTheme: TextButtonThemeData(
      style: withRing(theme.textButtonTheme.style),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: withRing(theme.elevatedButtonTheme.style),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: withRing(theme.filledButtonTheme.style),
    ),
  );
}

/// The density the interface is laid out for on this device.
ShioriDensity get _density => isTv
    ? ShioriDensity.tv
    : isDesktop
    ? ShioriDensity.desktop
    : ShioriDensity.phone;

/// Provides the light theme for the app, recomputed only when the palette,
/// the blend level or the surface tint change.
final lightThemeProvider = Provider<ThemeData>((ref) {
  final schemeIndex = ref.watch(
    flexSchemeColorStateProvider.select((theme) => theme.$2),
  );
  return _tvFocus(
    buildShioriTheme(
      brightness: Brightness.light,
      colors: ThemeAA.schemes[schemeIndex].light,
      tintSurfaces: ref.watch(tintSurfacesStateProvider),
      blendLevel: ref.watch(blendLevelStateProvider).toInt(),
      density: _density,
    ),
  );
});

/// Provides the dark theme for the app, recomputed only when the palette,
/// the blend level, the surface tint or the pure-black toggle change.
final darkThemeProvider = Provider<ThemeData>((ref) {
  final schemeIndex = ref.watch(
    flexSchemeColorStateProvider.select((theme) => theme.$2),
  );
  return _tvFocus(
    buildShioriTheme(
      brightness: Brightness.dark,
      colors: ThemeAA.schemes[schemeIndex].dark,
      tintSurfaces: ref.watch(tintSurfacesStateProvider),
      blendLevel: ref.watch(blendLevelStateProvider).toInt(),
      density: _density,
      pureBlack: ref.watch(pureBlackDarkModeStateProvider),
    ),
  );
});

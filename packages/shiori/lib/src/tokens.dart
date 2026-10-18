// Shiori, the design system the interface is written against. The contract,
// and the reasoning behind each value, is docs/design/DESIGN.md in the app.
//
// Two kinds of token live here. Constants that never change with the theme
// (spacing, shape, motion) are plain static values, usable in const
// contexts. Values that depend on the theme or the device (colour, type,
// density) travel in [ShioriTokens], a ThemeExtension read with
// `context.shiori`.
import 'package:flutter/material.dart';

import 'alphas.dart';

/// The face the whole interface is set in. Bundled with this package, so it
/// renders the same on every platform and needs no network. Scripts it does
/// not cover (CJK, Arabic, Devanagari, Bengali, Thai) fall back to the
/// platform's fonts.
///
/// A font declared by a package is registered under `packages/<name>/`.
const String shioriFontFamily = 'packages/shiori/Figtree';

/// The neutral ramp Shiori puts under the content: an ink that is slightly
/// blue, so it reads as chosen rather than as an inherited grey.
///
/// The user's palette never reaches these unless they ask for tinted
/// surfaces, which is what lets their contrast be checked once instead of
/// against every palette in the catalogue.
@immutable
class ShioriNeutrals {
  const ShioriNeutrals({
    required this.lowest,
    required this.ground,
    required this.low,
    required this.base,
    required this.high,
    required this.highest,
    required this.dim,
    required this.bright,
    required this.fg,
    required this.fgMuted,
    required this.outline,
    required this.outlineVariant,
    required this.inverse,
    required this.onInverse,
  });

  final Color lowest;

  /// Page ground: the scaffold.
  final Color ground;
  final Color low;

  /// Lists, sheets, cards.
  final Color base;

  /// Fields, secondary buttons, anything raised off [base].
  final Color high;
  final Color highest;
  final Color dim;
  final Color bright;

  /// Primary text and icons.
  final Color fg;

  /// Secondary text: metadata, captions, inactive icons.
  final Color fgMuted;
  final Color outline;
  final Color outlineVariant;
  final Color inverse;
  final Color onInverse;

  /// A cool paper, never pure white or a cream.
  static const light = ShioriNeutrals(
    lowest: Color(0xFFFFFFFF),
    ground: Color(0xFFF6F6F9),
    low: Color(0xFFF1F1F6),
    base: Color(0xFFECECF2),
    high: Color(0xFFE5E6EE),
    highest: Color(0xFFDEDFE8),
    dim: Color(0xFFD9DAE3),
    bright: Color(0xFFFFFFFF),
    fg: Color(0xFF15161D),
    fgMuted: Color(0xFF4B4D5C),
    outline: Color(0xFF777A8C),
    outlineVariant: Color(0xFFC6C8D4),
    inverse: Color(0xFF2A2B36),
    onInverse: Color(0xFFF1F1F6),
  );

  /// Ink. The default dark ground.
  static const dark = ShioriNeutrals(
    lowest: Color(0xFF0A0B10),
    ground: Color(0xFF0F1016),
    low: Color(0xFF14151D),
    base: Color(0xFF171823),
    high: Color(0xFF20212F),
    highest: Color(0xFF292A3A),
    dim: Color(0xFF0F1016),
    bright: Color(0xFF2E3042),
    fg: Color(0xFFECEDF5),
    fgMuted: Color(0xFFA3A5B8),
    outline: Color(0xFF6E7084),
    outlineVariant: Color(0xFF34364A),
    inverse: Color(0xFFECEDF5),
    onInverse: Color(0xFF171823),
  );

  /// Pure black ground, for OLED screens. Everything raised off it keeps the
  /// same steps as [dark], one notch lower.
  static const pureBlack = ShioriNeutrals(
    lowest: Color(0xFF000000),
    ground: Color(0xFF000000),
    low: Color(0xFF0A0A0F),
    base: Color(0xFF111118),
    high: Color(0xFF1A1B24),
    highest: Color(0xFF23242F),
    dim: Color(0xFF000000),
    bright: Color(0xFF26283A),
    fg: Color(0xFFECEDF5),
    fgMuted: Color(0xFFA3A5B8),
    outline: Color(0xFF6E7084),
    outlineVariant: Color(0xFF2C2E3F),
    inverse: Color(0xFFECEDF5),
    onInverse: Color(0xFF111118),
  );

  static ShioriNeutrals of(Brightness brightness, {bool pureBlack = false}) =>
      brightness == Brightness.light
      ? light
      : (pureBlack ? ShioriNeutrals.pureBlack : dark);

  /// [scheme] with its surface roles replaced by this ramp. Every other role
  /// (primary, secondary, tertiary, error and their containers) is kept, so
  /// the user's palette still drives the accent.
  ColorScheme applyTo(ColorScheme scheme) => scheme.copyWith(
    surface: ground,
    onSurface: fg,
    onSurfaceVariant: fgMuted,
    surfaceDim: dim,
    surfaceBright: bright,
    surfaceContainerLowest: lowest,
    surfaceContainerLow: low,
    surfaceContainer: base,
    surfaceContainerHigh: high,
    surfaceContainerHighest: highest,
    outline: outline,
    outlineVariant: outlineVariant,
    inverseSurface: inverse,
    onInverseSurface: onInverse,
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    // Material tints raised surfaces with the primary; Shiori separates them
    // by tone instead, so nothing may tint them back.
    surfaceTint: const Color(0x00000000),
  );
}

/// A status as a pair: the fill it sits on and the colour drawn on it.
@immutable
class ShioriStatus {
  const ShioriStatus(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static ShioriStatus lerp(ShioriStatus a, ShioriStatus b, double t) =>
      ShioriStatus(
        Color.lerp(a.background, b.background, t)!,
        Color.lerp(a.foreground, b.foreground, t)!,
      );
}

/// Colour roles. Read these, never `Colors.*` or a hex literal.
@immutable
class ShioriColors {
  const ShioriColors({
    required this.ink0,
    required this.ink1,
    required this.ink2,
    required this.ink3,
    required this.fg,
    required this.fgMuted,
    required this.hairline,
    required this.accent,
    required this.accentInk,
    required this.onAccent,
    required this.unread,
    required this.downloaded,
    required this.offline,
    required this.completed,
    required this.read,
    required this.newChapter,
    required this.error,
  });

  /// Page ground.
  final Color ink0;

  /// Lists, sheets, cards.
  final Color ink1;

  /// Fields, secondary buttons.
  final Color ink2;

  /// The highest raised surface: menus, the selected row.
  final Color ink3;
  final Color fg;
  final Color fgMuted;

  /// Rules and connectors.
  final Color hairline;

  /// The one brand signal, taken from the user's palette. For fills: a
  /// selection, an indicator, a button. Text and icons in the accent take
  /// [accentInk].
  final Color accent;

  /// The accent as text or an icon on the page: the palette's own colour,
  /// moved towards the foreground just far enough to read at 4.5:1 on
  /// [ink0]. A pale accent in light mode or a deep one in dark mode reads
  /// as a fill and fails as a word; this keeps the hue and fixes the word.
  final Color accentInk;

  /// Text and icons on an [accent] fill.
  final Color onAccent;

  // The app's subject matter, which had no names before Shiori. Fixed per
  // brightness, independent of the accent, so "offline" means the same
  // thing on every palette.
  final ShioriStatus unread;
  final ShioriStatus downloaded;
  final ShioriStatus offline;
  final ShioriStatus completed;
  final ShioriStatus read;
  final ShioriStatus newChapter;
  final ShioriStatus error;

  /// The label colour for a fill: whichever of black and white contrasts
  /// more with the fill itself, never chosen by the theme's brightness. A
  /// palette's accent can be pale in dark mode or deep in light mode, and
  /// white on pale blue is the bug this rule was written for.
  ///
  /// The crossover sits at a luminance of about 0.18, not 0.5: a threshold at
  /// 0.5 put white on mid tones at 2.6:1. Comparing both always clears 4.5:1.
  static Color onFill(Color fill) {
    final l = fill.computeLuminance();
    final onBlack = (l + 0.05) / 0.05;
    final onWhite = 1.05 / (l + 0.05);
    return onBlack >= onWhite
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
  }

  /// [accent], moved towards black or white (whichever the ground is not)
  /// until it reaches [target] contrast on [ground]. Returned as is when it
  /// already does.
  static Color legibleOn(Color accent, Color ground, {double target = 4.5}) {
    double ratio(Color c) {
      final a = c.computeLuminance(), b = ground.computeLuminance();
      return (a > b ? a + 0.05 : b + 0.05) / (a > b ? b + 0.05 : a + 0.05);
    }

    if (ratio(accent) >= target) return accent;
    final toward = ground.computeLuminance() > 0.18
        ? const Color(0xFF000000)
        : const Color(0xFFFFFFFF);
    // The smallest step that reads: the hue stays as close to the palette's
    // as legibility allows.
    for (var t = 0.05; t < 1; t += 0.05) {
      final c = Color.lerp(accent, toward, t)!;
      if (ratio(c) >= target) return c;
    }
    return toward;
  }

  /// Roles for a finished [ColorScheme], whether its surfaces are Shiori's
  /// neutrals or tinted by the palette.
  factory ShioriColors.fromScheme(ColorScheme scheme, {Color? ground}) {
    final dark = scheme.brightness == Brightness.dark;
    final accent = scheme.primary;
    final ink0 = ground ?? scheme.surface;
    return ShioriColors(
      ink0: ink0,
      ink1: scheme.surfaceContainer,
      ink2: scheme.surfaceContainerHigh,
      ink3: scheme.surfaceContainerHighest,
      fg: scheme.onSurface,
      fgMuted: scheme.onSurfaceVariant,
      hairline: scheme.onSurface.withValues(alpha: Alphas.hairline),
      accent: accent,
      accentInk: legibleOn(accent, ink0),
      onAccent: onFill(accent),
      unread: ShioriStatus(accent, onFill(accent)),
      downloaded: ShioriStatus(scheme.surfaceContainerHigh, scheme.onSurface),
      read: ShioriStatus(scheme.surfaceContainerHigh, scheme.onSurfaceVariant),
      offline: dark
          ? const ShioriStatus(Color(0xFF3A2F12), Color(0xFFF0BD5D))
          : const ShioriStatus(Color(0xFFFBEFD5), Color(0xFF7A5200)),
      completed: dark
          ? const ShioriStatus(Color(0xFF13301F), Color(0xFF6FD3A0))
          : const ShioriStatus(Color(0xFFDDF3E6), Color(0xFF1F6B44)),
      newChapter: dark
          ? const ShioriStatus(Color(0xFF2E1830), Color(0xFFE7A6F0))
          : const ShioriStatus(Color(0xFFF6E3F8), Color(0xFF7E2D8C)),
      error: dark
          ? const ShioriStatus(Color(0xFF3B1714), Color(0xFFFFB4AB))
          : const ShioriStatus(Color(0xFFFCE4E1), Color(0xFFA3261B)),
    );
  }

  static ShioriColors lerp(ShioriColors a, ShioriColors b, double t) =>
      ShioriColors(
        ink0: Color.lerp(a.ink0, b.ink0, t)!,
        ink1: Color.lerp(a.ink1, b.ink1, t)!,
        ink2: Color.lerp(a.ink2, b.ink2, t)!,
        ink3: Color.lerp(a.ink3, b.ink3, t)!,
        fg: Color.lerp(a.fg, b.fg, t)!,
        fgMuted: Color.lerp(a.fgMuted, b.fgMuted, t)!,
        hairline: Color.lerp(a.hairline, b.hairline, t)!,
        accent: Color.lerp(a.accent, b.accent, t)!,
        accentInk: Color.lerp(a.accentInk, b.accentInk, t)!,
        onAccent: Color.lerp(a.onAccent, b.onAccent, t)!,
        unread: ShioriStatus.lerp(a.unread, b.unread, t),
        downloaded: ShioriStatus.lerp(a.downloaded, b.downloaded, t),
        offline: ShioriStatus.lerp(a.offline, b.offline, t),
        completed: ShioriStatus.lerp(a.completed, b.completed, t),
        read: ShioriStatus.lerp(a.read, b.read, t),
        newChapter: ShioriStatus.lerp(a.newChapter, b.newChapter, t),
        error: ShioriStatus.lerp(a.error, b.error, t),
      );
}

/// The type scale: nine roles, one face. Weight carries hierarchy as much as
/// size does. Styles carry no colour; they inherit it, or the caller passes
/// a [ShioriColors] role.
@immutable
class ShioriType {
  const ShioriType._({
    required this.screenTitle,
    required this.seriesTitle,
    required this.section,
    required this.card,
    required this.body,
    required this.row,
    required this.meta,
    required this.badge,
    required this.overline,
  });

  /// The scale at [ShioriDensity.typeScale].
  factory ShioriType.scaled(double scale) {
    TextStyle s(
      double size,
      FontWeight weight, {
      double tracking = 0,
      double? height,
      bool tabular = false,
    }) => TextStyle(
      fontFamily: shioriFontFamily,
      fontSize: size * scale,
      fontWeight: weight,
      letterSpacing: tracking * size * scale,
      height: height,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
    return ShioriType._(
      screenTitle: s(28, FontWeight.w800, tracking: -0.02),
      seriesTitle: s(22, FontWeight.w800, tracking: -0.015),
      section: s(17, FontWeight.w700),
      card: s(14, FontWeight.w600),
      body: s(15, FontWeight.w400, height: 1.45),
      row: s(14, FontWeight.w500),
      meta: s(12, FontWeight.w500, tabular: true),
      badge: s(11, FontWeight.w800, tabular: true),
      overline: s(11, FontWeight.w700, tracking: 0.12),
    );
  }

  /// A screen's own title.
  final TextStyle screenTitle;

  /// A series or episode title on its detail page.
  final TextStyle seriesTitle;

  /// A section heading inside a screen.
  final TextStyle section;

  /// A title under a cover, or on a card.
  final TextStyle card;

  /// Running text: synopses, descriptions, dialogs.
  final TextStyle body;

  /// The main line of a list row.
  final TextStyle row;

  /// Dates, counts, sources: secondary metadata. Figures are tabular.
  final TextStyle meta;

  /// A count in a filled pill. Figures are tabular.
  final TextStyle badge;

  /// A small label above a group. Write the text in capitals.
  final TextStyle overline;

  /// The scale at its reference size, with no density applied: for layouts
  /// that something else already sizes for their screen. The TV screens are
  /// laid out at AppUiScale's 1280 px reference and stretched to the panel,
  /// so they take these sizes as they are; the TV density's 1.33 is for the
  /// phone layouts shown on a TV.
  static final ShioriType reference = ShioriType.scaled(1);

  static ShioriType lerp(ShioriType a, ShioriType b, double t) => ShioriType._(
    screenTitle: TextStyle.lerp(a.screenTitle, b.screenTitle, t)!,
    seriesTitle: TextStyle.lerp(a.seriesTitle, b.seriesTitle, t)!,
    section: TextStyle.lerp(a.section, b.section, t)!,
    card: TextStyle.lerp(a.card, b.card, t)!,
    body: TextStyle.lerp(a.body, b.body, t)!,
    row: TextStyle.lerp(a.row, b.row, t)!,
    meta: TextStyle.lerp(a.meta, b.meta, t)!,
    badge: TextStyle.lerp(a.badge, b.badge, t)!,
    overline: TextStyle.lerp(a.overline, b.overline, t)!,
  );
}

/// Spacing on a 4 point grid. Every padding and gap is one of these.
abstract final class ShioriSpace {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
}

/// Corner radii, one per role.
abstract final class ShioriShape {
  /// Pills and badges.
  static const double badge = 4;

  /// Covers: rounded without losing the look of a book.
  static const double cover = 6;

  /// Cards and text fields.
  static const double card = 12;

  /// Sheets and dialogs.
  static const double sheet = 20;

  /// Buttons and navigation: fully round at any height.
  static const double pill = 999;
}

/// Motion: four durations and the curve each one moves on.
abstract final class ShioriMotion {
  /// State changes: press, hover, focus, toggles.
  static const Duration fast = Duration(milliseconds: 120);

  /// Something moving within the screen: a pill, a tab indicator.
  static const Duration standard = Duration(milliseconds: 220);

  /// Something arriving: sheets, dialogs, routes, the shared cover.
  static const Duration enter = Duration(milliseconds: 350);

  /// Something stepping back: the reader's chrome, the shrinking bar.
  static const Duration exitSlow = Duration(milliseconds: 500);

  /// One cycle of a looping, ambient movement: a skeleton breathing. Not a
  /// transition, so it never runs on the curves below.
  static const Duration ambient = Duration(milliseconds: 1100);

  static const Curve standardCurve = Cubic(0.2, 0, 0, 1);
  static const Curve enterCurve = Cubic(0.05, 0.7, 0.1, 1);
  static const Curve exitCurve = Cubic(0.3, 0, 0.8, 0.15);

  /// [duration], or nothing when the platform asks for reduced motion.
  static Duration of(BuildContext context, Duration duration) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false
      ? Duration.zero
      : duration;
}

/// Fixed darkening for things drawn over a cover, a page or a video, whose
/// colours are unknown: it is the image, not the theme, that the overlay has
/// to stand out from.
abstract final class ShioriScrim {
  /// Behind a thin mark on an image, such as a progress track.
  static const Color onImage = Color(0x66000000);

  /// The shadow under something floating over the content.
  static const Color shadow = Color(0x66000000);

  /// The foot of the gradient that carries a title over a cover.
  static const Color underText = Color(0x99000000);

  /// The ground of a panel of controls floating over a picture, such as the
  /// video player's: dark enough for white text on a white frame, light
  /// enough to keep the picture there.
  static const Color panel = Color(0xC7000000);
}

/// The three ways the interface is used, and how big things get for each.
enum ShioriDensity {
  /// Touch, at arm's length.
  phone(minTarget: 48, rowHeight: 56, typeScale: 1),

  /// Mouse and keyboard, closer and more precise.
  desktop(minTarget: 36, rowHeight: 44, typeScale: 0.94),

  /// A remote, from across the room.
  tv(minTarget: 56, rowHeight: 64, typeScale: 1.33);

  const ShioriDensity({
    required this.minTarget,
    required this.rowHeight,
    required this.typeScale,
  });

  /// The smallest a tap or focus target may be.
  final double minTarget;

  /// The height of a standard list row.
  final double rowHeight;

  /// Multiplier on every [ShioriType] size.
  final double typeScale;
}

/// Everything theme dependent, carried by the theme. Read it with
/// `context.shiori`.
@immutable
class ShioriTokens extends ThemeExtension<ShioriTokens> {
  ShioriTokens({required this.color, required this.density})
    : text = ShioriType.scaled(density.typeScale);

  const ShioriTokens._(this.color, this.text, this.density);

  final ShioriColors color;

  /// The type scale. Not called `type`: ThemeExtension already has a `type`,
  /// the key the theme files the extension under.
  final ShioriType text;
  final ShioriDensity density;

  @override
  ShioriTokens copyWith({ShioriColors? color, ShioriDensity? density}) =>
      ShioriTokens._(
        color ?? this.color,
        density == null ? text : ShioriType.scaled(density.typeScale),
        density ?? this.density,
      );

  @override
  ShioriTokens lerp(covariant ShioriTokens? other, double t) {
    if (other == null) return this;
    return ShioriTokens._(
      ShioriColors.lerp(color, other.color, t),
      ShioriType.lerp(text, other.text, t),
      t < 0.5 ? density : other.density,
    );
  }

  /// Scales a length that is not a [ShioriType] size, such as an icon, with
  /// the density.
  double scaled(double value) => value * density.typeScale;

  /// The muted line under a row's title: a description, a count, a date.
  TextStyle get caption => text.meta.copyWith(color: color.fgMuted);

  /// The title of a group: a group of settings, a language in a list of
  /// sources, a day in the history. Small capitals in the accent, so the eye
  /// can find its way down a long screen; [ShioriGroupLabel] sets it in
  /// capitals.
  TextStyle get groupLabel => text.overline.copyWith(color: color.accentInk);
}

extension ShioriContext on BuildContext {
  /// The Shiori tokens of the ambient theme.
  ///
  /// A theme Shiori didn't build (a bare MaterialApp in a test, a widget
  /// shown above the app's theme) gets tokens derived from its colour scheme
  /// at phone density, so a component still draws instead of throwing.
  ShioriTokens get shiori {
    final theme = Theme.of(this);
    return theme.extension<ShioriTokens>() ??
        ShioriTokens(
          color: ShioriColors.fromScheme(theme.colorScheme),
          density: ShioriDensity.phone,
        );
  }
}

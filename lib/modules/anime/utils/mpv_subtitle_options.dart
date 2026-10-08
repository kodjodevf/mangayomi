import 'package:mangayomi/models/settings.dart';

/// An ARGB colour as the `#AARRGGBB` string mpv's colour options take.
String toMpvColor(int a, int r, int g, int b) {
  final hex =
      ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
  return '#${hex.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

/// The libass subtitle style the user picked, as mpv properties. Applied
/// once at player creation and again whenever the settings change.
Map<String, String> mpvSubtitleStyle(PlayerSubtitleSettings settings) {
  final overrideAss = settings.overrideAssSubtitles ?? false;
  return {
    "sub-font-size": "${settings.fontSize ?? 45}",
    "sub-bold": (settings.useBold ?? true) ? "yes" : "no",
    "sub-italic": (settings.useItalic ?? false) ? "yes" : "no",
    "sub-color": toMpvColor(
      settings.textColorA ?? 255,
      settings.textColorR ?? 255,
      settings.textColorG ?? 255,
      settings.textColorB ?? 255,
    ),
    "sub-border-color": toMpvColor(
      settings.borderColorA ?? 255,
      settings.borderColorR ?? 0,
      settings.borderColorG ?? 0,
      settings.borderColorB ?? 0,
    ),
    "sub-back-color": toMpvColor(
      settings.backgroundColorA ?? 0,
      settings.backgroundColorR ?? 0,
      settings.backgroundColorG ?? 0,
      settings.backgroundColorB ?? 0,
    ),
    "sub-ass-override": overrideAss ? "force" : "scale",
    if (overrideAss) "sub-ass-justify": "yes",
  };
}

/// [mpvSubtitleStyle] plus the fixed layout options, for the player's
/// initial configuration.
Map<String, String> mpvInitialSubtitleOptions(
  PlayerSubtitleSettings settings,
) => {
  ...mpvSubtitleStyle(settings),
  "sub-border-size": "3",
  "sub-shadow-offset": "0",
  "sub-pos": "100",
  "sub-scale": "1.0",
};

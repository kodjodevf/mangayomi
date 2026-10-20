import 'package:flutter/widgets.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/widgets/keyboard_shortcuts_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// What a video player shortcut does.
enum PlayerShortcut {
  playPause,
  seekBackShort,
  seekForwardShort,
  seekBackLong,
  seekForwardLong,
  skipIntro,
  previousFrame,
  nextFrame,
  volumeUp,
  volumeDown,
  mute,
  previousEpisode,
  nextEpisode,
  fullScreen,
  exitFullScreen,
  shaders,
  shadersOff,
  showShortcuts,
}

/// The seconds the arrow keys seek; J and L seek [playerLongSeekSeconds].
const playerShortSeekSeconds = 5;
const playerLongSeekSeconds = 10;

/// The desktop player's shortcuts with their keys, in the order the list
/// shows them. The Anime4K keys only do something with the mpv config on,
/// so they are listed only then ([shaders]). The keys are the user's
/// [bindings], but for the fixed ones.
List<(PlayerShortcut, List<String>)> playerShortcutKeys({
  bool shaders = false,
  KeyBindings bindings = defaultKeyBindings,
}) => [
  for (final shortcut in PlayerShortcut.values)
    if (_fixedKeys[shortcut] case final keys?) ...[
      if (shaders || !_shaderShortcuts.contains(shortcut)) (shortcut, keys),
    ] else
      (shortcut, keyLabels(bindings[shortcut]!)),
];

const _fixedKeys = {
  PlayerShortcut.previousFrame: [','],
  PlayerShortcut.nextFrame: ['.'],
  PlayerShortcut.shaders: ['Ctrl 1–6'],
  PlayerShortcut.shadersOff: ['Ctrl 0'],
  PlayerShortcut.showShortcuts: ['?', 'F1'],
};

const _shaderShortcuts = {PlayerShortcut.shaders, PlayerShortcut.shadersOff};

String playerShortcutLabel(
  PlayerShortcut shortcut,
  AppLocalizations l10n, {
  required int skipIntroSeconds,
}) => switch (shortcut) {
  PlayerShortcut.playPause => l10n.shortcut_play_pause,
  PlayerShortcut.seekBackShort => l10n.shortcut_seek_back(
    playerShortSeekSeconds,
  ),
  PlayerShortcut.seekForwardShort => l10n.shortcut_seek_forward(
    playerShortSeekSeconds,
  ),
  PlayerShortcut.seekBackLong => l10n.shortcut_seek_back(playerLongSeekSeconds),
  PlayerShortcut.seekForwardLong => l10n.shortcut_seek_forward(
    playerLongSeekSeconds,
  ),
  PlayerShortcut.skipIntro => l10n.shortcut_skip_intro(skipIntroSeconds),
  PlayerShortcut.previousFrame => l10n.shortcut_previous_frame,
  PlayerShortcut.nextFrame => l10n.shortcut_next_frame,
  PlayerShortcut.volumeUp => l10n.shortcut_volume_up,
  PlayerShortcut.volumeDown => l10n.shortcut_volume_down,
  PlayerShortcut.mute => l10n.shortcut_mute,
  PlayerShortcut.previousEpisode => l10n.previous_episode,
  PlayerShortcut.nextEpisode => l10n.next_episode,
  PlayerShortcut.fullScreen => l10n.fullscreen,
  PlayerShortcut.exitFullScreen => l10n.exit_fullscreen,
  PlayerShortcut.shaders => l10n.shortcut_shaders,
  PlayerShortcut.shadersOff => l10n.shortcut_shaders_off,
  PlayerShortcut.showShortcuts => l10n.shortcut_show,
};

/// Lists the desktop player's keyboard shortcuts in a dialog.
Future<void> showPlayerShortcuts(
  BuildContext context, {
  required int skipIntroSeconds,
  bool shaders = false,
  KeyBindings bindings = defaultKeyBindings,
}) {
  final l10n = context.l10n;
  return showKeyboardShortcuts(context, [
    for (final (shortcut, keys) in playerShortcutKeys(
      shaders: shaders,
      bindings: bindings,
    ))
      (
        playerShortcutLabel(shortcut, l10n, skipIntroSeconds: skipIntroSeconds),
        keys,
      ),
  ]);
}

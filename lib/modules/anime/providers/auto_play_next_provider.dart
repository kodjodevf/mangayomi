import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Hive box + key holding the "autoplay next episode" preference.
///
/// Stored in Hive (not the Isar Settings collection) so the toggle persists
/// without touching the generated Isar schema. The box is opened once at
/// startup in `_postLaunchInit`; see [openPlayerPrefsBox].
const _playerPrefsBox = 'player_prefs';
const _autoPlayNextKey = 'auto_play_next_episode';

/// Opens the player-preferences box. Called once during app startup so the
/// value can be read synchronously by [AutoPlayNextEpisode.build].
Future<void> openPlayerPrefsBox() async {
  if (!Hive.isBoxOpen(_playerPrefsBox)) {
    await Hive.openBox(_playerPrefsBox);
  }
}

/// Whether the player should automatically start the next episode when the
/// current one finishes. Defaults to `true` (the previous always-on behavior).
/// Toggled from a button in the player and persisted across sessions.
final autoPlayNextEpisodeProvider =
    NotifierProvider<AutoPlayNextEpisode, bool>(AutoPlayNextEpisode.new);

class AutoPlayNextEpisode extends Notifier<bool> {
  @override
  bool build() {
    if (Hive.isBoxOpen(_playerPrefsBox)) {
      return Hive.box(_playerPrefsBox).get(_autoPlayNextKey, defaultValue: true)
          as bool;
    }
    return true;
  }

  void toggle() => set(!state);

  void set(bool value) {
    state = value;
    if (Hive.isBoxOpen(_playerPrefsBox)) {
      Hive.box(_playerPrefsBox).put(_autoPlayNextKey, value);
    }
  }
}

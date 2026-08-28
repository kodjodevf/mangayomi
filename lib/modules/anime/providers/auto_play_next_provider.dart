import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// Whether the player should automatically start the next episode when the
/// current one finishes. Defaults to `true` (the previous always-on behavior).
/// Toggled from a button in the player and persisted on the Settings collection.
final autoPlayNextEpisodeProvider = NotifierProvider<AutoPlayNextEpisode, bool>(
  AutoPlayNextEpisode.new,
);

class AutoPlayNextEpisode extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.autoPlayNextEpisode ?? true;

  void toggle() => set(!state);

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.autoPlayNextEpisode = value);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

/// Whether the player should automatically start the next episode when the
/// current one finishes. Defaults to `true` (the previous always-on behavior).
/// Toggled from a button in the player and persisted on the Settings collection.
final autoPlayNextEpisodeProvider =
    NotifierProvider<AutoPlayNextEpisode, bool>(AutoPlayNextEpisode.new);

class AutoPlayNextEpisode extends Notifier<bool> {
  @override
  bool build() => isar.settings.getSync(227)?.autoPlayNextEpisode ?? true;

  void toggle() => set(!state);

  void set(bool value) {
    state = value;
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..autoPlayNextEpisode = value);
      }
    });
  }
}

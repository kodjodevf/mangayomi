import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates_last_seen_provider.g.dart';

/// When Updates was last opened or left, as epoch milliseconds (0 if never).
/// The navigation badge counts only what was found after it, the way Mihon's
/// does, so it clears on a visit instead of counting every unread chapter.
@riverpod
class UpdatesLastSeenState extends _$UpdatesLastSeenState {
  @override
  int build() => settingsRepository.current.updatesLastSeenAt ?? 0;

  void markSeen() {
    final now = DateTime.now().millisecondsSinceEpoch;
    state = now;
    settingsRepository.updateLocalState((s) => s.updatesLastSeenAt = now);
  }
}

/// The unread [updates] found after [lastSeenAt]. An update's date is when the
/// library update found its chapter, in epoch milliseconds.
int countNewUpdates(Iterable<Update> updates, int lastSeenAt) =>
    updates.where((u) => (int.tryParse(u.date ?? '') ?? 0) > lastSeenAt).length;

bool isUpdatesLocation(String? location) =>
    location != null && Uri.tryParse(location)?.path == '/updates';

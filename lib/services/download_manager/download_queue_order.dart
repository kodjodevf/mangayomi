import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// The user's manual ordering of the download queue as a list of Download ids
/// (which equal their chapter ids), highest priority first.
///
/// Stored on the Settings collection (`downloadQueueOrder`), alongside the rest
/// of the app's preferences. Ids missing from the saved order are treated as
/// lowest priority (in id order, after the known ones), so newly queued
/// downloads slot in at the end until the user moves them.
class DownloadQueueOrder {
  /// The saved priority order (Download ids), or an empty list if none.
  static List<int> get order =>
      settingsRepository.current.downloadQueueOrder ?? const [];

  /// Persists [ids] as the new priority order.
  static Future<void> setOrder(List<int> ids) =>
      settingsRepository.update((s) => s.downloadQueueOrder = ids);

  /// The position of each download in the queue, smallest first: its place
  /// in the saved manual order, then, for the rest, its id. Ids grow with
  /// chapter number within a series (chapters are stored oldest first), so a
  /// plain queue runs top to bottom, in the order the queue screen lists it.
  /// The screen, the queue processor and the gate all sort by this, so what
  /// is at the top of the list is what downloads next.
  static int Function(int id) positions() {
    final ord = order;
    final rank = <int, int>{for (var i = 0; i < ord.length; i++) ord[i]: i};
    return (id) => rank[id] ?? ord.length + id;
  }

  /// [ids] with the ones [moved] picks taken to the top or the bottom,
  /// keeping their order among themselves, and the rest theirs.
  static List<int> move(
    List<int> ids,
    bool Function(int id) moved, {
    required bool toTop,
  }) {
    final group = ids.where(moved).toList();
    final rest = ids.where((id) => !moved(id)).toList();
    return toTop ? [...group, ...rest] : [...rest, ...group];
  }

  /// Returns [items] in queue order (see [positions]).
  static List<Download> sorted(List<Download> items) {
    final position = positions();
    return [...items]
      ..sort((a, b) => position(a.id ?? 0).compareTo(position(b.id ?? 0)));
  }
}

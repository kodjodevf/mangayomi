import 'package:hive/hive.dart';
import 'package:mangayomi/models/download.dart';

/// Persists the user's manual ordering of the download queue as a list of
/// Download ids (which equal their chapter ids), highest priority first.
///
/// Kept in Hive rather than as an Isar field so the queue can be reordered
/// without a schema change. Ids missing from the saved order are treated as
/// lowest priority (kept in their incoming id order, after the known ones).
/// The box is opened once at startup (see [openBox]); when it isn't open the
/// order is empty and the queue falls back to its natural (insertion) order.
class DownloadQueueOrder {
  static const _boxName = 'download_queue_prefs';
  static const _orderKey = 'queue_order';

  /// Opens the backing box. Called once during app startup.
  static Future<void> openBox() async {
    // Best-effort: an optional ordering store must never block startup.
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox(_boxName);
      }
    } catch (_) {}
  }

  /// The saved priority order (Download ids), or an empty list if none.
  static List<int> get order {
    if (!Hive.isBoxOpen(_boxName)) return const [];
    final raw = Hive.box(_boxName).get(_orderKey);
    if (raw is List) return raw.whereType<int>().toList();
    return const [];
  }

  /// Persists [ids] as the new priority order (best-effort if the box is open).
  static void setOrder(List<int> ids) {
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_orderKey, ids);
    }
  }

  /// Returns [items] arranged by the saved manual order. Items whose id isn't
  /// in the saved order come last, keeping their incoming id order, so newly
  /// queued downloads slot in at the end until the user moves them.
  static List<Download> sorted(List<Download> items) {
    final ord = order;
    if (ord.isEmpty) return items;
    final rank = <int, int>{};
    for (var i = 0; i < ord.length; i++) {
      rank[ord[i]] = i;
    }
    final result = [...items];
    result.sort((a, b) {
      final ra = rank[a.id] ?? (ord.length + (a.id ?? 0));
      final rb = rank[b.id] ?? (ord.length + (b.id ?? 0));
      return ra.compareTo(rb);
    });
    return result;
  }
}

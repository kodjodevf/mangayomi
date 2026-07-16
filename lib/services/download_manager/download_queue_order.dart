import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';

/// The user's manual ordering of the download queue as a list of Download ids
/// (which equal their chapter ids), highest priority first.
///
/// Stored on the Settings collection (`downloadQueueOrder`), alongside the rest
/// of the app's preferences. Ids missing from the saved order are treated as
/// lowest priority (kept in their incoming id order, after the known ones), so
/// newly queued downloads slot in at the end until the user moves them.
class DownloadQueueOrder {
  /// The saved priority order (Download ids), or an empty list if none.
  static List<int> get order =>
      isar.settings.getSync(227)?.downloadQueueOrder ?? const [];

  /// Persists [ids] as the new priority order.
  static void setOrder(List<int> ids) {
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..downloadQueueOrder = ids);
      }
    });
  }

  /// Returns [items] arranged by the saved manual order. Items whose id isn't
  /// in the saved order come last, keeping their incoming id order.
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

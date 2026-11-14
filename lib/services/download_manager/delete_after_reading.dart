import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';

/// The chapter whose download goes once [current] is read: the one [slot]
/// chapters before it in [readingOrder], 0 being [current] itself. Keeping a
/// few read chapters around leaves room to go back to them offline.
///
/// None when there is no such chapter, it is not read, or it is bookmarked
/// and [deleteBookmarked] is off.
Chapter? chapterToDeleteAfterReading(
  List<Chapter> readingOrder,
  Chapter current, {
  required int slot,
  required bool deleteBookmarked,
}) {
  final Chapter target;
  if (slot <= 0) {
    target = current;
  } else {
    final index = readingOrder.indexWhere((c) => c.id == current.id);
    if (index - slot < 0) return null;
    target = readingOrder[index - slot];
    if (target.isRead != true) return null;
  }
  if (!deleteBookmarked && (target.isBookmarked ?? false)) return null;
  return target;
}

/// Downloads read in the open reader, deleted once it closes.
///
/// They used to go the moment a chapter counted as read, which is two pages
/// before its end: the reader had not loaded those last pages yet, and found
/// their files gone. Retry could not bring them back.
class PendingDownloadDeletions {
  PendingDownloadDeletions._();

  static final Map<int, Chapter> _chapters = {};

  /// The chapters waiting, in the order they were read.
  static Iterable<Chapter> get chapters => _chapters.values;

  /// Deletes [chapter]'s download when the reader closes.
  static void add(Chapter chapter) {
    final id = chapter.id;
    if (id != null) _chapters[id] = chapter;
  }

  /// Deletes every download waiting, with [delete] for each.
  static Future<void> flush([
    Future<void> Function(Chapter chapter)? delete,
  ]) async {
    final chapters = _chapters.values.toList();
    _chapters.clear();
    for (final chapter in chapters) {
      try {
        await (delete ?? (c) => c.deleteDownloadedFiles())(chapter);
      } catch (_) {
        // One chapter failing must not keep the others on disk.
      }
    }
  }
}

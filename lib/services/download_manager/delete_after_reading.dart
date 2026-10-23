import 'package:mangayomi/models/chapter.dart';

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

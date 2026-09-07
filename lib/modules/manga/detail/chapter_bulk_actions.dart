import 'package:mangayomi/models/chapter.dart';

/// Chooses one uniform state for the bulk read/unread action.
///
/// If every selected chapter is read, the action marks all of them unread.
/// Otherwise it marks all selected chapters read.
bool bulkChapterTargetReadState(Iterable<Chapter> chapters) {
  final selected = chapters.toList(growable: false);
  return selected.isEmpty ||
      !selected.every((chapter) => chapter.isRead == true);
}

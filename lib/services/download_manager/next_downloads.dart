import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';

/// Selects the next unread entries in reading order. Completed and already
/// queued downloads do not consume a slot in the requested batch size.
List<Chapter> selectNextDownloads(
  List<Chapter> chapters, {
  required int count,
  required Iterable<Download> downloads,
}) {
  if (count <= 0) return [];
  final unavailable = downloads
      .where(
        (download) =>
            download.isDownload == true || download.isStartDownload == true,
      )
      .map((download) => download.id)
      .toSet();
  return chapters
      .where(
        (chapter) =>
            chapter.isRead != true && !unavailable.contains(chapter.id),
      )
      .take(count)
      .toList();
}

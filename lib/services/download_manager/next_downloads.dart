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

/// The chapters to download ahead while [current] is read: the next [count]
/// unread chapters after it in [readingOrder], not already downloaded or
/// queued. Nothing when [current] itself is not downloaded: reading a chapter
/// online says nothing about wanting the next ones offline.
List<Chapter> selectDownloadAhead(
  List<Chapter> readingOrder,
  Chapter current, {
  required int count,
  required Iterable<Download> downloads,
}) {
  if (count <= 0) return [];
  final currentDownloaded = downloads.any(
    (download) => download.id == current.id && download.isDownload == true,
  );
  if (!currentDownloaded) return [];
  final index = readingOrder.indexWhere((c) => c.id == current.id);
  if (index < 0) return [];
  return selectNextDownloads(
    readingOrder.sublist(index + 1),
    count: count,
    downloads: downloads,
  );
}

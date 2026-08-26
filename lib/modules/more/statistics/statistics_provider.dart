import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'statistics_provider.g.dart';

class StatisticsData {
  final int totalItems;
  final int totalChapters;
  final int readChapters;
  final int completedItems;
  final int downloadedItems;
  final int totalReadingTimeSeconds;

  const StatisticsData({
    required this.totalItems,
    required this.totalChapters,
    required this.readChapters,
    required this.completedItems,
    required this.downloadedItems,
    required this.totalReadingTimeSeconds,
  });
}

@riverpod
Future<StatisticsData> getStatistics(
  Ref ref, {
  required ItemType itemType,
}) async {
  // Aggregate inside Isar instead of materialising every favourite manga
  // and every one of their chapters in Dart. Loading all chapters of a
  // 75+ manga library exhausts heap on Android and reliably crashes the
  // statistics screen — see issue #543.

  final totalItems = await mangaRepository.countFavoritesByItemType(itemType);

  final totalChapters = await chapterRepository.countByFavoriteItemType(
    itemType,
  );

  final readChapters = await chapterRepository.countReadByFavoriteItemType(
    itemType,
  );

  final downloadedCount = await downloadRepository
      .countDownloadedByFavoriteItemType(itemType);

  // Completed items: a favourite manga whose source-reported status is
  // Completed AND every chapter is read AND there is at least one chapter.
  // Pull only the IDs of completed favourites, then run two cheap count()
  // queries per item — never materialise the chapter rows.
  final completedFavouriteIds = await mangaRepository.getCompletedFavoriteIds(
    itemType,
  );

  int completedItems = 0;
  for (final id in completedFavouriteIds) {
    final total = await chapterRepository.countByMangaIdAsync(id);
    if (total == 0) continue;
    final unread = await chapterRepository.countUnreadByMangaId(id);
    if (unread == 0) completedItems++;
  }

  // Sum reading time without loading full History rows. Project just the
  // int field — Isar returns a List<int?> of plain ints, far cheaper than
  // hydrating every history record.
  final readingTimes = await historyRepository.getReadingTimesByItemType(
    itemType,
  );
  final totalReadingTimeSeconds = readingTimes.fold<int>(
    0,
    (sum, v) => sum + (v ?? 0),
  );

  return StatisticsData(
    totalItems: totalItems,
    totalChapters: totalChapters,
    readChapters: readChapters,
    completedItems: completedItems,
    downloadedItems: downloadedCount,
    totalReadingTimeSeconds: totalReadingTimeSeconds,
  );
}

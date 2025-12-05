import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'statistics_provider.g.dart';

class StatisticsData {
  final int totalItems;
  final int totalChapters;
  final int readChapters;
  final int completedItems;
  final int downloadedItems;

  const StatisticsData({
    required this.totalItems,
    required this.totalChapters,
    required this.readChapters,
    required this.completedItems,
    required this.downloadedItems,
  });
}

@riverpod
Future<StatisticsData> getStatistics(
  Ref ref, {
  required ItemType itemType,
}) async {
  final items = await isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType)
      .findAll();

  final chapters = await isar.chapters
      .filter()
      .idIsNotNull()
      .manga((q) => q.favoriteEqualTo(true).itemTypeEqualTo(itemType))
      .findAll();

  final downloadedCount = await isar.downloads
      .filter()
      .idIsNotNull()
      .chapter((q) => q.manga((m) => m.itemTypeEqualTo(itemType)))
      .chapter((q) => q.manga((m) => m.favoriteEqualTo(true)))
      .isDownloadEqualTo(true)
      .count();

  final totalItems = items.length;
  final totalChapters = chapters.length;
  final readChapters = chapters.where((c) => c.isRead ?? false).length;

  int completedItems = 0;
  for (var item in items) {
    if (item.status == Status.completed) {
      final itemChapters = item.chapters.toList();
      if (itemChapters.isNotEmpty &&
          itemChapters.every((element) => element.isRead ?? false)) {
        completedItems++;
      }
    }
  }

  return StatisticsData(
    totalItems: totalItems,
    totalChapters: totalChapters,
    readChapters: readChapters,
    completedItems: completedItems,
    downloadedItems: downloadedCount,
  );
}

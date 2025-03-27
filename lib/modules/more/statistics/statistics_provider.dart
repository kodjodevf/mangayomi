import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'statistics_provider.g.dart';

@riverpod
class StatisticsState extends _$StatisticsState {
  @override
  void build(ItemType itemType) {}
  final items =
      isar.mangas.filter().idIsNotNull().favoriteEqualTo(true).findAllSync();
  final chapters =
      isar.chapters
          .filter()
          .idIsNotNull()
          .manga((q) => q.favoriteEqualTo(true))
          .findAllSync();
  int get totalItems => items.where((i) => i.itemType == itemType).length;
  int get totalChapters =>
      chapters.where((i) => i.manga.value!.itemType == itemType).length;
  int get readChapters =>
      chapters
          .where(
            (i) => i.manga.value!.itemType == itemType && (i.isRead ?? false),
          )
          .length;
  int get completedItems =>
      items
          .where(
            (i) => i.itemType == itemType && (i.status == Status.completed),
          )
          .where((e) => e.chapters.every((element) => element.isRead ?? false))
          .length;

  int get downloadedItems =>
      isar.downloads
          .filter()
          .idIsNotNull()
          .chapter((q) => q.manga((m) => m.itemTypeEqualTo(itemType)))
          .chapter((q) => q.manga((m) => m.favoriteEqualTo(true)))
          .isDownloadEqualTo(true)
          .findAllSync()
          .length;
}

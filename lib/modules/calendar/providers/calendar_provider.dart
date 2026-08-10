import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'calendar_provider.g.dart';

@riverpod
Stream<List<Manga>> getCalendarStream(Ref ref, {ItemType? itemType}) async* {
  yield* isar.mangas
      .where()
      .favoriteItemTypeEqualTo(true, itemType ?? ItemType.manga)
      .filter()
      .anyOf([
        Status.ongoing,
        Status.unknown,
        Status.publishingFinished,
      ], (q, status) => q.statusEqualTo(status))
      .smartUpdateDaysIsNotNull()
      .smartUpdateDaysGreaterThan(0)
      .watch(fireImmediately: true);
}

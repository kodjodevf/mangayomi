import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'calendar_provider.g.dart';

@riverpod
Stream<List<Manga>> getCalendarStream(Ref ref, {ItemType? itemType}) async* {
  yield* isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .itemTypeEqualTo(itemType ?? ItemType.manga)
      .anyOf([
        Status.ongoing,
        Status.unknown,
        Status.publishingFinished,
      ], (q, status) => q.statusEqualTo(status))
      .smartUpdateDaysIsNotNull()
      .smartUpdateDaysGreaterThan(0)
      .watch(fireImmediately: true);
}

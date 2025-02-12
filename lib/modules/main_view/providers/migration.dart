import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'migration.g.dart';

@riverpod
Future<void> migration(Ref ref) async {
  final mangas =
      isar.mangas.filter().idIsNotNull().isMangaIsNotNull().findAllSync();
  final categories =
      isar.categorys.filter().idIsNotNull().forMangaIsNotNull().findAllSync();

  final histories = isar.historys
      .filter()
      .idIsNotNull()
      .chapterIdIsNull()
      .isMangaIsNotNull()
      .or()
      .idIsNotNull()
      .isMangaIsNotNull()
      .findAllSync();

  final sources =
      isar.sources.filter().idIsNotNull().isMangaIsNotNull().findAllSync();
  final tracks =
      isar.tracks.filter().idIsNotNull().isMangaIsNotNull().findAllSync();

  isar.writeTxnSync(() {
    for (var history in histories) {
      isar.historys
          .putSync(history..itemType = _convertToItemType(history.isManga!));
    }
    for (var source in sources) {
      isar.sources
          .putSync(source..itemType = _convertToItemType(source.isManga!));
    }
    for (var track in tracks) {
      isar.tracks.putSync(track..itemType = _convertToItemType(track.isManga!));
    }
    for (var manga in mangas) {
      isar.mangas.putSync(manga..itemType = _convertToItemType(manga.isManga!));
    }
    for (var category in categories) {
      isar.categorys.putSync(category..forItemType = _convertToItemType(category.forManga!));
    }
  });
}

ItemType _convertToItemType(bool isManga) {
  return isManga ? ItemType.manga : ItemType.anime;
}

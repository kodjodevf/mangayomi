import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'migration.g.dart';

@riverpod
Future<void> migration(MigrationRef ref) async {
  final chapters =
      isar.chapters.filter().idIsNotNull().mangaIdIsNull().findAllSync();
  final downloads =
      isar.downloads.filter().idIsNotNull().mangaIdIsNull().findAllSync();
  final histories = isar.historys
      .filter()
      .idIsNotNull()
      .chapterIdIsNull()
      .or()
      .idIsNotNull()
      .isMangaIsNull()
      .findAllSync();

  isar.writeTxnSync(() {
    //mangaId in chapter
    for (var chapter in chapters) {
      final mangaId = chapter.manga.value!.id;
      isar.chapters.putSync(chapter..mangaId = mangaId);
    }
    //mangaId in Download
    for (var download in downloads) {
      final mangaId = download.chapter.value!.manga.value!.id;
      isar.downloads.putSync(download..mangaId = mangaId);
    }
    //chapterId and isManga in History
    for (var history in histories) {
      final chapterId = history.chapter.value!.id;
      final isManga = history.chapter.value!.manga.value!.isManga;
      isar.historys.putSync(history
        ..chapterId = chapterId
        ..isManga = isManga);
    }
  });
}

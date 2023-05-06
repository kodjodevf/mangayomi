import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/chapter_filter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<Manga?> getMangaDetailStream(GetMangaDetailStreamRef ref,
    {required int mangaId}) async* {
  yield* isar.mangas.watchObject(mangaId, fireImmediately: true);
}

@riverpod
Stream<List<Chapter>> getChaptersStream(
  GetChaptersStreamRef ref, {
  required int mangaId,
}) async* {
  yield* isar.chapters
      .filter()
      .mangaIdEqualTo(mangaId)
      .watch(fireImmediately: true);
}

@riverpod
Stream<ChaptersFilter?> getChaptersFilterStream(
  GetChaptersFilterStreamRef ref, {
  required int mangaId,
}) async* {
  yield* isar.chaptersFilters.watchObject(mangaId, fireImmediately: true);
}

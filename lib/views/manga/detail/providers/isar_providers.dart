import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/views/manga/detail/models/chapter_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<ModelManga?> getMangaDetailStream(GetMangaDetailStreamRef ref,
    {required int mangaId}) async* {
  yield* isar.modelMangas.watchObject(mangaId, fireImmediately: true);
}

@riverpod
Stream<List<ModelChapters>> getChaptersStream(
  GetChaptersStreamRef ref, {
  required int mangaId,
}) async* {
  yield* isar.modelChapters
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

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<Manga?> getMangaDetailStream(Ref ref, {required int mangaId}) async* {
  yield* mangaRepository.watchById(mangaId);
}

@riverpod
Stream<List<Chapter>> getChaptersStream(
  Ref ref, {
  required int mangaId,
}) async* {
  yield* chapterRepository.watchByMangaId(mangaId);
}

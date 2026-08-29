import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'calendar_provider.g.dart';

@riverpod
Stream<List<Manga>> getCalendarStream(Ref ref, {ItemType? itemType}) async* {
  yield* mangaRepository.watchCalendarFavorites(itemType ?? ItemType.manga);
}

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'extensions_provider.g.dart';

@riverpod
Stream<List<Source>> getExtensionsStream(GetExtensionsStreamRef ref,
    {required String query, required bool? isManga}) async* {
  yield* query.isNotEmpty
      ? isar.sources
          .filter()
          .nameContains(query.toLowerCase(), caseSensitive: false)
          .idIsNotNull()
          .and()
          .isActiveEqualTo(true)
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true)
      : isar.sources
          .filter()
          .idIsNotNull()
          .and()
          .isActiveEqualTo(true)
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true);
}

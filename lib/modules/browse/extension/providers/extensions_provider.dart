import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'extensions_provider.g.dart';

@riverpod
Stream<List<Source>> getExtensionsStream(
    GetExtensionsStreamRef ref, bool? isManga) async* {
  yield* isar.sources
      .filter()
      .idIsNotNull()
      .and()
      .isActiveEqualTo(true)
      .isMangaEqualTo(isManga)
      .watch(fireImmediately: true);
}

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Category>> getMangaCategorieStream(Ref ref,
    {required bool isManga}) async* {
  yield* isar.categorys
      .filter()
      .idIsNotNull()
      .and()
      .forMangaEqualTo(isManga)
      .watch(fireImmediately: true);
}

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Category>> getMangaCategorieStream(Ref ref,
    {required ItemType itemType}) async* {
  yield* isar.categorys
      .filter()
      .idIsNotNull()
      .and()
      .forItemTypeEqualTo(itemType)
      .watch(fireImmediately: true);
}

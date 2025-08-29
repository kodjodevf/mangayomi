import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'extensions_provider.g.dart';

@riverpod
Stream<List<Source>> getExtensionsStream(Ref ref, ItemType itemType) async* {
  yield* isar.sources
      .filter()
      .idIsNotNull()
      .and()
      .group(
        (q) => q.repoIsNull().or().repo(
          (q) => q.hiddenIsNull().or().hiddenEqualTo(false),
        ),
      )
      .isActiveEqualTo(true)
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);
}

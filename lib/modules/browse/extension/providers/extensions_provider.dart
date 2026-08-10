import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'extensions_provider.g.dart';

@riverpod
Stream<List<Source>> getExtensionsStream(Ref ref, ItemType itemType) async* {
  // where().isActiveEqualTo() uses the isActive index for an efficient primary
  // scan; itemType and repo-visibility are secondary filters on the smaller set.
  yield* isar.sources
      .where()
      .isActiveEqualTo(true)
      .filter()
      .itemTypeEqualTo(itemType)
      .group(
        (q) => q.repoIsNull().or().repo(
          (q) => q.hiddenIsNull().or().hiddenEqualTo(false),
        ),
      )
      .watch(fireImmediately: true);
}

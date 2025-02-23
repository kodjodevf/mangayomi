import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'fetch_novel_sources.g.dart';

@Riverpod(keepAlive: true)
Future<void> fetchNovelSourcesList(Ref ref, {int? id, required reFresh}) async {
  if (ref.watch(checkForExtensionsUpdateStateProvider) || reFresh) {
    final repos = ref.watch(extensionsRepoStateProvider(ItemType.novel));
    for (Repo repo in repos) {
      await fetchSourcesList(
        repo: repo,
        refresh: reFresh,
        id: id,
        ref: ref,
        itemType: ItemType.novel,
      );
    }
  }
}

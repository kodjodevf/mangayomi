import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/utils/log/logger.dart';
part 'fetch_item_sources.g.dart';

@Riverpod(keepAlive: true)
Future<void> fetchItemSourcesList(
  Ref ref, {
  int? id,
  required bool reFresh,
  required ItemType itemType,
}) async {
  if (ref.watch(checkForExtensionsUpdateStateProvider) || reFresh) {
    if (id != null) {
      final existingSource = await sourceRepository.findByIdAsync(id);
      if (existingSource != null &&
          existingSource.sourceCodeUrl != null &&
          existingSource.sourceCodeUrl!.isNotEmpty &&
          !(existingSource.isAdded ?? false)) {
        // Direct install: download the extension binary directly and configure it.
        // Avoids fetching and parsing all remote repository indexes!
        await updateSource(
          existingSource,
          ref.watch(androidProxyServerStateProvider),
          existingSource.repo,
          itemType,
        );
        return;
      }

      // If updating or if the source is not yet stored locally, query ONLY the target repository if known:
      final targetRepo = existingSource?.repo;
      final repos = ref.watch(extensionsRepoStateProvider(itemType));
      final reposToQuery = targetRepo != null
          ? repos.where((r) => r.jsonUrl == targetRepo.jsonUrl).toList()
          : repos;

      for (Repo repo in reposToQuery) {
        try {
          final found = await fetchSourcesList(
            repo: repo,
            refresh: reFresh,
            id: id,
            androidProxyServer: ref.watch(androidProxyServerStateProvider),
            autoUpdateExtensions: ref.watch(autoUpdateExtensionsStateProvider),
            itemType: itemType,
          );
          if (found) break;
        } catch (e, st) {
          AppLogger.log(
            'fetchItemSources: repo fetch failed: $e\n$st',
            logLevel: LogLevel.error,
          );
        }
      }
      return;
    }

    final repos = ref.watch(extensionsRepoStateProvider(itemType));
    for (Repo repo in repos) {
      try {
        await fetchSourcesList(
          repo: repo,
          refresh: reFresh,
          id: id,
          androidProxyServer: ref.watch(androidProxyServerStateProvider),
          autoUpdateExtensions: ref.watch(autoUpdateExtensionsStateProvider),
          itemType: itemType,
        );
      } catch (e, st) {
        // The user just sees no sources for the repo.
        AppLogger.log(
          'fetchItemSources: repo fetch failed: $e\n$st',
          logLevel: LogLevel.error,
        );
      }
    }
  }
}

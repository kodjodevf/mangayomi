import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/services/extension_update.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/utils/log/logger.dart';
part 'fetch_item_sources.g.dart';

/// Reads the extension repositories of [itemType], or acts on the one
/// extension [id]: installs it, or installs the update the last read found
/// for it, from where it was found.
@Riverpod(keepAlive: true)
Future<void> fetchItemSourcesList(
  Ref ref, {
  int? id,
  required bool reFresh,
  required ItemType itemType,
}) async {
  if (!(ref.watch(checkForExtensionsUpdateStateProvider) || reFresh)) return;
  final repos = ref.watch(extensionsRepoStateProvider(itemType));
  final androidProxyServer = ref.watch(androidProxyServerStateProvider);

  if (id != null) {
    final existingSource = await sourceRepository.findByIdAsync(id);
    if (existingSource != null && (existingSource.isAdded ?? false)) {
      await installExtensionUpdate(
        installed: existingSource,
        repos: repos,
        androidProxyServer: androidProxyServer,
        itemType: itemType,
      );
      return;
    }
    if (existingSource != null &&
        (existingSource.sourceCodeUrl ?? '').isNotEmpty) {
      // Direct install: download the extension binary directly and configure it.
      // Avoids fetching and parsing all remote repository indexes!
      await updateSource(
        existingSource,
        androidProxyServer,
        existingSource.repo,
        itemType,
      );
      return;
    }
    // Not known here yet: the first repository that lists it.
    for (final repo in repos) {
      final listing = (await fetchRepoSources(
        repo: repo,
        itemType: itemType,
      )).where((s) => s.id == id).firstOrNull;
      if (listing == null || (listing.sourceCodeUrl ?? '').isEmpty) continue;
      await updateSource(listing, androidProxyServer, repo, itemType);
      return;
    }
    return;
  }

  // Every repository is read before any update is chosen, so the choice is
  // made among all of them rather than by whichever was read first.
  final offers = <int, List<ExtensionOffer>>{};
  final readRepos = <String>{};
  for (final repo in repos) {
    try {
      final listed = await fetchRepoSources(repo: repo, itemType: itemType);
      await recordRepoSources(listed, repo, itemType);
      readRepos.add(repo.jsonUrl!);
      for (final source in listed) {
        if (source.id == null) continue;
        (offers[source.id!] ??= []).add(ExtensionOffer(repo, source));
      }
    } catch (e, st) {
      // The user just sees no sources for the repo.
      AppLogger.log(
        'fetchItemSources: repo fetch failed: $e\n$st',
        logLevel: LogLevel.error,
      );
    }
  }
  await followMovedRepos(repos: repos, offers: offers, itemType: itemType);
  await applyExtensionUpdates(
    offers: offers,
    readRepos: readRepos,
    autoUpdate: ref.watch(autoUpdateExtensionsStateProvider),
    androidProxyServer: androidProxyServer,
    itemType: itemType,
  );
}

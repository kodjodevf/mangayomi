import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class BrowseSScreen extends ConsumerWidget {
  const BrowseSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlyIncludePinnedSource = ref.watch(
      onlyIncludePinnedSourceStateProvider,
    );
    final checkForExtensionUpdates = ref.watch(
      checkForExtensionsUpdateStateProvider,
    );
    final autoUpdateExtensions = ref.watch(autoUpdateExtensionsStateProvider);
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.browse)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          l10n.extensions,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.push(
                        "/SourceRepositories",
                        extra: ItemType.manga,
                      );
                    },
                    title: Text(l10n.manga_extensions_repo),
                    subtitle: Text(
                      l10n.manage_manga_repo_urls,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.push(
                        "/SourceRepositories",
                        extra: ItemType.anime,
                      );
                    },
                    title: Text(l10n.anime_extensions_repo),
                    subtitle: Text(
                      l10n.manage_anime_repo_urls,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.push(
                        "/SourceRepositories",
                        extra: ItemType.novel,
                      );
                    },
                    title: Text(l10n.novel_extensions_repo),
                    subtitle: Text(
                      l10n.manage_novel_repo_urls,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
                      ),
                    ),
                  ),
                  SwitchListTile(
                    value: checkForExtensionUpdates,
                    title: Text(l10n.check_for_extension_updates),
                    onChanged: (value) {
                      ref
                          .read(checkForExtensionsUpdateStateProvider.notifier)
                          .set(value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: SizedBox(
                      width: context.width(1),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            () => _showClearAllSourcesDialog(context, l10n),
                        child: Text(
                          l10n.clear_all_sources,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (checkForExtensionUpdates)
                    SwitchListTile(
                      value: autoUpdateExtensions,
                      title: Text(l10n.auto_extensions_updates),
                      subtitle: Text(
                        l10n.auto_extensions_updates_subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryColor,
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(autoUpdateExtensionsStateProvider.notifier)
                            .set(value);
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          l10n.global_search,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    value: onlyIncludePinnedSource,
                    title: Text(l10n.only_include_pinned_sources),
                    onChanged: (value) {
                      ref
                          .read(onlyIncludePinnedSourceStateProvider.notifier)
                          .set(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showClearAllSourcesDialog(BuildContext context, dynamic l10n) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.clear_all_sources),
        content: Text(l10n.clear_all_sources_msg),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
              Consumer(
                builder:
                    (context, ref, child) => TextButton(
                      onPressed: () {
                        isar.writeTxnSync(() {
                          isar.sources.clearSync();
                          ref
                              .read(synchingProvider(syncId: 1).notifier)
                              .addChangedPart(
                                ActionType.clearHistory,
                                null,
                                "{}",
                                false,
                              );
                        });

                        Navigator.pop(ctx);
                        botToast(l10n.sources_cleared);
                      },
                      child: Text(l10n.ok),
                    ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

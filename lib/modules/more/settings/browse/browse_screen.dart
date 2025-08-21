import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/player/custom_button_screen.dart';
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
                        onPressed: () =>
                            _showClearAllSourcesDialog(context, l10n),
                        child: Text(
                          l10n.clear_all_sources,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => _showCleanNonLibraryDialog(context, l10n),
                    title: Text(l10n.clean_database),
                    subtitle: Text(
                      l10n.clean_database_desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () => _showClearLibraryDialog(context, ref),
                    title: Text(l10n.clear_library),
                    subtitle: Text(
                      l10n.clear_library_desc,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
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
                builder: (context, ref, child) => TextButton(
                  onPressed: () {
                    isar.writeTxnSync(() {
                      isar.sources.clearSync();
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

void _showCleanNonLibraryDialog(BuildContext context, dynamic l10n) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.clean_database),
        content: Text(l10n.clean_database_desc),
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
                builder: (context, ref, child) => TextButton(
                  onPressed: () {
                    final mangasList = isar.mangas
                        .filter()
                        .favoriteEqualTo(false)
                        .findAllSync();
                    final provider = ref.read(
                      synchingProvider(syncId: 1).notifier,
                    );
                    isar.writeTxnSync(() {
                      for (var manga in mangasList) {
                        final histories = isar.historys
                            .filter()
                            .mangaIdEqualTo(manga.id)
                            .findAllSync();
                        for (var history in histories) {
                          isar.historys.deleteSync(history.id!);
                          provider.addChangedPart(
                            ActionType.removeHistory,
                            history.id,
                            "{}",
                            false,
                          );
                        }

                        for (var chapter in manga.chapters) {
                          final updates = isar.updates
                              .filter()
                              .mangaIdEqualTo(chapter.mangaId)
                              .chapterNameEqualTo(chapter.name)
                              .findAllSync();
                          for (var update in updates) {
                            isar.updates.deleteSync(update.id!);
                            provider.addChangedPart(
                              ActionType.removeUpdate,
                              update.id,
                              "{}",
                              false,
                            );
                          }
                          isar.chapters.deleteSync(chapter.id!);
                          provider.addChangedPart(
                            ActionType.removeChapter,
                            chapter.id,
                            "{}",
                            false,
                          );
                        }
                        isar.mangas.deleteSync(manga.id!);
                        provider.addChangedPart(
                          ActionType.removeItem,
                          manga.id,
                          "{}",
                          false,
                        );
                      }
                    });

                    Navigator.pop(ctx);
                    botToast(l10n.cleaned_database(mangasList.length));
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

void _showClearLibraryDialog(BuildContext context, WidgetRef ref) {
  final itemTypes = ItemType.values.map((e) => e.name).toList();
  bool isInputError = true;
  final textController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Column(
              children: [
                Text(context.l10n.clear_library),
                Text(
                  context.l10n.clear_library_input,
                  style: TextStyle(fontSize: 11, color: context.secondaryColor),
                ),
              ],
            ),
            content: SizedBox(
              width: context.width(0.8),
              child: CustomTextFormField(
                controller: textController,
                context: context,
                isMissing: isInputError,
                val: (text) => setState(() {
                  isInputError =
                      text.trim().isEmpty ||
                      text.split(",").any((e) => !itemTypes.contains(e));
                }),
                missing: (_) {},
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      context.l10n.cancel,
                      style: TextStyle(color: context.primaryColor),
                    ),
                  ),
                  TextButton(
                    onPressed: isInputError
                        ? null
                        : () {
                            final mangasList = isar.mangas
                                .filter()
                                .anyOf(
                                  textController.text
                                      .split(",")
                                      .map(
                                        (e) => switch (e) {
                                          "manga" => ItemType.manga,
                                          "anime" => ItemType.anime,
                                          "novel" => ItemType.novel,
                                          _ => null,
                                        },
                                      ),
                                  (q, element) => element == null
                                      ? q.idIsNull()
                                      : q.itemTypeEqualTo(element),
                                )
                                .findAllSync();
                            final provider = ref.read(
                              synchingProvider(syncId: 1).notifier,
                            );
                            isar.writeTxnSync(() {
                              for (var manga in mangasList) {
                                final histories = isar.historys
                                    .filter()
                                    .mangaIdEqualTo(manga.id)
                                    .findAllSync();
                                for (var history in histories) {
                                  isar.historys.deleteSync(history.id!);
                                  provider.addChangedPart(
                                    ActionType.removeHistory,
                                    history.id,
                                    "{}",
                                    false,
                                  );
                                }

                                for (var chapter in manga.chapters) {
                                  final updates = isar.updates
                                      .filter()
                                      .mangaIdEqualTo(chapter.mangaId)
                                      .chapterNameEqualTo(chapter.name)
                                      .findAllSync();
                                  for (var update in updates) {
                                    isar.updates.deleteSync(update.id!);
                                    provider.addChangedPart(
                                      ActionType.removeUpdate,
                                      update.id,
                                      "{}",
                                      false,
                                    );
                                  }
                                  isar.chapters.deleteSync(chapter.id!);
                                  provider.addChangedPart(
                                    ActionType.removeChapter,
                                    chapter.id,
                                    "{}",
                                    false,
                                  );
                                }
                                isar.mangas.deleteSync(manga.id!);
                                provider.addChangedPart(
                                  ActionType.removeItem,
                                  manga.id,
                                  "{}",
                                  false,
                                );
                              }
                            });
                            botToast(
                              context.l10n.cleaned_database(mangasList.length),
                            );
                            Navigator.pop(context);
                          },
                    child: Text(
                      context.l10n.ok,
                      style: TextStyle(
                        color: isInputError
                            ? context.secondaryColor
                            : context.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}

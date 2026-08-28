import 'dart:io';

import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/player/custom_button_screen.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class BrowseSScreen extends ConsumerWidget {
  const BrowseSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlyIncludePinnedSource = ref.watch(
      onlyIncludePinnedSourceStateProvider,
    );
    final showNSFW = ref.watch(showNSFWStateProvider);
    final checkForExtensionUpdates = ref.watch(
      checkForExtensionsUpdateStateProvider,
    );
    final autoUpdateExtensions = ref.watch(autoUpdateExtensionsStateProvider);
    // On the anime-only TV layout, hide the manga & novel repo settings.
    final animeOnly = ref.watch(animeOnlyTvModeProvider);
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.browse)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            // The master "anime only" TV switch: turning it off removes all the
            // TV-only gates (shows manga & novel again across the app).
            if (isTv)
              SwitchListTile(
                title: const Text('Anime only (beta)'),
                subtitle: const Text(
                  'Hide manga & novel across the app. Turn off to show everything.',
                ),
                value: animeOnly,
                onChanged: (v) =>
                    ref.read(animeOnlyTvModeProvider.notifier).set(v),
              ),
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
                  const ExtensionServerWarningBanner(),
                  if (!Platform.isAndroid)
                    ListTile(
                      onTap: () => context.push('/extensionServer'),
                      title: Text(
                        isMobile
                            ? l10n.android_proxy_server
                            : l10n.android_proxy_server_mihon,
                      ),
                      subtitle: Text(
                        isMobile
                            ? l10n.m_extension_server_description
                            : l10n.android_proxy_server_mihon_description,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.secondaryColor,
                        ),
                      ),
                    ),
                  if (!animeOnly)
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
                  if (!animeOnly)
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
                  ListTile(
                    onTap: () => _showClearLocalLibraryDialog(context, ref),
                    title: Text(l10n.clear_local_library),
                    subtitle: Text(
                      l10n.clear_local_library_desc,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          l10n.nsfw_sources,
                          style: TextStyle(
                            fontSize: 13,
                            color: context.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SwitchListTile(
                    value: showNSFW,
                    title: Text(l10n.nsfw_sources_show),
                    onChanged: (value) {
                      ref.read(showNSFWStateProvider.notifier).set(value);
                    },
                  ),
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: context.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      l10n.nsfw_sources_info,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.secondaryColor,
                      ),
                    ),
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
                    sourceRepository.clearAll();

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
                    final mangasList = mangaRepository.getNonFavorites();
                    mangaRepository.wipeMangas(ref, mangasList);

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
                            final mangasList = mangaRepository
                                .getByItemTypeNames(
                                  textController.text.split(",").map(
                                    (e) => switch (e) {
                                      "manga" => ItemType.manga,
                                      "anime" => ItemType.anime,
                                      "novel" => ItemType.novel,
                                      _ => null,
                                    },
                                  ),
                                );
                            mangaRepository.wipeMangas(ref, mangasList);
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

void _showClearLocalLibraryDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(context.l10n.clear_local_library),
        content: Text(context.l10n.clear_local_library_msg),
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
                onPressed: () {
                  final mangasList = mangaRepository.getBySourceLocalOrArchive();
                  mangaRepository.wipeMangas(ref, mangasList);
                  botToast(context.l10n.cleaned_database(mangasList.length));
                  Navigator.pop(context);
                },
                child: Text(
                  context.l10n.ok,
                  style: TextStyle(color: context.primaryColor),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

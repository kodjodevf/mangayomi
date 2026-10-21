import 'dart:io';

import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/browse/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
    final developerMode = ref.watch(developerModeStateProvider);
    // On the anime-only TV layout, hide the manga & novel repo settings.
    final animeOnly = ref.watch(animeOnlyTvModeProvider);
    final l10n = context.l10n;
    ShioriSettingRow repo(String title, String subtitle, ItemType type) =>
        ShioriSettingRow(
          title: title,
          subtitle: subtitle,
          trailing: const Icon(Symbols.chevron_forward_rounded),
          onTap: () => context.push("/SourceRepositories", extra: type),
        );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.browse)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          // The master "anime only" TV switch: turning it off removes all the
          // TV-only gates (shows manga & novel again across the app).
          if (isTv)
            ShioriSettingsGroup(
              children: [
                ShioriSwitchRow(
                  autofocus: true,
                  title: l10n.anime_only_beta,
                  subtitle: l10n.anime_only_beta_subtitle,
                  value: animeOnly,
                  onChanged: (v) =>
                      ref.read(animeOnlyTvModeProvider.notifier).set(v),
                ),
              ],
            ),
          ShioriSettingsGroup(
            title: l10n.extensions,
            children: [
              const ExtensionServerWarningBanner(),
              if (!Platform.isAndroid)
                ShioriSettingRow(
                  title: isMobile
                      ? l10n.android_proxy_server
                      : l10n.android_proxy_server_mihon,
                  subtitle: isMobile
                      ? l10n.m_extension_server_description
                      : l10n.android_proxy_server_mihon_description,
                  trailing: const Icon(Symbols.chevron_forward_rounded),
                  onTap: () => context.push('/extensionServer'),
                ),
              if (!animeOnly)
                repo(
                  l10n.manga_extensions_repo,
                  l10n.manage_manga_repo_urls,
                  ItemType.manga,
                ),
              repo(
                l10n.anime_extensions_repo,
                l10n.manage_anime_repo_urls,
                ItemType.anime,
              ),
              if (!animeOnly)
                repo(
                  l10n.novel_extensions_repo,
                  l10n.manage_novel_repo_urls,
                  ItemType.novel,
                ),
              ShioriSwitchRow(
                title: l10n.check_for_extension_updates,
                value: checkForExtensionUpdates,
                onChanged: (v) => ref
                    .read(checkForExtensionsUpdateStateProvider.notifier)
                    .set(v),
              ),
              if (checkForExtensionUpdates)
                ShioriSwitchRow(
                  title: l10n.auto_extensions_updates,
                  subtitle: l10n.auto_extensions_updates_subtitle,
                  value: autoUpdateExtensions,
                  onChanged: (v) => ref
                      .read(autoUpdateExtensionsStateProvider.notifier)
                      .set(v),
                ),
              ShioriSwitchRow(
                title: l10n.developer_mode,
                subtitle: l10n.developer_mode_subtitle,
                value: developerMode,
                onChanged: (v) =>
                    ref.read(developerModeStateProvider.notifier).set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.global_search,
            children: [
              ShioriSwitchRow(
                title: l10n.only_include_pinned_sources,
                value: onlyIncludePinnedSource,
                onChanged: (v) => ref
                    .read(onlyIncludePinnedSourceStateProvider.notifier)
                    .set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.nsfw_sources,
            footer: l10n.nsfw_sources_info,
            children: [
              ShioriSwitchRow(
                title: l10n.nsfw_sources_show,
                value: showNSFW,
                onChanged: (v) =>
                    ref.read(showNSFWStateProvider.notifier).set(v),
              ),
            ],
          ),
          // It deletes, so it sits apart from the settings. Removing series
          // from the database is under Data and storage.
          ShioriSettingsGroup(
            title: l10n.group_cleanup,
            children: [
              ShioriSettingRow(
                icon: Symbols.delete_sweep_rounded,
                title: l10n.clear_all_sources,
                subtitle: l10n.clear_all_sources_msg,
                destructive: true,
                onTap: () => _clearAllSources(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _clearAllSources(BuildContext context) async {
  final l10n = context.l10n;
  final confirmed = await showShioriConfirm(
    context,
    title: l10n.clear_all_sources,
    message: l10n.clear_all_sources_msg,
    confirmLabel: l10n.remove,
    destructive: true,
  );
  if (!confirmed) return;
  sourceRepository.clearAll();
  botToast(l10n.sources_cleared);
}

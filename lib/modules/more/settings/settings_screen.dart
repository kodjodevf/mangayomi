import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/settings_search.dart';
import 'package:mangayomi/modules/more/widgets/list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.settings),
        actions: [
          IconButton(
            tooltip: l10n.search_settings,
            onPressed: () => showSearch(
              context: context,
              delegate: SettingsSearchDelegate(l10n),
            ),
            icon: const Icon(Symbols.search_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            ShioriSettingsGroup(
              title: l10n.group_app,
              children: [
                ListTileWidget(
                  autofocus: isTv,
                  title: l10n.general,
                  subtitle: l10n.settings_general_summary,
                  icon: Symbols.tune_rounded,
                  onTap: () => context.push('/general'),
                ),
                ListTileWidget(
                  title: l10n.appearance,
                  subtitle: l10n.settings_appearance_summary,
                  icon: Symbols.palette_rounded,
                  onTap: () => context.push('/appearance'),
                ),
                if (!Platform.isLinux)
                  ListTileWidget(
                    title: l10n.security,
                    subtitle: l10n.settings_security_summary,
                    icon: Symbols.security_rounded,
                    onTap: () => context.push('/security'),
                  ),
              ],
            ),
            // The readers and the player follow the libraries shown: one
            // that is hidden takes its settings with it. The anime-only TV
            // layout shows none of them, as before.
            Consumer(
              builder: (context, ref, _) {
                final animeOnly = ref.watch(animeOnlyTvModeProvider);
                final hiddenItems = ref.watch(hideItemsStateProvider);
                return ShioriSettingsGroup(
                  title: l10n.group_reading_watching,
                  children: [
                    if (!animeOnly && !hiddenItems.contains("/MangaLibrary"))
                      ListTileWidget(
                        title: l10n.reader,
                        subtitle: l10n.reader_subtitle,
                        icon: Symbols.chrome_reader_mode_rounded,
                        onTap: () => context.push('/readerMode'),
                      ),
                    if (!animeOnly && !hiddenItems.contains("/NovelLibrary"))
                      ListTileWidget(
                        title: l10n.novel_reader,
                        subtitle: l10n.settings_novel_reader_summary,
                        icon: Symbols.menu_book_rounded,
                        onTap: () => context.push('/novelReaderMode'),
                      ),
                    if (!animeOnly && !hiddenItems.contains("/AnimeLibrary"))
                      ListTileWidget(
                        title: l10n.player,
                        subtitle: l10n.settings_player_summary,
                        icon: Symbols.play_circle_rounded,
                        onTap: () => context.push('/playerOverview'),
                      ),
                    // Where a keyboard can be found, its keys.
                    if (isDesktop)
                      ListTileWidget(
                        title: l10n.keyboard_shortcuts,
                        subtitle: l10n.settings_keyboard_shortcuts_summary,
                        icon: Symbols.keyboard_rounded,
                        onTap: () => context.push('/keyboardShortcuts'),
                      ),
                    ListTileWidget(
                      title: l10n.downloads,
                      subtitle: l10n.settings_downloads_summary,
                      icon: Symbols.download_rounded,
                      onTap: () => context.push('/downloads'),
                    ),
                  ],
                );
              },
            ),
            ShioriSettingsGroup(
              title: l10n.group_sources_services,
              children: [
                ListTileWidget(
                  title: l10n.browse,
                  subtitle: l10n.settings_browse_summary,
                  icon: Symbols.explore_rounded,
                  onTap: () => context.push('/browseS'),
                ),
                ListTileWidget(
                  title: l10n.tracking,
                  subtitle: l10n.settings_tracking_summary,
                  icon: Symbols.sync_rounded,
                  onTap: () => context.push('/track'),
                ),
                ListTileWidget(
                  title: l10n.syncing,
                  subtitle: l10n.settings_syncing_summary,
                  icon: Symbols.cloud_sync_rounded,
                  onTap: () => context.push('/sync'),
                ),
              ],
            ),
            ShioriSettingsGroup(
              children: [
                ListTileWidget(
                  title: l10n.about,
                  subtitle: l10n.settings_about_summary,
                  icon: Symbols.info_rounded,
                  onTap: () => context.push('/about'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

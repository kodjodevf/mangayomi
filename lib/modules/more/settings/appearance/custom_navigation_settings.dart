import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/appearance_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CustomNavigationSettings extends ConsumerStatefulWidget {
  const CustomNavigationSettings({super.key});

  @override
  ConsumerState<CustomNavigationSettings> createState() =>
      _CustomNavigationSettingsState();
}

class _CustomNavigationSettingsState
    extends ConsumerState<CustomNavigationSettings> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);
    final mergeLibraryNavMobile = ref.watch(mergeLibraryNavMobileStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reorder_navigation)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
        child: ReorderableListView.builder(
          header: ShioriSettingsGroup(
            children: [
              ShioriSwitchRow(
                title: l10n.anime_only_tv_layout,
                subtitle: l10n.anime_only_beta_subtitle,
                value: ref.watch(animeOnlyTvModeProvider),
                onChanged: (v) =>
                    ref.read(animeOnlyTvModeProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.group_nav_destinations,
                subtitle: l10n.group_nav_destinations_subtitle,
                value: ref.watch(navGroupingProvider),
                onChanged: (v) => ref.read(navGroupingProvider.notifier).set(v),
              ),
              // The older, mobile-only way of folding the libraries; the
              // grouping above supersedes it while it is on.
              if (!ref.watch(navGroupingProvider))
                ShioriSwitchRow(
                  title: l10n.merge_library_nav_mobile,
                  value: mergeLibraryNavMobile,
                  onChanged: (v) => ref
                      .read(mergeLibraryNavMobileStateProvider.notifier)
                      .set(v),
                ),
            ],
          ),
          buildDefaultDragHandles: false,
          itemCount: navigationOrder.length,
          itemBuilder: (context, index) {
            final navigation = navigationOrder[index];
            // More and Browse hold the settings and the sources: always
            // shown, so there is always a way back to this screen.
            final fixed = navigation == "/more" || navigation == "/browse";
            return Row(
              key: Key('navigation_$navigation'),
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Symbols.drag_handle_rounded),
                ),
                Expanded(
                  child: ShioriSwitchRow(
                    key: Key(navigation),
                    title: _label(l10n, navigation),
                    value: !hideItems.contains(navigation),
                    onChanged: fixed
                        ? null
                        : (value) {
                            final temp = hideItems.toList();
                            if (!value && !hideItems.contains(navigation)) {
                              temp.add(navigation);
                            } else if (value) {
                              temp.remove(navigation);
                            }
                            ref.read(hideItemsStateProvider.notifier).set(temp);
                          },
                  ),
                ),
              ],
            );
          },
          onReorderItem: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              final draggedItem = navigationOrder[oldIndex];
              for (var i = oldIndex; i < newIndex - 1; i++) {
                navigationOrder[i] = navigationOrder[i + 1];
              }
              navigationOrder[newIndex - 1] = draggedItem;
            } else {
              final draggedItem = navigationOrder[oldIndex];
              for (var i = oldIndex; i > newIndex; i--) {
                navigationOrder[i] = navigationOrder[i - 1];
              }
              navigationOrder[newIndex] = draggedItem;
            }
            ref
                .read(navigationOrderStateProvider.notifier)
                .set(navigationOrder);
          },
        ),
      ),
    );
  }
}

/// The destination's name in the reader's language.
String _label(AppLocalizations l10n, String route) => switch (route) {
  "/MangaLibrary" => l10n.manga,
  "/AnimeLibrary" => l10n.anime,
  "/NovelLibrary" => l10n.novel,
  "/updates" => l10n.updates,
  "/history" => l10n.history,
  "/browse" => l10n.browse,
  "/more" => l10n.more,
  "/trackerLibrary" => l10n.tracking,
  _ => navigationItems[route] ?? route,
};

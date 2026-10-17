import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/download_quick_menu.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// The detail page's app bar: the normal title/actions bar, or - while a
/// long-press has put the chapter list into multi-select - a count plus
/// select-all/invert-selection actions instead. One widget because which of
/// the two shows is itself reactive (isLongPressedStateProvider).
class DetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Manga manga;
  final ItemType itemType;
  final bool isLocalArchive;

  /// Every chapter currently shown, needed for "select all" - not
  /// derivable from a provider, it's whatever _buildWidget's own sort/filter
  /// pass produced for this build.
  final List<Chapter> chapters;

  final NotifierProvider<Notifier<double>, double> offsetProvider;
  final Future<void> Function(BuildContext context, List<Chapter> chapters)
  onDownload;
  final VoidCallback onShowFilterMenu;
  final Future<void> Function(int value) onOverflowAction;

  const DetailAppBar({
    super.key,
    required this.manga,
    required this.itemType,
    required this.isLocalArchive,
    required this.chapters,
    required this.offsetProvider,
    required this.onDownload,
    required this.onShowFilterMenu,
    required this.onOverflowAction,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final chapterList = ref.watch(chaptersListStateProvider);
    final checkCategoryList =
        ref
            .watch(getMangaCategorieStreamProvider(itemType: itemType))
            .asData
            ?.value
            .isNotEmpty ??
        false;
    final isNotFiltering = ref.watch(
      chapterFilterResultStateProvider(manga: manga),
    );

    return isLongPressed
        ? Container(
            color: context.shiori.color.ink0,
            child: AppBar(
              title: Text(context.l10n.n_selected(chapterList.length)),
              backgroundColor: context.shiori.color.accent.withValues(
                alpha: 0.2,
              ),
              leading: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () {
                  ref.read(chaptersListStateProvider.notifier).clear();
                  ref
                      .read(isLongPressedStateProvider.notifier)
                      .update(!isLongPressed);
                },
                icon: const Icon(Symbols.close_rounded),
              ),
              actions: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context)
                      .selectAllButtonLabel,
                  onPressed: () {
                    for (var chapter in chapters) {
                      ref
                          .read(chaptersListStateProvider.notifier)
                          .selectAll(chapter);
                    }
                  },
                  icon: const Icon(Symbols.select_all_rounded),
                ),
                IconButton(
                  tooltip: context.l10n.invert_selection,
                  onPressed: () {
                    if (chapters.length == chapterList.length) {
                      for (var chapter in chapters) {
                        ref
                            .read(chaptersListStateProvider.notifier)
                            .selectSome(chapter);
                      }
                      ref
                          .read(isLongPressedStateProvider.notifier)
                          .update(false);
                    } else {
                      for (var chapter in chapters) {
                        ref
                            .read(chaptersListStateProvider.notifier)
                            .selectSome(chapter);
                      }
                    }
                  },
                  icon: const Icon(Symbols.flip_to_back_rounded),
                ),
              ],
            ),
          )
        : AppBar(
            title: ref.watch(offsetProvider.select((val) => val > 200))
                ? Text(
                    manga.name!,
                    style: context.shiori.text.section.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  )
                : null,
            backgroundColor:
                ref.watch(offsetProvider.select((val) => val == 0.0))
                ? Colors.transparent
                : context.shiori.color.ink0,
            actions: [
              // Downloads are hidden on TV.
              if (!isLocalArchive && !isTv) ...[
                DownloadQuickMenu(
                  itemType: itemType,
                  manga: manga,
                  onDownload: onDownload,
                ),
              ],
              IconButton(
                tooltip: context.l10n.filter,
                splashRadius: 20,
                onPressed: onShowFilterMenu,
                icon: Icon(
                  Symbols.filter_list_rounded,
                  fill: isNotFiltering ? 0 : 1,
                  color: isNotFiltering ? null : context.shiori.color.accentInk,
                ),
              ),
              // The menu's items are conditional, so its values
              // are not its indices: keep label and value paired so
              // the centred TV menu cannot fire the wrong action.
              if (isTv)
                Builder(
                  builder: (context) {
                    final entries = <(String, int)>[
                      if (!isLocalArchive) (l10n.refresh, 0),
                      if (manga.favorite! && checkCategoryList)
                        (l10n.set_categories, 1),
                      if (!isLocalArchive) (l10n.share, 2),
                      (l10n.migrate, 3),
                      (l10n.mass_migration_title, 6),
                      if (!isLocalArchive) (l10n.extension_settings, 4),
                      (l10n.export_metadata, 5),
                    ];
                    return IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .moreButtonTooltip,
                      icon: const Icon(Symbols.more_vert_rounded),
                      onPressed: () async {
                        final picked = await showTvMenu(
                          context,
                          title: manga.name ?? '',
                          options: [
                            for (final e in entries) TvMenuOption(e.$1),
                          ],
                        );
                        if (picked != null) {
                          await onOverflowAction(entries[picked].$2);
                        }
                      },
                    );
                  },
                )
              else
                ShioriMenuButton(
                  tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
                  items: [
                    if (!isLocalArchive)
                      ShioriMenuItem(
                        label: l10n.refresh,
                        icon: Symbols.refresh_rounded,
                        onSelected: () => onOverflowAction(0),
                      ),
                    if (manga.favorite! && checkCategoryList)
                      ShioriMenuItem(
                        label: l10n.set_categories,
                        icon: Symbols.label_rounded,
                        onSelected: () => onOverflowAction(1),
                      ),
                    if (!isLocalArchive)
                      ShioriMenuItem(
                        label: l10n.share,
                        icon: Symbols.share_rounded,
                        onSelected: () => onOverflowAction(2),
                      ),
                    null,
                    ShioriMenuItem(
                      label: l10n.migrate,
                      icon: Symbols.swap_horiz_rounded,
                      onSelected: () => onOverflowAction(3),
                    ),
                    ShioriMenuItem(
                      label: l10n.mass_migration_title,
                      icon: Symbols.move_up_rounded,
                      onSelected: () => onOverflowAction(6),
                    ),
                    null,
                    if (!isLocalArchive)
                      ShioriMenuItem(
                        label: l10n.extension_settings,
                        icon: Symbols.extension_rounded,
                        onSelected: () => onOverflowAction(4),
                      ),
                    ShioriMenuItem(
                      label: l10n.export_metadata,
                      icon: Symbols.ios_share_rounded,
                      onSelected: () => onOverflowAction(5),
                    ),
                  ],
                ),
            ],
          );
  }
}

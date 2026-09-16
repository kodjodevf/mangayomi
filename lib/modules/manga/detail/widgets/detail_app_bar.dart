import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/download_quick_menu.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
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
            color: Theme.of(context).scaffoldBackgroundColor,
            child: AppBar(
              title: Text(chapterList.length.toString()),
              backgroundColor: context.primaryColor.withValues(alpha: 0.2),
              leading: IconButton(
                onPressed: () {
                  ref.read(chaptersListStateProvider.notifier).clear();
                  ref
                      .read(isLongPressedStateProvider.notifier)
                      .update(!isLongPressed);
                },
                icon: const Icon(Icons.clear),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    for (var chapter in chapters) {
                      ref.read(chaptersListStateProvider.notifier).selectAll(chapter);
                    }
                  },
                  icon: const Icon(Icons.select_all),
                ),
                IconButton(
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
                  icon: const Icon(Icons.flip_to_back_rounded),
                ),
              ],
            ),
          )
        : AppBar(
            title: ref.watch(offsetProvider.select((val) => val > 200))
                ? Text(manga.name!, style: const TextStyle(fontSize: 17))
                : null,
            backgroundColor:
                ref.watch(offsetProvider.select((val) => val == 0.0))
                ? Colors.transparent
                : Theme.of(context).scaffoldBackgroundColor,
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
                splashRadius: 20,
                onPressed: onShowFilterMenu,
                icon: Icon(
                  Icons.filter_list_sharp,
                  color: isNotFiltering ? null : Colors.yellow,
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
                      icon: const Icon(Icons.more_vert),
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
                PopupMenuButton(
                  popUpAnimationStyle: popupAnimationStyle,
                  itemBuilder: (context) {
                    return [
                      if (!isLocalArchive)
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text(l10n.refresh),
                        ),
                      if (manga.favorite! && checkCategoryList)
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text(l10n.set_categories),
                        ),
                      if (!isLocalArchive)
                        PopupMenuItem<int>(
                          value: 2,
                          child: Text(l10n.share),
                        ),
                      PopupMenuItem<int>(
                        value: 3,
                        child: Text(l10n.migrate),
                      ),
                      PopupMenuItem<int>(
                        value: 6,
                        child: Text(l10n.mass_migration_title),
                      ),
                      if (!isLocalArchive)
                        PopupMenuItem<int>(
                          value: 4,
                          child: Text(l10n.extension_settings),
                        ),
                      PopupMenuItem<int>(
                        value: 5,
                        child: Text(l10n.export_metadata),
                      ),
                    ];
                  },
                  onSelected: onOverflowAction,
                ),
            ],
          );
  }
}

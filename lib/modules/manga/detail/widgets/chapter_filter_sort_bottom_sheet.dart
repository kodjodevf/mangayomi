import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

void showChapterFilterSortBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required Manga manga,
  required ItemType itemType,
  required bool isLocalArchive,
  required TickerProvider vsync,
}) {
  final scanlators = ref.read(scanlatorsFilterStateProvider(manga));
  final l10n = l10nLocalizations(context)!;
  customDraggableTabBar(
    tabs: [
      Tab(text: l10n.filter),
      Tab(text: l10n.sort),
      Tab(text: l10n.display),
    ],
    children: [
      Consumer(
        builder: (context, ref, child) {
          return Column(
            children: [
              if (!isLocalArchive)
                ListTileChapterFilter(
                  label: l10n.downloaded,
                  type: ref.watch(
                    chapterFilterDownloadedStateProvider(mangaId: manga.id!),
                  ),
                  onTap: () {
                    ref
                        .read(
                          chapterFilterDownloadedStateProvider(
                            mangaId: manga.id!,
                          ).notifier,
                        )
                        .update();
                  },
                ),
              ListTileChapterFilter(
                label: itemType != ItemType.anime
                    ? l10n.unread
                    : l10n.unwatched,
                type: ref.watch(
                  chapterFilterUnreadStateProvider(mangaId: manga.id!),
                ),
                onTap: () {
                  ref
                      .read(
                        chapterFilterUnreadStateProvider(mangaId: manga.id!)
                            .notifier,
                      )
                      .update();
                },
              ),
              ListTileChapterFilter(
                label: l10n.bookmarked,
                type: ref.watch(
                  chapterFilterBookmarkedStateProvider(mangaId: manga.id!),
                ),
                onTap: () {
                  ref
                      .read(
                        chapterFilterBookmarkedStateProvider(mangaId: manga.id!)
                            .notifier,
                      )
                      .update();
                },
              ),
              if (scanlators.$1.isNotEmpty)
                ShioriSettingRow(
                  icon: Symbols.group_rounded,
                  title: l10n.filter_scanlator_groups,
                  subtitle: scanlators.$2.isEmpty
                      ? null
                      : '${scanlators.$1.length - scanlators.$2.length} / ${scanlators.$1.length}',
                  onTap: () async {
                    // Ticked is shown; what is stored is what is left out.
                    final shown = await showShioriMultiChoice<String>(
                      context,
                      title: l10n.filter_scanlator_groups,
                      confirmLabel: l10n.filter,
                      selected: {
                        for (final g in scanlators.$1)
                          if (!scanlators.$2.contains(g)) g,
                      },
                      options: [
                        for (final g in scanlators.$1) ShioriChoice(g, g),
                      ],
                    );
                    if (shown == null) return;
                    ref.read(scanlatorsFilterStateProvider(manga).notifier).set(
                      [
                        for (final g in scanlators.$1)
                          if (!shown.contains(g)) g,
                      ],
                    );
                  },
                ),
            ],
          );
        },
      ),
      Consumer(
        builder: (context, ref, chil) {
          final reverse = ref
              .read(sortChapterStateProvider(mangaId: manga.id!).notifier)
              .isReverse();
          final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));
          final reverseChapter = ref.watch(
            sortChapterStateProvider(mangaId: manga.id!),
          );
          return Column(
            children: [
              if (scanlators.$1.isNotEmpty)
                ListTileChapterSort(
                  label: _getSortNameByIndex(0, context, itemType),
                  reverse: reverse,
                  onTap: () {
                    ref
                        .read(
                          sortChapterStateProvider(mangaId: manga.id!).notifier,
                        )
                        .set(0);
                  },
                  showLeading: reverseChapter.index == 0,
                ),
              for (var i = 1; i < 4; i++)
                ListTileChapterSort(
                  label: _getSortNameByIndex(i, context, itemType),
                  reverse: reverse,
                  onTap: () {
                    ref
                        .read(
                          sortChapterStateProvider(mangaId: manga.id!).notifier,
                        )
                        .set(i);
                  },
                  showLeading: reverseChapter.index == i,
                ),
            ],
          );
        },
      ),
      // How each chapter is named in the list: as the source titles it,
      // or by its number.
      Consumer(
        builder: (context, ref, _) {
          final byNumber = ref.watch(
            chapterNumberDisplayProvider.select(
              (ids) => ids.contains(manga.id),
            ),
          );
          void set(bool value) => ref
              .read(chapterNumberDisplayProvider.notifier)
              .set(manga.id!, byNumber: value);
          return Column(
            children: [
              ChapterDisplayChoiceRow(
                label: l10n.source_title,
                selected: !byNumber,
                onTap: () => set(false),
              ),
              ChapterDisplayChoiceRow(
                label: itemType != ItemType.anime
                    ? l10n.chapter_number
                    : l10n.episode_number,
                selected: byNumber,
                onTap: () => set(true),
              ),
            ],
          );
        },
      ),
    ],
    context: context,
    vsync: vsync,
  );
}

String _getSortNameByIndex(int index, BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  if (index == 0) {
    return l10n.by_scanlator;
  } else if (index == 1) {
    return itemType != ItemType.anime
        ? l10n.by_chapter_number
        : l10n.by_episode_number;
  } else if (index == 2) {
    return l10n.by_upload_date;
  }
  return l10n.by_name;
}

/// One choice of the Display tab, laid out as the Filter tab's rows: the
/// same inset, height and icon size, with a radio mark for the checkbox.
/// Material's radio tiles sat further in than the rows beside them.
class ChapterDisplayChoiceRow extends StatelessWidget {
  const ChapterDisplayChoiceRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    return MergeSemantics(
      child: Semantics(
        checked: selected,
        inMutuallyExclusiveGroup: true,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            dense: true,
            minTileHeight: tokens.density.minTarget,
            leading: Icon(
              selected
                  ? Symbols.radio_button_checked_rounded
                  : Symbols.radio_button_unchecked_rounded,
              color: selected ? c.accentInk : c.fgMuted,
              size: tokens.scaled(24),
            ),
            title: Text(label, style: tokens.text.row.copyWith(color: c.fg)),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

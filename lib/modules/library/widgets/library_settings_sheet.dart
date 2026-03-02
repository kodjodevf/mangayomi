import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Shows the library filter/sort/display settings sheet.
void showLibrarySettingsSheet({
  required BuildContext context,
  required TickerProvider vsync,
  required Settings settings,
  required ItemType itemType,
  required List<Manga> entries,
}) {
  final l10n = l10nLocalizations(context)!;
  customDraggableTabBar(
    tabs: [
      Tab(text: l10n.filter),
      Tab(text: l10n.sort),
      Tab(text: l10n.display),
    ],
    children: [
      _FilterTab(itemType: itemType, settings: settings, entries: entries),
      _SortTab(itemType: itemType, settings: settings),
      _DisplayTab(itemType: itemType, settings: settings),
    ],
    context: context,
    vsync: vsync,
  );
}

// ─── Filter Tab ───────────────────────────────────────────────────────────────

class _FilterTab extends ConsumerWidget {
  final ItemType itemType;
  final Settings settings;
  final List<Manga> entries;

  const _FilterTab({
    required this.itemType,
    required this.settings,
    required this.entries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Column(
      children: [
        ListTileChapterFilter(
          label: l10n.downloaded,
          type: ref.watch(
            mangaFilterDownloadedStateProvider(
              itemType: itemType,
              mangaList: entries,
              settings: settings,
            ),
          ),
          onTap: () {
            ref
                .read(
                  mangaFilterDownloadedStateProvider(
                    itemType: itemType,
                    mangaList: entries,
                    settings: settings,
                  ).notifier,
                )
                .update();
          },
        ),
        ListTileChapterFilter(
          label: itemType != ItemType.anime ? l10n.unread : l10n.unwatched,
          type: ref.watch(
            mangaFilterUnreadStateProvider(
              itemType: itemType,
              mangaList: entries,
              settings: settings,
            ),
          ),
          onTap: () {
            ref
                .read(
                  mangaFilterUnreadStateProvider(
                    itemType: itemType,
                    mangaList: entries,
                    settings: settings,
                  ).notifier,
                )
                .update();
          },
        ),
        ListTileChapterFilter(
          label: l10n.started,
          type: ref.watch(
            mangaFilterStartedStateProvider(
              itemType: itemType,
              mangaList: entries,
              settings: settings,
            ),
          ),
          onTap: () {
            ref
                .read(
                  mangaFilterStartedStateProvider(
                    itemType: itemType,
                    mangaList: entries,
                    settings: settings,
                  ).notifier,
                )
                .update();
          },
        ),
        ListTileChapterFilter(
          label: l10n.bookmarked,
          type: ref.watch(
            mangaFilterBookmarkedStateProvider(
              itemType: itemType,
              mangaList: entries,
              settings: settings,
            ),
          ),
          onTap: () {
            ref
                .read(
                  mangaFilterBookmarkedStateProvider(
                    itemType: itemType,
                    mangaList: entries,
                    settings: settings,
                  ).notifier,
                )
                .update();
          },
        ),
      ],
    );
  }
}

// ─── Sort Tab ─────────────────────────────────────────────────────────────────

class _SortTab extends ConsumerWidget {
  final ItemType itemType;
  final Settings settings;

  const _SortTab({required this.itemType, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reverse = ref
        .read(
          sortLibraryMangaStateProvider(
            itemType: itemType,
            settings: settings,
          ).notifier,
        )
        .isReverse();
    final reverseChapter = ref.watch(
      sortLibraryMangaStateProvider(itemType: itemType, settings: settings),
    );
    return Column(
      children: [
        for (var i = 0; i < 7; i++)
          ListTileChapterSort(
            label: _getSortNameByIndex(i, context, itemType),
            reverse: reverse,
            onTap: () {
              ref
                  .read(
                    sortLibraryMangaStateProvider(
                      itemType: itemType,
                      settings: settings,
                    ).notifier,
                  )
                  .set(i);
            },
            showLeading: reverseChapter.index == i,
          ),
      ],
    );
  }
}

String _getSortNameByIndex(int index, BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  return switch (index) {
    0 => l10n.alphabetically,
    1 => itemType != ItemType.anime ? l10n.last_read : l10n.last_watched,
    2 => l10n.last_update_check,
    3 => itemType != ItemType.anime ? l10n.unread_count : l10n.unwatched_count,
    4 => itemType != ItemType.anime ? l10n.total_chapters : l10n.total_episodes,
    5 => itemType != ItemType.anime ? l10n.latest_chapter : l10n.latest_episode,
    _ => l10n.date_added,
  };
}

// ─── Display Tab ──────────────────────────────────────────────────────────────

class _DisplayTab extends ConsumerWidget {
  final ItemType itemType;
  final Settings settings;

  const _DisplayTab({required this.itemType, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final display = ref.watch(
      libraryDisplayTypeStateProvider(itemType: itemType, settings: settings),
    );
    final displayV = ref.read(
      libraryDisplayTypeStateProvider(
        itemType: itemType,
        settings: settings,
      ).notifier,
    );
    final showCategoryTabs = ref.watch(
      libraryShowCategoryTabsStateProvider(
        itemType: itemType,
        settings: settings,
      ),
    );
    final continueReaderBtn = ref.watch(
      libraryShowContinueReadingButtonStateProvider(
        itemType: itemType,
        settings: settings,
      ),
    );
    final showNumbersOfItems = ref.watch(
      libraryShowNumbersOfItemsStateProvider(
        itemType: itemType,
        settings: settings,
      ),
    );
    final downloadedChapter = ref.watch(
      libraryDownloadedChaptersStateProvider(
        itemType: itemType,
        settings: settings,
      ),
    );
    final language = ref.watch(
      libraryLanguageStateProvider(itemType: itemType, settings: settings),
    );
    final localSource = ref.watch(
      libraryLocalSourceStateProvider(itemType: itemType, settings: settings),
    );
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display mode
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(children: [Text(l10n.display_mode)]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Wrap(
              children: DisplayType.values.map((e) {
                final selected = e == display;
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: selected
                          ? null
                          : BorderSide(
                              color: context.isLight
                                  ? Colors.black
                                  : Colors.white,
                              width: 0.8,
                            ),
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      backgroundColor: selected
                          ? context.primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                    ),
                    onPressed: () {
                      displayV.setLibraryDisplayType(e);
                    },
                    child: Text(
                      displayV.getLibraryDisplayTypeName(e, context),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Grid size
          _GridSizeSlider(itemType: itemType),

          // Badges section
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(children: [Text(l10n.badges)]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                ListTileChapterFilter(
                  label: itemType != ItemType.anime
                      ? l10n.downloaded_chapters
                      : l10n.downloaded_episodes,
                  type: downloadedChapter ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryDownloadedChaptersStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!downloadedChapter);
                  },
                ),
                ListTileChapterFilter(
                  label: l10n.language,
                  type: language ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryLanguageStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!language);
                  },
                ),
                ListTileChapterFilter(
                  label: l10n.local_source,
                  type: localSource ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryLocalSourceStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!localSource);
                  },
                ),
                ListTileChapterFilter(
                  label: itemType != ItemType.anime
                      ? l10n.show_continue_reading_buttons
                      : l10n.show_continue_watching_buttons,
                  type: continueReaderBtn ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryShowContinueReadingButtonStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!continueReaderBtn);
                  },
                ),
              ],
            ),
          ),

          // Tabs section
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(children: [Text(l10n.tabs)]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                ListTileChapterFilter(
                  label: l10n.show_category_tabs,
                  type: showCategoryTabs ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryShowCategoryTabsStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!showCategoryTabs);
                  },
                ),
                ListTileChapterFilter(
                  label: l10n.show_numbers_of_items,
                  type: showNumbersOfItems ? 1 : 0,
                  onTap: () {
                    ref
                        .read(
                          libraryShowNumbersOfItemsStateProvider(
                            itemType: itemType,
                            settings: settings,
                          ).notifier,
                        )
                        .set(!showNumbersOfItems);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Grid Size Slider ─────────────────────────────────────────────────────────

class _GridSizeSlider extends ConsumerWidget {
  final ItemType itemType;
  const _GridSizeSlider({required this.itemType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridSize =
        ref.watch(libraryGridSizeStateProvider(itemType: itemType)) ?? 0;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(context.l10n.grid_size),
                Text(
                  gridSize == 0
                      ? context.l10n.default0
                      : context.l10n.n_per_row(gridSize.toString()),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 7,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
              ),
              child: Slider(
                min: 0.0,
                max: 7,
                divisions: 7,
                value: gridSize.toDouble(),
                onChanged: (value) {
                  HapticFeedback.vibrate();
                  ref
                      .read(
                        libraryGridSizeStateProvider(
                          itemType: itemType,
                        ).notifier,
                      )
                      .set(value.toInt());
                },
                onChangeEnd: (value) {
                  ref
                      .read(
                        libraryGridSizeStateProvider(
                          itemType: itemType,
                        ).notifier,
                      )
                      .set(value.toInt(), end: true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

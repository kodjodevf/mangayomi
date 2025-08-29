// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/providers/add_torrent.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:path/path.dart' as p;

class LibraryScreen extends ConsumerStatefulWidget {
  final ItemType itemType;
  final String? presetInput;
  const LibraryScreen({
    required this.itemType,
    required this.presetInput,
    super.key,
  });

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool _isSearch = false;
  final List<Manga> _entries = [];
  final _textEditingController = TextEditingController();
  TabController? tabBarController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.presetInput != null) {
      _isSearch = true;
      _textEditingController.text = widget.presetInput!;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    tabBarController?.dispose();
    super.dispose();
  }

  Future<void> _updateLibrary(List<Manga> mangaList) async {
    bool isDark = ref.read(themeModeStateProvider);
    botToast(
      context.l10n.updating_library("0", "0", "0"),
      fontSize: 13,
      second: 30,
      alignY: !context.isTablet ? 0.85 : 1,
      themeDark: isDark,
    );
    int numbers = 0;
    int failed = 0;
    for (var manga in mangaList) {
      try {
        await ref.read(
          updateMangaDetailProvider(mangaId: manga.id, isInit: false).future,
        );
      } catch (_) {
        failed++;
      }
      numbers++;
      if (context.mounted) {
        botToast(
          context.l10n.updating_library(numbers, failed, mangaList.length),
          fontSize: 13,
          second: 10,
          alignY: !context.isTablet ? 0.85 : 1,
          animationDuration: 0,
          dismissDirections: [DismissDirection.none],
          onlyOne: false,
          themeDark: isDark,
        );
      }
    }
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mangaList.length == numbers) {
        return false;
      }
      return true;
    });
    BotToast.cleanAll();
  }

  @override
  Widget build(BuildContext context) {
    final settingsStream = ref.watch(getSettingsStreamProvider);
    return settingsStream.when(
      data: (settingsList) {
        final settings = settingsList.first;

        final categories = ref.watch(
          getMangaCategorieStreamProvider(itemType: widget.itemType),
        );
        final withoutCategories = ref.watch(
          getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType),
        );
        final downloadedOnly = ref.watch(downloadedOnlyStateProvider);
        final mangaAll = ref.watch(
          getAllMangaStreamProvider(
            categoryId: null,
            itemType: widget.itemType,
          ),
        );
        T watchWithSettings<T>(
          ProviderListenable<T> Function({
            required ItemType itemType,
            required Settings settings,
          })
          providerFn,
        ) {
          return ref.watch(
            providerFn(itemType: widget.itemType, settings: settings),
          );
        }

        T watchWithSettingsAndManga<T>(
          ProviderListenable<T> Function({
            required ItemType itemType,
            required List<Manga> mangaList,
            required Settings settings,
          })
          providerFn,
        ) {
          return ref.watch(
            providerFn(
              itemType: widget.itemType,
              mangaList: _entries,
              settings: settings,
            ),
          );
        }

        final showCategoryTabs = watchWithSettings(
          libraryShowCategoryTabsStateProvider.call,
        );

        final l10n = l10nLocalizations(context)!;
        return Scaffold(
          body: mangaAll.when(
            data: (man) {
              return withoutCategories.when(
                data: (withoutCategory) {
                  return categories.when(
                    data: (data) {
                      bool reverse = watchWithSettings(
                        sortLibraryMangaStateProvider.call,
                      ).reverse!;
                      final continueReaderBtn = watchWithSettings(
                        libraryShowContinueReadingButtonStateProvider.call,
                      );
                      final showNumbersOfItems = watchWithSettings(
                        libraryShowNumbersOfItemsStateProvider.call,
                      );
                      final localSource = watchWithSettings(
                        libraryLocalSourceStateProvider.call,
                      );
                      final downloadedChapter = watchWithSettings(
                        libraryDownloadedChaptersStateProvider.call,
                      );
                      final language = watchWithSettings(
                        libraryLanguageStateProvider.call,
                      );
                      final displayType = watchWithSettings(
                        libraryDisplayTypeStateProvider.call,
                      );
                      final isNotFiltering = watchWithSettingsAndManga(
                        mangasFilterResultStateProvider.call,
                      );
                      final downloadFilterType = watchWithSettingsAndManga(
                        mangaFilterDownloadedStateProvider.call,
                      );
                      final unreadFilterType = watchWithSettingsAndManga(
                        mangaFilterUnreadStateProvider.call,
                      );
                      final startedFilterType = watchWithSettingsAndManga(
                        mangaFilterStartedStateProvider.call,
                      );
                      final bookmarkedFilterType = watchWithSettingsAndManga(
                        mangaFilterBookmarkedStateProvider.call,
                      );
                      final sortType =
                          watchWithSettings(
                                sortLibraryMangaStateProvider.call,
                              ).index
                              as int;

                      if (data.isNotEmpty && showCategoryTabs) {
                        data.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));

                        final entr = data
                            .where((e) => !(e.hide ?? false))
                            .toList();
                        int tabCount = withoutCategory.isNotEmpty
                            ? entr.length + 1
                            : entr.length;
                        if (tabCount <= 0) {
                          return _bodyWithoutCategories(
                            withoutCategories: true,
                            downloadFilterType: downloadFilterType,
                            unreadFilterType: unreadFilterType,
                            startedFilterType: startedFilterType,
                            bookmarkedFilterType: bookmarkedFilterType,
                            reverse: reverse,
                            downloadedChapter: downloadedChapter,
                            continueReaderBtn: continueReaderBtn,
                            language: language,
                            displayType: displayType,
                            ref: ref,
                            localSource: localSource,
                            settings: settings,
                            downloadedOnly: downloadedOnly,
                          );
                        }
                        if (tabCount > 0 &&
                            (tabBarController == null ||
                                tabBarController!.length != tabCount)) {
                          int newTabIndex = _tabIndex;
                          if (newTabIndex >= tabCount) {
                            newTabIndex = tabCount - 1;
                          }
                          tabBarController?.dispose();
                          tabBarController = TabController(
                            length: tabCount,
                            vsync: this,
                            initialIndex: newTabIndex,
                          );
                          _tabIndex = newTabIndex;
                          tabBarController!.addListener(() {
                            setState(() {
                              _tabIndex = tabBarController!.index;
                            });
                          });
                        }

                        return Consumer(
                          builder: (context, ref, child) {
                            final numberOfItemsList = _filterAndSortManga(
                              data: man,
                              downloadFilterType: downloadFilterType,
                              unreadFilterType: unreadFilterType,
                              startedFilterType: startedFilterType,
                              bookmarkedFilterType: bookmarkedFilterType,
                              sortType: sortType,
                              downloadedOnly: downloadedOnly,
                            );
                            final withoutCategoryNumberOfItemsList =
                                _filterAndSortManga(
                                  data: withoutCategory,
                                  downloadFilterType: downloadFilterType,
                                  unreadFilterType: unreadFilterType,
                                  startedFilterType: startedFilterType,
                                  bookmarkedFilterType: bookmarkedFilterType,
                                  sortType: sortType,
                                  downloadedOnly: downloadedOnly,
                                );

                            return DefaultTabController(
                              length: entr.length,
                              child: Scaffold(
                                appBar: _appBar(
                                  isNotFiltering,
                                  showNumbersOfItems,
                                  numberOfItemsList.length,
                                  ref,
                                  [],
                                  true,
                                  withoutCategory.isNotEmpty && _tabIndex == 0
                                      ? null
                                      : entr[withoutCategory.isNotEmpty
                                                ? _tabIndex - 1
                                                : _tabIndex]
                                            .id!,
                                  settings,
                                ),
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TabBar(
                                      isScrollable: true,
                                      controller: tabBarController,
                                      tabs: [
                                        if (withoutCategory.isNotEmpty)
                                          for (
                                            var i = 0;
                                            i < entr.length + 1;
                                            i++
                                          )
                                            Row(
                                              children: [
                                                Tab(
                                                  text: i == 0
                                                      ? l10n.default0
                                                      : entr[i - 1].name,
                                                ),
                                                const SizedBox(width: 4),
                                                if (showNumbersOfItems)
                                                  i == 0
                                                      ? CircleAvatar(
                                                          backgroundColor:
                                                              Theme.of(
                                                                context,
                                                              ).focusColor,
                                                          radius: 8,
                                                          child: Text(
                                                            withoutCategoryNumberOfItemsList
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .color,
                                                            ),
                                                          ),
                                                        )
                                                      : _categoriesNumberOfItems(
                                                          downloadFilterType:
                                                              downloadFilterType,
                                                          unreadFilterType:
                                                              unreadFilterType,
                                                          startedFilterType:
                                                              startedFilterType,
                                                          bookmarkedFilterType:
                                                              bookmarkedFilterType,
                                                          reverse: reverse,
                                                          downloadedChapter:
                                                              downloadedChapter,
                                                          continueReaderBtn:
                                                              continueReaderBtn,
                                                          categoryId:
                                                              entr[i - 1].id!,
                                                          settings: settings,
                                                          downloadedOnly:
                                                              downloadedOnly,
                                                        ),
                                              ],
                                            ),
                                        if (withoutCategory.isEmpty)
                                          for (var i = 0; i < entr.length; i++)
                                            Row(
                                              children: [
                                                Tab(text: entr[i].name),
                                                const SizedBox(width: 4),
                                                if (showNumbersOfItems)
                                                  _categoriesNumberOfItems(
                                                    downloadFilterType:
                                                        downloadFilterType,
                                                    unreadFilterType:
                                                        unreadFilterType,
                                                    startedFilterType:
                                                        startedFilterType,
                                                    bookmarkedFilterType:
                                                        bookmarkedFilterType,
                                                    reverse: reverse,
                                                    downloadedChapter:
                                                        downloadedChapter,
                                                    continueReaderBtn:
                                                        continueReaderBtn,
                                                    categoryId: entr[i].id!,
                                                    settings: settings,
                                                    downloadedOnly:
                                                        downloadedOnly,
                                                  ),
                                              ],
                                            ),
                                      ],
                                    ),
                                    Flexible(
                                      child: TabBarView(
                                        controller: tabBarController,
                                        children: [
                                          if (withoutCategory.isNotEmpty)
                                            for (
                                              var i = 0;
                                              i < entr.length + 1;
                                              i++
                                            )
                                              i == 0
                                                  ? _bodyWithoutCategories(
                                                      withoutCategories: true,
                                                      downloadFilterType:
                                                          downloadFilterType,
                                                      unreadFilterType:
                                                          unreadFilterType,
                                                      startedFilterType:
                                                          startedFilterType,
                                                      bookmarkedFilterType:
                                                          bookmarkedFilterType,
                                                      reverse: reverse,
                                                      downloadedChapter:
                                                          downloadedChapter,
                                                      continueReaderBtn:
                                                          continueReaderBtn,
                                                      language: language,
                                                      displayType: displayType,
                                                      ref: ref,
                                                      localSource: localSource,
                                                      settings: settings,
                                                      downloadedOnly:
                                                          downloadedOnly,
                                                    )
                                                  : _bodyWithCatories(
                                                      categoryId:
                                                          entr[i - 1].id!,
                                                      downloadFilterType:
                                                          downloadFilterType,
                                                      unreadFilterType:
                                                          unreadFilterType,
                                                      startedFilterType:
                                                          startedFilterType,
                                                      bookmarkedFilterType:
                                                          bookmarkedFilterType,
                                                      reverse: reverse,
                                                      downloadedChapter:
                                                          downloadedChapter,
                                                      continueReaderBtn:
                                                          continueReaderBtn,
                                                      language: language,
                                                      displayType: displayType,
                                                      ref: ref,
                                                      localSource: localSource,
                                                      settings: settings,
                                                      downloadedOnly:
                                                          downloadedOnly,
                                                    ),
                                          if (withoutCategory.isEmpty)
                                            for (
                                              var i = 0;
                                              i < entr.length;
                                              i++
                                            )
                                              _bodyWithCatories(
                                                categoryId: entr[i].id!,
                                                downloadFilterType:
                                                    downloadFilterType,
                                                unreadFilterType:
                                                    unreadFilterType,
                                                startedFilterType:
                                                    startedFilterType,
                                                bookmarkedFilterType:
                                                    bookmarkedFilterType,
                                                reverse: reverse,
                                                downloadedChapter:
                                                    downloadedChapter,
                                                continueReaderBtn:
                                                    continueReaderBtn,
                                                language: language,
                                                displayType: displayType,
                                                ref: ref,
                                                localSource: localSource,
                                                settings: settings,
                                                downloadedOnly: downloadedOnly,
                                              ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Consumer(
                        builder: (context, ref, child) {
                          final numberOfItemsList = _filterAndSortManga(
                            data: man,
                            downloadFilterType: downloadFilterType,
                            unreadFilterType: unreadFilterType,
                            startedFilterType: startedFilterType,
                            bookmarkedFilterType: bookmarkedFilterType,
                            sortType: sortType,
                            downloadedOnly: downloadedOnly,
                          );
                          return Scaffold(
                            appBar: _appBar(
                              isNotFiltering,
                              showNumbersOfItems,
                              numberOfItemsList.length,
                              ref,
                              numberOfItemsList,
                              false,
                              null,
                              settings,
                            ),
                            body: _bodyWithoutCategories(
                              downloadFilterType: downloadFilterType,
                              unreadFilterType: unreadFilterType,
                              startedFilterType: startedFilterType,
                              bookmarkedFilterType: bookmarkedFilterType,
                              reverse: reverse,
                              downloadedChapter: downloadedChapter,
                              continueReaderBtn: continueReaderBtn,
                              language: language,
                              displayType: displayType,
                              ref: ref,
                              localSource: localSource,
                              settings: settings,
                              downloadedOnly: downloadedOnly,
                            ),
                          );
                        },
                      );
                    },
                    error: (Object error, StackTrace stackTrace) {
                      return ErrorText(error);
                    },
                    loading: () {
                      return const ProgressCenter();
                    },
                  );
                },
                error: (Object error, StackTrace stackTrace) {
                  return ErrorText(error);
                },
                loading: () {
                  return const ProgressCenter();
                },
              );
            },
            error: (Object error, StackTrace stackTrace) {
              return ErrorText(error);
            },
            loading: () {
              return const ProgressCenter();
            },
          ),
          bottomNavigationBar: Builder(
            builder: (context) {
              final mangaIds = ref.watch(mangasListStateProvider);
              final color = Theme.of(context).textTheme.bodyLarge!.color!;
              return BottomSelectBar(
                isVisible: ref.watch(isLongPressedStateProvider),
                actions: [
                  BottomSelectButton(
                    icon: Icon(Icons.label_outline_rounded, color: color),
                    onPressed: () {
                      final mangaIdsList = ref.watch(mangasListStateProvider);
                      final List<Manga> bulkMangas = mangaIdsList
                          .map((id) => isar.mangas.getSync(id)!)
                          .toList();
                      showCategorySelectionDialog(
                        context: context,
                        ref: ref,
                        itemType: widget.itemType,
                        bulkMangas: bulkMangas,
                      );
                    },
                  ),
                  BottomSelectButton(
                    icon: Icon(Icons.done_all_sharp, color: color),
                    onPressed: () {
                      ref
                          .read(
                            mangasSetIsReadStateProvider(
                              mangaIds: mangaIds,
                              markAsRead: true,
                            ).notifier,
                          )
                          .set();
                      ref.invalidate(
                        getAllMangaWithoutCategoriesStreamProvider(
                          itemType: widget.itemType,
                        ),
                      );
                      ref.invalidate(
                        getAllMangaStreamProvider(
                          categoryId: null,
                          itemType: widget.itemType,
                        ),
                      );
                    },
                  ),
                  BottomSelectButton(
                    icon: Icon(Icons.remove_done_sharp, color: color),
                    onPressed: () {
                      ref
                          .read(
                            mangasSetIsReadStateProvider(
                              mangaIds: mangaIds,
                              markAsRead: false,
                            ).notifier,
                          )
                          .set();
                      ref.invalidate(
                        getAllMangaWithoutCategoriesStreamProvider(
                          itemType: widget.itemType,
                        ),
                      );
                      ref.invalidate(
                        getAllMangaStreamProvider(
                          categoryId: null,
                          itemType: widget.itemType,
                        ),
                      );
                    },
                  ),
                  // BottomBarAction(
                  //   icon: Icon(Icons.download_outlined, color: color),
                  //   onPressed: () {}
                  // ),
                  BottomSelectButton(
                    icon: Icon(Icons.delete_outline_outlined, color: color),
                    onPressed: () => _deleteManga(),
                  ),
                ],
              );
            },
          ),
        );
      },
      error: (error, e) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    );
  }

  Widget _categoriesNumberOfItems({
    required int downloadFilterType,
    required int unreadFilterType,
    required int startedFilterType,
    required int bookmarkedFilterType,
    required bool reverse,
    required bool downloadedChapter,
    required bool continueReaderBtn,
    required int categoryId,
    required Settings settings,
    required bool downloadedOnly,
  }) {
    final mangas = ref.watch(
      getAllMangaStreamProvider(
        categoryId: categoryId,
        itemType: widget.itemType,
      ),
    );
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(
            itemType: widget.itemType,
            settings: settings,
          ),
        )
        .index;
    return mangas.when(
      data: (data) {
        final categoriNumberOfItemsList = _filterAndSortManga(
          data: data,
          downloadFilterType: downloadFilterType,
          unreadFilterType: unreadFilterType,
          startedFilterType: startedFilterType,
          bookmarkedFilterType: bookmarkedFilterType,
          sortType: sortType!,
          downloadedOnly: downloadedOnly,
        );
        return CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          radius: 8,
          child: Text(
            categoriNumberOfItemsList.length.toString(),
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    );
  }

  Widget _bodyWithCatories({
    required int categoryId,
    required int downloadFilterType,
    required int unreadFilterType,
    required int startedFilterType,
    required int bookmarkedFilterType,
    required bool reverse,
    required bool downloadedChapter,
    required bool continueReaderBtn,
    required bool localSource,
    required bool language,
    required WidgetRef ref,
    required DisplayType displayType,
    required Settings settings,
    required bool downloadedOnly,
  }) {
    final l10n = l10nLocalizations(context)!;
    final mangas = ref.watch(
      getAllMangaStreamProvider(
        categoryId: categoryId,
        itemType: widget.itemType,
      ),
    );
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(
            itemType: widget.itemType,
            settings: settings,
          ),
        )
        .index;
    final mangaIdsList = ref.watch(mangasListStateProvider);
    return Scaffold(
      body: mangas.when(
        data: (data) {
          final entries = _filterAndSortManga(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            sortType: sortType!,
            downloadedOnly: downloadedOnly,
          );
          if (entries.isNotEmpty) {
            final entriesManga = reverse ? entries.reversed.toList() : entries;
            return RefreshIndicator(
              onRefresh: () async {
                await _updateLibrary(data);
              },
              child: displayType == DisplayType.list
                  ? LibraryListViewWidget(
                      entriesManga: entriesManga,
                      continueReaderBtn: continueReaderBtn,
                      downloadedChapter: downloadedChapter,
                      language: language,
                      mangaIdsList: mangaIdsList,
                      localSource: localSource,
                    )
                  : LibraryGridViewWidget(
                      entriesManga: entriesManga,
                      isCoverOnlyGrid:
                          !(displayType == DisplayType.compactGrid),
                      isComfortableGrid:
                          displayType == DisplayType.comfortableGrid,
                      continueReaderBtn: continueReaderBtn,
                      downloadedChapter: downloadedChapter,
                      language: language,
                      mangaIdsList: mangaIdsList,
                      localSource: localSource,
                      itemType: widget.itemType,
                    ),
            );
          }
          return Center(child: Text(l10n.empty_library));
        },
        error: (Object error, StackTrace stackTrace) {
          return ErrorText(error);
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
    );
  }

  Widget _bodyWithoutCategories({
    required int downloadFilterType,
    required int unreadFilterType,
    required int startedFilterType,
    required int bookmarkedFilterType,
    required bool reverse,
    required bool downloadedChapter,
    required bool continueReaderBtn,
    required bool localSource,
    required bool language,
    required DisplayType displayType,
    required WidgetRef ref,
    bool withoutCategories = false,
    required Settings settings,
    required bool downloadedOnly,
  }) {
    final sortType = ref
        .watch(
          sortLibraryMangaStateProvider(
            itemType: widget.itemType,
            settings: settings,
          ),
        )
        .index;
    final manga = withoutCategories
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(
              itemType: widget.itemType,
            ),
          )
        : ref.watch(
            getAllMangaStreamProvider(
              categoryId: null,
              itemType: widget.itemType,
            ),
          );
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final l10n = l10nLocalizations(context)!;
    return manga.when(
      data: (data) {
        final entries = _filterAndSortManga(
          data: data,
          downloadFilterType: downloadFilterType,
          unreadFilterType: unreadFilterType,
          startedFilterType: startedFilterType,
          bookmarkedFilterType: bookmarkedFilterType,
          sortType: sortType ?? 0,
          downloadedOnly: downloadedOnly,
        );
        if (entries.isNotEmpty) {
          final entriesManga = reverse ? entries.reversed.toList() : entries;
          return RefreshIndicator(
            onRefresh: () async {
              await _updateLibrary(data);
            },
            child: displayType == DisplayType.list
                ? LibraryListViewWidget(
                    entriesManga: entriesManga,
                    continueReaderBtn: continueReaderBtn,
                    downloadedChapter: downloadedChapter,
                    language: language,
                    mangaIdsList: mangaIdsList,
                    localSource: localSource,
                  )
                : LibraryGridViewWidget(
                    entriesManga: entriesManga,
                    isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                    isComfortableGrid:
                        displayType == DisplayType.comfortableGrid,
                    continueReaderBtn: continueReaderBtn,
                    downloadedChapter: downloadedChapter,
                    language: language,
                    mangaIdsList: mangaIdsList,
                    localSource: localSource,
                    itemType: widget.itemType,
                  ),
          );
        }
        return Center(child: Text(l10n.empty_library));
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    );
  }

  bool matchesSearchQuery(Manga manga, String query) {
    final keywords = query
        .toLowerCase()
        .split(',')
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty);

    return keywords.any(
      (keyword) =>
          (manga.name?.toLowerCase().contains(keyword) ?? false) ||
          (manga.source?.toLowerCase().contains(keyword) ?? false) ||
          (manga.genre?.any((g) => g.toLowerCase().contains(keyword)) ?? false),
    );
  }

  List<Manga> _filterAndSortManga({
    required List<Manga> data,
    required int downloadFilterType,
    required int unreadFilterType,
    required int startedFilterType,
    required int bookmarkedFilterType,
    required int sortType,
    bool downloadedOnly = false,
  }) {
    List<Manga>? mangas;
    final searchQuery = _textEditingController.text;
    // Skip all filters, just do search
    if (searchQuery.isNotEmpty && _ignoreFiltersOnSearch) {
      mangas = data
          .where((element) => matchesSearchQuery(element, searchQuery))
          .toList();
    } else {
      // Apply filters + search
      mangas = data
          .where((element) {
            // Filter by download
            List list = [];
            if (downloadFilterType == 1 || downloadedOnly) {
              for (var chap in element.chapters) {
                final modelChapDownload = isar.downloads
                    .filter()
                    .idEqualTo(chap.id)
                    .findAllSync();

                if (modelChapDownload.isNotEmpty &&
                    modelChapDownload.first.isDownload == true) {
                  list.add(true);
                }
              }
              return list.isNotEmpty;
            } else if (downloadFilterType == 2) {
              for (var chap in element.chapters) {
                final modelChapDownload = isar.downloads
                    .filter()
                    .idEqualTo(chap.id)
                    .findAllSync();
                if (!(modelChapDownload.isNotEmpty &&
                    modelChapDownload.first.isDownload == true)) {
                  list.add(true);
                }
              }
              return list.length == element.chapters.length;
            }
            return true;
          })
          .where((element) {
            // Filter by unread or started
            List list = [];
            if (unreadFilterType == 1 || startedFilterType == 1) {
              for (var chap in element.chapters) {
                if (!chap.isRead!) {
                  list.add(true);
                }
              }
              return list.isNotEmpty;
            } else if (unreadFilterType == 2 || startedFilterType == 2) {
              List list = [];
              for (var chap in element.chapters) {
                if (chap.isRead!) {
                  list.add(true);
                }
              }
              return list.length == element.chapters.length;
            }
            return true;
          })
          .where((element) {
            // Filter by bookmarked
            List list = [];
            if (bookmarkedFilterType == 1) {
              for (var chap in element.chapters) {
                if (chap.isBookmarked!) {
                  list.add(true);
                }
              }
              return list.isNotEmpty;
            } else if (bookmarkedFilterType == 2) {
              List list = [];
              for (var chap in element.chapters) {
                if (!chap.isBookmarked!) {
                  list.add(true);
                }
              }
              return list.length == element.chapters.length;
            }
            return true;
          })
          .where(
            (element) => searchQuery.isNotEmpty
                ? matchesSearchQuery(element, searchQuery)
                : true,
          )
          .toList();
    }
    // Sorting the data based on selected sort type
    mangas.sort((a, b) {
      switch (sortType) {
        case 0:
          return a.name!.compareTo(b.name!);
        case 1:
          return a.lastRead!.compareTo(b.lastRead!);
        case 2:
          return a.lastUpdate?.compareTo(b.lastUpdate ?? 0) ?? 0;
        case 3:
          return a.chapters
              .where((e) => !e.isRead!)
              .length
              .compareTo(b.chapters.where((e) => !e.isRead!).length);
        case 4:
          return a.chapters.length.compareTo(b.chapters.length);
        case 5:
          return (a.chapters.lastOrNull?.dateUpload ?? "").compareTo(
            b.chapters.lastOrNull?.dateUpload ?? "",
          );
        case 6:
          return a.dateAdded?.compareTo(b.dateAdded ?? 0) ?? 0;
        default:
          return 0;
      }
    });
    return mangas;
  }

  void _deleteManga() {
    List<int> fromLibList = [];
    List<int> downloadedChapsList = [];
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final l10n = l10nLocalizations(context)!;
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(l10n.remove),
                  content: SizedBox(
                    height: 100,
                    width: context.width(0.8),
                    child: Column(
                      children: [
                        ListTileChapterFilter(
                          label: l10n.from_library,
                          onTap: () {
                            setState(() {
                              if (fromLibList == mangaIdsList) {
                                fromLibList = [];
                              } else {
                                fromLibList = mangaIdsList;
                              }
                            });
                          },
                          type: fromLibList.isNotEmpty ? 1 : 0,
                        ),
                        ListTileChapterFilter(
                          label: widget.itemType != ItemType.anime
                              ? l10n.downloaded_chapters
                              : l10n.downloaded_episodes,
                          onTap: () {
                            setState(() {
                              if (downloadedChapsList == mangaIdsList) {
                                downloadedChapsList = [];
                              } else {
                                downloadedChapsList = mangaIdsList;
                              }
                            });
                          },
                          type: downloadedChapsList.isNotEmpty ? 1 : 0,
                        ),
                      ],
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
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          onPressed: () async {
                            // From Library
                            if (fromLibList.isNotEmpty) {
                              isar.writeTxnSync(() {
                                for (var manga in mangasList) {
                                  if (manga.isLocalArchive ?? false) {
                                    _removeImport(ref, manga);
                                  } else {
                                    manga.favorite = false;
                                    manga.updatedAt =
                                        DateTime.now().millisecondsSinceEpoch;
                                    isar.mangas.putSync(manga);
                                  }
                                }
                              });
                            }
                            // Downloaded Chapters
                            if (downloadedChapsList.isNotEmpty) {
                              for (var manga in mangasList) {
                                String mangaDirectory = "";
                                if (manga.isLocalArchive ?? false) {
                                  mangaDirectory = _deleteImport(
                                    manga,
                                    mangaDirectory,
                                  );
                                  // Also remove item from library
                                  // else it has 0 chapters/episodes
                                  // and when opened, shows exception
                                  // "Null check operator"
                                  isar.writeTxnSync(() {
                                    _removeImport(ref, manga);
                                  });
                                } else {
                                  mangaDirectory = await _deleteDownload(
                                    manga,
                                    mangaDirectory,
                                  );
                                }
                                if (mangaDirectory.isNotEmpty) {
                                  final path = Directory(mangaDirectory);
                                  if (path.existsSync() &&
                                      path.listSync().isEmpty) {
                                    path.deleteSync(recursive: true);
                                  }
                                }
                              }
                            }

                            ref.read(mangasListStateProvider.notifier).clear();
                            ref
                                .read(isLongPressedStateProvider.notifier)
                                .update(false);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(l10n.ok),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  /// helper method to remove the library entry of an imported item
  /// does not remove from the device itself.
  void _removeImport(WidgetRef ref, Manga manga) {
    final provider = ref.read(synchingProvider(syncId: 1).notifier);
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
    provider.addChangedPart(ActionType.removeItem, manga.id, "{}", false);
  }

  /// helper method to delete imported mangas/animes
  String _deleteImport(Manga manga, String mangaDirectory) {
    for (var chapter in manga.chapters) {
      final path = chapter.archivePath;
      if (path == null) continue;
      final chapterFile = File(path);
      if (mangaDirectory.isEmpty) {
        mangaDirectory = p.dirname(path);
      }

      try {
        if (chapterFile.existsSync()) {
          chapterFile.deleteSync();
        }
      } catch (_) {}
    }
    return mangaDirectory;
  }

  /// helper method to delete downloaded mangas/animes
  Future<String> _deleteDownload(Manga manga, String mangaDirectory) async {
    final storageProvider = StorageProvider();
    Directory? mangaDir;
    final idsToDelete = <int>{};
    final downloadedIds = (await isar.downloads.where().idProperty().findAll())
        .toSet();

    if (downloadedIds.isEmpty) return mangaDirectory;

    for (var chapter in manga.chapters) {
      if (chapter.id == null || !downloadedIds.contains(chapter.id)) continue;

      mangaDir ??= await storageProvider.getMangaMainDirectory(chapter);
      final chapterDir = await storageProvider.getMangaChapterDirectory(
        chapter,
        mangaMainDirectory: mangaDir,
      );
      File? file;

      if (mangaDirectory.isEmpty) mangaDirectory = mangaDir!.path;
      if (manga.itemType == ItemType.manga) {
        // ref: download_page_widget.dart
        file = File(p.join(mangaDir!.path, "${chapter.name}.cbz"));
      } else if (manga.itemType == ItemType.anime) {
        // ref: download_page_widget.dart
        file = File(
          p.join(
            mangaDir!.path,
            "${chapter.name!.replaceForbiddenCharacters(' ')}.mp4",
          ),
        );
      }

      try {
        if (file != null && file.existsSync()) {
          file.deleteSync();
        }
        if (chapterDir!.existsSync()) {
          chapterDir.deleteSync(recursive: true);
        }
      } catch (_) {}
      idsToDelete.add(chapter.id!);
    }
    if (idsToDelete.isNotEmpty) {
      isar.writeTxnSync(() {
        isar.downloads.deleteAllSync(idsToDelete.toList());
      });
    }
    return mangaDirectory;
  }

  void _showDraggableMenu(Settings settings) {
    final l10n = l10nLocalizations(context)!;
    customDraggableTabBar(
      tabs: [
        Tab(text: l10n.filter),
        Tab(text: l10n.sort),
        Tab(text: l10n.display),
      ],
      children: [
        Consumer(
          builder: (context, ref, chil) {
            return Column(
              children: [
                ListTileChapterFilter(
                  label: l10n.downloaded,
                  type: ref.watch(
                    mangaFilterDownloadedStateProvider(
                      itemType: widget.itemType,
                      mangaList: _entries,
                      settings: settings,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          mangaFilterDownloadedStateProvider(
                            itemType: widget.itemType,
                            mangaList: _entries,
                            settings: settings,
                          ).notifier,
                        )
                        .update();
                  },
                ),
                ListTileChapterFilter(
                  label: widget.itemType != ItemType.anime
                      ? l10n.unread
                      : l10n.unwatched,
                  type: ref.watch(
                    mangaFilterUnreadStateProvider(
                      itemType: widget.itemType,
                      mangaList: _entries,
                      settings: settings,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          mangaFilterUnreadStateProvider(
                            itemType: widget.itemType,
                            mangaList: _entries,
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
                      itemType: widget.itemType,
                      mangaList: _entries,
                      settings: settings,
                    ),
                  ),
                  onTap: () {
                    ref
                        .read(
                          mangaFilterStartedStateProvider(
                            itemType: widget.itemType,
                            mangaList: _entries,
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
                      itemType: widget.itemType,
                      mangaList: _entries,
                      settings: settings,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      ref
                          .read(
                            mangaFilterBookmarkedStateProvider(
                              itemType: widget.itemType,
                              mangaList: _entries,
                              settings: settings,
                            ).notifier,
                          )
                          .update();
                    });
                  },
                ),
              ],
            );
          },
        ),
        Consumer(
          builder: (context, ref, chil) {
            final reverse = ref
                .read(
                  sortLibraryMangaStateProvider(
                    itemType: widget.itemType,
                    settings: settings,
                  ).notifier,
                )
                .isReverse();
            final reverseChapter = ref.watch(
              sortLibraryMangaStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            return Column(
              children: [
                for (var i = 0; i < 7; i++)
                  ListTileChapterSort(
                    label: _getSortNameByIndex(i, context),
                    reverse: reverse,
                    onTap: () {
                      ref
                          .read(
                            sortLibraryMangaStateProvider(
                              itemType: widget.itemType,
                              settings: settings,
                            ).notifier,
                          )
                          .set(i);
                    },
                    showLeading: reverseChapter.index == i,
                  ),
              ],
            );
          },
        ),
        Consumer(
          builder: (context, ref, chil) {
            final display = ref.watch(
              libraryDisplayTypeStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final displayV = ref.read(
              libraryDisplayTypeStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ).notifier,
            );
            final showCategoryTabs = ref.watch(
              libraryShowCategoryTabsStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final continueReaderBtn = ref.watch(
              libraryShowContinueReadingButtonStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final showNumbersOfItems = ref.watch(
              libraryShowNumbersOfItemsStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final downloadedChapter = ref.watch(
              libraryDownloadedChaptersStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final language = ref.watch(
              libraryLanguageStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            final localSource = ref.watch(
              libraryLocalSourceStateProvider(
                itemType: widget.itemType,
                settings: settings,
              ),
            );
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Row(children: [Text(l10n.display_mode)]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Wrap(
                      children: DisplayType.values.map(
                        (e) {
                          final selected = e == display;
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
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
                                    ? context.primaryColor.withValues(
                                        alpha: 0.2,
                                      )
                                    : Colors.transparent,
                              ),
                              onPressed: () {
                                displayV.setLibraryDisplayType(e);
                              },
                              child: Text(
                                displayV.getLibraryDisplayTypeName(e, context),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },

                        // RadioListTile<
                        //     DisplayType>(
                        //   dense: true,
                        //   title: ,
                        //   value: e,
                        //   groupValue: displayV
                        //       .getLibraryDisplayTypeValue(
                        //           display),
                        //   selected: true,
                        //   onChanged: (value) {
                        //     displayV
                        //         .setLibraryDisplayType(
                        //             value!);
                        //   },
                        // ),
                      ).toList(),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final gridSize =
                          ref.watch(
                            libraryGridSizeStateProvider(
                              itemType: widget.itemType,
                            ),
                          ) ??
                          0;
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 10,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(context.l10n.grid_size),
                                  Text(
                                    gridSize == 0
                                        ? context.l10n.default0
                                        : context.l10n.n_per_row(
                                            gridSize.toString(),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 7,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 5.0,
                                  ),
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: 7,
                                  divisions: max(7, 0),
                                  value: gridSize.toDouble(),
                                  onChanged: (value) {
                                    HapticFeedback.vibrate();
                                    ref
                                        .read(
                                          libraryGridSizeStateProvider(
                                            itemType: widget.itemType,
                                          ).notifier,
                                        )
                                        .set(value.toInt());
                                  },
                                  onChangeEnd: (value) {
                                    ref
                                        .read(
                                          libraryGridSizeStateProvider(
                                            itemType: widget.itemType,
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
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Row(children: [Text(l10n.badges)]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        ListTileChapterFilter(
                          label: widget.itemType != ItemType.anime
                              ? l10n.downloaded_chapters
                              : l10n.downloaded_episodes,
                          type: downloadedChapter ? 1 : 0,
                          onTap: () {
                            ref
                                .read(
                                  libraryDownloadedChaptersStateProvider(
                                    itemType: widget.itemType,
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
                                    itemType: widget.itemType,
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
                                    itemType: widget.itemType,
                                    settings: settings,
                                  ).notifier,
                                )
                                .set(!localSource);
                          },
                        ),
                        ListTileChapterFilter(
                          label: widget.itemType != ItemType.anime
                              ? l10n.show_continue_reading_buttons
                              : l10n.show_continue_watching_buttons,
                          type: continueReaderBtn ? 1 : 0,
                          onTap: () {
                            ref
                                .read(
                                  libraryShowContinueReadingButtonStateProvider(
                                    itemType: widget.itemType,
                                    settings: settings,
                                  ).notifier,
                                )
                                .set(!continueReaderBtn);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
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
                                    itemType: widget.itemType,
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
                                    itemType: widget.itemType,
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
          },
        ),
      ],
      context: context,
      vsync: this,
    );
  }

  String _getSortNameByIndex(int index, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (index == 0) {
      return l10n.alphabetically;
    } else if (index == 1) {
      return widget.itemType != ItemType.anime
          ? l10n.last_read
          : l10n.last_watched;
    } else if (index == 2) {
      return l10n.last_update_check;
    } else if (index == 3) {
      return widget.itemType != ItemType.anime
          ? l10n.unread_count
          : l10n.unwatched_count;
    } else if (index == 4) {
      return widget.itemType != ItemType.anime
          ? l10n.total_chapters
          : l10n.total_episodes;
    } else if (index == 5) {
      return widget.itemType != ItemType.anime
          ? l10n.latest_chapter
          : l10n.latest_episode;
    }
    return l10n.date_added;
  }

  bool _ignoreFiltersOnSearch = false;
  final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  PreferredSize _appBar(
    bool isNotFiltering,
    bool showNumbersOfItems,
    int numberOfItems,
    WidgetRef ref,
    List<Manga> mangas,
    bool isCategory,
    int? categoryId,
    Settings settings,
  ) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final manga = categoryId == null
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(
              itemType: widget.itemType,
            ),
          )
        : ref.watch(
            getAllMangaStreamProvider(
              categoryId: categoryId,
              itemType: widget.itemType,
            ),
          );
    final l10n = l10nLocalizations(context)!;
    return PreferredSize(
      preferredSize: Size.fromHeight(AppBar().preferredSize.height),
      child: isLongPressed
          ? manga.when(
              data: (data) => Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: AppBar(
                  title: Text(mangaIdsList.length.toString()),
                  backgroundColor: context.primaryColor.withValues(alpha: 0.2),
                  leading: IconButton(
                    onPressed: () {
                      ref.read(mangasListStateProvider.notifier).clear();

                      ref
                          .read(isLongPressedStateProvider.notifier)
                          .update(!isLongPressed);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        for (var manga in data) {
                          ref
                              .read(mangasListStateProvider.notifier)
                              .selectAll(manga);
                        }
                      },
                      icon: const Icon(Icons.select_all),
                    ),
                    IconButton(
                      onPressed: () {
                        if (data.length == mangaIdsList.length) {
                          for (var manga in data) {
                            ref
                                .read(mangasListStateProvider.notifier)
                                .selectSome(manga);
                          }
                          ref
                              .read(isLongPressedStateProvider.notifier)
                              .update(false);
                        } else {
                          for (var manga in data) {
                            ref
                                .read(mangasListStateProvider.notifier)
                                .selectSome(manga);
                          }
                        }
                      },
                      icon: const Icon(Icons.flip_to_back_rounded),
                    ),
                  ],
                ),
              ),
              error: (Object error, StackTrace stackTrace) {
                return ErrorText(error);
              },
              loading: () {
                return const ProgressCenter();
              },
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: _isSearch
                  ? null
                  : Row(
                      children: [
                        Text(
                          widget.itemType == ItemType.manga
                              ? l10n.manga
                              : widget.itemType == ItemType.anime
                              ? l10n.anime
                              : l10n.novel,
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        const SizedBox(width: 10),
                        if (showNumbersOfItems)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Badge(
                              backgroundColor: Theme.of(context).focusColor,
                              label: Text(
                                numberOfItems.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.color,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
              actions: [
                _isSearch
                    ? SeachFormTextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        onPressed: () {
                          setState(() {
                            _isSearch = false;
                          });
                          _textEditingController.clear();
                        },
                        controller: _textEditingController,
                        onSuffixPressed: () {
                          _textEditingController.clear();
                          setState(() {});
                        },
                      )
                    : IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          setState(() {
                            _isSearch = true;
                          });
                          _textEditingController.clear();
                        },
                        icon: const Icon(Icons.search),
                      ),
                // Checkbox when searching library to ignore filters
                if (_isSearch)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isMobile
                            // Adds a line break where spaces exist for better mobile layout.
                            // Works for languages that use spaces between words.
                            ? l10n.ignore_filters.replaceFirst(' ', '\n')
                            // Removes manually added line breaks for Thai and Chinese,
                            // where spaces aren’t used, to ensure proper desktop rendering.
                            : l10n.ignore_filters.replaceAll('\n', ''),
                        textAlign: TextAlign.center,
                      ),
                      Checkbox(
                        value: _ignoreFiltersOnSearch,
                        onChanged: (val) {
                          setState(() {
                            _ignoreFiltersOnSearch = val ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    _showDraggableMenu(settings);
                  },
                  icon: Icon(
                    Icons.filter_list_sharp,
                    color: isNotFiltering ? null : Colors.yellow,
                  ),
                ),
                PopupMenuButton(
                  popUpAnimationStyle: popupAnimationStyle,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(context.l10n.update_library),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(l10n.open_random_entry),
                      ),
                      PopupMenuItem<int>(value: 2, child: Text(l10n.import)),
                      if (widget.itemType == ItemType.anime)
                        PopupMenuItem<int>(
                          value: 3,
                          child: Text(l10n.torrent_stream),
                        ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      manga.whenData((value) {
                        _updateLibrary(value);
                      });
                    } else if (value == 1) {
                      manga.whenData((value) {
                        var randomManga = (value..shuffle()).first;
                        pushToMangaReaderDetail(
                          ref: ref,
                          archiveId: randomManga.isLocalArchive ?? false
                              ? randomManga.id
                              : null,
                          context: context,
                          lang: randomManga.lang!,
                          mangaM: randomManga,
                          source: randomManga.source!,
                          sourceId: randomManga.sourceId,
                        );
                      });
                    } else if (value == 2) {
                      _importLocal(context, widget.itemType);
                    } else if (value == 3 &&
                        widget.itemType == ItemType.anime) {
                      addTorrent(context);
                    }
                  },
                ),
              ],
            ),
    );
  }
}

void _importLocal(BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  final filesText = switch (itemType) {
    ItemType.manga => ".zip, .cbz",
    ItemType.anime => ".mp4, .mkv, .avi, and more",
    ItemType.novel => ".epub",
  };
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.import_local_file),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, child) {
                return SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref.watch(
                                    importArchivesFromFileProvider(
                                      itemType: itemType,
                                      null,
                                      init: true,
                                    ).future,
                                  );
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.archive_outlined),
                                    Text(
                                      "${l10n.import_files} ( $filesText )",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodySmall!.color,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isLoading)
                        Container(
                          width: context.width(1),
                          height: context.height(1),
                          color: Colors.transparent,
                          child: UnconstrainedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                              height: 50,
                              width: 50,
                              child: const Center(child: ProgressCenter()),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}

void addTorrent(BuildContext context, {Manga? manga}) {
  final l10n = l10nLocalizations(context)!;
  String torrentUrl = "";
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.add_torrent),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, _) {
                return SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  torrentUrl = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: l10n.enter_torrent_hint_text,
                                labelText: l10n.torrent_url,
                                isDense: true,
                                filled: true,
                                fillColor: Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await ref.watch(
                                        addTorrentFromUrlOrFromFileProvider(
                                          manga,
                                          init: true,
                                          url: torrentUrl,
                                        ).future,
                                      );
                                    } catch (_) {}

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                  },
                            child: Text(l10n.add),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(l10n.or),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await ref.watch(
                                                addTorrentFromUrlOrFromFileProvider(
                                                  manga,
                                                  init: true,
                                                ).future,
                                              );
                                            } catch (_) {}

                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.archive_outlined),
                                        Text(
                                          "import .torrent file",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall!.color,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                width: 300,
                                height: 150,
                                color: Colors.transparent,
                                child: UnconstrainedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: const Center(
                                      child: ProgressCenter(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}

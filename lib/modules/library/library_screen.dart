// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/providers/add_torrent.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
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
import 'package:mangayomi/modules/library/widgets/list_tile_manga_category.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/global_style.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  final bool isManga;
  const LibraryScreen({required this.isManga, super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool _isSearch = false;
  final List<Manga> _entries = [];
  final _textEditingController = TextEditingController();
  late TabController tabBarController;
  int _tabIndex = 0;

  Future<void> _updateLibrary(List<Manga> mangaList) async {
    botToast(context.l10n.updating_library,
        fontSize: 13, second: 1600, alignY: !context.isTablet ? 0.85 : 1);
    int numbers = 0;
    for (var manga in mangaList) {
      try {
        await ref.read(
            updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
      } catch (_) {}
      numbers++;
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
    return settingsStream.when(data: (settingsList) {
      final settings = settingsList.first;

      final categories =
          ref.watch(getMangaCategorieStreamProvider(isManga: widget.isManga));
      final withoutCategories = ref.watch(
          getAllMangaWithoutCategoriesStreamProvider(isManga: widget.isManga));
      final showCategoryTabs = ref.watch(libraryShowCategoryTabsStateProvider(
          isManga: widget.isManga, settings: settings));
      final mangaAll = ref.watch(
          getAllMangaStreamProvider(categoryId: null, isManga: widget.isManga));
      final l10n = l10nLocalizations(context)!;
      return Scaffold(
          body: mangaAll.when(
            data: (man) {
              return withoutCategories.when(
                data: (withoutCategory) {
                  return categories.when(
                    data: (data) {
                      if (data.isNotEmpty && showCategoryTabs) {
                        final entr = data;
                        tabBarController = TabController(
                            length: withoutCategory.isNotEmpty
                                ? entr.length + 1
                                : entr.length,
                            vsync: this);
                        tabBarController.animateTo(_tabIndex);
                        tabBarController.addListener(() {
                          _tabIndex = tabBarController.index;
                        });

                        return Consumer(builder: (context, ref, child) {
                          bool reverse = ref
                              .watch(sortLibraryMangaStateProvider(
                                  isManga: widget.isManga, settings: settings))
                              .reverse!;

                          final continueReaderBtn = ref.watch(
                              libraryShowContinueReadingButtonStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final showNumbersOfItems = ref.watch(
                              libraryShowNumbersOfItemsStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final localSource = ref.watch(
                              libraryLocalSourceStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final downloadedChapter = ref.watch(
                              libraryDownloadedChaptersStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final language = ref.watch(
                              libraryLanguageStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final displayType = ref.watch(
                              libraryDisplayTypeStateProvider(
                                  isManga: widget.isManga, settings: settings));
                          final isNotFiltering = ref.watch(
                              mangasFilterResultStateProvider(
                                  isManga: widget.isManga,
                                  mangaList: _entries,
                                  settings: settings));
                          final downloadFilterType = ref.watch(
                              mangaFilterDownloadedStateProvider(
                                  isManga: widget.isManga,
                                  mangaList: _entries,
                                  settings: settings));
                          final unreadFilterType = ref.watch(
                              mangaFilterUnreadStateProvider(
                                  isManga: widget.isManga,
                                  mangaList: _entries,
                                  settings: settings));
                          final startedFilterType = ref.watch(
                              mangaFilterStartedStateProvider(
                                  isManga: widget.isManga,
                                  mangaList: _entries,
                                  settings: settings));
                          final bookmarkedFilterType = ref.watch(
                              mangaFilterBookmarkedStateProvider(
                                  isManga: widget.isManga,
                                  mangaList: _entries,
                                  settings: settings));
                          final sortType = ref
                              .watch(sortLibraryMangaStateProvider(
                                  isManga: widget.isManga, settings: settings))
                              .index as int;
                          final numberOfItemsList = _filterAndSortManga(
                              data: man,
                              downloadFilterType: downloadFilterType,
                              unreadFilterType: unreadFilterType,
                              startedFilterType: startedFilterType,
                              bookmarkedFilterType: bookmarkedFilterType,
                              sortType: sortType);
                          final withoutCategoryNumberOfItemsList =
                              _filterAndSortManga(
                                  data: withoutCategory,
                                  downloadFilterType: downloadFilterType,
                                  unreadFilterType: unreadFilterType,
                                  startedFilterType: startedFilterType,
                                  bookmarkedFilterType: bookmarkedFilterType,
                                  sortType: sortType);

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
                                  settings),
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TabBar(
                                      isScrollable: true,
                                      controller: tabBarController,
                                      tabs: [
                                        if (withoutCategory.isNotEmpty)
                                          for (var i = 0;
                                              i < entr.length + 1;
                                              i++)
                                            Row(
                                              children: [
                                                Tab(
                                                    text: i == 0
                                                        ? l10n.default0
                                                        : entr[i - 1].name),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                if (showNumbersOfItems)
                                                  i == 0
                                                      ? CircleAvatar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .focusColor,
                                                          radius: 8,
                                                          child: Text(
                                                            withoutCategoryNumberOfItemsList
                                                                .length
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .color),
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
                                                          settings: settings),
                                              ],
                                            ),
                                        if (withoutCategory.isEmpty)
                                          for (var i = 0; i < entr.length; i++)
                                            Row(
                                              children: [
                                                Tab(text: entr[i].name),
                                                const SizedBox(
                                                  width: 4,
                                                ),
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
                                                      settings: settings),
                                              ],
                                            )
                                      ]),
                                  Flexible(
                                      child: TabBarView(
                                          controller: tabBarController,
                                          children: [
                                        if (withoutCategory.isNotEmpty)
                                          for (var i = 0;
                                              i < entr.length + 1;
                                              i++)
                                            i == 0
                                                ? _bodyWithoutCategories(
                                                    withouCategories: true,
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
                                                    settings: settings)
                                                : _bodyWithCatories(
                                                    categoryId: entr[i - 1].id!,
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
                                                    settings: settings),
                                        if (withoutCategory.isEmpty)
                                          for (var i = 0; i < entr.length; i++)
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
                                                settings: settings)
                                      ]))
                                ],
                              ),
                            ),
                          );
                        });
                      }
                      return Consumer(builder: (context, ref, child) {
                        bool reverse = ref
                            .watch(sortLibraryMangaStateProvider(
                                isManga: widget.isManga, settings: settings))
                            .reverse!;
                        final continueReaderBtn = ref.watch(
                            libraryShowContinueReadingButtonStateProvider(
                                isManga: widget.isManga, settings: settings));
                        final showNumbersOfItems = ref.watch(
                            libraryShowNumbersOfItemsStateProvider(
                                isManga: widget.isManga, settings: settings));
                        final localSource = ref.watch(
                            libraryLocalSourceStateProvider(
                                isManga: widget.isManga, settings: settings));
                        final downloadedChapter = ref.watch(
                            libraryDownloadedChaptersStateProvider(
                                isManga: widget.isManga, settings: settings));
                        final language = ref.watch(libraryLanguageStateProvider(
                            isManga: widget.isManga, settings: settings));
                        final displayType = ref.watch(
                            libraryDisplayTypeStateProvider(
                                isManga: widget.isManga, settings: settings));
                        final isNotFiltering = ref.watch(
                            mangasFilterResultStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings));
                        final downloadFilterType = ref.watch(
                            mangaFilterDownloadedStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings));
                        final unreadFilterType = ref.watch(
                            mangaFilterUnreadStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings));
                        final startedFilterType = ref.watch(
                            mangaFilterStartedStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings));
                        final bookmarkedFilterType = ref.watch(
                            mangaFilterBookmarkedStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings));
                        final sortType = ref
                            .watch(sortLibraryMangaStateProvider(
                                isManga: widget.isManga, settings: settings))
                            .index;
                        final numberOfItemsList = _filterAndSortManga(
                            data: man,
                            downloadFilterType: downloadFilterType,
                            unreadFilterType: unreadFilterType,
                            startedFilterType: startedFilterType,
                            bookmarkedFilterType: bookmarkedFilterType,
                            sortType: sortType!);
                        return Scaffold(
                            appBar: _appBar(
                                isNotFiltering,
                                showNumbersOfItems,
                                numberOfItemsList.length,
                                ref,
                                numberOfItemsList,
                                false,
                                null,
                                settings),
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
                                settings: settings));
                      });
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
          bottomNavigationBar: Consumer(builder: (context, ref, child) {
            final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
            final color = Theme.of(context).textTheme.bodyLarge!.color!;
            final mangaIds = ref.watch(mangasListStateProvider);
            return AnimatedContainer(
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              duration: const Duration(milliseconds: 100),
              height: isLongPressed ? 70 : 0,
              width: context.width(1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              backgroundColor: Colors.transparent),
                          onPressed: () {
                            _openCategory();
                          },
                          child: Icon(
                            Icons.label_outline_rounded,
                            color: color,
                          )),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            ref
                                .read(mangasSetIsReadStateProvider(
                                        mangaIds: mangaIds)
                                    .notifier)
                                .set();
                            ref.invalidate(
                                getAllMangaWithoutCategoriesStreamProvider(
                                    isManga: widget.isManga));
                            ref.invalidate(getAllMangaStreamProvider(
                                categoryId: null, isManga: widget.isManga));
                          },
                          child: Icon(
                            Icons.done_all_sharp,
                            color: color,
                          )),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            ref
                                .read(mangasSetUnReadStateProvider(
                                        mangaIds: mangaIds)
                                    .notifier)
                                .set();
                            ref.invalidate(
                                getAllMangaWithoutCategoriesStreamProvider(
                                    isManga: widget.isManga));
                            ref.invalidate(getAllMangaStreamProvider(
                                categoryId: null, isManga: widget.isManga));
                          },
                          child: Icon(
                            Icons.remove_done_sharp,
                            color: color,
                          )),
                    ),
                  ),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 70,
                  //     child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //           elevation: 0,
                  //           backgroundColor: Colors.transparent,
                  //           shadowColor: Colors.transparent,
                  //         ),
                  //         onPressed: () {},
                  //         child: Icon(
                  //           Icons.download_outlined,
                  //           color: color,
                  //         )),
                  //   ),
                  // ),
                  Expanded(
                    child: SizedBox(
                      height: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            _deleteManga();
                          },
                          child: Icon(
                            Icons.delete_outline_outlined,
                            color: color,
                          )),
                    ),
                  ),
                ],
              ),
            );
          }));
    }, error: (error, e) {
      return ErrorText(error);
    }, loading: () {
      return const ProgressCenter();
    });
  }

  Widget _categoriesNumberOfItems(
      {required int downloadFilterType,
      required int unreadFilterType,
      required int startedFilterType,
      required int bookmarkedFilterType,
      required bool reverse,
      required bool downloadedChapter,
      required bool continueReaderBtn,
      required int categoryId,
      required Settings settings}) {
    final mangas = ref.watch(getAllMangaStreamProvider(
        categoryId: categoryId, isManga: widget.isManga));
    final sortType = ref
        .watch(sortLibraryMangaStateProvider(
            isManga: widget.isManga, settings: settings))
        .index;
    return mangas.when(
      data: (data) {
        final categoriNumberOfItemsList = _filterAndSortManga(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            sortType: sortType!);
        return CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          radius: 8,
          child: Text(
            categoriNumberOfItemsList.length.toString(),
            style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).textTheme.bodySmall!.color),
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

  Widget _bodyWithCatories(
      {required int categoryId,
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
      required Settings settings}) {
    final l10n = l10nLocalizations(context)!;
    final mangas = ref.watch(getAllMangaStreamProvider(
        categoryId: categoryId, isManga: widget.isManga));
    final sortType = ref
        .watch(sortLibraryMangaStateProvider(
            isManga: widget.isManga, settings: settings))
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
            sortType: sortType!);
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
                    isManga: widget.isManga,
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
    ));
  }

  Widget _bodyWithoutCategories(
      {required int downloadFilterType,
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
      bool withouCategories = false,
      required Settings settings}) {
    final sortType = ref
        .watch(sortLibraryMangaStateProvider(
            isManga: widget.isManga, settings: settings))
        .index;
    final manga = withouCategories
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(isManga: widget.isManga))
        : ref.watch(getAllMangaStreamProvider(
            categoryId: null, isManga: widget.isManga));
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
            sortType: sortType!);
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
                    isManga: widget.isManga,
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

  List<Manga> _filterAndSortManga(
      {required List<Manga> data,
      required int downloadFilterType,
      required int unreadFilterType,
      required int startedFilterType,
      required int bookmarkedFilterType,
      required int sortType}) {
    List<Manga>? mangas;
    mangas = data
        .where((element) {
          List list = [];
          if (downloadFilterType == 1) {
            for (var chap in element.chapters) {
              final modelChapDownload = isar.downloads
                  .filter()
                  .idIsNotNull()
                  .chapterIdEqualTo(chap.id)
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
                  .idIsNotNull()
                  .chapterIdEqualTo(chap.id)
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
        .where((element) => _textEditingController.text.isNotEmpty
            ? element.name!
                .toLowerCase()
                .contains(_textEditingController.text.toLowerCase())
            : true)
        .toList();

    if (sortType == 0) {
      mangas.sort(
        (a, b) {
          return a.name!.compareTo(b.name!);
        },
      );
    } else if (sortType == 1) {
      mangas.sort(
        (a, b) {
          return a.lastRead!.compareTo(b.lastRead!);
        },
      );
    } else if (sortType == 2) {
      mangas.sort(
        (a, b) {
          return a.lastUpdate?.compareTo(b.lastUpdate ?? 0) ?? 0;
        },
      );
    } else if (sortType == 3) {
      mangas.sort(
        (a, b) {
          return a.chapters
              .where((element) => !element.isRead!)
              .toList()
              .length
              .compareTo(b.chapters
                  .where((element) => !element.isRead!)
                  .toList()
                  .length);
        },
      );
    } else if (sortType == 4) {
      mangas.sort(
        (a, b) {
          return a.chapters.length.compareTo(b.chapters.length);
        },
      );
    } else if (sortType == 5) {
      mangas.sort(
        (a, b) {
          final aChaps = a.chapters;
          final bChaps = b.chapters;
          return (aChaps.lastOrNull?.dateUpload ?? "")
              .compareTo(bChaps.lastOrNull?.dateUpload ?? "");
        },
      );
    } else if (sortType == 6) {
      mangas.sort(
        (a, b) {
          return a.dateAdded?.compareTo(b.dateAdded ?? 0) ?? 0;
        },
      );
    }
    return mangas;
  }

  void _openCategory() {
    List<int> categoryIds = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final l10n = l10nLocalizations(context)!;
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return StreamBuilder(
                    stream: isar.categorys
                        .filter()
                        .idIsNotNull()
                        .and()
                        .forMangaEqualTo(widget.isManga)
                        .watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      return AlertDialog(
                        title: Text(
                          l10n.set_categories,
                        ),
                        content: SizedBox(
                          width: context.width(0.8),
                          child: Builder(builder: (context) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              final entries = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  return ListTileMangaCategory(
                                    category: entries[index],
                                    categoryIds: categoryIds,
                                    mangasList: mangasList,
                                    onTap: () {
                                      setState(() {
                                        if (categoryIds
                                            .contains(entries[index].id)) {
                                          categoryIds.remove(entries[index].id);
                                        } else {
                                          categoryIds.add(entries[index].id!);
                                        }
                                      });
                                    },
                                    res: (res) {
                                      if (res.isNotEmpty) {
                                        categoryIds.add(entries[index].id!);
                                      }
                                    },
                                  );
                                },
                              );
                            }
                            return Text(l10n.library_no_category_exist);
                          }),
                        ),
                        actions: [
                          snapshot.hasData && snapshot.data!.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          context.push("/categories", extra: (
                                            true,
                                            widget.isManga ? 0 : 1
                                          ));
                                          Navigator.pop(context);
                                        },
                                        child: Text(l10n.edit)),
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(l10n.cancel)),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              isar.writeTxnSync(() {
                                                for (var id in mangaIdsList) {
                                                  Manga? manga =
                                                      isar.mangas.getSync(id);
                                                  manga!.categories =
                                                      categoryIds;
                                                  isar.mangas.putSync(manga);
                                                }
                                              });
                                              ref
                                                  .read(mangasListStateProvider
                                                      .notifier)
                                                  .clear();
                                              ref
                                                  .read(
                                                      isLongPressedMangaStateProvider
                                                          .notifier)
                                                  .update(false);
                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(
                                              l10n.ok,
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          context.push("/categories", extra: (
                                            true,
                                            widget.isManga ? 0 : 1
                                          ));
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          l10n.edit_categories,
                                        )),
                                  ],
                                )
                        ],
                      );
                    });
              },
            );
          });
        });
  }

  void _deleteManga() {
    List<int> fromLibList = [];
    List<int> downloadedChapsList = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final l10n = l10nLocalizations(context)!;
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(
                    l10n.remove,
                  ),
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
                            label: l10n.downloaded_chapters,
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
                      )),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(l10n.cancel)),
                        const SizedBox(
                          width: 15,
                        ),
                        TextButton(
                            onPressed: () async {
                              if (fromLibList.isNotEmpty) {
                                isar.writeTxnSync(() {
                                  for (var manga in mangasList) {
                                    if (manga.isLocalArchive ?? false) {
                                      final histories = isar.historys
                                          .filter()
                                          .mangaIdEqualTo(manga.id)
                                          .findAllSync();
                                      for (var history in histories) {
                                        isar.historys.deleteSync(history.id!);
                                      }

                                      for (var chapter in manga.chapters) {
                                        ref
                                            .read(changedItemsManagerProvider(
                                                    managerId: 1)
                                                .notifier)
                                            .addUpdatedChapter(
                                                chapter, true, false);
                                        isar.updates
                                            .filter()
                                            .mangaIdEqualTo(chapter.mangaId)
                                            .chapterNameEqualTo(chapter.name)
                                            .deleteAllSync();
                                        isar.chapters.deleteSync(chapter.id!);
                                      }
                                      ref
                                          .read(changedItemsManagerProvider(
                                                  managerId: 1)
                                              .notifier)
                                          .addDeletedManga(manga, false);
                                      isar.mangas.deleteSync(manga.id!);
                                    } else {
                                      manga.favorite = false;
                                      isar.mangas.putSync(manga);
                                    }
                                  }
                                });
                              }
                              if (downloadedChapsList.isNotEmpty) {
                                isar.writeTxnSync(() async {
                                  for (var manga in mangasList) {
                                    if (manga.isLocalArchive ?? false) {
                                      for (var chapter in manga.chapters) {
                                        try {
                                          final storageProvider =
                                              StorageProvider();
                                          final mangaDir = await storageProvider
                                              .getMangaMainDirectory(chapter);
                                          final path = await storageProvider
                                              .getMangaChapterDirectory(
                                            chapter,
                                          );

                                          try {
                                            try {
                                              if (File(
                                                      "${mangaDir!.path}${chapter.name}.cbz")
                                                  .existsSync()) {
                                                File("${mangaDir.path}${chapter.name}.cbz")
                                                    .deleteSync();
                                              }
                                            } catch (_) {}
                                            try {
                                              if (File(
                                                      "${mangaDir!.path}${chapter.name}.mp4")
                                                  .existsSync()) {
                                                File("${mangaDir.path}${chapter.name}.mp4")
                                                    .deleteSync();
                                              }
                                            } catch (_) {}
                                            path!.deleteSync(recursive: true);
                                          } catch (_) {}
                                          isar.writeTxnSync(() {
                                            final download = isar.downloads
                                                .filter()
                                                .chapterIdEqualTo(chapter.id!)
                                                .findAllSync();
                                            if (download.isNotEmpty) {
                                              isar.downloads.deleteSync(
                                                  download.first.id!);
                                            }
                                          });
                                        } catch (_) {}
                                      }
                                    }
                                  }
                                });
                              }

                              ref
                                  .read(mangasListStateProvider.notifier)
                                  .clear();
                              ref
                                  .read(
                                      isLongPressedMangaStateProvider.notifier)
                                  .update(false);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              l10n.ok,
                            )),
                      ],
                    ),
                  ],
                );
              },
            );
          });
        });
  }

  void _showDraggableMenu(Settings settings) {
    final l10n = l10nLocalizations(context)!;
    customDraggableTabBar(tabs: [
      Tab(text: l10n.filter),
      Tab(text: l10n.sort),
      Tab(text: l10n.display),
    ], children: [
      Consumer(builder: (context, ref, chil) {
        return Column(
          children: [
            ListTileChapterFilter(
                label: l10n.downloaded,
                type: ref.watch(mangaFilterDownloadedStateProvider(
                    isManga: widget.isManga,
                    mangaList: _entries,
                    settings: settings)),
                onTap: () {
                  ref
                      .read(mangaFilterDownloadedStateProvider(
                              isManga: widget.isManga,
                              mangaList: _entries,
                              settings: settings)
                          .notifier)
                      .update();
                }),
            ListTileChapterFilter(
                label: l10n.unread,
                type: ref.watch(mangaFilterUnreadStateProvider(
                    isManga: widget.isManga,
                    mangaList: _entries,
                    settings: settings)),
                onTap: () {
                  ref
                      .read(mangaFilterUnreadStateProvider(
                              isManga: widget.isManga,
                              mangaList: _entries,
                              settings: settings)
                          .notifier)
                      .update();
                }),
            ListTileChapterFilter(
                label: l10n.started,
                type: ref.watch(mangaFilterStartedStateProvider(
                    isManga: widget.isManga,
                    mangaList: _entries,
                    settings: settings)),
                onTap: () {
                  ref
                      .read(mangaFilterStartedStateProvider(
                              isManga: widget.isManga,
                              mangaList: _entries,
                              settings: settings)
                          .notifier)
                      .update();
                }),
            ListTileChapterFilter(
                label: l10n.bookmarked,
                type: ref.watch(mangaFilterBookmarkedStateProvider(
                    isManga: widget.isManga,
                    mangaList: _entries,
                    settings: settings)),
                onTap: () {
                  setState(() {
                    ref
                        .read(mangaFilterBookmarkedStateProvider(
                                isManga: widget.isManga,
                                mangaList: _entries,
                                settings: settings)
                            .notifier)
                        .update();
                  });
                }),
          ],
        );
      }),
      Consumer(builder: (context, ref, chil) {
        final reverse = ref
            .read(sortLibraryMangaStateProvider(
                    isManga: widget.isManga, settings: settings)
                .notifier)
            .isReverse();
        final reverseChapter = ref.watch(sortLibraryMangaStateProvider(
            isManga: widget.isManga, settings: settings));
        return Column(
          children: [
            for (var i = 0; i < 7; i++)
              ListTileChapterSort(
                label: _getSortNameByIndex(i, context),
                reverse: reverse,
                onTap: () {
                  ref
                      .read(sortLibraryMangaStateProvider(
                              isManga: widget.isManga, settings: settings)
                          .notifier)
                      .set(i);
                },
                showLeading: reverseChapter.index == i,
              ),
          ],
        );
      }),
      Consumer(builder: (context, ref, chil) {
        final display = ref.watch(libraryDisplayTypeStateProvider(
            isManga: widget.isManga, settings: settings));
        final displayV = ref.read(libraryDisplayTypeStateProvider(
                isManga: widget.isManga, settings: settings)
            .notifier);
        final showCategoryTabs = ref.watch(libraryShowCategoryTabsStateProvider(
            isManga: widget.isManga, settings: settings));
        final continueReaderBtn = ref.watch(
            libraryShowContinueReadingButtonStateProvider(
                isManga: widget.isManga, settings: settings));
        final showNumbersOfItems = ref.watch(
            libraryShowNumbersOfItemsStateProvider(
                isManga: widget.isManga, settings: settings));
        final downloadedChapter = ref.watch(
            libraryDownloadedChaptersStateProvider(
                isManga: widget.isManga, settings: settings));
        final language = ref.watch(libraryLanguageStateProvider(
            isManga: widget.isManga, settings: settings));
        final localSource = ref.watch(libraryLocalSourceStateProvider(
            isManga: widget.isManga, settings: settings));
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(l10n.display_mode),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                                borderRadius: BorderRadius.circular(10)),
                            side: selected
                                ? null
                                : BorderSide(
                                    color: context.isLight
                                        ? Colors.black
                                        : Colors.white,
                                    width: 0.8),
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            backgroundColor: selected
                                ? context.primaryColor.withValues(alpha: 0.2)
                                : Colors.transparent),
                        onPressed: () {
                          displayV.setLibraryDisplayType(e);
                        },
                        child: Text(
                          displayV.getLibraryDisplayTypeName(e, context),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 14),
                        )),
                  );
                }

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
                        ).toList()),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final gridSize = ref.watch(libraryGridSizeStateProvider(
                          isManga: widget.isManga)) ??
                      0;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(context.l10n.grid_size),
                              Text(gridSize == 0
                                  ? context.l10n.default0
                                  : context.l10n.n_per_row(gridSize.toString()))
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 5.0),
                            ),
                            child: Slider(
                              min: 0.0,
                              max: 7,
                              divisions: max(7, 0),
                              value: gridSize.toDouble(),
                              onChanged: (value) {
                                HapticFeedback.vibrate();
                                ref
                                    .read(libraryGridSizeStateProvider(
                                            isManga: widget.isManga)
                                        .notifier)
                                    .set(value.toInt());
                              },
                              onChangeEnd: (value) {
                                ref
                                    .read(libraryGridSizeStateProvider(
                                            isManga: widget.isManga)
                                        .notifier)
                                    .set(value.toInt(), end: true);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(l10n.badges),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    ListTileChapterFilter(
                        label: l10n.downloaded_chapters,
                        type: downloadedChapter ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryDownloadedChaptersStateProvider(
                                      isManga: widget.isManga,
                                      settings: settings)
                                  .notifier)
                              .set(!downloadedChapter);
                        }),
                    ListTileChapterFilter(
                        label: l10n.language,
                        type: language ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryLanguageStateProvider(
                                      isManga: widget.isManga,
                                      settings: settings)
                                  .notifier)
                              .set(!language);
                        }),
                    ListTileChapterFilter(
                        label: l10n.local_source,
                        type: localSource ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryLocalSourceStateProvider(
                                      isManga: widget.isManga,
                                      settings: settings)
                                  .notifier)
                              .set(!localSource);
                        }),
                    ListTileChapterFilter(
                        label: l10n.show_continue_reading_buttons,
                        type: continueReaderBtn ? 1 : 0,
                        onTap: () {
                          ref
                              .read(
                                  libraryShowContinueReadingButtonStateProvider(
                                          isManga: widget.isManga,
                                          settings: settings)
                                      .notifier)
                              .set(!continueReaderBtn);
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [Text(l10n.tabs)],
                ),
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
                              .read(libraryShowCategoryTabsStateProvider(
                                      isManga: widget.isManga,
                                      settings: settings)
                                  .notifier)
                              .set(!showCategoryTabs);
                        }),
                    ListTileChapterFilter(
                        label: l10n.show_numbers_of_items,
                        type: showNumbersOfItems ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryShowNumbersOfItemsStateProvider(
                                      isManga: widget.isManga,
                                      settings: settings)
                                  .notifier)
                              .set(!showNumbersOfItems);
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    ], context: context, vsync: this);
  }

  String _getSortNameByIndex(int index, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (index == 0) {
      return l10n.alphabetically;
    } else if (index == 1) {
      return l10n.last_read;
    } else if (index == 2) {
      return l10n.last_update_check;
    } else if (index == 3) {
      return l10n.unread_count;
    } else if (index == 4) {
      return l10n.total_chapters;
    } else if (index == 5) {
      return l10n.latest_chapter;
    }
    return l10n.date_added;
  }

  PreferredSize _appBar(
      bool isNotFiltering,
      bool showNumbersOfItems,
      int numberOfItems,
      WidgetRef ref,
      List<Manga> mangas,
      bool isCategory,
      int? categoryId,
      Settings settings) {
    final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final manga = categoryId == null
        ? ref.watch(
            getAllMangaWithoutCategoriesStreamProvider(isManga: widget.isManga))
        : ref.watch(getAllMangaStreamProvider(
            categoryId: categoryId, isManga: widget.isManga));
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
                              .read(isLongPressedMangaStateProvider.notifier)
                              .update(!isLongPressed);
                        },
                        icon: const Icon(Icons.clear)),
                    actions: [
                      IconButton(
                          onPressed: () {
                            for (var manga in data) {
                              ref
                                  .read(mangasListStateProvider.notifier)
                                  .selectAll(manga);
                            }
                          },
                          icon: const Icon(Icons.select_all)),
                      IconButton(
                          onPressed: () {
                            if (data.length == mangaIdsList.length) {
                              for (var manga in data) {
                                ref
                                    .read(mangasListStateProvider.notifier)
                                    .selectSome(manga);
                              }
                              ref
                                  .read(
                                      isLongPressedMangaStateProvider.notifier)
                                  .update(false);
                            } else {
                              for (var manga in data) {
                                ref
                                    .read(mangasListStateProvider.notifier)
                                    .selectSome(manga);
                              }
                            }
                          },
                          icon: const Icon(Icons.flip_to_back_rounded)),
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
                leading: BackButton(
                    onPressed: () => context.go(
                        widget.isManga ? '/browse/manga' : '/browse/anime')),
                title: _isSearch
                    ? null
                    : Row(
                        children: [
                          Text(
                            widget.isManga ? l10n.manga : l10n.anime,
                            style:
                                TextStyle(color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (showNumbersOfItems)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).focusColor,
                                radius: 10,
                                child: Text(
                                  numberOfItems.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color),
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
                          icon: const Icon(
                            Icons.search,
                          )),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        _showDraggableMenu(settings);
                      },
                      icon: Icon(
                        Icons.filter_list_sharp,
                        color: isNotFiltering ? null : Colors.yellow,
                      )),
                  PopupMenuButton(
                      popUpAnimationStyle: popupAnimationStyle,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text(context.l10n.update_library),
                          ),
                          PopupMenuItem<int>(
                              value: 1, child: Text(l10n.open_random_entry)),
                          PopupMenuItem<int>(
                              value: 2, child: Text(l10n.import)),
                          if (!widget.isManga)
                            PopupMenuItem<int>(
                                value: 3, child: Text(l10n.torrent_stream)),
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
                                archiveId: randomManga.isLocalArchive ?? false
                                    ? randomManga.id
                                    : null,
                                context: context,
                                lang: randomManga.lang!,
                                mangaM: randomManga,
                                source: randomManga.source!);
                          });
                        } else if (value == 2) {
                          _importLocal(context, widget.isManga);
                        } else if (value == 3 && !widget.isManga) {
                          addTorrent(context);
                        }
                      }),
                ],
              ));
  }
}

void _importLocal(BuildContext context, bool isManga) {
  final l10n = l10nLocalizations(context)!;
  bool isLoading = false;
  showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.import_local_file,
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer(builder: (context, ref, child) {
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
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref.watch(
                                      importArchivesFromFileProvider(
                                              isManga: isManga,
                                              null,
                                              init: true)
                                          .future);
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
                                        "${l10n.import_files} ( ${isManga ? ".zip, .cbz" : ".mp4, .mkv, .avi, and more"} )",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color,
                                            fontSize: 10))
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
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                height: 50,
                                width: 50,
                                child: const Center(child: ProgressCenter())),
                          ),
                        )
                    ],
                  ),
                );
              });
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
                    child: Text(l10n.cancel)),
                const SizedBox(
                  width: 15,
                ),
              ],
            )
          ],
        );
      });
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
          title: Text(
            l10n.add_torrent,
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer(builder: (context, ref, _) {
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
                                          color: context.secondaryColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: context.secondaryColor)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: context.secondaryColor))),
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
                                                    url: torrentUrl)
                                                .future);
                                      } catch (_) {}

                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    },
                              child: Text(l10n.add))
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
                                            borderRadius:
                                                BorderRadius.circular(10))),
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
                                                          init: true)
                                                      .future);
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
                                        Text("import .torrent file",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .color,
                                                fontSize: 10))
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
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: const Center(
                                          child: ProgressCenter())),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              });
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
                    child: Text(l10n.cancel)),
                const SizedBox(
                  width: 15,
                ),
              ],
            )
          ],
        );
      });
}

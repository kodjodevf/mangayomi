import 'dart:developer';

import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/library/providers/isar_providers.dart';
import 'package:mangayomi/views/library/providers/library_state_provider.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';
import 'package:mangayomi/views/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/views/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/more/settings/categoties/providers/isar_providers.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool isSearch = false;
  List<Manga> entries = [];
  List<Manga> entriesFilter = [];
  final _textEditingController = TextEditingController();
  late TabController tabBarController;
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final reverse = ref.watch(libraryReverseListStateProvider);
    final showCategoryTabs = ref.watch(libraryShowCategoryTabsStateProvider);
    final continueReaderBtn =
        ref.watch(libraryShowContinueReadingButtonStateProvider);
    final showNumbersOfItems =
        ref.watch(libraryShowNumbersOfItemsStateProvider);
    final downloadedChapter = ref.watch(libraryDownloadedChaptersStateProvider);
    final language = ref.watch(libraryLanguageStateProvider);
    final displayType = ref
        .read(libraryDisplayTypeStateProvider.notifier)
        .getLibraryDisplayTypeValue(ref.watch(libraryDisplayTypeStateProvider));
    final isNotFiltering =
        ref.watch(mangasFilterResultStateProvider(mangaList: entries));
    final categories = ref.watch(getMangaCategorieStreamProvider);
    final downloadFilterType =
        ref.watch(mangaFilterDownloadedStateProvider(mangaList: entries));
    final unreadFilterType =
        ref.watch(mangaFilterUnreadStateProvider(mangaList: entries));
    final startedFilterType =
        ref.watch(mangaFilterStartedStateProvider(mangaList: entries));
    final bookmarkedFilterType =
        ref.watch(mangaFilterBookmarkedStateProvider(mangaList: entries));
    log(downloadFilterType.toString());
    return categories.when(
      data: (data) {
        if (data.isNotEmpty && showCategoryTabs) {
          final entr = data;
          tabBarController = TabController(length: entr.length, vsync: this);
          tabBarController.animateTo(tabIndex);
          tabBarController.addListener(() {
            tabIndex = tabBarController.index;
          });

          return DefaultTabController(
            length: entr.length,
            child: Scaffold(
              appBar:
                  _appBar(isNotFiltering, showNumbersOfItems, entries.length),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                      isScrollable: true,
                      controller: tabBarController,
                      tabs: entr.map((e) => Tab(text: e.name)).toList()),
                  Flexible(
                      child: TabBarView(
                    controller: tabBarController,
                    children: entr.map((e) {
                      final mangas = ref
                          .watch(getAllMangaStreamProvider(categoryId: e.id));
                      return Scaffold(
                          body: mangas.when(
                        data: (data) {
                          final entries = _filterMangas(
                              data: data,
                              downloadFilterType: downloadFilterType,
                              unreadFilterType: unreadFilterType,
                              startedFilterType: startedFilterType,
                              bookmarkedFilterType: bookmarkedFilterType);
                          if (entries.isNotEmpty) {
                            final entriesManga =
                                reverse ? entries.reversed.toList() : entries;
                            return displayType == DisplayType.list
                                ? LibraryListViewWidget(
                                    entriesManga: entriesManga,
                                    continueReaderBtn: continueReaderBtn,
                                    downloadedChapter: downloadedChapter,
                                    language: language,
                                  )
                                : LibraryGridViewWidget(
                                    entriesManga: entriesManga,
                                    isCoverOnlyGrid:
                                        displayType == DisplayType.compactGrid
                                            ? false
                                            : true,
                                    isComfortableGrid: displayType ==
                                            DisplayType.comfortableGrid
                                        ? true
                                        : false,
                                    continueReaderBtn: continueReaderBtn,
                                    downloadedChapter: downloadedChapter,
                                    language: language,
                                  );
                          }
                          return const Center(child: Text("Empty Library"));
                        },
                        error: (Object error, StackTrace stackTrace) {
                          return ErrorText(error);
                        },
                        loading: () {
                          return const ProgressCenter();
                        },
                      ));
                    }).toList(),
                  ))
                ],
              ),
            ),
          );
        }
        return Scaffold(
            appBar: _appBar(isNotFiltering, showNumbersOfItems, entries.length),
            body: ref.watch(getAllMangaStreamProvider(categoryId: null)).when(
              data: (data) {
                final entries = _filterMangas(
                    data: data,
                    downloadFilterType: downloadFilterType,
                    unreadFilterType: unreadFilterType,
                    startedFilterType: startedFilterType,
                    bookmarkedFilterType: bookmarkedFilterType);
                if (entries.isNotEmpty) {
                  final entriesManga =
                      reverse ? entries.reversed.toList() : entries;
                  return displayType == DisplayType.list
                      ? LibraryListViewWidget(
                          entriesManga: entriesManga,
                          continueReaderBtn: continueReaderBtn,
                          downloadedChapter: downloadedChapter,
                          language: language,
                        )
                      : LibraryGridViewWidget(
                          entriesManga: entriesManga,
                          isCoverOnlyGrid:
                              displayType == DisplayType.compactGrid
                                  ? false
                                  : true,
                          isComfortableGrid:
                              displayType == DisplayType.comfortableGrid
                                  ? true
                                  : false,
                          continueReaderBtn: continueReaderBtn,
                          downloadedChapter: downloadedChapter,
                          language: language,
                        );
                }
                return const Center(child: Text("Empty Library"));
              },
              error: (Object error, StackTrace stackTrace) {
                return ErrorText(error);
              },
              loading: () {
                return const ProgressCenter();
              },
            ));
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    );
  }

  List<Manga> _filterMangas(
      {required List<Manga> data,
      required int downloadFilterType,
      required int unreadFilterType,
      required int startedFilterType,
      required int bookmarkedFilterType}) {
    return data.where((element) {
      List list = [];
      if (downloadFilterType == 1) {
        for (var chap in element.chapters) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get("${chap.mangaId}/${chap.id}", defaultValue: null);
          if (modelChapDownload != null &&
              modelChapDownload.isDownload == true) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      } else if (downloadFilterType == 2) {
        for (var chap in element.chapters) {
          final modelChapDownload = ref
              .watch(hiveBoxMangaDownloadsProvider)
              .get("${chap.mangaId}/${chap.id}", defaultValue: null);
          if (!(modelChapDownload != null &&
              modelChapDownload.isDownload == true)) {
            list.add(true);
          }
        }
        return list.length == element.chapters.length;
      }
      return true;
    }).where((element) {
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
    }).where((element) {
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
    }).toList();
  }

  _showDraggableMenu() {
    late TabController tabBarController;
    tabBarController = TabController(length: 3, vsync: this);
    DraggableMenu.open(
        context,
        DraggableMenu(
            barItem: Container(),
            uiType: DraggableMenuUiType.softModern,
            expandable: true,
            expandedHeight: mediaHeight(context, 0.8),
            maxHeight: mediaHeight(context, 0.5),
            minimizeBeforeFastDrag: true,
            child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: Column(
                    children: [
                      TabBar(
                        controller: tabBarController,
                        tabs: const [
                          Tab(text: "Filter"),
                          Tab(text: "Sort"),
                          Tab(text: "Display"),
                        ],
                      ),
                      Flexible(
                        child:
                            TabBarView(controller: tabBarController, children: [
                          Consumer(builder: (context, ref, chil) {
                            return Column(
                              children: [
                                ListTileChapterFilter(
                                    label: "Downloaded",
                                    type: ref.watch(
                                        mangaFilterDownloadedStateProvider(
                                            mangaList: entries)),
                                    onTap: () {
                                      ref
                                          .read(
                                              mangaFilterDownloadedStateProvider(
                                                      mangaList: entries)
                                                  .notifier)
                                          .update();
                                    }),
                                ListTileChapterFilter(
                                    label: "Unread",
                                    type: ref.watch(
                                        mangaFilterUnreadStateProvider(
                                            mangaList: entries)),
                                    onTap: () {
                                      ref
                                          .read(mangaFilterUnreadStateProvider(
                                                  mangaList: entries)
                                              .notifier)
                                          .update();
                                    }),
                                ListTileChapterFilter(
                                    label: "Started",
                                    type: ref.watch(
                                        mangaFilterStartedStateProvider(
                                            mangaList: entries)),
                                    onTap: () {
                                      ref
                                          .read(mangaFilterStartedStateProvider(
                                                  mangaList: entries)
                                              .notifier)
                                          .update();
                                    }),
                                ListTileChapterFilter(
                                    label: "Bookmarked",
                                    type: ref.watch(
                                        mangaFilterBookmarkedStateProvider(
                                            mangaList: entries)),
                                    onTap: () {
                                      setState(() {
                                        entriesFilter = ref
                                            .read(
                                                mangaFilterBookmarkedStateProvider(
                                                        mangaList: entries)
                                                    .notifier)
                                            .update();
                                      });
                                    }),
                              ],
                            );
                          }),
                          Consumer(builder: (context, ref, chil) {
                            final reverse =
                                ref.watch(libraryReverseListStateProvider);

                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    ref
                                        .read(libraryReverseListStateProvider
                                            .notifier)
                                        .set(!reverse);
                                  },
                                  dense: true,
                                  leading: Icon(reverse
                                      ? Icons.arrow_downward_sharp
                                      : Icons.arrow_upward_sharp),
                                  title: const Text("Alphabetically"),
                                ),
                              ],
                            );
                          }),
                          Consumer(builder: (context, ref, chil) {
                            final display =
                                ref.watch(libraryDisplayTypeStateProvider);
                            final displayV = ref
                                .read(libraryDisplayTypeStateProvider.notifier);
                            final showCategoryTabs =
                                ref.watch(libraryShowCategoryTabsStateProvider);
                            final continueReaderBtn = ref.watch(
                                libraryShowContinueReadingButtonStateProvider);
                            final showNumbersOfItems = ref
                                .watch(libraryShowNumbersOfItemsStateProvider);
                            final downloadedChapter = ref
                                .watch(libraryDownloadedChaptersStateProvider);
                            final language =
                                ref.watch(libraryLanguageStateProvider);
                            return SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Row(
                                      children: const [
                                        Text("Display mode"),
                                      ],
                                    ),
                                  ),
                                  Column(
                                      children: DisplayType.values
                                          .map(
                                            (e) => RadioListTile<DisplayType>(
                                              title: Text(
                                                displayV
                                                    .getLibraryDisplayTypeName(
                                                        e.name),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fontSize: 14),
                                              ),
                                              value: e,
                                              groupValue: displayV
                                                  .getLibraryDisplayTypeValue(
                                                      display),
                                              selected: true,
                                              onChanged: (value) {
                                                displayV.setLibraryDisplayType(
                                                    value!);
                                              },
                                            ),
                                          )
                                          .toList()),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Row(
                                      children: const [
                                        Text("Badges"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: [
                                        ListTileChapterFilter(
                                            label: "Downloaded chapters",
                                            type: downloadedChapter ? 1 : 0,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      libraryDownloadedChaptersStateProvider
                                                          .notifier)
                                                  .set(!downloadedChapter);
                                            }),
                                        ListTileChapterFilter(
                                            label: "Language",
                                            type: language ? 1 : 0,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      libraryLanguageStateProvider
                                                          .notifier)
                                                  .set(!language);
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Row(
                                      children: const [
                                        Text("Tabs"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: [
                                        ListTileChapterFilter(
                                            label: "Show category tabs",
                                            type: showCategoryTabs ? 1 : 0,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      libraryShowCategoryTabsStateProvider
                                                          .notifier)
                                                  .set(!showCategoryTabs);
                                            }),
                                        ListTileChapterFilter(
                                            label: "Show numbers of items",
                                            type: showNumbersOfItems ? 1 : 0,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      libraryShowNumbersOfItemsStateProvider
                                                          .notifier)
                                                  .set(!showNumbersOfItems);
                                            }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Row(
                                      children: const [
                                        Text("Others"),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: [
                                        ListTileChapterFilter(
                                            label:
                                                "Show continue reading button",
                                            type: continueReaderBtn ? 1 : 0,
                                            onTap: () {
                                              ref
                                                  .read(
                                                      libraryShowContinueReadingButtonStateProvider
                                                          .notifier)
                                                  .set(!continueReaderBtn);
                                            }),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ]),
                      ),
                    ],
                  ),
                ))));
  }

  AppBar _appBar(
      bool isNotFiltering, bool showNumbersOfItems, int numberOfItems) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: isSearch
          ? null
          : Row(
              children: [
                Text(
                  'Library',
                  style: TextStyle(color: Theme.of(context).hintColor),
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
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                      ),
                    ),
                  ),
              ],
            ),
      actions: [
        isSearch
            ? SeachFormTextField(
                onChanged: (value) {
                  setState(() {});
                },
                onPressed: () {
                  setState(() {
                    isSearch = false;
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
                    isSearch = true;
                  });
                  _textEditingController.clear();
                },
                icon: const Icon(
                  Icons.search,
                )),
        IconButton(
            splashRadius: 20,
            onPressed: () {
              _showDraggableMenu();
            },
            icon: Icon(
              Icons.filter_list_sharp,
              color: isNotFiltering ? null : Colors.yellow,
            )),
        PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                    value: 0, child: Text("Open random entry")),
              ];
            },
            onSelected: (value) {}),
      ],
    );
  }
}

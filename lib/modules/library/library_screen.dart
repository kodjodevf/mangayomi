import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/library/widgets/list_tile_manga_category.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/more/categoties/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

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
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(getMangaCategorieStreamProvider);
    final withoutCategories =
        ref.watch(getAllMangaWithoutCategoriesStreamProvider);
    final showCategoryTabs = ref.watch(libraryShowCategoryTabsStateProvider);
    final mangaAll = ref.watch(getAllMangaStreamProvider(categoryId: null));

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
                        bool reverse =
                            ref.watch(sortLibraryMangaStateProvider).reverse!;

                        final continueReaderBtn = ref.watch(
                            libraryShowContinueReadingButtonStateProvider);
                        final showNumbersOfItems =
                            ref.watch(libraryShowNumbersOfItemsStateProvider);
                        final downloadedChapter =
                            ref.watch(libraryDownloadedChaptersStateProvider);
                        final language =
                            ref.watch(libraryLanguageStateProvider);
                        final displayType = ref
                            .read(libraryDisplayTypeStateProvider.notifier)
                            .getLibraryDisplayTypeValue(
                                ref.watch(libraryDisplayTypeStateProvider));
                        final isNotFiltering = ref.watch(
                            mangasFilterResultStateProvider(
                                mangaList: _entries));
                        final downloadFilterType = ref.watch(
                            mangaFilterDownloadedStateProvider(
                                mangaList: _entries));
                        final unreadFilterType = ref.watch(
                            mangaFilterUnreadStateProvider(
                                mangaList: _entries));
                        final startedFilterType = ref.watch(
                            mangaFilterStartedStateProvider(
                                mangaList: _entries));
                        final bookmarkedFilterType = ref.watch(
                            mangaFilterBookmarkedStateProvider(
                                mangaList: _entries));
                        final sortType = ref
                            .watch(sortLibraryMangaStateProvider)
                            .index as int;
                        final numberOfItemsList = _filterAndSortMangas(
                            data: man,
                            downloadFilterType: downloadFilterType,
                            unreadFilterType: unreadFilterType,
                            startedFilterType: startedFilterType,
                            bookmarkedFilterType: bookmarkedFilterType,
                            sortType: sortType);
                        final withoutCategoryNumberOfItemsList =
                            _filterAndSortMangas(
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
                                        .id!),
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
                                                      ? "Default"
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
                                                            entr[i - 1].id!),
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
                                                    categoryId: entr[i].id!),
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
                                                  ref: ref)
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
                                                  ref: ref),
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
                                              ref: ref)
                                    ]))
                              ],
                            ),
                          ),
                        );
                      });
                    }
                    return Consumer(builder: (context, ref, child) {
                      bool reverse =
                          ref.watch(sortLibraryMangaStateProvider).reverse!;
                      final continueReaderBtn = ref
                          .watch(libraryShowContinueReadingButtonStateProvider);
                      final showNumbersOfItems =
                          ref.watch(libraryShowNumbersOfItemsStateProvider);
                      final downloadedChapter =
                          ref.watch(libraryDownloadedChaptersStateProvider);
                      final language = ref.watch(libraryLanguageStateProvider);
                      final displayType = ref
                          .read(libraryDisplayTypeStateProvider.notifier)
                          .getLibraryDisplayTypeValue(
                              ref.watch(libraryDisplayTypeStateProvider));
                      final isNotFiltering = ref.watch(
                          mangasFilterResultStateProvider(mangaList: _entries));
                      final downloadFilterType = ref.watch(
                          mangaFilterDownloadedStateProvider(
                              mangaList: _entries));
                      final unreadFilterType = ref.watch(
                          mangaFilterUnreadStateProvider(mangaList: _entries));
                      final startedFilterType = ref.watch(
                          mangaFilterStartedStateProvider(mangaList: _entries));
                      final bookmarkedFilterType = ref.watch(
                          mangaFilterBookmarkedStateProvider(
                              mangaList: _entries));
                      final sortType =
                          ref.watch(sortLibraryMangaStateProvider).index;
                      final numberOfItemsList = _filterAndSortMangas(
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
                              null),
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
                              ref: ref));
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
                color: primaryColor(context).withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            duration: const Duration(milliseconds: 100),
            height: isLongPressed ? 70 : 0,
            width: mediaWidth(context, 1),
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
                        },
                        child: Icon(
                          Icons.remove_done_sharp,
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
                        onPressed: () {},
                        child: Icon(
                          Icons.download_outlined,
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
  }

  Widget _categoriesNumberOfItems(
      {required int downloadFilterType,
      required int unreadFilterType,
      required int startedFilterType,
      required int bookmarkedFilterType,
      required bool reverse,
      required bool downloadedChapter,
      required bool continueReaderBtn,
      required int categoryId}) {
    final mangas = ref.watch(getAllMangaStreamProvider(categoryId: categoryId));
    final sortType = ref.watch(sortLibraryMangaStateProvider).index;
    return mangas.when(
      data: (data) {
        final categoriNumberOfItemsList = _filterAndSortMangas(
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
      required bool language,
      required WidgetRef ref,
      required DisplayType displayType}) {
    final mangas = ref.watch(getAllMangaStreamProvider(categoryId: categoryId));
    final sortType = ref.watch(sortLibraryMangaStateProvider).index;
    final mangaIdsList = ref.watch(mangasListStateProvider);
    return Scaffold(
        body: mangas.when(
      data: (data) {
        final entries = _filterAndSortMangas(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            sortType: sortType!);
        if (entries.isNotEmpty) {
          final entriesManga = reverse ? entries.reversed.toList() : entries;
          return displayType == DisplayType.list
              ? LibraryListViewWidget(
                  entriesManga: entriesManga,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                )
              : LibraryGridViewWidget(
                  entriesManga: entriesManga,
                  isCoverOnlyGrid:
                      displayType == DisplayType.compactGrid ? false : true,
                  isComfortableGrid:
                      displayType == DisplayType.comfortableGrid ? true : false,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
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
  }

  Widget _bodyWithoutCategories(
      {required int downloadFilterType,
      required int unreadFilterType,
      required int startedFilterType,
      required int bookmarkedFilterType,
      required bool reverse,
      required bool downloadedChapter,
      required bool continueReaderBtn,
      required bool language,
      required DisplayType displayType,
      required WidgetRef ref,
      bool withouCategories = false}) {
    final sortType = ref.watch(sortLibraryMangaStateProvider).index;
    final manga = withouCategories
        ? ref.watch(getAllMangaWithoutCategoriesStreamProvider)
        : ref.watch(getAllMangaStreamProvider(categoryId: null));
    final mangaIdsList = ref.watch(mangasListStateProvider);
    return manga.when(
      data: (data) {
        final entries = _filterAndSortMangas(
            data: data,
            downloadFilterType: downloadFilterType,
            unreadFilterType: unreadFilterType,
            startedFilterType: startedFilterType,
            bookmarkedFilterType: bookmarkedFilterType,
            sortType: sortType!);
        if (entries.isNotEmpty) {
          final entriesManga = reverse ? entries.reversed.toList() : entries;
          return displayType == DisplayType.list
              ? LibraryListViewWidget(
                  entriesManga: entriesManga,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                )
              : LibraryGridViewWidget(
                  entriesManga: entriesManga,
                  isCoverOnlyGrid:
                      displayType == DisplayType.compactGrid ? false : true,
                  isComfortableGrid:
                      displayType == DisplayType.comfortableGrid ? true : false,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
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
    );
  }

  List<Manga> _filterAndSortMangas(
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
          return a.lastUpdate!.compareTo(b.lastUpdate!);
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
          return a.chapters.first.dateUpload!
              .compareTo(b.chapters.first.dateUpload!);
        },
      );
    } else if (sortType == 6) {
      mangas.sort(
        (a, b) {
          return a.dateAdded!.compareTo(b.dateAdded!);
        },
      );
    }
    return mangas;
  }

  _openCategory() {
    List<int> categoryIds = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text(
                    "Set categories",
                  ),
                  content: SizedBox(
                    width: mediaWidth(context, 0.8),
                    child: StreamBuilder(
                        stream: isar.categorys
                            .filter()
                            .idIsNotNull()
                            .watch(fireImmediately: true),
                        builder: (context, snapshot) {
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
                          return Container();
                        }),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              context.push("/categories");
                              Navigator.pop(context);
                            },
                            child: const Text("Edit")),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                                onPressed: () {
                                  isar.writeTxnSync(() {
                                    for (var id in mangaIdsList) {
                                      Manga? manga = isar.mangas.getSync(id);
                                      manga!.categories = categoryIds;
                                      isar.mangas.putSync(manga);
                                    }
                                  });
                                  ref
                                      .read(mangasListStateProvider.notifier)
                                      .clear();
                                  ref
                                      .read(isLongPressedMangaStateProvider
                                          .notifier)
                                      .update(false);
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "OK",
                                )),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          });
        });
  }

  _deleteManga() {
    List<int> fromLibList = [];
    List<int> downloadedChapsList = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text(
                    "Remove",
                  ),
                  content: SizedBox(
                      height: 100,
                      width: mediaWidth(context, 0.8),
                      child: Column(
                        children: [
                          ListTileChapterFilter(
                            label: "From library",
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
                            label: "Downloaded chapters",
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
                            child: const Text("Cancel")),
                        const SizedBox(
                          width: 15,
                        ),
                        TextButton(
                            onPressed: () async {
                              if (fromLibList.isNotEmpty) {
                                isar.writeTxnSync(() {
                                  for (var manga in mangasList) {
                                    manga.favorite = false;
                                    isar.mangas.putSync(manga);
                                  }
                                });
                              }
                              if (downloadedChapsList.isNotEmpty) {
                                isar.writeTxnSync(() async {
                                  for (var manga in mangasList) {
                                    for (var chapter in manga.chapters) {
                                      final path = await StorageProvider()
                                          .getMangaChapterDirectory(
                                        chapter,
                                      );
                                      try {
                                        path!.deleteSync(recursive: true);
                                      } catch (e) {
                                        int id = isar.downloads
                                            .filter()
                                            .chapterIdEqualTo(chapter.id!)
                                            .findFirstSync()!
                                            .id!;
                                        isar.downloads.deleteSync(id);
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
                            child: const Text(
                              "OK",
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

  _showDraggableMenu() {
    late TabController tabBarController;
    tabBarController = TabController(length: 3, vsync: this);
    DraggableMenu.open(
        context,
        DraggableMenu(
            ui: SoftModernDraggableMenu(barItem: Container(), radius: 20),
            expandable: true,
            expandedHeight: mediaHeight(context, 0.8),
            maxHeight: mediaHeight(context, 0.6),
            minimizeBeforeFastDrag: true,
            child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Column(
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
                          child: TabBarView(
                              controller: tabBarController,
                              children: [
                                Consumer(builder: (context, ref, chil) {
                                  return Column(
                                    children: [
                                      ListTileChapterFilter(
                                          label: "Downloaded",
                                          type: ref.watch(
                                              mangaFilterDownloadedStateProvider(
                                                  mangaList: _entries)),
                                          onTap: () {
                                            ref
                                                .read(
                                                    mangaFilterDownloadedStateProvider(
                                                            mangaList: _entries)
                                                        .notifier)
                                                .update();
                                          }),
                                      ListTileChapterFilter(
                                          label: "Unread",
                                          type: ref.watch(
                                              mangaFilterUnreadStateProvider(
                                                  mangaList: _entries)),
                                          onTap: () {
                                            ref
                                                .read(
                                                    mangaFilterUnreadStateProvider(
                                                            mangaList: _entries)
                                                        .notifier)
                                                .update();
                                          }),
                                      ListTileChapterFilter(
                                          label: "Started",
                                          type: ref.watch(
                                              mangaFilterStartedStateProvider(
                                                  mangaList: _entries)),
                                          onTap: () {
                                            ref
                                                .read(
                                                    mangaFilterStartedStateProvider(
                                                            mangaList: _entries)
                                                        .notifier)
                                                .update();
                                          }),
                                      ListTileChapterFilter(
                                          label: "Bookmarked",
                                          type: ref.watch(
                                              mangaFilterBookmarkedStateProvider(
                                                  mangaList: _entries)),
                                          onTap: () {
                                            setState(() {
                                              ref
                                                  .read(
                                                      mangaFilterBookmarkedStateProvider(
                                                              mangaList:
                                                                  _entries)
                                                          .notifier)
                                                  .update();
                                            });
                                          }),
                                    ],
                                  );
                                }),
                                Consumer(builder: (context, ref, chil) {
                                  final reverse = ref
                                      .read(sortLibraryMangaStateProvider
                                          .notifier)
                                      .isReverse();
                                  final reverseChapter =
                                      ref.watch(sortLibraryMangaStateProvider);
                                  return Column(
                                    children: [
                                      for (var i = 0; i < 7; i++)
                                        ListTileChapterSort(
                                          label: _getSortNameByIndex(i),
                                          reverse: reverse,
                                          onTap: () {
                                            ref
                                                .read(
                                                    sortLibraryMangaStateProvider
                                                        .notifier)
                                                .set(i);
                                          },
                                          showLeading:
                                              reverseChapter.index == i,
                                        ),
                                    ],
                                  );
                                }),
                                Consumer(builder: (context, ref, chil) {
                                  final display = ref
                                      .watch(libraryDisplayTypeStateProvider);
                                  final displayV = ref.read(
                                      libraryDisplayTypeStateProvider.notifier);
                                  final showCategoryTabs = ref.watch(
                                      libraryShowCategoryTabsStateProvider);
                                  final continueReaderBtn = ref.watch(
                                      libraryShowContinueReadingButtonStateProvider);
                                  final showNumbersOfItems = ref.watch(
                                      libraryShowNumbersOfItemsStateProvider);
                                  final downloadedChapter = ref.watch(
                                      libraryDownloadedChaptersStateProvider);
                                  final language =
                                      ref.watch(libraryLanguageStateProvider);
                                  return SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Row(
                                            children: [
                                              Text("Display mode"),
                                            ],
                                          ),
                                        ),
                                        Column(
                                            children: DisplayType.values
                                                .map(
                                                  (e) => RadioListTile<
                                                      DisplayType>(
                                                    title: Text(
                                                      displayV
                                                          .getLibraryDisplayTypeName(
                                                              e.name),
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
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
                                                      displayV
                                                          .setLibraryDisplayType(
                                                              value!);
                                                    },
                                                  ),
                                                )
                                                .toList()),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Row(
                                            children: [
                                              Text("Badges"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: [
                                              ListTileChapterFilter(
                                                  label: "Downloaded chapters",
                                                  type:
                                                      downloadedChapter ? 1 : 0,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            libraryDownloadedChaptersStateProvider
                                                                .notifier)
                                                        .set(
                                                            !downloadedChapter);
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
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Row(
                                            children: [
                                              Text("Tabs"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: [
                                              ListTileChapterFilter(
                                                  label: "Show category tabs",
                                                  type:
                                                      showCategoryTabs ? 1 : 0,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            libraryShowCategoryTabsStateProvider
                                                                .notifier)
                                                        .set(!showCategoryTabs);
                                                  }),
                                              ListTileChapterFilter(
                                                  label:
                                                      "Show numbers of items",
                                                  type: showNumbersOfItems
                                                      ? 1
                                                      : 0,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            libraryShowNumbersOfItemsStateProvider
                                                                .notifier)
                                                        .set(
                                                            !showNumbersOfItems);
                                                  }),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Row(
                                            children: [
                                              Text("Others"),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 5),
                                          child: Column(
                                            children: [
                                              ListTileChapterFilter(
                                                  label:
                                                      "Show continue reading button",
                                                  type:
                                                      continueReaderBtn ? 1 : 0,
                                                  onTap: () {
                                                    ref
                                                        .read(
                                                            libraryShowContinueReadingButtonStateProvider
                                                                .notifier)
                                                        .set(
                                                            !continueReaderBtn);
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
                  ),
                ))));
  }

  String _getSortNameByIndex(int index) {
    if (index == 0) {
      return "AlphabeticalLy";
    } else if (index == 1) {
      return "Last read";
    } else if (index == 2) {
      return "Last update check";
    } else if (index == 3) {
      return "Unread count";
    } else if (index == 4) {
      return "Total chapters";
    } else if (index == 5) {
      return "Latest chapter";
    }
    return "Date added";
  }

  PreferredSize _appBar(
      bool isNotFiltering,
      bool showNumbersOfItems,
      int numberOfItems,
      WidgetRef ref,
      List<Manga> mangas,
      bool isCategory,
      int? categoryId) {
    final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final manga = categoryId == null
        ? ref.watch(getAllMangaWithoutCategoriesStreamProvider)
        : ref.watch(getAllMangaStreamProvider(categoryId: categoryId));

    return PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: isLongPressed
            ? manga.when(
                data: (data) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: AppBar(
                    title: Text(mangaIdsList.length.toString()),
                    backgroundColor: primaryColor(context).withOpacity(0.2),
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
                title: _isSearch
                    ? null
                    : Row(
                        children: [
                          Text(
                            'Library',
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
                        _showDraggableMenu();
                      },
                      icon: Icon(
                        Icons.filter_list_sharp,
                        color: isNotFiltering ? null : Colors.yellow,
                      )),
                  PopupMenuButton(itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                          value: 0, child: Text("Open random entry")),
                    ];
                  }, onSelected: (value) {
                    manga.whenData((value) {
                      var randomManga = (value..shuffle()).first;
                      context.push('/manga-reader/detail',
                          extra: randomManga.id);
                    });
                  }),
                ],
              ));
  }
}

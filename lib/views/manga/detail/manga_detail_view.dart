import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;

  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final Manga? manga;
  const MangaDetailView({
    super.key,
    required this.isExtended,
    this.titleDescription,
    this.backButtonColors,
    this.action,
    required this.manga,
  });

  @override
  ConsumerState<MangaDetailView> createState() => _MangaDetailViewState();
}

class _MangaDetailViewState extends ConsumerState<MangaDetailView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        ref.read(offetProvider.notifier).state = _scrollController.offset;
      });
    super.initState();
  }

  final offetProvider = StateProvider((ref) => 0.0);
  bool _expanded = false;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final chapterNameList = ref.watch(chaptersListStateProvider);
    bool reverse = ref
        .watch(sortChapterStateProvider(mangaId: widget.manga!.id!))
        .reverse!;
    final filterUnread =
        ref.watch(chapterFilterUnreadStateProvider(mangaId: widget.manga!.id!));
    final filterBookmarked = ref.watch(
        chapterFilterBookmarkedStateProvider(mangaId: widget.manga!.id!));
    final filterDownloaded = ref.watch(
        chapterFilterDownloadedStateProvider(mangaId: widget.manga!.id!));
    final sortChapter = ref
        .watch(sortChapterStateProvider(mangaId: widget.manga!.id!))
        .index as int;
    final chapters =
        ref.watch(getChaptersStreamProvider(mangaId: widget.manga!.id!));
    return NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            widget.isExtended(true);
          }
          if (notification.direction == ScrollDirection.reverse) {
            widget.isExtended(false);
          }
          return true;
        },
        child: chapters.when(
          data: (data) {
            List<Chapter> chapters = _filterAndSortChapter(
                data: data,
                filterUnread: filterUnread,
                filterBookmarked: filterBookmarked,
                filterDownloaded: filterDownloaded,
                sortChapter: sortChapter);
            ref.read(chaptersListttStateProvider.notifier).set(chapters);
            return _buildWidget(
                chapters: chapters,
                reverse: reverse,
                chapterList: chapterNameList,
                isLongPressed: isLongPressed);
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorText(error);
          },
          loading: () {
            return _buildWidget(
                chapters: widget.manga!.chapters.toList(),
                reverse: reverse,
                chapterList: chapterNameList,
                isLongPressed: isLongPressed);
          },
        ));
  }

  List<Chapter> _filterAndSortChapter(
      {required List<Chapter> data,
      required int filterUnread,
      required int filterBookmarked,
      required int filterDownloaded,
      required int sortChapter}) {
    List<Chapter>? chapterList;
    chapterList = data
        .where((element) => filterUnread == 1
            ? element.isRead == false
            : filterUnread == 2
                ? element.isRead == true
                : true)
        .where((element) => filterBookmarked == 1
            ? element.isBookmarked == true
            : filterBookmarked == 2
                ? element.isBookmarked == false
                : true)
        .where((element) {
      final modelChapDownload = isar.downloads
          .filter()
          .idIsNotNull()
          .chapterIdEqualTo(element.id)
          .findAllSync();
      return filterDownloaded == 1
          ? modelChapDownload.isNotEmpty &&
              modelChapDownload.first.isDownload == true
          : filterDownloaded == 2
              ? !(modelChapDownload.isNotEmpty &&
                  modelChapDownload.first.isDownload == true)
              : true;
    }).toList();
    List<Chapter> chapters =
        sortChapter == 1 ? chapterList.reversed.toList() : chapterList;
    if (sortChapter == 0) {
      chapters.sort(
        (a, b) {
          return a.scanlator!.compareTo(b.scanlator!) |
              a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    } else if (sortChapter == 2) {
      chapters.sort(
        (a, b) {
          return a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    }
    return chapterList;
  }

  Widget _buildWidget(
      {required List<Chapter> chapters,
      required bool reverse,
      required List<Chapter> chapterList,
      required bool isLongPressed}) {
    return Stack(
      children: [
        Consumer(
          builder: (context, ref, child) {
            return Positioned(
              top: 0,
              child: ref.watch(offetProvider) == 0.0
                  ? Stack(
                      children: [
                        cachedNetworkImage(
                            headers: ref.watch(
                                headersProvider(source: widget.manga!.source!)),
                            imageUrl: widget.manga!.imageUrl!,
                            width: mediaWidth(context, 1),
                            height: 410,
                            fit: BoxFit.cover),
                        Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: mediaWidth(context, 1),
                                  height: AppBar().preferredSize.height,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.9),
                                ),
                                Container(
                                  width: mediaWidth(context, 1),
                                  height: 465,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                  width: mediaWidth(context, 1),
                                  height: 100,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
            );
          },
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: Consumer(
                  builder: (context, ref, child) {
                    final isNotFiltering = ref.watch(
                        chapterFilterResultStateProvider(
                            mangaId: widget.manga!.id!));
                    final isLongPressed = ref.watch(isLongPressedStateProvider);
                    return isLongPressed
                        ? Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: AppBar(
                              title: Text(chapterList.length.toString()),
                              backgroundColor:
                                  primaryColor(context).withOpacity(0.2),
                              leading: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(
                                            chaptersListStateProvider.notifier)
                                        .clear();

                                    ref
                                        .read(
                                            isLongPressedStateProvider.notifier)
                                        .update(!isLongPressed);
                                  },
                                  icon: const Icon(Icons.clear)),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      for (var chapter in chapters) {
                                        ref
                                            .read(chaptersListStateProvider
                                                .notifier)
                                            .selectAll(chapter);
                                      }
                                    },
                                    icon: const Icon(Icons.select_all)),
                                IconButton(
                                    onPressed: () {
                                      if (chapters.length ==
                                          chapterList.length) {
                                        for (var chapter in chapters) {
                                          ref
                                              .read(chaptersListStateProvider
                                                  .notifier)
                                              .selectSome(chapter);
                                        }
                                        ref
                                            .read(isLongPressedStateProvider
                                                .notifier)
                                            .update(false);
                                      } else {
                                        for (var chapter in chapters) {
                                          ref
                                              .read(chaptersListStateProvider
                                                  .notifier)
                                              .selectSome(chapter);
                                        }
                                      }
                                    },
                                    icon:
                                        const Icon(Icons.flip_to_back_rounded)),
                              ],
                            ),
                          )
                        : AppBar(
                            title: ref.watch(offetProvider) > 200
                                ? Text(
                                    widget.manga!.name!,
                                    style: const TextStyle(fontSize: 17),
                                  )
                                : null,
                            backgroundColor: ref.watch(offetProvider) == 0.0
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor,
                            actions: [
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.download_outlined,
                                  )),
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    _showDraggableMenu();
                                  },
                                  icon: Icon(
                                    Icons.filter_list_sharp,
                                    color:
                                        isNotFiltering ? null : Colors.yellow,
                                  )),
                              PopupMenuButton(itemBuilder: (context) {
                                return [
                                  if (widget.manga!.favorite)
                                    const PopupMenuItem<int>(
                                        value: 0,
                                        child: Text("Edit categories")),
                                  if (widget.manga!.favorite)
                                    const PopupMenuItem<int>(
                                        value: 1, child: Text("Migrate")),
                                  const PopupMenuItem<int>(
                                      value: 2, child: Text("Share")),
                                ];
                              }, onSelected: (value) {
                                if (value == 0) {
                                  context.push("/categories");
                                } else if (value == 1) {
                                } else if (value == 2) {
                                  String url = getMangaAPIUrl(
                                              widget.manga!.source!)
                                          .isEmpty
                                      ? widget.manga!.link!
                                      : "${getMangaBaseUrl(widget.manga!.source!)}${widget.manga!.link!}";
                                  Share.share(url);
                                }
                              }),
                            ],
                          );
                  },
                )),
            body: SafeArea(
              child: Row(
                children: [
                  if (isTablet(context))
                    SizedBox(
                        width: mediaWidth(context, 0.3),
                        height: mediaHeight(context, 1),
                        child: _bodyContainer(chapterLength: chapters.length)),
                  Expanded(
                    child: DraggableScrollbar(
                        padding: const EdgeInsets.only(right: 7),
                        heightScrollThumb: 48.0,
                        backgroundColor: primaryColor(context),
                        scrollThumbBuilder: (backgroundColor, thumbAnimation,
                            labelAnimation, height,
                            {labelConstraints, labelText}) {
                          return FadeTransition(
                            opacity: thumbAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: height,
                              width: 8.0,
                            ),
                          );
                        },
                        scrollbarTimeToFade: const Duration(seconds: 2),
                        controller: _scrollController,
                        child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 0, bottom: 60),
                            itemCount: chapters.length + 1,
                            itemBuilder: (context, index) {
                              int finalIndex = index - 1;
                              if (index == 0) {
                                return isTablet(context)
                                    ? Column(
                                        children: [
                                          //Description
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    '${chapters.length} chapters',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : _bodyContainer(
                                        chapterLength: chapters.length);
                              }
                              int reverseIndex = chapters.length -
                                  chapters.reversed.toList().indexOf(
                                      chapters.reversed.toList()[finalIndex]) -
                                  1;
                              final indexx =
                                  reverse ? reverseIndex : finalIndex;
                              return ChapterListTileWidget(
                                chapter: chapters[indexx],
                                chapterList: chapterList,
                              );
                            })),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Consumer(builder: (context, ref, child) {
              final chap = ref.watch(chaptersListStateProvider);
              bool getLength1 = chap.length == 1;
              bool checkFirstBookmarked =
                  chap.isNotEmpty && chap.first.isBookmarked! && getLength1;
              bool checkReadBookmarked =
                  chap.isNotEmpty && chap.first.isRead! && getLength1;

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
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              final chapters =
                                  ref.watch(chaptersListStateProvider);
                              isar.writeTxnSync(() {
                                for (var chapter in chapters) {
                                  chapter.isBookmarked = !chapter.isBookmarked!;
                                  isar.chapters.putSync(
                                      chapter..manga.value = widget.manga);
                                  chapter.manga.saveSync();
                                }
                              });
                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(false);
                              ref
                                  .read(chaptersListStateProvider.notifier)
                                  .clear();
                            },
                            child: Icon(
                                checkFirstBookmarked
                                    ? Icons.bookmark_remove_outlined
                                    : Icons.bookmark_add_outlined,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color)),
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
                              final chapters =
                                  ref.watch(chaptersListStateProvider);
                              isar.writeTxnSync(() {
                                for (var chapter in chapters) {
                                  chapter.isRead = !chapter.isRead!;
                                  isar.chapters.putSync(
                                      chapter..manga.value = widget.manga);
                                  chapter.manga.saveSync();
                                }
                              });
                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(false);
                              ref
                                  .read(chaptersListStateProvider.notifier)
                                  .clear();
                            },
                            child: Icon(
                                checkReadBookmarked
                                    ? Icons.remove_done_sharp
                                    : Icons.done_all_sharp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!)),
                      ),
                    ),
                    if (getLength1)
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
                                int index = chapters.indexOf(chap.first);
                                isar.writeTxnSync(() {
                                  for (var i = index + 1;
                                      i < chapters.length;
                                      i++) {
                                    chapters[i].isRead = true;
                                    isar.chapters.putSync(chapters[i]
                                      ..manga.value = widget.manga);
                                    chapters[i].manga.saveSync();
                                  }
                                  ref
                                      .read(isLongPressedStateProvider.notifier)
                                      .update(false);
                                  ref
                                      .read(chaptersListStateProvider.notifier)
                                      .clear();
                                });
                              },
                              child: Stack(
                                children: [
                                  Icon(Icons.done_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!),
                                  Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Icon(Icons.arrow_downward_outlined,
                                          size: 11,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!))
                                ],
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
                              isar.txnSync(() {
                                for (var chapter
                                    in ref.watch(chaptersListStateProvider)) {
                                  final entries = isar.downloads
                                      .filter()
                                      .idIsNotNull()
                                      .chapterIdEqualTo(chapter.id)
                                      .findAllSync();
                                  if (entries.isEmpty ||
                                      !entries.first.isDownload!) {
                                    ref.watch(downloadChapterProvider(
                                        chapter: chapter));
                                  }
                                }
                              });

                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(false);
                              ref
                                  .read(chaptersListStateProvider.notifier)
                                  .clear();
                            },
                            child: Icon(
                              Icons.download_outlined,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                            )),
                      ),
                    )
                  ],
                ),
              );
            })),
      ],
    );
  }

  _showDraggableMenu() {
    late TabController tabBarController;
    tabBarController = TabController(length: 3, vsync: this);
    tabBarController.animateTo(0);
    DraggableMenu.open(
      context,
      DraggableMenu(
        ui: ClassicDraggableMenu(barItem: Container(), radius: 20),
        expandable: false,
        maxHeight: 240,
        fastDrag: false,
        minimizeBeforeFastDrag: false,
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
                      child:
                          TabBarView(controller: tabBarController, children: [
                        Consumer(builder: (context, ref, chil) {
                          return Column(
                            children: [
                              ListTileChapterFilter(
                                  label: "Downloaded",
                                  type: ref.watch(
                                      chapterFilterDownloadedStateProvider(
                                          mangaId: widget.manga!.id!)),
                                  onTap: () {
                                    ref
                                        .read(
                                            chapterFilterDownloadedStateProvider(
                                                    mangaId: widget.manga!.id!)
                                                .notifier)
                                        .update();
                                  }),
                              ListTileChapterFilter(
                                  label: "Unread",
                                  type: ref.watch(
                                      chapterFilterUnreadStateProvider(
                                          mangaId: widget.manga!.id!)),
                                  onTap: () {
                                    ref
                                        .read(chapterFilterUnreadStateProvider(
                                                mangaId: widget.manga!.id!)
                                            .notifier)
                                        .update();
                                  }),
                              ListTileChapterFilter(
                                  label: "Bookmarked",
                                  type: ref.watch(
                                      chapterFilterBookmarkedStateProvider(
                                          mangaId: widget.manga!.id!)),
                                  onTap: () {
                                    ref
                                        .read(
                                            chapterFilterBookmarkedStateProvider(
                                                    mangaId: widget.manga!.id!)
                                                .notifier)
                                        .update();
                                  }),
                            ],
                          );
                        }),
                        Consumer(builder: (context, ref, chil) {
                          final reverse = ref
                              .read(sortChapterStateProvider(
                                      mangaId: widget.manga!.id!)
                                  .notifier)
                              .isReverse();
                          final reverseChapter = ref.watch(
                              sortChapterStateProvider(
                                  mangaId: widget.manga!.id!));
                          return Column(
                            children: [
                              for (var i = 0; i < 3; i++)
                                ListTileChapterSort(
                                  label: _getSortNameByIndex(i),
                                  reverse: reverse,
                                  onTap: () {
                                    ref
                                        .read(sortChapterStateProvider(
                                                mangaId: widget.manga!.id!)
                                            .notifier)
                                        .set(i);
                                  },
                                  showLeading: reverseChapter.index == i,
                                ),
                            ],
                          );
                        }),
                        Consumer(builder: (context, ref, chil) {
                          return Column(
                            children: [
                              RadioListTile(
                                dense: true,
                                title: const Text("Source title"),
                                value: "e",
                                groupValue: "e",
                                selected: true,
                                onChanged: (value) {},
                              ),
                              RadioListTile(
                                dense: true,
                                title: const Text("Chapter number"),
                                value: "ej",
                                groupValue: "e",
                                selected: false,
                                onChanged: (value) {},
                              ),
                            ],
                          );
                        }),
                      ]),
                    ),
                  ],
                ),
              ),
            )),
      ),
      barrier: true,
    );
  }

  String _getSortNameByIndex(int index) {
    if (index == 0) {
      return "By source";
    } else if (index == 1) {
      return "By chapter number";
    }
    return "By upload date";
  }

  Widget _bodyContainer({required int chapterLength}) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: cachedNetworkImage(
                headers:
                    ref.watch(headersProvider(source: widget.manga!.source!)),
                imageUrl: widget.manga!.imageUrl!,
                width: mediaWidth(context, 1),
                height: 250,
                fit: BoxFit.cover)),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                Color(Theme.of(context).scaffoldBackgroundColor.value)
              ],
              stops: const [0, .35],
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  _titles(),
                  _coverCard(),
                ],
              ),
            ),
            _actionFavouriteAndWebview(),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.manga!.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: widget.manga!.description!,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _expanded
                          ? Wrap(
                              children: [
                                for (var i = 0;
                                    i < widget.manga!.genre!.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2, bottom: 5),
                                    child: SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () {},
                                        child: Text(
                                          widget.manga!.genre![i],
                                          style: TextStyle(
                                              fontSize: 11.5,
                                              color: isLight(context)
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (var i = 0;
                                      i < widget.manga!.genre!.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2, bottom: 5),
                                      child: SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () {},
                                          child: Text(
                                            widget.manga!.genre![i],
                                            style: TextStyle(
                                                fontSize: 11.5,
                                                color: isLight(context)
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                  if (!isTablet(context))
                    Column(
                      children: [
                        //Description
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '$chapterLength chapters',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _coverCard() {
    return Positioned(
      top: 20,
      left: 13,
      child: GestureDetector(
        onTap: () {
          _openImage(widget.manga!.imageUrl!);
        },
        child: SizedBox(
          width: 65 * 1.5,
          height: 65 * 2.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.manga!.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titles() {
    return Positioned(
      top: 60,
      left: 23,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 100),
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.manga!.name!,
                style: const TextStyle(
                  fontSize: 18,
                )),
            widget.titleDescription!,
          ],
        ),
      ),
    );
  }

  Widget _actionFavouriteAndWebview() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.action!,
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: isTablet(context) ? null : mediaWidth(context, 0.4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0),
              onPressed: () {
                final manga = widget.manga!;
                String url = getMangaAPIUrl(manga.source!).isEmpty
                    ? manga.link!
                    : "${getMangaBaseUrl(manga.source!)}${manga.link!}";
                Map<String, String> data = {
                  'url': url,
                  'source': manga.source!,
                  'title': manga.name!
                };
                context.push("/mangawebview", extra: data);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.public,
                    size: 22,
                    color: secondaryColor(context),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'WebView',
                    style:
                        TextStyle(fontSize: 13, color: secondaryColor(context)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _openImage(String url) {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: PhotoViewGallery.builder(
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: CachedNetworkImageProvider(url),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered,
                  );
                },
                loadingBuilder: (context, event) {
                  return const ProgressCenter();
                },
              ),
            ),
          );
        });
  }
}

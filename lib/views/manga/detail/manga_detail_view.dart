import 'dart:developer';

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
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/readmore.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

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
    final chapterNameList = ref.watch(chapterIdsListStateProvider);
    bool reverse = ref.watch(
        reverseChapterStateProvider(mangaId: widget.manga!.id!))["reverse"];
    // log(reverse.toString());
    // final chaptersList =
    //     ref.watch(getChaptersStreamProvider(mangaId: widget.manga!.id!));
    final filterUnread =
        ref.watch(chapterFilterUnreadStateProvider(mangaId: widget.manga!.id!));
    final filterBookmarked = ref.watch(
        chapterFilterBookmarkedStateProvider(mangaId: widget.manga!.id!));
    final filterDownloaded = ref.watch(
        chapterFilterDownloadedStateProvider(mangaId: widget.manga!.id!));
    final sortChapter = ref.watch(
            reverseChapterStateProvider(mangaId: widget.manga!.id!))['index']
        as int;
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
            List<Chapter> chapterList = data
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
              final modelChapDownload = ref
                  .watch(hiveBoxMangaDownloadsProvider)
                  .get("${element.mangaId}/${element.id}", defaultValue: null);
              return filterDownloaded == 1
                  ? modelChapDownload != null &&
                      modelChapDownload.isDownload == true
                  : filterDownloaded == 2
                      ? !(modelChapDownload != null &&
                          modelChapDownload.isDownload == true)
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
            return _buildWidget(
                chapters: chapters,
                reverse: reverse,
                chapterNameList: chapterNameList,
                isLongPressed: isLongPressed);
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorText(error);
          },
          loading: () {
            return _buildWidget(
                chapters: widget.manga!.chapters.toList(),
                reverse: reverse,
                chapterNameList: chapterNameList,
                isLongPressed: isLongPressed);
          },
        ));
  }

  Widget _buildWidget(
      {required List<Chapter> chapters,
      required bool reverse,
      required List<Chapter> chapterNameList,
      required bool isLongPressed}) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height),
            child: Consumer(
              builder: (context, ref, child) {
                final isNotFiltering = ref.watch(
                    chapterFilterResultStateProvider(
                        mangaId: widget.manga!.id!));
                final isLongPressed = ref.watch(isLongPressedStateProvider);
                // final chapterNameList = ref.watch(chapterIdsListStateProvider);
                return isLongPressed
                    ? Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: AppBar(
                          title: Text(chapterNameList.length.toString()),
                          backgroundColor:
                              primaryColor(context).withOpacity(0.2),
                          leading: IconButton(
                              onPressed: () {
                                ref
                                    .read(chapterIdsListStateProvider.notifier)
                                    .clear();

                                ref
                                    .read(isLongPressedStateProvider.notifier)
                                    .update(!isLongPressed);
                              },
                              icon: const Icon(Icons.clear)),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  for (var chapter in chapters) {
                                    ref
                                        .read(chapterIdsListStateProvider
                                            .notifier)
                                        .selectAll(chapter);
                                  }
                                },
                                icon: const Icon(Icons.select_all)),
                            IconButton(
                                onPressed: () {
                                  if (chapters.length ==
                                      chapterNameList.length) {
                                    for (var chapter in chapters) {
                                      ref
                                          .read(chapterIdsListStateProvider
                                              .notifier)
                                          .selectSome(chapter);
                                    }
                                    ref
                                        .read(
                                            isLongPressedStateProvider.notifier)
                                        .update(false);
                                  } else {
                                    for (var chapter in chapters) {
                                      ref
                                          .read(chapterIdsListStateProvider
                                              .notifier)
                                          .selectSome(chapter);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.flip_to_back_rounded)),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Positioned(
                              top: 0,
                              child: Stack(
                                children: [
                                  cachedNetworkImage(
                                      headers: headers(widget.manga!.source!),
                                      imageUrl: widget.manga!.imageUrl!,
                                      width: mediaWidth(context, 1),
                                      height: 410,
                                      fit: BoxFit.cover),
                                  Container(
                                    width: mediaWidth(context, 1),
                                    height: 465,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .withOpacity(0.9),
                                  ),
                                ],
                              )),
                          AppBar(
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
                              PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      if (widget.manga!.favorite)
                                        const PopupMenuItem<int>(
                                            value: 0,
                                            child: Text("Edit categories")),
                                      if (widget.manga!.favorite)
                                        const PopupMenuItem<int>(
                                            value: 0, child: Text("Migrate")),
                                      const PopupMenuItem<int>(
                                          value: 0, child: Text("Share")),
                                    ];
                                  },
                                  onSelected: (value) {}),
                            ],
                          )
                        ],
                      );
              },
            )),
        body: SafeArea(
            child: DraggableScrollbar(
                heightScrollThumb: 48.0,
                backgroundColor: primaryColor(context),
                scrollThumbBuilder:
                    (backgroundColor, thumbAnimation, labelAnimation, height,
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
                        return _bodyContainer(chapterLength: chapters.length);
                      }
                      int reverseIndex = chapters.length -
                          chapters.reversed
                              .toList()
                              .indexOf(chapters.reversed.toList()[finalIndex]) -
                          1;
                      final indexx = reverse ? reverseIndex : finalIndex;
                      return ChapterListTileWidget(
                        chapter: chapters[indexx],
                        chapterNameList: chapterNameList,
                      );
                    }))),
        bottomNavigationBar: AnimatedContainer(
          curve: Curves.easeIn,
          decoration: BoxDecoration(
              color: primaryColor(context).withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
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
                          elevation: 0, backgroundColor: Colors.transparent),
                      onPressed: () {
                        ref
                            .read(chapterSetIsBookmarkStateProvider(
                                    manga: widget.manga!)
                                .notifier)
                            .set();
                      },
                      child: const Icon(Icons.bookmark_add_outlined)),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: Colors.transparent),
                      onPressed: () {
                        ref
                            .read(chapterSetIsReadStateProvider(
                                    manga: widget.manga!)
                                .notifier)
                            .set();
                      },
                      child: const Icon(Icons.done_all_sharp)),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: Colors.transparent),
                      onPressed: () {
                        ref
                            .read(chapterSetDownloadStateProvider(
                                    manga: widget.manga!)
                                .notifier)
                            .set();
                      },
                      child: const Icon(Icons.download_outlined)),
                ),
              )
            ],
          ),
        ));
  }

  _showDraggableMenu() {
    late TabController tabBarController;
    tabBarController = TabController(length: 3, vsync: this);
    tabBarController.animateTo(0);
    DraggableMenu.open(
      context,
      DraggableMenu(
        barItem: Container(),
        uiType: DraggableMenuUiType.classic,
        expandable: false,
        maxHeight: 240,
        fastDrag: false,
        minimizeBeforeFastDrag: false,
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
                    child: TabBarView(controller: tabBarController, children: [
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
                            .read(reverseChapterStateProvider(
                                    mangaId: widget.manga!.id!)
                                .notifier)
                            .isReverse();
                        final reverseChapter = ref.watch(
                            reverseChapterStateProvider(
                                mangaId: widget.manga!.id!));
                        return Column(
                          children: [
                            for (var i = 0; i < 3; i++)
                              ListTileChapterSort(
                                label: i == 0
                                    ? "By source"
                                    : i == 1
                                        ? "By chapter number"
                                        : "By upload date",
                                reverse: reverse,
                                onTap: () {
                                  ref
                                      .read(reverseChapterStateProvider(
                                              mangaId: widget.manga!.id!)
                                          .notifier)
                                      .set(i);
                                },
                                showLeading: reverseChapter['index'] == i,
                              ),
                          ],
                        );
                      }),
                      Consumer(builder: (context, ref, chil) {
                        return Column(
                          children: [
                            RadioListTile(
                              title: const Text("Source title"),
                              value: "e",
                              groupValue: "e",
                              selected: true,
                              onChanged: (value) {},
                            ),
                            RadioListTile(
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
            )),
      ),
      barrier: true,
    );
  }

  Widget _bodyContainer({required int chapterLength}) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: cachedNetworkImage(
                headers: headers(widget.manga!.source!),
                imageUrl: widget.manga!.imageUrl!,
                width: mediaWidth(context, 1),
                height: 300,
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
            _actionConstructor(),
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
                  // log
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
      left: 20,
      child: GestureDetector(
        onTap: () {},
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
      left: 30,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 100),
        width: MediaQuery.of(context).size.width * 0.9,
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

  Widget _actionConstructor() {
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
            width: mediaWidth(context, 0.4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0),
              onPressed: () {
                Map<String, String> data = {
                  'url': widget.manga!.link!,
                  'source': widget.manga!.source!,
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
}

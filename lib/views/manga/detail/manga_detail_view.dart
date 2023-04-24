import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/readmore.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;

  final int listLength;
  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final ModelManga? modelManga;
  const MangaDetailView({
    super.key,
    required this.isExtended,
    this.titleDescription,
    this.backButtonColors,
    this.action,
    required this.modelManga,
    required this.listLength,
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
  bool isOk = false;
  bool _expanded = false;
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final chapterIndexList = ref.watch(chapterIndexListStateProvider);
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final reverse = ref.watch(reverseMangaStateProvider);
    final chapter = ref.watch(chapterModelStateProvider);
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
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppBar().preferredSize.height),
              child: isLongPressed
                  ? Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: AppBar(
                        title: Text(chapterIndexList.length.toString()),
                        backgroundColor: generalColor(context).withOpacity(0.2),
                        leading: IconButton(
                            onPressed: () {
                              ref
                                  .read(chapterIndexListStateProvider.notifier)
                                  .clear();

                              ref
                                  .read(isLongPressedStateProvider.notifier)
                                  .update(!isLongPressed);
                            },
                            icon: const Icon(Icons.clear)),
                        actions: [
                          IconButton(
                              onPressed: () {
                                for (var i = 0;
                                    i < widget.modelManga!.chapters!.length;
                                    i++) {
                                  ref
                                      .read(chapterIndexListStateProvider
                                          .notifier)
                                      .selectAll(i);
                                }
                              },
                              icon: const Icon(Icons.select_all)),
                          IconButton(
                              onPressed: () {
                                if (widget.modelManga!.chapters!.length ==
                                    chapterIndexList.length) {
                                  for (var i = 0;
                                      i < widget.modelManga!.chapters!.length;
                                      i++) {
                                    ref
                                        .read(chapterIndexListStateProvider
                                            .notifier)
                                        .selectSome(i);
                                  }
                                  ref
                                      .read(isLongPressedStateProvider.notifier)
                                      .update(false);
                                } else {
                                  for (var i = 0;
                                      i < widget.modelManga!.chapters!.length;
                                      i++) {
                                    ref
                                        .read(chapterIndexListStateProvider
                                            .notifier)
                                        .selectSome(i);
                                  }
                                }
                              },
                              icon: const Icon(Icons.flip_to_back_rounded)),
                        ],
                      ),
                    )
                  : AppBar(
                      title: ref.watch(offetProvider) > 200
                          ? Text(
                              widget.modelManga!.name!,
                              style: const TextStyle(fontSize: 17),
                            )
                          : null,
                      backgroundColor: ref.watch(offetProvider) == 0.0
                          ? Colors.transparent
                          : Theme.of(context).scaffoldBackgroundColor,
                      actions: [
                        // IconButton(
                        //     splashRadius: 20,
                        //     onPressed: () {},
                        //     icon: Icon(Icons.download_outlined,
                        //         color: Theme.of(context).hintColor)),
                        IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              ref
                                  .read(reverseMangaStateProvider.notifier)
                                  .update(!reverse);
                            },
                            icon: Icon(
                                reverse
                                    ? Icons.arrow_downward_sharp
                                    : Icons.arrow_upward_sharp,
                                color: Theme.of(context).hintColor)),
                      ],
                    )),
          body: Stack(
            children: [
              Positioned(
                  top: 0,
                  child: Stack(
                    children: [
                      cachedNetworkImage(
                          imageUrl: widget.modelManga!.imageUrl!,
                          width: mediaWidth(context, 1),
                          height: 461,
                          fit: BoxFit.cover),
                      Container(
                        width: mediaWidth(context, 1),
                        height: 465,
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9),
                      ),
                      SafeArea(
                        child: Container(
                            width: mediaWidth(context, 1),
                            height: mediaHeight(context, 1),
                            color: Theme.of(context).scaffoldBackgroundColor),
                      )
                    ],
                  )),
              SafeArea(
                  child: DraggableScrollbar(
                      heightScrollThumb: 48.0,
                      backgroundColor: generalColor(context),
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
                          itemCount: widget.listLength,
                          itemBuilder: (context, index) {
                            int finalIndex = index - 1;
                            if (index == 0) {
                              return _bodyContainer();
                            }

                            int reverseIndex = widget
                                    .modelManga!.chapters!.length -
                                widget.modelManga!.chapters!.reversed
                                    .toList()
                                    .indexOf(widget
                                        .modelManga!.chapters!.reversed
                                        .toList()[finalIndex]) -
                                1;

                            List<ModelChapters> chapters = reverse
                                ? widget.modelManga!.chapters!.reversed.toList()
                                : widget.modelManga!.chapters!;

                            return ChapterListTileWidget(
                                chapters: chapters,
                                modelManga: widget.modelManga!,
                                reverse: reverse,
                                reverseIndex: reverseIndex,
                                finalIndex: finalIndex,
                                isLongPressed: isLongPressed);
                          }))),
            ],
          ),
          bottomNavigationBar: AnimatedContainer(
            curve: Curves.easeIn,
            decoration: BoxDecoration(
                color: generalColor(context).withOpacity(0.2),
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
                            backgroundColor: Colors.transparent),
                        onPressed: () async {
                          for (var idx in chapterIndexList) {
                            List<ModelChapters> chap = [];
                            for (var i = 0;
                                i < widget.modelManga!.chapters!.length;
                                i++) {
                              final entries = ref
                                  .watch(hiveBoxManga)
                                  .values
                                  .where((element) =>
                                      '${element.lang}-${element.link}' ==
                                      '${widget.modelManga!.lang}-${widget.modelManga!.link}')
                                  .toList()
                                  .first;
                              chap.add(ModelChapters(
                                  name: entries.chapters![i].name,
                                  url: entries.chapters![i].url,
                                  dateUpload: entries.chapters![i].dateUpload,
                                  isBookmarked: idx == i
                                      ? entries.chapters![i].isBookmarked
                                          ? false
                                          : true
                                      : entries.chapters![i].isBookmarked,
                                  scanlator: entries.chapters![i].scanlator,
                                  isRead: entries.chapters![i].isRead,
                                  lastPageRead:
                                      entries.chapters![i].lastPageRead));
                            }

                            // print(chapterIndexList);
                            final model = ModelManga(
                                imageUrl: widget.modelManga!.imageUrl,
                                name: widget.modelManga!.name,
                                genre: widget.modelManga!.genre,
                                author: widget.modelManga!.author,
                                description: widget.modelManga!.description,
                                status: widget.modelManga!.status,
                                favorite: widget.modelManga!.favorite,
                                link: widget.modelManga!.link,
                                source: widget.modelManga!.source,
                                lang: widget.modelManga!.lang,
                                dateAdded: widget.modelManga!.dateAdded,
                                lastUpdate: widget.modelManga!.lastUpdate,
                                chapters: chap,
                                category: widget.modelManga!.category,
                                lastRead: widget.modelManga!.lastRead);
                            ref.watch(hiveBoxManga).put(
                                '${widget.modelManga!.lang}-${widget.modelManga!.link}',
                                model);
                            ref
                                .read(chapterIndexListStateProvider.notifier)
                                .clear();
                            ref
                                .read(isLongPressedStateProvider.notifier)
                                .update(false);
                          }
                        },
                        child: Icon(chapter.isBookmarked
                            ? Icons.bookmark_remove
                            : Icons.bookmark_add_outlined)),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        onPressed: () {
                          for (var idx in chapterIndexList) {
                            List<ModelChapters> chap = [];
                            for (var i = 0;
                                i < widget.modelManga!.chapters!.length;
                                i++) {
                              final entries = ref
                                  .watch(hiveBoxManga)
                                  .values
                                  .where((element) =>
                                      '${element.lang}-${element.link}' ==
                                      '${widget.modelManga!.lang}-${widget.modelManga!.link}')
                                  .toList()
                                  .first;
                              chap.add(ModelChapters(
                                  name: entries.chapters![i].name,
                                  url: entries.chapters![i].url,
                                  dateUpload: entries.chapters![i].dateUpload,
                                  isBookmarked:
                                      entries.chapters![i].isBookmarked,
                                  scanlator: entries.chapters![i].scanlator,
                                  isRead: idx == i
                                      ? entries.chapters![i].isRead
                                          ? false
                                          : true
                                      : entries.chapters![i].isRead,
                                  lastPageRead:
                                      entries.chapters![i].lastPageRead));
                            }

                            final model = ModelManga(
                                imageUrl: widget.modelManga!.imageUrl,
                                name: widget.modelManga!.name,
                                genre: widget.modelManga!.genre,
                                author: widget.modelManga!.author,
                                description: widget.modelManga!.description,
                                status: widget.modelManga!.status,
                                favorite: widget.modelManga!.favorite,
                                link: widget.modelManga!.link,
                                source: widget.modelManga!.source,
                                lang: widget.modelManga!.lang,
                                dateAdded: widget.modelManga!.dateAdded,
                                lastUpdate: widget.modelManga!.lastUpdate,
                                chapters: chap,
                                category: widget.modelManga!.category,
                                lastRead: widget.modelManga!.lastRead);
                            ref.watch(hiveBoxManga).put(
                                '${widget.modelManga!.lang}-${widget.modelManga!.link}',
                                model);
                            ref
                                .read(chapterIndexListStateProvider.notifier)
                                .clear();
                            ref
                                .read(isLongPressedStateProvider.notifier)
                                .update(false);
                          }
                        },
                        child: Icon(chapter.isRead
                            ? Icons.remove_done_sharp
                            : Icons.done_all_sharp)),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent),
                        onPressed: () {
                          for (var idx in chapterIndexList) {
                            final entries = ref
                                .watch(hiveBoxMangaDownloads)
                                .values
                                .where((element) =>
                                    element.modelManga.chapters![element.index]
                                        .name ==
                                    widget.modelManga!.chapters![idx].name)
                                .toList();
                            if (entries.isEmpty) {
                              ref.watch(downloadChapterProvider(
                                  modelManga: widget.modelManga!, index: idx));
                            } else {
                              if (!entries.first.isDownload) {
                                ref.watch(downloadChapterProvider(
                                    modelManga: widget.modelManga!,
                                    index: idx));
                              }
                            }
                          }
                          ref
                              .read(isLongPressedStateProvider.notifier)
                              .update(false);
                          ref
                              .read(chapterIndexListStateProvider.notifier)
                              .clear();
                        },
                        child: const Icon(Icons.download_outlined)),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _bodyContainer() {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: cachedNetworkImage(
                imageUrl: widget.modelManga!.imageUrl!,
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
                  if (widget.modelManga!.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: widget.modelManga!.description!,
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
                                    i < widget.modelManga!.genre!.length;
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
                                          widget.modelManga!.genre![i],
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
                                      i < widget.modelManga!.genre!.length;
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
                                            widget.modelManga!.genre![i],
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
                                '${widget.modelManga!.chapters!.length.toString()} chapters',
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
                image: CachedNetworkImageProvider(widget.modelManga!.imageUrl!),
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
            Text(widget.modelManga!.name!,
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
                  'url': widget.modelManga!.link!,
                  'source': widget.modelManga!.source!,
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

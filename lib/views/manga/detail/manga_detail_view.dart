import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/readmore.dart';

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

class _MangaDetailViewState extends ConsumerState<MangaDetailView> {
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        ref.read(offetProvider.notifier).state = _scrollController.offset;
      });
    super.initState();
  }

  final offetProvider = StateProvider((ref) => 0.0);
  bool _reverse = false;
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
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
              child: Consumer(
                builder: (context, ref, child) {
                  return AppBar(
                    title: ref.watch(offetProvider) > 200
                        ? Text(widget.modelManga!.name!)
                        : null,
                    backgroundColor: ref.watch(offetProvider) == 0.0
                        ? Colors.transparent
                        : Theme.of(context).scaffoldBackgroundColor,
                    actions: [
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: Icon(Icons.download_outlined,
                              color: Theme.of(context).hintColor)),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {},
                          icon: Icon(Icons.filter_list_sharp,
                              color: Theme.of(context).hintColor)),
                      PopupMenuButton(
                          color: Theme.of(context).hintColor,
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem<int>(
                                value: 0,
                                child: Text("1"),
                              ),
                              const PopupMenuItem<int>(
                                value: 1,
                                child: Text("2"),
                              ),
                              const PopupMenuItem<int>(
                                value: 2,
                                child: Text("3"),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            if (value == 0) {
                            } else if (value == 1) {
                            } else if (value == 2) {}
                          }),
                    ],
                  );
                },
              )),
          body: _listView(),
        ));
  }

  _listView() {
    return DraggableScrollbar.rrect(
        controller: _scrollController,
        child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 0),
            reverse: _reverse,
            itemCount: widget.listLength,
            itemBuilder: (context, index) {
              int finalIndex = index - 1;
              if (index == 0) {
                return _bodyContainer();
              }
              return ListTile(
                key: ObjectKey(widget.modelManga!.chapterUrl),
                onTap: () {
                  pushMangaReaderView(
                      context: context,
                      modelManga: widget.modelManga!,
                      index: finalIndex);
                },
                trailing: const Icon(FontAwesomeIcons.circleDown),
                subtitle: Text(
                  widget.modelManga!.chapterDate![finalIndex],
                  style: const TextStyle(fontSize: 13),
                ),
                title: Text(
                  widget.modelManga!.chapterTitle![finalIndex],
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }));
  }

  Widget _bodyContainer() {
    return Stack(
      children: [
        Positioned(top: 0, child: _backgroundConstructor()),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
                Color(Theme.of(context).scaffoldBackgroundColor.value)
              ],
              stops: const [0, .8],
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
            ),
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  _titleConstructor(),
                  _cardConstructor(),
                ],
              ),
            ),
            _actionConstructor(),
            Container(
              key: const Key("widget_body"),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.modelManga!.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: widget.modelManga!.description!,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Wrap(
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
                                    shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))),
                                onPressed: () {},
                                child: Text(
                                  widget.modelManga!.genre![i],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
                                '${widget.modelManga!.chapterTitle!.length.toString()} chapter(s)',
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

  Widget _cardConstructor() {
    return Positioned(
      key: const Key("widget_card"),
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

  Widget _backgroundConstructor() {
    return cachedNetworkImage(
        imageUrl: widget.modelManga!.imageUrl!,
        width: mediaWidth(context, 1),
        height: 300,
        fit: BoxFit.cover);
  }

  Widget _titleConstructor() {
    return Positioned(
      key: const Key("widget_title"),
      top: 60,
      left: 30,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 100),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.modelManga!.name!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            widget.titleDescription!,
          ],
        ),
      ),
    );
  }

  Widget _actionConstructor() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
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
                onPressed: () {},
                child: Column(
                  children: const [
                    Icon(
                      Icons.travel_explore,
                      size: 25,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text('WebView')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
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
                  final reverse = ref.watch(reverseMangaStateProvider);
                  return AppBar(
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
                            ref.read(reverseMangaStateProvider.notifier).state =
                                !reverse;
                          },
                          icon: Icon(
                              reverse
                                  ? Icons.arrow_downward_sharp
                                  : Icons.arrow_upward_sharp,
                              color: Theme.of(context).hintColor)),
                    ],
                  );
                },
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
              SafeArea(child: _listView()),
            ],
          ),
        ));
  }

  Widget _listView() {
    return Consumer(builder: (context, ref, child) {
      final reverse = ref.watch(reverseMangaStateProvider);
      return DraggableScrollbar.rrect(
          scrollbarTimeToFade: const Duration(seconds: 2),
          controller: _scrollController,
          child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 0),
              itemCount: widget.listLength,
              itemBuilder: (context, index) {
                int finalIndex = index - 1;
                if (index == 0) {
                  return _bodyContainer();
                }

                int reverseIndex = widget.modelManga!.chapterDate!.length -
                    widget.modelManga!.chapterDate!.reversed.toList().indexOf(
                        widget.modelManga!.chapterDate!.reversed
                            .toList()[finalIndex]) -
                    1;
                List<String>? chapterUrl = reverse
                    ? widget.modelManga!.chapterUrl!.reversed.toList()
                    : widget.modelManga!.chapterUrl!;
                List<String>? chapterDate = reverse
                    ? widget.modelManga!.chapterDate!.reversed.toList()
                    : widget.modelManga!.chapterDate!;
                List<String>? chapterTitle = reverse
                    ? widget.modelManga!.chapterTitle!.reversed.toList()
                    : widget.modelManga!.chapterTitle!;

                return ListTile(
                  key: ObjectKey(chapterUrl),
                  onTap: () {
                    pushMangaReaderView(
                        context: context,
                        modelManga: widget.modelManga!,
                        index: reverse ? reverseIndex : finalIndex);
                  },
                  trailing: const Icon(
                    FontAwesomeIcons.circleDown,
                    size: 20,
                  ),
                  subtitle: Text(
                    chapterDate[finalIndex],
                    style: const TextStyle(fontSize: 12),
                  ),
                  title: Text(
                    chapterTitle[finalIndex],
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }));
    });
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
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () {},
                                        child: Text(
                                          widget.modelManga!.genre![i],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
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
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () {},
                                          child: Text(
                                            widget.modelManga!.genre![i],
                                            style:
                                                const TextStyle(fontSize: 12),
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
                                '${widget.modelManga!.chapterTitle!.length.toString()} chapters',
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

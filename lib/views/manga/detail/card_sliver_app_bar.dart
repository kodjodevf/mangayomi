import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/readmore.dart';

class CardSliverAppBar extends ConsumerStatefulWidget {
  final double? height;
  final Function(bool) isExtended;
  final double? appBarHeight = 65;
  final Text? title;
  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final bool? isManga;
  final String? description;
  final ModelManga? modelManga;
  final List<String>? genre;
  final List<String>? chapterTitle;
  const CardSliverAppBar({
    super.key,
    required this.isExtended,
    required this.isManga,
    required this.height,
    required this.title,
    this.titleDescription,
    this.backButtonColors,
    this.action,
    required this.description,
    required this.genre,
    required this.chapterTitle,
    required this.modelManga,
  });

  @override
  ConsumerState<CardSliverAppBar> createState() => _CardSliverAppBarState();
}

class _CardSliverAppBarState extends ConsumerState<CardSliverAppBar> {
  bool _reverse = false;
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
      child: DraggableHome(
        centerTitle: false,
        leading: const BackButton(),
        headerExpandedHeight: mediaHeight(context, 1) <= 600 ? 0.50 : 0.35,
        title: Text(widget.modelManga!.name!),
        actions: [
          IconButton(
            icon: _reverse
                ? const Icon(FontAwesomeIcons.arrowDownShortWide)
                : const Icon(FontAwesomeIcons.arrowUpShortWide),
            iconSize: 25,
            onPressed: () {
              setState(() {
                _reverse = !_reverse;
              });
            },
          ),
        ],
        headerWidget: Stack(
          children: [
            _backgroundConstructor(),
            SafeArea(
              child: Stack(
                children: [
                  _titleConstructor(),
                  _cardConstructor(),
                  if (widget.action != null) _actionConstructor(),
                  _backButtonConstructor(),
                  _filterConstructor(),
                ],
              ),
            )
          ],
        ),
        body: [
          _bodyContainer(),
          _listView(),
          const SizedBox(
            height: 50,
          )
        ],
        fullyStretchable: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  ListView _listView() {
    return ListView.builder(
        // controller: _scrollController,
        padding: const EdgeInsets.only(top: 0),
        physics: const NeverScrollableScrollPhysics(),
        reverse: _reverse,
        itemCount: widget.modelManga!.chapterTitle!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            key: ObjectKey(widget.modelManga!.chapterUrl),
            onTap: () {},
            trailing: const Icon(FontAwesomeIcons.circleDown),
            subtitle: widget.isManga == true
                ? Text(
                    widget.modelManga!.chapterDate![index],
                    style: const TextStyle(fontSize: 13),
                  )
                : const SizedBox(
                    height: 10,
                  ),
            title: Text(
              widget.modelManga!.chapterTitle![index],
              style: const TextStyle(fontSize: 15),
            ),
          );
        });
  }

  Widget _backButtonConstructor() {
    return Positioned(
      top: 7,
      left: 5,
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 25,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _filterConstructor() {
    return Positioned(
      top: 7,
      right: 0,
      child: IconButton(
        icon: _reverse
            ? const Icon(FontAwesomeIcons.arrowDownShortWide)
            : const Icon(FontAwesomeIcons.arrowUpShortWide),
        iconSize: 25,
        onPressed: () {
          setState(() {
            _reverse = !_reverse;
          });
        },
      ),
    );
  }

  Widget _bodyContainer() {
    return Container(
      key: const Key("widget_body"),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              children: [
                for (var i = 0; i < widget.genre!.length; i++)
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2, right: 2, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(width: 1, color: Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: Text(
                                widget.genre![i],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          // log
          Column(
            children: [
              //Description
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReadMoreWidget(
                    text: widget.description!,
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${widget.chapterTitle!.length.toString()} chapter(s)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      // _body
      // ,
    );
  }

  Widget _cardConstructor() {
    return Positioned(
      key: const Key("widget_card"),
      top: widget.height! - (widget.appBarHeight! * 1.8),
      left: 20,
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: widget.appBarHeight! * 1.5,
          height: widget.appBarHeight! * 2.3,
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
    return SizedBox(
      key: const Key("widget_background"),
      height: widget.height! + 400,
      width: MediaQuery.of(context).size.width,
      // color: Colors.black,
      child: Blur(
        blur: 10,
        blurColor: Theme.of(context).primaryColor,
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
    );
  }

  Widget _titleConstructor() {
    return Positioned(
      key: const Key("widget_title"),
      top: widget.height! - widget.appBarHeight!,
      left: 30,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 100),
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
        height: 70,
        child: _titleDescriptionHandler(),
      ),
    );
  }

  Widget _titleDescriptionHandler() {
    var titleContainer = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        bottom: 50,
      ),
      child: widget.title,
    );

    var titleDescriptionContainer = Opacity(
      opacity: 1.0,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: widget.titleDescription,
      ),
    );

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        titleContainer,
        titleDescriptionContainer,
      ],
    );
  }

  Widget _actionConstructor() {
    return Positioned(
        key: const Key("widget_action"),
        top: widget.height! - widget.appBarHeight! - 45,
        right: 10,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 3.0)
                  ]),
              child: widget.action,
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54, blurRadius: 3.0)
                  ]),
              child: IconButton(
                  onPressed: () async {},
                  icon: const Icon(Icons.travel_explore)),
            ),
          ],
        ));
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';

class TrackerWidgetSearch extends ConsumerStatefulWidget {
  final bool isManga;
  final Track track;
  const TrackerWidgetSearch(
      {required this.isManga, required this.track, super.key});

  @override
  ConsumerState<TrackerWidgetSearch> createState() =>
      _TrackerWidgetSearchState();
}

class _TrackerWidgetSearchState extends ConsumerState<TrackerWidgetSearch> {
  @override
  initState() {
    _init();
    super.initState();
  }

  late String query = widget.track.title!.trim();
  late List<TrackSearch>? tracks = [];
  _init() async {
    await Future.delayed(const Duration(microseconds: 100));
    tracks = await ref
        .read(trackStateProvider(track: widget.track, isManga: widget.isManga)
            .notifier)
        .search(query);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late final _controller = TextEditingController(text: query);
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: _isLoading
          ? const ProgressCenter()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: mediaHeight(context, 0.8),
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: tracks!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, tracks![index]);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.transparent,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: Ink.image(
                                          height: 120,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              tracks![index].coverUrl!),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: mediaWidth(context, 0.6),
                                            child: Text(
                                              tracks![index].title!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Type : ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                tracks![index].publishingType!,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Status : ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                tracks![index]
                                                    .publishingStatus!,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Text(
                                    tracks![index].summary!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        onChanged: (d) {
                          setState(() {
                            query = d;
                          });
                        },
                        onFieldSubmitted: (d) async {
                          setState(() {
                            _isLoading = true;
                          });
                          tracks = await ref
                              .read(trackStateProvider(
                                      track: widget.track,
                                      isManga: widget.isManga)
                                  .notifier)
                              .search(d.trim());
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.transparent,
                            suffixIcon: query.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _controller.clear();
                                    },
                                    icon: const Icon(Icons.clear)),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor(context)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: primaryColor(context)),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor(context)))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

trackersSearchraggableMenu(BuildContext context,
    {required Track track, required bool isManga}) async {
  return await DraggableMenu.open(
      context,
      DraggableMenu(
          blockMenuClosing: true,
          ui: ClassicDraggableMenu(
              radius: 20,
              barItem: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.clear)),
                    )
                  ],
                ),
              )),
          levels: [
            DraggableMenuLevel.ratio(ratio: 0.9),
          ],
          minimizeBeforeFastDrag: true,
          child: TrackerWidgetSearch(
            track: track,
            isManga: isManga,
          )));
}

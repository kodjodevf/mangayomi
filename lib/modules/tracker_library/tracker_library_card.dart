import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_item_card.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class TrackerLibraryImageCard extends ConsumerStatefulWidget {
  final TrackSearch track;
  final ItemType itemType;

  const TrackerLibraryImageCard({
    super.key,
    required this.track,
    required this.itemType,
  });

  @override
  ConsumerState<TrackerLibraryImageCard> createState() =>
      _TrackerLibraryImageCardState();
}

class _TrackerLibraryImageCardState
    extends ConsumerState<TrackerLibraryImageCard>
    with AutomaticKeepAliveClientMixin<TrackerLibraryImageCard> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final trackData = widget.track;
    return GestureDetector(
      onTap: () => _showCard(context),
      child: StreamBuilder(
        stream: isar.tracks
            .filter()
            .mangaIdIsNotNull()
            .mediaIdEqualTo(trackData.mediaId)
            .itemTypeEqualTo(widget.itemType)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Stack(
              children: [
                SizedBox(
                  width: 110,
                  child: Column(
                    children: [
                      Builder(
                        builder: (context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              children: [
                                cachedNetworkImage(
                                  imageUrl: toImgUrl(trackData.coverUrl ?? ""),
                                  width: 110,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Text.rich(
                                    TextSpan(
                                      style: TextStyle(
                                        background: Paint()
                                          ..color = Theme.of(context)
                                              .scaffoldBackgroundColor
                                              .withValues(alpha: 0.75)
                                          ..strokeWidth = 20.0
                                          ..strokeJoin = StrokeJoin.round
                                          ..style = PaintingStyle.stroke,
                                      ),
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            Icons.star,
                                            color: context.primaryColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " ${trackData.score ?? "?"}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      BottomTextWidget(
                        fontSize: 12.0,
                        text: trackData.title!,
                        isLoading: true,
                        textColor: Theme.of(context).textTheme.bodyLarge!.color,
                        isComfortableGrid: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 110,
                  height: 150,
                  color: hasData ? Colors.black.withValues(alpha: 0.7) : null,
                ),
                if (hasData)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.collections_bookmark,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          TrackerItemCard(track: widget.track, itemType: widget.itemType),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

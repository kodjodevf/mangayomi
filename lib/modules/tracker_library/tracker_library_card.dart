import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/in_library_badge.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_item_card.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackerLibraryImageCard extends StatelessWidget {
  final TrackSearch track;
  final ItemType itemType;
  final Track? libraryTrack;

  const TrackerLibraryImageCard({
    super.key,
    required this.track,
    required this.itemType,
    this.libraryTrack,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = libraryTrack?.mangaId != null;
    return GestureDetector(
      onTap: () => _showCard(context, libraryTrack?.mangaId),
      child: Padding(
        padding: const EdgeInsets.only(left: ShioriSpace.s12),
        child: Stack(
          children: [
            SizedBox(
              width: 110,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ShioriShape.cover),
                    child: Stack(
                      children: [
                        cachedNetworkImage(
                          imageUrl: toImgUrl(track.coverUrl ?? ""),
                          width: 110,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        PositionedDirectional(
                          top: ShioriSpace.s4,
                          end: ShioriSpace.s4,
                          child: EntryBadgeChip(
                            label: '★ ${track.score ?? "?"}',
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomTextWidget(
                    fontSize: context.shiori.text.meta.fontSize,
                    text: track.title!,
                    isLoading: true,
                    textColor: context.shiori.color.fg,
                    isComfortableGrid: true,
                  ),
                ],
              ),
            ),
            Container(
              width: 110,
              height: 150,
              // Already in the library: a light veil and a label, so the
              // cover stays recognisable.
              color: hasData ? inLibraryVeil : null,
            ),
            if (hasData)
              PositionedDirectional(
                top: ShioriSpace.s4,
                start: ShioriSpace.s4,
                child: const InLibraryBadge(),
              ),
          ],
        ),
      ),
    );
  }

  void _showCard(BuildContext context, int? mangaId) {
    showTrackerItemSheet(
      context,
      track: track,
      itemType: itemType,
      mangaId: mangaId,
    );
  }
}

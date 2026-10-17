import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_listile.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Opens the tracker list bottom sheet for [manga]. [entries] is the set of
/// logged-in tracker services. Each row shows the current tracking state
/// ([TrackerWidget]) or an "add tracker" tile that runs a search. Shared by the
/// classic manga detail and the TV anime detail so both behave identically.
void openTrackingMenu({
  required BuildContext context,
  required Manga manga,
  required List<TrackPreference> entries,
}) {
  showShioriSheet<void>(
    context,
    title: context.l10n.tracking,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        return Padding(
          // Clear of the system navigation bar, so the last tracker is not
          // behind the on-screen buttons.
          padding: EdgeInsets.fromLTRB(
            ShioriSpace.s8,
            0,
            ShioriSpace.s8,
            ShioriSpace.s8 + MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: SuperListView.separated(
            padding: const EdgeInsets.all(0),
            itemCount: entries.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return StreamBuilder(
                stream: trackRepository.watchBySyncIdAndMangaId(
                  entries[index].syncId,
                  manga.id!,
                ),
                builder: (context, snapshot) {
                  List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
                  return trackRes!.isNotEmpty
                      ? TrackerWidget(
                          mangaId: manga.id!,
                          syncId: entries[index].syncId!,
                          trackRes: trackRes.first,
                          itemType: manga.itemType,
                        )
                      : TrackListile(
                          text: l10nLocalizations(context)!.add_tracker,
                          onTap: () async {
                            final trackSearch =
                                await trackersSearchDraggableMenu(
                                  context,
                                  itemType: manga.itemType,
                                  track: Track(
                                    status: TrackStatus.planToRead,
                                    syncId: entries[index].syncId!,
                                    title: manga.name!,
                                  ),
                                );
                            if (trackSearch != null) {
                              await ref
                                  .read(
                                    trackStateProvider(
                                      track: null,
                                      itemType: manga.itemType,
                                      widgetRef: ref,
                                    ).notifier,
                                  )
                                  .setTrackSearch(
                                    trackSearch,
                                    manga.id!,
                                    entries[index].syncId!,
                                  );
                            }
                          },
                          id: entries[index].syncId!,
                          entries: const [],
                        );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        );
      },
    ),
  );
}

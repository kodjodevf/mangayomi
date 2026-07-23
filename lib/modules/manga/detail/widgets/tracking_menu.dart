import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_listile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
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
  DraggableMenu.open(
    context,
    Consumer(
      builder: (context, ref, _) {
        final isPureBlack = ref.watch(pureBlackDarkModeStateProvider);
        final theme = Theme.of(context);
        final bgColor = context.isLight || !isPureBlack
            ? theme.scaffoldBackgroundColor.withValues(alpha: 0.9)
            : theme.cardColor;

        return DraggableMenu(
          ui: ClassicDraggableMenu(
            radius: 20,
            barItem: Container(),
            color: theme.scaffoldBackgroundColor,
          ),
          allowToShrink: true,
          child: Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SuperListView.separated(
                padding: const EdgeInsets.all(0),
                itemCount: entries.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: isar.tracks
                        .filter()
                        .idIsNotNull()
                        .syncIdEqualTo(entries[index].syncId)
                        .mangaIdEqualTo(manga.id!)
                        .watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      List<Track>? trackRes = snapshot.hasData
                          ? snapshot.data
                          : [];
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
                                        )
                                        as TrackSearch?;
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
            ),
          ),
        );
      },
    ),
  );
}

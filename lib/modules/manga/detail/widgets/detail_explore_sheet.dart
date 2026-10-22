import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/manga/detail/widgets/detail_header_action.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:shiori/shiori.dart';

/// A place a title leads to from its detail page.
class DetailExploreAction {
  const DetailExploreAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.onPressed,
  });

  final IconData icon;
  final String label;

  /// What is found there, under its name.
  final String description;
  final VoidCallback onPressed;
}

/// Explore quick action button under the manga detail cover.
class DetailExploreButton extends StatelessWidget {
  const DetailExploreButton({super.key, required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailHeaderAction(
      icon: Symbols.explore_rounded,
      label: l10n.group_explore,
      onPressed: () => showShioriSheet<void>(
        context,
        title: l10n.group_explore,
        builder: (_) => DetailExplorePlaces(manga: manga),
      ),
    );
  }
}

/// The places [manga] leads to, worked out when the sheet opens.
class DetailExplorePlaces extends ConsumerWidget {
  const DetailExplorePlaces({super.key, required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final router = GoRouter.of(context);
    DetailExploreAction recommendations(MediaLookupContext media) =>
        DetailExploreAction(
          icon: Symbols.auto_awesome_rounded,
          label: l10n.recommendations,
          description: l10n.explore_recommendations_subtitle,
          onPressed: () => router.push(
            "/recommendations",
            extra: (media, ref.read(algorithmWeightsStateProvider)),
          ),
        );
    final related = DetailExploreAction(
      icon: Symbols.account_tree_rounded,
      label: l10n.related_titles,
      description: l10n.explore_related_subtitle,
      onPressed: () =>
          router.push("/related", extra: (manga.name!, manga.itemType)),
    );

    if (manga.itemType != ItemType.anime) {
      return DetailExploreList(
        actions: [
          recommendations(MediaLookupContext.fromManga(manga)),
          related,
        ],
      );
    }
    return StreamBuilder(
      stream: trackRepository.watchByMangaId(manga.id!),
      builder: (context, snapshot) {
        final tracks = snapshot.data ?? const <Track>[];
        Track? sequelTrack;
        for (final track in tracks) {
          final mediaId = track.mediaId;
          if (mediaId != null &&
              mediaId > 0 &&
              (track.syncId == TrackerProviders.myAnimeList.syncId ||
                  track.syncId == TrackerProviders.anilist.syncId)) {
            sequelTrack ??= track;
          }
        }
        final media = MediaLookupContext.fromManga(manga, tracks: tracks);
        return DetailExploreList(
          actions: [
            recommendations(media),
            related,
            DetailExploreAction(
              icon: Symbols.format_list_numbered_rounded,
              label: l10n.watch_order,
              description: l10n.explore_watch_order_subtitle,
              onPressed: () =>
                  router.push("/watchOrder", extra: (media, null as Track?)),
            ),
            if (sequelTrack != null)
              DetailExploreAction(
                icon: Symbols.playlist_play_rounded,
                label: l10n.sequels,
                description: l10n.explore_sequels_subtitle,
                onPressed: () =>
                    router.push("/watchOrder", extra: (media, sequelTrack)),
              ),
          ],
        );
      },
    );
  }
}

/// The places to go, each a full row: its icon, its name, what is there, and a chevron.
class DetailExploreList extends StatelessWidget {
  const DetailExploreList({super.key, required this.actions});

  final List<DetailExploreAction> actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              ShioriSettingRow(
                icon: action.icon,
                title: action.label,
                subtitle: action.description,
                trailing: const Icon(Symbols.chevron_forward_rounded),
                onTap: () {
                  Navigator.pop(context);
                  action.onPressed();
                },
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_routes.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Every monthly Episode, newest first, like a series' chapter list; the
/// Prologue closes the list.
class EpisodeListScreen extends ConsumerWidget {
  const EpisodeListScreen({super.key, required this.itemType});

  final ItemType itemType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = StripText(ref.watch(recapFontsProvider));
    final episodes = ref.watch(episodeListProvider(itemType: itemType));
    return Scaffold(
      backgroundColor: StripColors.bg,
      appBar: AppBar(
        backgroundColor: StripColors.bg,
        foregroundColor: StripColors.paper,
        surfaceTintColor: StripColors.bg,
        title: Text(l10n.recapEpisodesTitle, style: text.nav),
      ),
      body: episodes.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: StripColors.yellow),
        ),
        error: (err, _) => ErrorState(detail: err.toString()),
        data: (data) {
          final since = data.prologue.since;
          return ListView(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s48),
            children: [
              if (data.months.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(ShioriSpace.s16),
                  child: Text(l10n.recapEpisodesEmpty, style: text.tileBody),
                ),
              for (final episode in data.months)
                _EpisodeTile(
                  coverIds: episode.coverMangaIds,
                  title: l10n.recapEpisodeTitle(
                    monthLabel(context, episode.month),
                  ),
                  teaser: l10n.recapEpisodeTeaser(
                    formatCount(context, episode.completions),
                    tenthHours(context, episode.seconds),
                    l10n.recapUnits(episode.completions, itemType.name),
                  ),
                  text: text,
                  onTap: () =>
                      context.push(episodeLocation(itemType, episode.month)),
                ),
              _EpisodeTile(
                coverIds: [for (final s in data.prologue.bonded) s.id],
                title: l10n.recapPrologue,
                teaser: since == null
                    ? l10n.recapPrologueTeaserUndated
                    : l10n.recapPrologueTeaser(monthLabel(context, since)),
                text: text,
                onTap: () => context.push(episodeLocation(itemType, null)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({
    required this.coverIds,
    required this.title,
    required this.teaser,
    required this.text,
    required this.onTap,
  });

  final List<int> coverIds;
  final String title;
  final String teaser;
  final StripText text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s16,
          vertical: ShioriSpace.s12,
        ),
        child: Row(
          children: [
            _Collage(ids: coverIds),
            const SizedBox(width: ShioriSpace.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: ShioriSpace.s4,
                children: [
                  Text(title, style: text.tileTitle),
                  Text(
                    teaser,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.tileBody,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Up to three covers fanned like a stack of chapters.
class _Collage extends StatelessWidget {
  const _Collage({required this.ids});

  static const _width = 44.0;
  static const _height = 66.0;
  static const _offset = 16.0;
  static const _shown = 3;

  final List<int> ids;

  @override
  Widget build(BuildContext context) {
    final shown = ids.take(_shown).toList();
    return SizedBox(
      width: _width + _offset * (_shown - 1),
      height: _height,
      child: Stack(
        children: [
          if (shown.isEmpty)
            Container(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: StripColors.coverPlaceholder,
                border: Border.all(color: StripColors.paper, width: 1.5),
              ),
            ),
          // Drawn last-first so the month's #1 sits on top.
          for (final (i, id) in shown.indexed.toList().reversed)
            Positioned(
              left: i * _offset,
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  border: Border.all(color: StripColors.paper, width: 1.5),
                  borderRadius: StripShape.tileRadius,
                ),
                clipBehavior: Clip.hardEdge,
                child: RecapCover(
                  mangaId: id,
                  placeholder: StripColors.coverPlaceholder,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

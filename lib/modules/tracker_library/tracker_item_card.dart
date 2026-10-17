import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';

/// Opens a tracker entry from the tracker library in a sheet.
Future<void> showTrackerItemSheet(
  BuildContext context, {
  required TrackSearch track,
  required ItemType itemType,
  int? mangaId,
}) {
  return showShioriSheet<void>(
    context,
    builder: (_) =>
        TrackerItemCard(track: track, itemType: itemType, mangaId: mangaId),
  );
}

/// A tracker entry: its cover, title, score and length, its summary, and
/// what can be done with it — add it to the library, open it there when it
/// already is, or open it on the tracker's site.
///
/// It was a full-screen dialog over the blurred cover, laid out in fractions
/// of the screen's width; it is the inside of a sheet now, as every other
/// look at one entry.
class TrackerItemCard extends StatelessWidget {
  final TrackSearch track;
  final ItemType itemType;
  final int? mangaId;

  const TrackerItemCard({
    super.key,
    required this.track,
    required this.itemType,
    this.mangaId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final c = tokens.color;
    final meta = [
      if (track.score != null) '★ ${track.score}',
      if (track.totalChapter != null && track.totalChapter! > 0)
        '${track.totalChapter} ${itemType == ItemType.anime ? l10n.episodes : l10n.chapters}',
      ?track.publishingType,
      ?track.publishingStatus,
    ].where((s) => s.isNotEmpty).join(' · ');
    final cover = track.coverUrl ?? '';
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s8,
        ShioriSpace.s16,
        ShioriSpace.s16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: ShioriSpace.s16,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ShioriSpace.s16,
            children: [
              ShioriThumbnail(
                height: tokens.scaled(132),
                child: cover.isEmpty
                    ? Icon(Symbols.image_rounded, color: c.fgMuted)
                    : Image(
                        image: coverProvider(toImgUrl(cover)),
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: ShioriSpace.s4,
                  children: [
                    Text(
                      track.title ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.seriesTitle.copyWith(color: c.fg),
                    ),
                    if (meta.isNotEmpty) Text(meta, style: tokens.caption),
                  ],
                ),
              ),
            ],
          ),
          if ((track.summary ?? '').isNotEmpty)
            ReadMoreWidget(text: track.summary!, onChanged: (_) {}),
          Wrap(
            spacing: ShioriSpace.s8,
            runSpacing: ShioriSpace.s8,
            children: [
              ShioriButton(
                onPressed: () => _go(context, _migrationRoute),
                label: l10n.track_library_add,
                icon: Symbols.add_rounded,
              ),
              if (mangaId != null)
                ShioriButton.secondary(
                  onPressed: () => _go(
                    context,
                    (router) =>
                        router.push('/manga-reader/detail', extra: mangaId),
                  ),
                  label: l10n.track_library_navigate,
                  icon: Symbols.north_east_rounded,
                ),
              if ((track.trackingUrl ?? '').isNotEmpty)
                ShioriButton.quiet(
                  onPressed: () => InAppBrowser.openWithSystemBrowser(
                    url: WebUri(track.trackingUrl!),
                  ),
                  label: l10n.open_in_browser,
                  icon: Symbols.public_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Closes the sheet, then goes where [push] says: the new screen opens
  /// on its own rather than over a sheet left behind it.
  void _go(BuildContext context, void Function(GoRouter router) push) {
    final router = GoRouter.of(context);
    Navigator.pop(context);
    push(router);
  }

  void _migrationRoute(GoRouter router) {
    router.push(
      "/migrate/tracker",
      extra: (
        Manga(
          name: track.title,
          itemType: itemType,
          source: null,
          author: "",
          artist: "",
          genre: [],
          imageUrl: null,
          lang: null,
          link: null,
          status: Status.unknown,
          description: "",
          sourceId: null,
        ),
        track,
      ),
    );
  }
}

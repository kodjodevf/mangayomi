import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/deferred_cover_image.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:shiori/shiori.dart';

/// One series' new chapters on one day.
class SeriesDayUpdates {
  SeriesDayUpdates({
    required this.mangaId,
    required this.day,
    required this.updates,
  });

  final int mangaId;

  /// The day key the list groups under.
  final String day;

  /// Newest first.
  final List<Update> updates;

  /// When the newest of them arrived, for ordering within the day.
  String get latest => updates.first.date ?? '';
}

/// [updates] folded into one entry per series and day, so ten chapters of
/// one series released together make one row rather than ten.
List<SeriesDayUpdates> groupUpdatesBySeries(
  List<Update> updates, {
  required int? Function(Update) mangaIdOf,
  required String Function(Update) dayOf,
}) {
  final groups = <(int, String), List<Update>>{};
  for (final u in updates) {
    final mangaId = mangaIdOf(u);
    if (mangaId == null) continue;
    (groups[(mangaId, dayOf(u))] ??= []).add(u);
  }
  int when(Update u) => int.tryParse(u.date ?? '') ?? 0;
  return [
    for (final MapEntry(key: (mangaId, day), value: list) in groups.entries)
      SeriesDayUpdates(
        mangaId: mangaId,
        day: day,
        updates: list..sort((a, b) => when(b).compareTo(when(a))),
      ),
  ];
}

/// A series with several new chapters on a day: one row saying how many,
/// that opens onto the chapters themselves.
class SeriesUpdatesTile extends ConsumerStatefulWidget {
  const SeriesUpdatesTile({
    super.key,
    required this.manga,
    required this.chapters,
  });

  final Manga manga;

  /// Newest first.
  final List<Chapter> chapters;

  @override
  ConsumerState<SeriesUpdatesTile> createState() => _SeriesUpdatesTileState();
}

class _SeriesUpdatesTileState extends ConsumerState<SeriesUpdatesTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final manga = widget.manga;
    final chapters = widget.chapters;
    final height = context.shiori.density.rowHeight - ShioriSpace.s8;
    final unread = chapters.where((c) => !(c.isRead ?? false)).length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          expanded: _open,
          child: ShioriListRow(
            leading: ShioriThumbnail(
              height: height,
              semanticLabel: manga.name,
              onTap: () =>
                  context.push('/manga-reader/detail', extra: manga.id),
              child: DeferredCoverImage(
                width: height * coverAspect,
                height: height,
                builder: (context) => Image(
                  image: manga.customCoverImage != null
                      ? MemoryImage(manga.customCoverImage as Uint8List)
                      : coverProvider(
                          toImgUrl(
                            manga.customCoverFromTracker ??
                                manga.imageUrl ??
                                '',
                          ),
                          headers: ref.watch(
                            headersProvider(
                              source: manga.source!,
                              lang: manga.lang!,
                              sourceId: manga.sourceId,
                            ),
                          ),
                        ),
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
            title: manga.name!,
            subtitle:
                '${l10n.n_new_chapters(chapters.length)} · ${chapters.first.name}',
            dimmed: unread == 0,
            onTap: () => setState(() => _open = !_open),
            trailing: AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: ShioriMotion.of(context, ShioriMotion.fast),
              child: Icon(
                Symbols.expand_more_rounded,
                semanticLabel: _open
                    ? MaterialLocalizations.of(context).expandedHint
                    : MaterialLocalizations.of(context).collapsedHint,
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: ShioriMotion.of(context, ShioriMotion.standard),
          curve: ShioriMotion.standardCurve,
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: ShioriSpace.s24,
                  ),
                  child: Column(
                    children: [
                      for (final chapter in chapters)
                        UpdateChapterListTileWidget(
                          chapter: chapter,
                          manga: manga,
                          sourceExist: true,
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

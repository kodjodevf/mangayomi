import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';

/// Looks a series up on a tracker and lets the reader pick the match.
///
/// The search starts from the series' title; the field is at the head of
/// the sheet, as in every Shiori choice with a search, and each result is a
/// row with its cover, its type and status, and the start of its summary.
class TrackerWidgetSearch extends ConsumerStatefulWidget {
  final ItemType itemType;
  final Track track;
  const TrackerWidgetSearch({
    required this.itemType,
    required this.track,
    super.key,
  });

  @override
  ConsumerState<TrackerWidgetSearch> createState() =>
      _TrackerWidgetSearchState();
}

class _TrackerWidgetSearchState extends ConsumerState<TrackerWidgetSearch> {
  late final _controller = TextEditingController(
    text: widget.track.title?.trim() ?? '',
  );
  List<TrackSearch> _results = [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    // After the first frame, so the provider isn't read during build.
    WidgetsBinding.instance.addPostFrameCallback((_) => _search());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await ref
          .read(
            trackStateProvider(
              track: widget.track,
              itemType: widget.itemType,
              widgetRef: ref,
            ).notifier,
          )
          .search(_controller.text.trim());
      _results = results ?? [];
    } catch (e) {
      _error = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final Widget body;
    if (_loading) {
      body = const ShioriLoading();
    } else if (_error != null) {
      body = ErrorState(detail: _error, onRetry: _search);
    } else if (_results.isEmpty) {
      body = ShioriEmptyState(
        icon: Symbols.search_off_rounded,
        title: l10n.no_result,
        compact: true,
      );
    } else {
      body = ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: ShioriSpace.s16),
        itemCount: _results.length,
        itemBuilder: (context, index) => _ResultRow(
          result: _results[index],
          onTap: () => Navigator.pop(context, _results[index]),
        ),
      );
    }
    return Padding(
      // The keyboard covers the sheet's foot; the results stay above it.
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      // As tall as the results, up to three quarters of the screen; the
      // loading, empty and failed states keep a modest height of their own.
      child: AnimatedSize(
        duration: ShioriMotion.of(context, ShioriMotion.standard),
        curve: ShioriMotion.standardCurve,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: media.size.height * 0.75),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ShioriSpace.s16,
                  0,
                  ShioriSpace.s16,
                  ShioriSpace.s8,
                ),
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) => TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.search,
                      prefixIcon: const Icon(Symbols.search_rounded),
                      suffixIcon: _controller.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: MaterialLocalizations.of(context)
                                  .clearButtonTooltip,
                              onPressed: _controller.clear,
                              icon: const Icon(Symbols.close_rounded),
                            ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
              ),
              Flexible(
                child: body is ListView
                    ? body
                    : SizedBox(height: context.shiori.scaled(240), child: body),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One match: the cover, the title, its type and status, and the start of
/// its summary.
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.onTap});

  final TrackSearch result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final meta = [
      result.publishingType,
      result.publishingStatus,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    final summary = result.summary?.trim() ?? '';
    final cover = result.coverUrl ?? '';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s16,
          vertical: ShioriSpace.s8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ShioriSpace.s12,
          children: [
            ShioriThumbnail(
              height: tokens.scaled(96),
              child: cover.isEmpty
                  ? Icon(Symbols.image_rounded, color: c.fgMuted)
                  : Image(image: coverProvider(cover), fit: BoxFit.cover),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    result.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text.row.copyWith(
                      color: c.fg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (meta.isNotEmpty) Text(meta, style: tokens.caption),
                  if (summary.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: ShioriSpace.s4),
                      child: Text(
                        summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.text.meta.copyWith(color: c.fgMuted),
                      ),
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

/// Opens the search on [track]'s tracker; resolves to the [TrackSearch]
/// picked, or null.
Future<TrackSearch?> trackersSearchDraggableMenu(
  BuildContext context, {
  required Track track,
  required ItemType itemType,
}) {
  return showShioriSheet<TrackSearch>(
    context,
    title: track.syncId == null ? null : trackInfos(track.syncId!).$2,
    builder: (_) => TrackerWidgetSearch(track: track, itemType: itemType),
  );
}

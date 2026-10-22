import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

import 'tv_key_utils.dart';

class TvDetailEpisodesPanel extends StatelessWidget {
  const TvDetailEpisodesPanel({
    super.key,
    required this.episodes,
    required this.resumeId,
    required this.loading,
    required this.onExitLeft,
    required this.onOpen,
  });

  final List<Chapter> episodes;
  final int? resumeId;
  final bool loading;
  final VoidCallback onExitLeft;
  final ValueChanged<Chapter> onOpen;

  @override
  Widget build(BuildContext context) {
    final accent = context.shiori.color.accentInk;
    // No panel surface and no divider line: the list sits over the same
    // backdrop as the left side so the two columns read as one screen. It fills
    // its half so the episodes balance the hero on the left instead of leaving
    // an empty gap on the right.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            'Episodes  ·  ${episodes.length}',
            style: TextStyle(
              fontSize: ShioriType.reference.section.fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: loading
              ? const SizedBox.shrink()
              : episodes.isEmpty
              ? Center(
                  child: Text(
                    context.l10n.no_episodes_yet,
                    style: TextStyle(color: context.shiori.color.fgMuted),
                  ),
                )
              : FocusTraversalGroup(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 28),
                    itemCount: episodes.length,
                    itemBuilder: (context, i) {
                      final ep = episodes[i];
                      return TvDetailEpisodeRow(
                        accent: accent,
                        episode: ep,
                        index: i,
                        isResume: ep.id != null && ep.id == resumeId,
                        onOpen: () => onOpen(ep),
                        onExitLeft: onExitLeft,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class TvDetailEpisodeRow extends StatefulWidget {
  const TvDetailEpisodeRow({
    super.key,
    required this.accent,
    required this.episode,
    required this.index,
    required this.isResume,
    required this.onOpen,
    required this.onExitLeft,
  });

  final Color accent;
  final Chapter episode;
  final int index;
  final bool isResume;
  final VoidCallback onOpen;
  final VoidCallback onExitLeft;

  @override
  State<TvDetailEpisodeRow> createState() => _TvDetailEpisodeRowState();
}

class _TvDetailEpisodeRowState extends State<TvDetailEpisodeRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final ep = widget.episode;
    final watched = ep.isRead ?? false;
    final filler = ep.isFiller ?? false;
    final title = (ep.name ?? '').trim().isEmpty
        ? 'Episode ${widget.index + 1}'
        : ep.name!.trim();
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            widget.onExitLeft();
            return KeyEventResult.handled;
          }
        }
        if (event is KeyDownEvent && isTvSelectKey(event.logicalKey)) {
          widget.onOpen();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onOpen,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: _focused
                ? widget.accent.withValues(alpha: Alphas.accentTint)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          child: Row(
            children: [
              // Unwatched marker — an accent bar that fades to grey once the
              // episode is read (the classic detail's left rail).
              Container(
                width: 3,
                height: 34,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: watched
                      ? context.shiori.color.fgMuted.withValues(alpha: 0.3)
                      : widget.accent,
                  borderRadius: BorderRadius.circular(ShioriShape.card),
                ),
              ),
              // The title already reads "Episode N", so no leading number —
              // just a play marker on the resume episode.
              if (widget.isResume) ...[
                Icon(
                  Symbols.play_arrow_rounded,
                  fill: 1,
                  color: widget.accent,
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: watched ? context.shiori.color.fgMuted : null,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (filler)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ShioriShape.badge),
                    border: Border.all(color: context.shiori.color.fgMuted),
                  ),
                  child: Text(
                    context.l10n.filler.toUpperCase(),
                    style: TextStyle(
                      fontSize: ShioriType.reference.meta.fontSize,
                      color: context.shiori.color.fgMuted,
                    ),
                  ),
                ),
              if ((ep.duration ?? '').isNotEmpty) ...[
                const SizedBox(width: 10),
                Text(
                  ep.duration!,
                  style: TextStyle(
                    fontSize: ShioriType.reference.meta.fontSize,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
              ],
              if (watched)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Symbols.check_circle_rounded,
                    fill: 1,
                    size: 16,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

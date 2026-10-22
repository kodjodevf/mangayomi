import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

import 'tv_key_utils.dart';

/// The hero column: cover with the title bottom-aligned beside it, meta, tags,
/// synopsis, then a vertical, scrollable list of actions. Up/Down moves through
/// the actions (auto-scrolling); Right off any action jumps to the episodes;
/// the first action (Continue) hands Up back to the top bar.
class TvDetailLeftInfo extends StatelessWidget {
  const TvDetailLeftInfo({
    super.key,
    required this.manga,
    required this.cover,
    required this.episodeCount,
    required this.watched,
    required this.resume,
    required this.actionFocus,
    required this.onPlay,
    required this.onToggleLibrary,
    required this.onCategories,
    required this.onTracking,
    required this.onBrowser,
    required this.onRecommendations,
    required this.onWatchOrder,
    required this.onMigrate,
    required this.onMassMigrate,
    required this.onExitUp,
  });

  final Manga manga;
  final ImageProvider cover;
  final int episodeCount;
  final int watched;
  final Chapter? resume;
  final List<FocusNode> actionFocus;
  final VoidCallback onPlay;
  final VoidCallback onToggleLibrary;
  final VoidCallback onCategories;
  final VoidCallback onTracking;
  final VoidCallback onBrowser;
  final VoidCallback onRecommendations;
  final VoidCallback onWatchOrder;
  final VoidCallback onMigrate;
  final VoidCallback onMassMigrate;
  final VoidCallback onExitUp;

  @override
  Widget build(BuildContext context) {
    final accent = context.shiori.color.accentInk;
    final genres = (manga.genre ?? const <String>[])
        .where((g) => g.trim().isNotEmpty)
        .toList();
    final metaBits = <String>[
      manga.status.name.isNotEmpty ? _cap(manga.status.name) : '',
      '$episodeCount episodes',
      if ((manga.source ?? '').isNotEmpty) manga.source!,
      if ((manga.author ?? '').isNotEmpty) manga.author!,
    ].where((s) => s.isNotEmpty).join('   ·   ');
    final favorite = manga.favorite ?? false;
    final resumeWord = resume == null
        ? 'Play'
        : (resume!.isRead ?? false)
        ? 'Replay'
        : (watched > 0 ? 'Continue' : 'Play');
    final resumeName = resume?.name?.trim() ?? '';
    final resumeLabel = resumeName.isEmpty
        ? resumeWord
        : '$resumeWord  ·  $resumeName';

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover on the left with the title + meta + tags beside it, the whole
          // block vertically centred against the cover.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ShioriShape.card),
                child: SizedBox(
                  width: 150,
                  child: AspectRatio(
                    aspectRatio: 0.68,
                    child: Image(image: cover, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      manga.name ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ShioriType.reference.screenTitle.fontSize,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                      ),
                    ),
                    if (metaBits.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        metaBits,
                        style: TextStyle(
                          fontSize: ShioriType.reference.row.fontSize,
                          color: context.shiori.color.fgMuted,
                        ),
                      ),
                    ],
                    if (genres.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final g in genres.take(8))
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: Alphas.focus),
                                borderRadius: BorderRadius.circular(
                                  ShioriShape.sheet,
                                ),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: ShioriType.reference.meta.fontSize,
                                  color: accent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if ((manga.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              manga.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ShioriType.reference.row.fontSize,
                height: 1.45,
                color: context.shiori.color.fg.withValues(alpha: 0.82),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Continue is pinned above the scroller: the primary action is always
          // visible and never fades (Apple-Timer-style fixed primary button).
          TvDetailActionButton(
            focusNode: actionFocus[0],
            autofocus: true,
            accent: accent,
            primary: true,
            icon: Symbols.play_arrow_rounded,
            label: resumeLabel,
            onPressed: onPlay,
            onExitUp: onExitUp,
          ),
          const SizedBox(height: 4),
          // The remaining actions live in a bounded scroller (~4 visible) so the
          // hero above stays put; arrowing down scrolls just this list.
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TvDetailActionButton(
                      focusNode: actionFocus[1],
                      accent: accent,
                      icon: favorite
                          ? Symbols.favorite_rounded
                          : Symbols.favorite_border_rounded,
                      label: favorite ? 'In Library' : 'Add to Library',
                      onPressed: onToggleLibrary,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[2],
                      accent: accent,
                      icon: Symbols.label_rounded,
                      label: context.l10n.categories,
                      onPressed: onCategories,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[8],
                      accent: accent,
                      icon: Symbols.sync_alt_rounded,
                      label: context.l10n.tracking,
                      onPressed: onTracking,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[3],
                      accent: accent,
                      icon: Symbols.public_rounded,
                      label: context.l10n.open_in_browser,
                      onPressed: onBrowser,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[4],
                      accent: accent,
                      icon: Symbols.recommend_rounded,
                      label: context.l10n.recommendations,
                      onPressed: onRecommendations,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[5],
                      accent: accent,
                      icon: Symbols.format_list_numbered_rounded,
                      label: context.l10n.watch_order,
                      onPressed: onWatchOrder,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[6],
                      accent: accent,
                      icon: Symbols.swap_horiz_rounded,
                      label: context.l10n.migrate,
                      onPressed: onMigrate,
                    ),
                    TvDetailActionButton(
                      focusNode: actionFocus[7],
                      accent: accent,
                      icon: Symbols.dynamic_feed_rounded,
                      label: context.l10n.migrate_source,
                      onPressed: onMassMigrate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// A full-width, d-pad-focusable action row. Subtle until focused (the primary
/// Continue action carries a faint persistent tint so it still reads first);
/// accent fill on focus. Right hands off to the episode list.
class TvDetailActionButton extends StatefulWidget {
  const TvDetailActionButton({
    super.key,
    required this.accent,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.primary = false,
    this.onExitUp,
  });

  final Color accent;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool primary;
  final VoidCallback? onExitUp;

  @override
  State<TvDetailActionButton> createState() => _TvDetailActionButtonState();
}

class _TvDetailActionButtonState extends State<TvDetailActionButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final bg = _focused
        ? accent
        : widget.primary
        ? accent.withValues(alpha: Alphas.accentTint)
        : Colors.white.withValues(alpha: 0.05);
    // Read on the accent once focused; white was lost on a light accent.
    final fg = _focused
        ? ShioriColors.onFill(accent)
        : widget.primary
        ? accent
        : context.shiori.color.fg;
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && isTvSelectKey(event.logicalKey)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            // Cross into the episode list by direction so focus lands on a
            // currently-visible row rather than a fixed (possibly scrolled-off)
            // one, which would silently drop focus.
            node.focusInDirection(TraversalDirection.right);
            return KeyEventResult.handled;
          }
          if (widget.onExitUp != null &&
              event.logicalKey == LogicalKeyboardKey.arrowUp) {
            widget.onExitUp!();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: ShioriMotion.fast,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: _focused ? ShioriColors.onFill(accent) : accent,
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w600,
                    fontSize: ShioriType.reference.body.fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

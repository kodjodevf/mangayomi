import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/utils.dart';

/// TV-only, d-pad-first anime detail. Equal split, screen-padded: the hero
/// (cover, title, meta, synopsis) and a vertical list of actions on the left,
/// the episode list on the right. Right from any action hands off to the
/// episodes; Left from the episodes returns to the actions. Reached only when
/// `isTv` and the entry is anime.
class TvAnimeDetailView extends ConsumerStatefulWidget {
  const TvAnimeDetailView({super.key, required this.manga});

  final Manga manga;

  @override
  ConsumerState<TvAnimeDetailView> createState() => _TvAnimeDetailViewState();
}

class _TvAnimeDetailViewState extends ConsumerState<TvAnimeDetailView> {
  static const _actionCount = 9;
  late final List<FocusNode> _actionFocus;
  final _rootFocus = FocusNode(debugLabel: 'tvDetailRoot');
  final _topBarFocus = FocusNode(debugLabel: 'tvDetailTopBar');
  // The action the user last sat on, so returning from the episodes (or after a
  // rebuild) resumes there instead of snapping back to Continue every time.
  int _lastAction = 0;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _actionFocus = List.generate(
      _actionCount,
      (i) => FocusNode(debugLabel: 'tvDetailAction$i'),
    );
    for (var i = 0; i < _actionFocus.length; i++) {
      final node = _actionFocus[i];
      node.addListener(() {
        if (node.hasFocus) _lastAction = i;
      });
    }
  }

  @override
  void dispose() {
    for (final node in _actionFocus) {
      node.dispose();
    }
    _rootFocus.dispose();
    _topBarFocus.dispose();
    super.dispose();
  }

  // Exit the detail on the remote's Back — on some Fire TV remotes it arrives as
  // a `goBack` key event that gets swallowed rather than falling through to the
  // system back. Consuming it here pops the route (and prevents a double pop).
  KeyEventResult _onKeyBack(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final k = event.logicalKey;
      if (k == LogicalKeyboardKey.goBack ||
          k == LogicalKeyboardKey.escape ||
          k == LogicalKeyboardKey.browserBack ||
          k == LogicalKeyboardKey.gameButtonB) {
        Navigator.maybePop(context);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  Future<void> _refresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      await ref.read(
        updateMangaDetailProvider(mangaId: manga.id, isInit: false).future,
      );
    } catch (_) {}
    if (mounted) setState(() => _refreshing = false);
  }

  Manga get manga => widget.manga;

  /// The episode Play/Continue lands on: the one in watch history, else the
  /// first unwatched, else the first.
  Chapter? _resumeEpisode(List<Chapter> reading) {
    final history = isar.historys
        .filter()
        .mangaIdEqualTo(manga.id!)
        .findAllSync();
    if (history.isNotEmpty) {
      history.first.chapter.loadSync();
      final ch = history.first.chapter.value;
      if (ch != null) return ch;
    }
    for (final c in reading) {
      if (!(c.isRead ?? false)) return c;
    }
    return reading.isNotEmpty ? reading.first : null;
  }

  @override
  Widget build(BuildContext context) {
    // Live episode list; seed the first frame synchronously so it never flashes.
    final chaptersAsync = ref.watch(
      getChaptersStreamProvider(mangaId: manga.id!),
    );
    final hasLive = chaptersAsync.asData != null;
    // getFilteredChapters / getChapterListForReading read the manga.chapters
    // Isar link, which is lazy — load it (refreshed each rebuild the stream
    // triggers) so the episode list isn't empty.
    try {
      manga.chapters.loadSync();
    } catch (_) {}
    // Filtered + sorted (ascending) episodes, respecting the scanlator/chapter
    // filters — the same list the classic detail shows.
    final episodes = manga.getFilteredChapters();
    final reading = manga.getChapterListForReading();
    final resume = _resumeEpisode(reading);
    final watched = episodes.where((c) => c.isRead ?? false).length;

    final cover = resolveCoverImage(manga, ref);
    final bg = Theme.of(context).scaffoldBackgroundColor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Claim focus only if it landed nowhere in the detail at all (initial
      // frame, or after a pushed route / dialog returns). Checking the root
      // node's whole subtree — not individual nodes — so focus deep in the lazy
      // episode list never reads as "nowhere" and gets yanked back.
      //
      // Critically, only reclaim when this detail is the *current* route. This
      // view watches a live chapters stream and rebuilds while a pushed screen
      // (Migrate, Mass migration, Recommendations, Tracking) sits on top of it;
      // without this gate every such rebuild would steal focus back from that
      // screen to the Continue button, so those screens never held focus and an
      // OK press landed on Continue instead (playing a random episode).
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? true;
      if (mounted && isCurrent && !_rootFocus.hasFocus) {
        _actionFocus[_lastAction].requestFocus();
      }
    });

    return Focus(
      focusNode: _rootFocus,
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onKeyBack,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred backdrop from the cover.
            ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Image(image: cover, fit: BoxFit.cover),
            ),
            // Darken enough that text reads over any cover on both columns, so
            // the two sides blend into one screen instead of reading as panels.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    bg,
                    bg.withValues(alpha: 0.9),
                    bg.withValues(alpha: 0.82),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    topBarFocus: _topBarFocus,
                    refreshing: _refreshing,
                    onBack: () => Navigator.maybePop(context),
                    onRefresh: _refresh,
                    onDown: () => _actionFocus[_lastAction].requestFocus(),
                  ),
                  Expanded(
                    // Screen padding on both sides so nothing hugs the TV edge.
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(48, 0, 48, 48),
                      child: Row(
                        // Both columns full height and top-aligned.
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left: hero + vertical action list (equal half).
                          Expanded(
                            child: _LeftInfo(
                              manga: manga,
                              cover: cover,
                              episodeCount: episodes.length,
                              watched: watched,
                              resume: resume,
                              actionFocus: _actionFocus,
                              onPlay: () => resume?.pushToReaderView(context),
                              onToggleLibrary: _toggleLibrary,
                              onCategories: () => showCategorySelectionDialog(
                                context: context,
                                ref: ref,
                                itemType: manga.itemType,
                                singleManga: manga,
                              ),
                              onTracking: _openTracking,
                              onBrowser: _openInBrowser,
                              onRecommendations: () => context.push(
                                '/recommendations',
                                extra: (
                                  manga.name,
                                  manga.itemType,
                                  ref.read(algorithmWeightsStateProvider),
                                ),
                              ),
                              onWatchOrder: () => context.push(
                                '/watchOrder',
                                extra: (manga.name, null),
                              ),
                              onMigrate: () =>
                                  context.push('/migrate', extra: manga),
                              // Seeded: this manga's source floats to the top.
                              onMassMigrate: () => context.push(
                                '/massMigration',
                                extra: (manga.itemType, manga),
                              ),
                              onExitUp: () => _topBarFocus.requestFocus(),
                            ),
                          ),
                          // Right: episodes (equal half).
                          Expanded(
                            child: _EpisodesPanel(
                              episodes: episodes,
                              resumeId: resume?.id,
                              loading: !hasLive && episodes.isEmpty,
                              onExitLeft: () =>
                                  _actionFocus[_lastAction].requestFocus(),
                              onOpen: (c) => c.pushToReaderView(
                                context,
                                ignoreIsRead: true,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void _toggleLibrary() {
    final model = manga;
    final now = DateTime.now().millisecondsSinceEpoch;
    isar.writeTxnSync(() {
      model.favorite = !(model.favorite ?? false);
      model.dateAdded = model.favorite! ? now : 0;
      model.updatedAt = now;
      isar.mangas.putSync(model);
    });
    setState(() {});
  }

  /// Opens the tracker list (MAL/AniList/etc.) for this title. If no tracker is
  /// logged in there is nothing to track against, so route to the tracking
  /// settings to set one up instead of showing an empty sheet.
  void _openTracking() {
    final entries = isar.trackPreferences
        .filter()
        .syncIdIsNotNull()
        .findAllSync();
    if (entries.isEmpty) {
      context.push('/track');
      return;
    }
    openTrackingMenu(context: context, manga: manga, entries: entries);
  }

  void _openInBrowser() {
    final source = getSource(manga.lang!, manga.source!, manga.sourceId);
    if (source == null || manga.link == null) return;
    context.push(
      '/mangawebview',
      extra: {
        'url': '${source.baseUrl}${manga.link!.getUrlWithoutDomain}',
        'sourceId': source.id.toString(),
        'title': manga.name!,
      },
    );
  }
}

/// Focusable top bar: Back (top-left) and Refresh. Everything else now lives as
/// a button in the hero's action list, so the bar stays minimal. Down hands
/// focus to the content below.
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.topBarFocus,
    required this.refreshing,
    required this.onBack,
    required this.onRefresh,
    required this.onDown,
  });

  final FocusNode topBarFocus;
  final bool refreshing;
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          onDown();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 4),
        child: Row(
          children: [
            _TopBarButton(
              focusNode: topBarFocus,
              icon: Icons.arrow_back,
              onPressed: onBack,
            ),
            const Spacer(),
            _TopBarButton(
              icon: refreshing ? Icons.hourglass_empty : Icons.refresh,
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBarButton extends StatefulWidget {
  const _TopBarButton({
    required this.icon,
    required this.onPressed,
    this.focusNode,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final FocusNode? focusNode;

  @override
  State<_TopBarButton> createState() => _TopBarButtonState();
}

class _TopBarButtonState extends State<_TopBarButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused ? accent : accent.withValues(alpha: 0.12),
          ),
          child: Icon(
            widget.icon,
            size: 22,
            color: _focused ? Colors.white : accent,
          ),
        ),
      ),
    );
  }
}

/// The hero column: cover with the title bottom-aligned beside it, meta, tags,
/// synopsis, then a vertical, scrollable list of actions. Up/Down moves through
/// the actions (auto-scrolling); Right off any action jumps to the episodes;
/// the first action (Continue) hands Up back to the top bar.
class _LeftInfo extends StatelessWidget {
  const _LeftInfo({
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
    final accent = context.primaryColor;
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
                borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.12,
                      ),
                    ),
                    if (metaBits.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        metaBits,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).hintColor,
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
                                color: accent.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 12,
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
                fontSize: 14,
                height: 1.45,
                color: Theme.of(
                  context,
                ).textTheme.bodyLarge!.color!.withValues(alpha: 0.82),
              ),
            ),
          ],
          const SizedBox(height: 16),
          // Continue is pinned above the scroller: the primary action is always
          // visible and never fades (Apple-Timer-style fixed primary button).
          _VActionButton(
            focusNode: actionFocus[0],
            autofocus: true,
            accent: accent,
            primary: true,
            icon: Icons.play_arrow_rounded,
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
                    _VActionButton(
                      focusNode: actionFocus[1],
                      accent: accent,
                      icon: favorite ? Icons.favorite : Icons.favorite_border,
                      label: favorite ? 'In Library' : 'Add to Library',
                      onPressed: onToggleLibrary,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[2],
                      accent: accent,
                      icon: Icons.label_outline,
                      label: 'Categories',
                      onPressed: onCategories,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[8],
                      accent: accent,
                      icon: Icons.sync_alt,
                      label: 'Tracking',
                      onPressed: onTracking,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[3],
                      accent: accent,
                      icon: Icons.public,
                      label: 'Open in browser',
                      onPressed: onBrowser,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[4],
                      accent: accent,
                      icon: Icons.recommend_outlined,
                      label: 'Recommendations',
                      onPressed: onRecommendations,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[5],
                      accent: accent,
                      icon: Icons.format_list_numbered,
                      label: 'Watch order',
                      onPressed: onWatchOrder,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[6],
                      accent: accent,
                      icon: Icons.swap_horiz,
                      label: 'Migrate',
                      onPressed: onMigrate,
                    ),
                    _VActionButton(
                      focusNode: actionFocus[7],
                      accent: accent,
                      icon: Icons.dynamic_feed,
                      label: 'Migrate source',
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
class _VActionButton extends StatefulWidget {
  const _VActionButton({
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
  State<_VActionButton> createState() => _VActionButtonState();
}

class _VActionButtonState extends State<_VActionButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final bg = _focused
        ? accent
        : widget.primary
        ? accent.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.05);
    final fg = _focused
        ? Colors.white
        : widget.primary
        ? accent
        : Theme.of(context).textTheme.bodyLarge!.color;
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
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
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: _focused ? Colors.white : accent,
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
                    fontSize: 15,
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

class _EpisodesPanel extends StatelessWidget {
  const _EpisodesPanel({
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
    final accent = context.primaryColor;
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: loading
              ? const SizedBox.shrink()
              : episodes.isEmpty
              ? Center(
                  child: Text(
                    'No episodes yet',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                )
              : FocusTraversalGroup(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 28),
                    itemCount: episodes.length,
                    itemBuilder: (context, i) {
                      final ep = episodes[i];
                      return _EpisodeRow(
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

class _EpisodeRow extends StatefulWidget {
  const _EpisodeRow({
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
  State<_EpisodeRow> createState() => _EpisodeRowState();
}

class _EpisodeRowState extends State<_EpisodeRow> {
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
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
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
                ? widget.accent.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
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
                      ? Theme.of(context).hintColor.withValues(alpha: 0.3)
                      : widget.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // The title already reads "Episode N", so no leading number —
              // just a play marker on the resume episode.
              if (widget.isResume) ...[
                Icon(Icons.play_arrow_rounded, color: widget.accent, size: 20),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: watched ? Theme.of(context).hintColor : null,
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
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Theme.of(context).hintColor),
                  ),
                  child: Text(
                    'FILLER',
                    style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              if ((ep.duration ?? '').isNotEmpty) ...[
                const SizedBox(width: 10),
                Text(
                  ep.duration!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
              if (watched)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _isSelect(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;

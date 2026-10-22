import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/library/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/tv/widgets/tv_detail_episodes_panel.dart';
import 'package:mangayomi/modules/manga/detail/tv/widgets/tv_detail_left_info.dart';
import 'package:mangayomi/modules/manga/detail/tv/widgets/tv_detail_top_bar.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracking_menu.dart';
import 'package:mangayomi/modules/more/providers/algorithm_weights_state_provider.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:shiori/shiori.dart';

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
    final history = historyRepository.getAllByMangaId(manga.id!);
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
    final bg = context.shiori.color.ink0;

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
                  TvDetailTopBar(
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
                            child: TvDetailLeftInfo(
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
                              onRecommendations: () {
                                context.push(
                                  '/recommendations',
                                  extra: (
                                    _mediaContext(),
                                    ref.read(algorithmWeightsStateProvider),
                                  ),
                                );
                              },
                              onWatchOrder: () {
                                context.push(
                                  '/watchOrder',
                                  extra: (_mediaContext(), null as Track?),
                                );
                              },
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
                            child: TvDetailEpisodesPanel(
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

  MediaLookupContext _mediaContext() => MediaLookupContext.fromManga(
    manga,
    tracks: trackRepository.getAllByMangaId(manga.id),
  );

  void _toggleLibrary() {
    final model = manga;
    model.favorite = !(model.favorite ?? false);
    model.dateAdded = model.favorite!
        ? DateTime.now().millisecondsSinceEpoch
        : 0;
    mangaRepository.save(model);
    setState(() {});
  }

  /// Opens the tracker list (MAL/AniList/etc.) for this title. If no tracker is
  /// logged in there is nothing to track against, so route to the tracking
  /// settings to set one up instead of showing an empty sheet.
  void _openTracking() {
    final entries = trackRepository.getAllPreferences();
    if (entries.isEmpty) {
      context.push('/track');
      return;
    }
    openTrackingMenu(context: context, manga: manga, entries: entries);
  }

  void _openInBrowser() {
    final source = getSource(
      manga.lang!,
      manga.source!,
      manga.sourceId,
      installedOnly: true,
    );
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

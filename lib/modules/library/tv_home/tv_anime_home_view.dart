import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_home_top_bar.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_home_hero.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_home_row.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_category_pills.dart';
import 'package:mangayomi/modules/library/tv_home/widgets/tv_empty_home.dart';

/// TV-only, d-pad-first anime home. A hero (the thing you'll resume) plus
/// horizontal rows — Continue Watching (from history), New Episodes (from the
/// update feed), Recently Added, then one row per category. A top bar adds
/// search and the library's own filter/sort/display sheet.
/// Rendered only when `isTv` + `tvHomeStyle`.
class TvAnimeHomeView extends ConsumerStatefulWidget {
  const TvAnimeHomeView({super.key, required this.settings});

  final Settings settings;

  @override
  ConsumerState<TvAnimeHomeView> createState() => _TvAnimeHomeViewState();
}

class _TvAnimeHomeViewState extends ConsumerState<TvAnimeHomeView> {
  final _searchController = TextEditingController();
  String _query = '';
  // Selected category filter: null = "All" (the curated home). A non-empty
  // search query overrides this while active.
  int? _selected;

  // Each vertical section (top bar, pills, hero, each row) gets its own
  // FocusScope. Up/Down move whole-section to whole-section — restoring each
  // scope's remembered child — instead of Flutter's geometric directional
  // focus, which skips items that aren't exactly aligned above/below.
  final _scopeTopbar = FocusScopeNode(debugLabel: 'tvHomeTopbar');
  final _scopePills = FocusScopeNode(debugLabel: 'tvHomePills');
  final _scopeHero = FocusScopeNode(debugLabel: 'tvHomeHero');
  final _scopeRows = List.generate(
    12,
    (i) => FocusScopeNode(debugLabel: 'tvHomeRow$i'),
  );
  // The search / category grid is a 2D section: it navigates internally and
  // only hands off to the pills at its top edge.
  final _scopeGrid = FocusScopeNode(debugLabel: 'tvHomeGrid');
  List<FocusScopeNode> _order = const [];

  @override
  void dispose() {
    _searchController.dispose();
    _scopeTopbar.dispose();
    _scopePills.dispose();
    _scopeHero.dispose();
    _scopeGrid.dispose();
    for (final s in _scopeRows) {
      s.dispose();
    }
    super.dispose();
  }

  // Move focus between the ordered vertical sections on Up/Down. Defer to the
  // default (geometric) focus at the edges and for the 2D grid views, which
  // aren't registered in `_order`.
  KeyEventResult _handleVertical(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final k = event.logicalKey;
    if (k != LogicalKeyboardKey.arrowDown && k != LogicalKeyboardKey.arrowUp) {
      return KeyEventResult.ignored;
    }
    final cur = _order.indexWhere((s) => s.hasFocus);
    if (cur == -1) return KeyEventResult.ignored;
    final down = k == LogicalKeyboardKey.arrowDown;

    // The grid is 2D — let it move between its own rows first; only when it
    // can't (top/bottom edge) do we hop to the adjacent section.
    if (identical(_order[cur], _scopeGrid)) {
      final moved =
          FocusManager.instance.primaryFocus?.focusInDirection(
            down ? TraversalDirection.down : TraversalDirection.up,
          ) ??
          false;
      if (moved) return KeyEventResult.handled;
    }

    final target = down ? cur + 1 : cur - 1;
    if (target < 0 || target >= _order.length) return KeyEventResult.ignored;
    // Column-preserving: land on the *same* card index in the target row so
    // Up/Down keeps your horizontal position instead of snapping to card 1.
    final curDesc = _order[cur].traversalDescendants.toList();
    final col = curDesc.indexWhere((n) => n.hasPrimaryFocus);
    // If the target has nothing focusable (e.g. a category you just created and
    // haven't filled yet), stay put rather than dropping focus into a void.
    _focusSection(_order[target], col < 0 ? 0 : col);
    return KeyEventResult.handled;
  }

  /// Focus the card at [column] in a section (clamped) — always a visible child,
  /// so a card/button shows the focus ring and the horizontal position carries
  /// over. Returns false when the section has no focusable children.
  bool _focusSection(FocusScopeNode scope, int column) {
    final descendants = scope.traversalDescendants.toList();
    if (descendants.isEmpty) return false;
    descendants[column.clamp(0, descendants.length - 1)].requestFocus();
    return true;
  }

  /// Synchronous read matching getAllMangaStreamProvider(categoryId: null) —
  /// used to seed the first frame so the spinner never flashes for local data.
  List<Manga> _favoriteAnimeSync() =>
      mangaRepository.getFavoritesByItemTypeIdNotNull(ItemType.anime);

  @override
  Widget build(BuildContext context) {
    final animeAsync = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: ItemType.anime),
    );
    final catsAsync = ref.watch(
      getMangaCategorieStreamProvider(itemType: ItemType.anime),
    );

    // Seed the first frame from a synchronous Isar read. A stream provider is
    // AsyncLoading on its very first build — its fireImmediately value arrives a
    // microtask later — so .when() flashed the spinner for one frame even though
    // the (local) library data is available instantly. `asData` is null only on
    // that first frame (a local Isar stream doesn't error), and the sync read
    // covers it; the stream then drives live updates.
    final allAnime = animeAsync.asData?.value ?? _favoriteAnimeSync();
    return Scaffold(
      body: Builder(
        builder: (context) {
          // A hidden category hides its entries, matching the library (a hidden
          // category has no tab, and its titles aren't "Default" either). A
          // title stays visible if it's uncategorised, or sits in at least one
          // non-hidden category.
          final allCats = catsAsync.asData?.value ?? const <Category>[];
          final hiddenCats = allCats.where((c) => c.hide ?? false).toList()
            ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
          final hiddenCatIds = hiddenCats
              .map((c) => c.id)
              .whereType<int>()
              .toSet();
          final cats = allCats.where((c) => !(c.hide ?? false)).toList()
            ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
          final visible = hiddenCatIds.isEmpty
              ? allAnime
              : allAnime.where((m) {
                  final mc = m.categories ?? const <int>[];
                  return mc.isEmpty ||
                      mc.any((id) => !hiddenCatIds.contains(id));
                }).toList();

          // Only a genuinely empty library short-circuits the whole screen. If
          // everything is merely hidden, keep the pill bar on screen — holding
          // OK on "All" is the way back, and TvEmptyHome has no "All".
          if (allAnime.isEmpty) return const TvEmptyHome();

          // The filter/sort/display sheet is the library's own, so its settings
          // have to bite here too. Filters and the search box narrow every view;
          // the sort order drives the grids, while the curated rows keep the
          // ordering that gives them their meaning (last watched, newest
          // episode, most recently added).
          const it = ItemType.anime;
          final settings = widget.settings;
          final sortState = ref.watch(
            sortLibraryMangaStateProvider(itemType: it, settings: settings),
          );
          final filtered = ref.watch(
            filteredLibraryMangaProvider(
              data: visible,
              downloadFilterType: ref.watch(
                mangaFilterDownloadedStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              unreadFilterType: ref.watch(
                mangaFilterUnreadStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              startedFilterType: ref.watch(
                mangaFilterStartedStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              bookmarkedFilterType: ref.watch(
                mangaFilterBookmarkedStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              completedFilterType: ref.watch(
                mangaFilterCompletedStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              trackingFilterType: ref.watch(
                mangaFilterTrackingStateProvider(
                  itemType: it,
                  mangaList: visible,
                  settings: settings,
                ),
              ),
              sortType: sortState.index ?? 0,
              downloadedOnly: ref.watch(downloadedOnlyStateProvider),
              searchQuery: _query.trim(),
              ignoreFiltersOnSearch: false,
              sourceIds: ref
                  .watch(
                    mangaFilterSourceStateProvider(
                      itemType: it,
                      mangaList: visible,
                      settings: settings,
                    ),
                  )
                  .$2,
              settings: settings,
            ),
          );
          final entries = (sortState.reverse ?? false)
              ? sortState.index == 3
                    ? sortByUnreadCount(
                        filtered,
                        unreadCountOf: (manga) =>
                            manga.unreadChaptersCount(settings),
                        descending: true,
                      )
                    : filtered.reversed.toList()
              : filtered;

          // Continue Watching = every anime you've actually played, from watch
          // history, most-recently-watched first.
          final historyIds =
              (ref
                          .watch(
                            getAllHistoryStreamProvider(
                              itemType: ItemType.anime,
                            ),
                          )
                          .asData
                          ?.value ??
                      const <History>[])
                  .map((h) => h.mangaId)
                  .whereType<int>()
                  .toSet();
          // New Episodes = the library-update feed (new episodes a refresh
          // detected), limited to unwatched ones.
          final updatedIds =
              (ref
                          .watch(
                            getAllUpdateStreamProvider(
                              itemType: ItemType.anime,
                            ),
                          )
                          .asData
                          ?.value ??
                      const <Update>[])
                  .map((u) => u.mangaId)
                  .whereType<int>()
                  .toSet();

          final continueList =
              entries.where((m) => historyIds.contains(m.id)).toList()
                ..sort((a, b) => (b.lastRead ?? 0).compareTo(a.lastRead ?? 0));
          final newEpisodes =
              entries
                  .where(
                    (m) =>
                        updatedIds.contains(m.id) &&
                        m.chapters.any((c) => !(c.isRead ?? true)),
                  )
                  .toList()
                ..sort(
                  (a, b) => (b.lastUpdate ?? 0).compareTo(a.lastUpdate ?? 0),
                );
          final recent = [...entries]
            ..sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
          final heroItems = (continueList.isNotEmpty ? continueList : recent)
              .take(6)
              .toList();

          // If the selected category was removed, fall back to All.
          final selectedId =
              (_selected != null && cats.any((c) => c.id == _selected))
              ? _selected
              : null;

          final q = _query.trim().toLowerCase();
          final searching = q.isNotEmpty;

          // Ordered vertical sections for whole-row Up/Down navigation. Top bar
          // and pills are always first; the All view adds hero + one scope per
          // row. Grid views leave the grid out (default 2D focus handles it).
          final order = <FocusScopeNode>[_scopeTopbar, _scopePills];
          Widget content;
          if (visible.isEmpty) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Every title sits in a hidden category.\n'
                  'Hold OK on “All” to unhide one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
            );
          } else if (searching) {
            // `entries` already has the query applied, in the sheet's sort
            // order. A selected pill scopes the search to that category, the
            // way searching inside a category tab does everywhere else — the
            // library searches `getAllMangaStreamProvider(categoryId:)`, not
            // the whole library.
            final catName = selectedId == null
                ? null
                : cats
                      .firstWhere(
                        (c) => c.id == selectedId,
                        orElse: () => cats.first,
                      )
                      .name;
            final matches = selectedId == null
                ? entries
                : entries
                      .where(
                        (m) => (m.categories ?? const <int>[]).contains(
                          selectedId,
                        ),
                      )
                      .toList();
            order.add(_scopeGrid);
            content = FocusScope(
              node: _scopeGrid,
              child: TvMangaGrid(
                items: matches,
                emptyLabel: catName == null
                    ? 'No matching anime'
                    : 'No matching anime in “$catName”',
              ),
            );
          } else if (entries.isEmpty) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No anime matches the current filters.\n'
                  'Change them from the button beside search.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
            );
          } else if (selectedId == null) {
            order.add(_scopeHero);
            final rows = <Widget>[
              FocusScope(
                node: _scopeHero,
                child: TvHomeHero(items: heroItems),
              ),
            ];
            var ri = 0;
            void addRow(String title, List<Manga> items) {
              if (ri >= _scopeRows.length) return; // scope pool exhausted
              final scope = _scopeRows[ri++];
              order.add(scope);
              rows.add(
                FocusScope(
                  node: scope,
                  child: TvHomeRow(title: title, items: items),
                ),
              );
            }

            if (continueList.isNotEmpty) {
              addRow('Continue Watching', continueList);
            }
            if (newEpisodes.isNotEmpty) addRow('New Episodes', newEpisodes);
            addRow('Recently Added', recent);

            // Genre rows — browse the library by genre (top few, ≥3 titles).
            // The one place a title can appear in more than one row, so they're
            // switchable from the filter/sort/display sheet.
            if (ref.watch(tvHomeGenreRowsProvider)) {
              final byGenre = <String, List<Manga>>{};
              for (final m in entries) {
                for (final g in (m.genre ?? const <String>[])) {
                  final t = g.trim();
                  if (t.isNotEmpty) (byGenre[t] ??= <Manga>[]).add(m);
                }
              }
              final genreRows =
                  byGenre.entries.where((e) => e.value.length >= 3).toList()
                    ..sort((a, b) => b.value.length.compareTo(a.value.length));
              for (final g in genreRows.take(6)) {
                addRow(g.key, g.value);
              }
            }
            content = ListView(
              padding: const EdgeInsets.only(bottom: 28),
              children: rows,
            );
          } else {
            // Category view: a Continue Watching row scoped to *this* category,
            // then the category's full grid.
            final catName = cats
                .firstWhere((c) => c.id == selectedId, orElse: () => cats.first)
                .name;
            final inCat = entries
                .where(
                  (m) => (m.categories ?? const <int>[]).contains(selectedId),
                )
                .toList();
            final catContinue =
                inCat.where((m) => historyIds.contains(m.id)).toList()..sort(
                  (a, b) => (b.lastRead ?? 0).compareTo(a.lastRead ?? 0),
                );
            // Same hero rule as All: what you'd resume, else what you added
            // last — never "whatever the sort tab happens to put first".
            final catRecent = [...inCat]
              ..sort((a, b) => (b.dateAdded ?? 0).compareTo(a.dateAdded ?? 0));
            final catHero = (catContinue.isNotEmpty ? catContinue : catRecent)
                .take(6)
                .toList();

            if (inCat.isEmpty) {
              order.add(_scopeGrid);
              content = FocusScope(
                node: _scopeGrid,
                child: TvMangaGrid(
                  items: inCat,
                  emptyLabel:
                      'No anime in this category yet.\n'
                      'Add titles to it from a title’s detail page.',
                ),
              );
            } else {
              // NestedScrollView, not a CustomScrollView: the hero and rail
              // still scroll away, but the grid stays a real (lazy) box widget,
              // so each part can own a FocusScope — a scope can't wrap a sliver.
              // That keeps every section on `_handleVertical`'s column-preserving
              // navigation instead of Flutter's geometric focus, which snaps to
              // the first card whenever the rows don't line up.
              order.add(_scopeHero);
              if (catContinue.isNotEmpty) order.add(_scopeRows[0]);
              order.add(_scopeGrid);
              content = NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                    child: FocusScope(
                      node: _scopeHero,
                      child: TvHomeHero(items: catHero),
                    ),
                  ),
                  if (catContinue.isNotEmpty)
                    SliverToBoxAdapter(
                      child: FocusScope(
                        node: _scopeRows[0],
                        child: TvHomeRow(
                          title: context.l10n.continue_watching,
                          items: catContinue,
                        ),
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                      child: Text(
                        catName ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
                // The grid keeps the sheet's sort order.
                body: FocusScope(
                  node: _scopeGrid,
                  child: TvMangaGrid(items: inCat),
                ),
              );
            }
          }
          _order = order;

          // Whatever is painted behind the pills — the colour the scrolling
          // content has to dissolve into at the top of its viewport.
          final pageBg = Theme.of(context).scaffoldBackgroundColor;
          return Focus(
            onKeyEvent: _handleVertical,
            child: Column(
              children: [
                FocusScope(
                  node: _scopeTopbar,
                  child: TvHomeTopBar(
                    controller: _searchController,
                    settings: settings,
                    entries: entries,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                FocusScope(
                  node: _scopePills,
                  child: TvCategoryPills(
                    selected: selectedId,
                    categories: cats,
                    hidden: hiddenCats,
                    onSelect: (id) => setState(() => _selected = id),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: content),
                      // The hero's backdrop is full-bleed, so scrolling it up
                      // under the pills leaves the viewport's clip cutting
                      // straight across it. The hero fades at its *own* top
                      // edge, which by then is off-screen — so dissolve the
                      // cut here, where it actually happens.
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 36,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [pageBg, pageBg.withValues(alpha: 0)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

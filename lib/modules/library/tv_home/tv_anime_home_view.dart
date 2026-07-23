import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/library/widgets/library_settings_sheet.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/categories/widgets/custom_textfield.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

// Poster width per density scale (0 compact · 1 comfortable · 2 large); row
// height keeps a poster-plus-title aspect.
/// Matches `GridViewWidget`'s TV default, so an untouched grid-size setting
/// looks the same here as in the classic library.
const double _defaultCardWidth = 150;

/// Card width follows the library's own grid-size setting ("items per row",
/// 0 = default) — the slider in the filter/sort/display sheet drives the TV
/// home too, rather than the home keeping a private density of its own.
double _cardWidth(BuildContext context, int gridSize) {
  final size = MediaQuery.sizeOf(context);
  final raw = gridSize <= 0
      ? _defaultCardWidth
      : (size.width - 44) / gridSize - 8;
  // A rail is not a grid: cap the card so "1 per row" can't eat the screen.
  final cap = ((size.height * 0.5) / 1.66).clamp(120.0, 400.0);
  return raw.clamp(90.0, cap);
}

double _rowHeight(BuildContext context, int gridSize) =>
    _cardWidth(context, gridSize) * 1.66;

int _gridSize(WidgetRef ref) =>
    ref.watch(libraryGridSizeStateProvider(itemType: ItemType.anime)) ?? 0;

/// Mirrors GridViewWidget: 0 means "default", anything else is an exact number
/// of columns.
SliverGridDelegate _gridDelegate(int gridSize) => gridSize <= 0
    ? const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _defaultCardWidth + 10,
        childAspectRatio: 0.60,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      )
    : SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridSize,
        childAspectRatio: 0.60,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      );

/// The episode to resume for [manga] — the last from watch history, else the
/// first chapter.
Chapter? _resumeChapter(Manga manga) {
  final history = isar.historys
      .filter()
      .mangaIdEqualTo(manga.id!)
      .findAllSync();
  if (history.isNotEmpty) {
    history.first.chapter.loadSync();
    final ch = history.first.chapter.value;
    if (ch != null) return ch;
  }
  return manga.chapters.isNotEmpty ? manga.chapters.first : null;
}

String _fmtMs(int ms) {
  final d = Duration(milliseconds: ms);
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '${d.inMinutes}:$s';
}

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
  List<Manga> _favoriteAnimeSync() => isar.mangas
      .filter()
      .idIsNotNull()
      .favoriteEqualTo(true)
      .and()
      .itemTypeEqualTo(ItemType.anime)
      .findAllSync();

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
          // OK on "All" is the way back, and _EmptyHome has no "All".
          if (allAnime.isEmpty) return const _EmptyHome();

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
            ),
          );
          final entries = (sortState.reverse ?? false)
              ? filtered.reversed.toList()
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
              child: _MangaGrid(
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
                child: _TvHomeHero(items: heroItems),
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
                  child: _TvHomeRow(title: title, items: items),
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
                child: _MangaGrid(
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
                      child: _TvHomeHero(items: catHero),
                    ),
                  ),
                  if (catContinue.isNotEmpty)
                    SliverToBoxAdapter(
                      child: FocusScope(
                        node: _scopeRows[0],
                        child: _TvHomeRow(
                          title: 'Continue Watching',
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
                  child: _MangaGrid(items: inCat),
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
                  child: _TvHomeTopBar(
                    controller: _searchController,
                    settings: settings,
                    entries: entries,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                FocusScope(
                  node: _scopePills,
                  child: _CategoryPills(
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

/// Search field + card-density control. Sits above the rows; Up from the hero
/// reaches it.
class _TvHomeTopBar extends StatelessWidget {
  const _TvHomeTopBar({
    required this.controller,
    required this.settings,
    required this.entries,
    required this.onChanged,
  });
  final TextEditingController controller;
  final Settings settings;
  final List<Manga> entries;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 6),
      child: Row(
        children: [
          Expanded(
            // The text field owns Left/Right for the cursor; let Right escape to
            // the size button once the cursor is at the end of the text.
            child: Focus(
              canRequestFocus: false,
              skipTraversal: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  final sel = controller.selection;
                  final atEnd =
                      !sel.isValid || sel.baseOffset >= controller.text.length;
                  if (atEnd) {
                    FocusScope.of(
                      context,
                    ).focusInDirection(TraversalDirection.right);
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => FocusScope.of(
                  context,
                ).focusInDirection(TraversalDirection.down),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  hintText: 'Search your anime',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide(color: accent, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _LibrarySettingsButton(settings: settings, entries: entries),
        ],
      ),
    );
  }
}

/// Opens the library's own filter/sort/display sheet — the same one the phone
/// app uses, already d-pad traversable. Its grid-size slider is where card
/// density now lives.
class _LibrarySettingsButton extends ConsumerStatefulWidget {
  const _LibrarySettingsButton({required this.settings, required this.entries});

  final Settings settings;
  final List<Manga> entries;

  @override
  ConsumerState<_LibrarySettingsButton> createState() =>
      _LibrarySettingsButtonState();
}

class _LibrarySettingsButtonState extends ConsumerState<_LibrarySettingsButton>
    with SingleTickerProviderStateMixin {
  bool _focused = false;

  void _open() => showLibrarySettingsSheet(
    context: context,
    vsync: this,
    settings: widget.settings,
    itemType: ItemType.anime,
    entries: widget.entries,
  );

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        // Opens on release: the sheet must not inherit the repeats of the press
        // that opened it (SingleActivator activates on repeats).
        if (event is KeyUpEvent && _isSelectKey(event.logicalKey)) {
          _open();
          return KeyEventResult.handled;
        }
        if (_isSelectKey(event.logicalKey)) return KeyEventResult.handled;
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused ? accent : accent.withValues(alpha: 0.12),
          ),
          child: Icon(
            Icons.filter_list_sharp,
            size: 22,
            color: _focused ? Colors.white : accent,
          ),
        ),
      ),
    );
  }
}

/// Flat grid of a Manga list (leaf view — a plain grid navigates predictably).
/// Shared by search results and a selected category.
class _MangaGrid extends ConsumerWidget {
  const _MangaGrid({required this.items, this.emptyLabel = ''});
  final List<Manga> items;

  /// Only reachable where [items] can legitimately be empty.
  final String emptyLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(emptyLabel, textAlign: TextAlign.center),
        ),
      );
    }
    return GridView.builder(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      gridDelegate: _gridDelegate(_gridSize(ref)),
      itemCount: items.length,
      itemBuilder: (context, index) => _TvHomeCard(manga: items[index]),
    );
  }
}

/// The top hero: a blurred cover backdrop (clipped so it can't bleed into the
/// rows), darkened on the left for text and faded into the page background at
/// the bottom for a clean seam. Poster + title + the autofocused Continue.
/// Auto-rotating hero — cycles through the top few resume candidates with a
/// crossfade, pausing while it (its Continue button) is focused.
class _TvHomeHero extends StatefulWidget {
  const _TvHomeHero({required this.items});
  final List<Manga> items;

  @override
  State<_TvHomeHero> createState() => _TvHomeHeroState();
}

class _TvHomeHeroState extends State<_TvHomeHero>
    with SingleTickerProviderStateMixin {
  static const _dwell = Duration(seconds: 7);
  int _index = 0;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // One clock drives both the dwell timer and the progress indicator.
    _ctrl = AnimationController(vsync: this, duration: _dwell)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          setState(() => _index = (_index + 1) % widget.items.length);
          _ctrl.forward(from: 0);
        }
      });
    if (widget.items.length > 1) _ctrl.forward();
  }

  /// Pause the dwell while the hero is focused so it never rotates out from
  /// under you; resume when focus leaves.
  void _setPaused(bool paused) {
    if (widget.items.length <= 1) return;
    if (paused) {
      _ctrl.stop();
    } else if (!_ctrl.isAnimating) {
      _ctrl.forward();
    }
  }

  @override
  void didUpdateWidget(_TvHomeHero old) {
    super.didUpdateWidget(old);
    if (_index >= widget.items.length) _index = 0;
    if (widget.items.length > 1 && !_ctrl.isAnimating) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();
    final manga = widget.items[_index.clamp(0, widget.items.length - 1)];
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _setPaused,
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _HeroContent(key: ValueKey(manga.id), manga: manga),
          ),
          if (widget.items.length > 1)
            Positioned(
              right: 34,
              bottom: 26,
              child: _RotationDots(
                controller: _ctrl,
                count: widget.items.length,
                index: _index,
              ),
            ),
        ],
      ),
    );
  }
}

/// The rotation timer: the active item is a short bar that fills over the dwell
/// time; the others are muted dots. Deliberately not a countdown number.
class _RotationDots extends StatelessWidget {
  const _RotationDots({
    required this.controller,
    required this.count,
    required this.index,
  });
  final AnimationController controller;
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final muted = Colors.white.withValues(alpha: 0.28);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: active
              ? SizedBox(
                  width: 24,
                  height: 4,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: controller.value,
                        minHeight: 4,
                        backgroundColor: muted,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 6,
                  height: 4,
                  decoration: BoxDecoration(
                    color: muted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
        );
      }),
    );
  }
}

class _HeroContent extends ConsumerWidget {
  const _HeroContent({required this.manga, super.key});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = resolveCoverImage(manga, ref);
    final total = manga.chapters.length;
    final read = manga.chapters.where((c) => c.isRead ?? false).length;
    final unread = manga.chapters.where((c) => !(c.isRead ?? true)).length;
    final resume = _resumeChapter(manga);
    final posMs = int.tryParse(resume?.lastPageRead ?? '') ?? 0;

    // Series progress = watched / total (episode duration isn't reliably
    // stored, so within-episode % isn't available).
    final progress = (total > 0 && read > 0 && read < total)
        ? read / total
        : 0.0;
    final hasBar = progress > 0;

    final metaBits = <String>[
      if ((resume?.name ?? '').isNotEmpty) resume!.name!,
      if (posMs > 0) 'at ${_fmtMs(posMs)}',
      if (unread > 0) '$unread new',
      if ((manga.source ?? '').isNotEmpty) manga.source!,
    ];
    final genreBits = (manga.genre ?? const <String>[])
        .where((g) => g.trim().isNotEmpty)
        .take(3)
        .toList();

    return ClipRect(
      child: SizedBox(
        height: 330,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The backdrop fades its own alpha out into the rows below, rather
            // than blending toward a background colour it would have to guess
            // at. Its top edge is handled by the fade over the whole content
            // viewport — that edge moves as the hero scrolls, this one doesn't.
            ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.72, 1.0],
                colors: [Colors.white, Colors.white, Colors.transparent],
              ).createShader(rect),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ImageFiltered(
                    imageFilter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Image(image: image, fit: BoxFit.cover),
                  ),
                  // Darken the left so the title/summary stay readable.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xDB000000), Color(0x40000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 40, 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 0.68,
                      child: Image(image: image, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          manga.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (metaBits.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            metaBits.join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 14,
                            ),
                          ),
                        ],
                        if (genreBits.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            genreBits.join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.55),
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (hasBar) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$read / $total',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if ((manga.description ?? '').trim().isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            manga.description!.trim(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.72),
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _HeroContinueButton(manga: manga, chapter: resume),
                      ],
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

/// The hero's Continue button — focusable, autofocused (the home's landing
/// target), theme-accent when focused, OK/Select or tap to resume.
class _HeroContinueButton extends StatefulWidget {
  const _HeroContinueButton({required this.manga, this.chapter});
  final Manga manga;
  final Chapter? chapter;

  @override
  State<_HeroContinueButton> createState() => _HeroContinueButtonState();
}

class _HeroContinueButtonState extends State<_HeroContinueButton> {
  bool _focused = false;

  void _resume() {
    (widget.chapter ?? _resumeChapter(widget.manga))?.pushToReaderView(context);
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return Focus(
      // Entry focus lives on the "All" pill; the hero must not steal it when
      // switching back to All from a category view.
      autofocus: false,
      onFocusChange: (f) {
        setState(() => _focused = f);
        // When focus returns to the hero (e.g. scrolling up out of the rows),
        // pull the page fully to the top so the whole poster is revealed
        // instead of staying clipped under the first row.
        if (f) {
          Scrollable.maybeOf(context)?.position.animateTo(
            0,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelectKey(event.logicalKey)) {
          _resume();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: _resume,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.05 : 1.0,
              _focused ? 1.05 : 1.0,
              _focused ? 1.05 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: _focused ? accent : Colors.white.withValues(alpha: 0.14),
            border: Border.all(
              color: _focused ? accent : Colors.white.withValues(alpha: 0.28),
              width: 2,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A titled horizontal row of cover cards, sized by the current density scale.
class _TvHomeRow extends ConsumerWidget {
  const _TvHomeRow({required this.title, required this.items});
  final String title;
  final List<Manga> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridSize = _gridSize(ref);
    final width = _cardWidth(context, gridSize);
    final height = _rowHeight(context, gridSize);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: height,
            child: FocusTraversalGroup(
              child: SuperListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, index) => SizedBox(
                  width: width,
                  child: _TvHomeCard(manga: items[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The category filter bar under the search row: [All] + a pill per category +
/// [+ Category]. Selecting sets the filter but keeps focus on the pill.
class _CategoryPills extends StatefulWidget {
  const _CategoryPills({
    required this.selected,
    required this.categories,
    required this.hidden,
    required this.onSelect,
  });
  final int? selected;
  final List<Category> categories;
  final List<Category> hidden;
  final ValueChanged<int?> onSelect;

  @override
  State<_CategoryPills> createState() => _CategoryPillsState();
}

class _CategoryPillsState extends State<_CategoryPills> {
  /// "All" is the one pill that always exists, so it's where focus lands when
  /// the pill that had it leaves the tree — hiding it, or unhiding the last
  /// hidden category and losing the Hidden pill with it.
  final _allNode = FocusNode(debugLabel: 'tvPillAll');

  @override
  void dispose() {
    _allNode.dispose();
    super.dispose();
  }

  void _focusAll() {
    Future<void>.microtask(() {
      if (mounted) _allNode.requestFocus();
    });
  }

  /// Hold OK on a category pill to hide it: the pill goes away and so do its
  /// titles, matching what hiding does in the library. Unconfirmed, because the
  /// toast that names the way back doubles as the undo prompt.
  void _hide(Category category) {
    isar.writeTxnSync(() => isar.categorys.putSync(category..hide = true));
    if (widget.selected == category.id) widget.onSelect(null);
    _focusAll();
    botToast('Hid “${category.name}” · hold OK on “All” to unhide');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            // minWidth = viewport, so the Row centers its pills when they fit
            // and simply grows/scrolls when there are many categories.
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: FocusTraversalGroup(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TvPill(
                    label: 'All',
                    focusNode: _allNode,
                    selected: widget.selected == null,
                    autofocus: true,
                    onTap: () => widget.onSelect(null),
                    onLongPress: () =>
                        _showHiddenCategoriesDialog(context, widget.hidden),
                    onMenu: () =>
                        _showHiddenCategoriesDialog(context, widget.hidden),
                  ),
                  for (final c in widget.categories)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TvPill(
                        label: c.name ?? '',
                        selected: widget.selected == c.id,
                        onTap: () => widget.onSelect(c.id),
                        onLongPress: () => _hide(c),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TvPill(
                      label: 'Category',
                      icon: Icons.add,
                      onTap: () =>
                          _showAddCategoryDialog(context, widget.categories),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// The filter pill moved to the shared `TvPill` widget
// (lib/modules/widgets/tv_pill.dart), reused by the Browse tab switcher.

/// Reuses the categories screen's add-category flow to create an anime category
/// inline from the home.
/// Has no chip, no icon, nothing on screen: a visible "Hidden" affordance would
/// advertise the categories the user hid, which is most of what hiding is for.
/// Reached from the "All" pill — hold OK on it, or press Menu while it's
/// focused. Hiding leaves focus there, so the toast can name the way back.
void _showHiddenCategoriesDialog(BuildContext context, List<Category> hidden) {
  if (hidden.isEmpty) {
    botToast('No hidden categories');
    return;
  }
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Hidden categories'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < hidden.length; i++)
              ListTile(
                autofocus: i == 0,
                title: Text(hidden[i].name ?? ''),
                trailing: const Icon(Icons.visibility_outlined),
                onTap: () {
                  isar.writeTxnSync(
                    () => isar.categorys.putSync(hidden[i]..hide = false),
                  );
                  Navigator.pop(dialogContext);
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void _showAddCategoryDialog(BuildContext context, List<Category> existing) {
  final controller = TextEditingController();
  bool isExist = false;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('New category'),
        content: CustomTextFormField(
          controller: controller,
          entries: existing,
          context: context,
          exist: (v) => setState(() => isExist = v),
          isExist: isExist,
          val: (_) => setState(() {}),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: controller.text.trim().isEmpty || isExist
                ? null
                : () {
                    final category = Category(
                      forItemType: ItemType.anime,
                      name: controller.text.trim(),
                      updatedAt: DateTime.now().millisecondsSinceEpoch,
                    );
                    isar.writeTxnSync(() {
                      isar.categorys.putSync(category..pos = category.id);
                      final nulls = isar.categorys
                          .filter()
                          .posIsNull()
                          .findAllSync();
                      for (final c in nulls) {
                        isar.categorys.putSync(c..pos = c.id);
                      }
                    });
                    Navigator.pop(context);
                  },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

/// A cover card: reuses [CoverViewWidget] (focus ring + badges) and scrolls
/// itself into view when focused (focus drives scroll). Select → detail.
class _TvHomeCard extends ConsumerWidget {
  const _TvHomeCard({required this.manga});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = manga.chapters.length;
    final read = manga.chapters.where((c) => c.isRead ?? false).length;
    final unread = manga.chapters.where((c) => !(c.isRead ?? true)).length;
    // Series progress = episodes watched / total (episode duration isn't
    // reliably stored, so within-episode progress isn't available).
    final progress = (total > 0 && read > 0 && read < total)
        ? read / total
        : 0.0;
    final source = manga.source ?? '';
    return CoverViewWidget(
      isComfortableGrid: true,
      progress: progress,
      bottomTextWidget: BottomTextWidget(
        text: manga.name ?? '',
        maxLines: 1,
        isComfortableGrid: true,
      ),
      image: resolveCoverImage(manga, ref),
      onFocusChange: (focused) {
        if (focused && context.mounted) {
          // Reveal the focused card in both the row (horizontal) and the page
          // (vertical) — one call walks up every enclosing scrollable.
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
          );
        }
      },
      onTap: () => onTapEntry(
        isLongPressed: false,
        ref: ref,
        context: context,
        entry: manga,
      ),
      // Long-press (hold OK on a remote) → assign this title to categories.
      onLongPress: () => showCategorySelectionDialog(
        context: context,
        ref: ref,
        itemType: ItemType.anime,
        singleManga: manga,
      ),
      children: [
        if (unread > 0)
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '$unread',
                  style: TextStyle(
                    color: context.dynamicBlackWhiteColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        if (source.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 92),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                  ),
                ),
                child: Text(
                  source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 9),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shown when the anime library is empty — carries a *focusable* action so the
/// content always has a focus target (otherwise the empty home traps the d-pad
/// with nothing to move Left from to reach the rail).
class _EmptyHome extends StatefulWidget {
  const _EmptyHome();

  @override
  State<_EmptyHome> createState() => _EmptyHomeState();
}

class _EmptyHomeState extends State<_EmptyHome> {
  bool _focused = false;

  void _browse() => context.go('/browse');

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final hint = Theme.of(context).hintColor;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.video_library_outlined, size: 56, color: accent),
          const SizedBox(height: 16),
          const Text(
            'Your anime library is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Add anime from Browse to fill your home',
            style: TextStyle(color: hint),
          ),
          const SizedBox(height: 22),
          Focus(
            autofocus: true,
            onFocusChange: (f) => setState(() => _focused = f),
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && _isSelectKey(event.logicalKey)) {
                _browse();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              onTap: _browse,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: _focused ? accent : accent.withValues(alpha: 0.12),
                  border: Border.all(
                    color: _focused ? accent : accent.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      color: _focused ? Colors.white : accent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Browse anime',
                      style: TextStyle(
                        color: _focused ? Colors.white : accent,
                        fontWeight: FontWeight.w600,
                      ),
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
}

bool _isSelectKey(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;

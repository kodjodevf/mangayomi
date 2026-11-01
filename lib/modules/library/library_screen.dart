// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/collapsing_header.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_swipe.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/tv_home/tv_anime_home_view.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/library/providers/add_torrent.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/widgets/library_app_bar.dart';
import 'package:mangayomi/modules/library/widgets/library_body.dart';
import 'package:mangayomi/modules/library/widgets/library_dialogs.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/widgets/bottom_select_bar.dart';
import 'package:mangayomi/modules/library/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/library/widgets/active_filter_chips.dart';
import 'package:mangayomi/modules/library/widgets/continue_shelf.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/library/utils/last_category.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:shiori/shiori.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Main library screen — refactored from 2309 lines to ~350 lines.
///
/// Decomposed into:
/// - [LibraryAppBar] — search, selection, popup menu
/// - [LibraryBody] — filtered/sorted manga grid or list per category
/// - [CategoryBadge] — tab badge with item count
/// - [showLibrarySettingsSheet] — filter/sort/display bottom sheet
/// - [showDeleteMangaDialog] — bulk delete dialog
/// - [showImportLocalDialog] — import local files dialog
/// - [filteredLibraryMangaProvider] — cached filter+sort (S8)
class LibraryScreen extends ConsumerStatefulWidget {
  final ItemType itemType;
  final String? presetInput;
  const LibraryScreen({
    required this.itemType,
    required this.presetInput,
    super.key,
  });

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool _isSearch = false;
  bool _ignoreFiltersOnSearch = false;
  final _textEditingController = TextEditingController();
  TabController? tabBarController;
  int _tabIndex = 0;
  Timer? _searchDebounce;

  /// The category of the selected tab (null for Default), which the tab is
  /// found by when the tabs change. Starts as the one the library was last
  /// left on, so it reopens there.
  int? _selectedCategoryId;

  /// The category each tab shows, in order (null for Default).
  List<int?> _tabCategoryIds = const [];

  /// Saves the selected category when the app is sent to the background,
  /// the last moment it reliably runs before the system may close it.
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    if (widget.presetInput != null) {
      _isSearch = true;
      _textEditingController.text = widget.presetInput!;
    }
    final settings = settingsRepository.currentOrNull;
    _selectedCategoryId = settings == null
        ? null
        : lastLibraryCategoryId(settings, widget.itemType);
    _lifecycleListener = AppLifecycleListener(onHide: _saveSelectedCategory);
  }

  /// Saved here rather than on every tab change: writing a setting rebuilds
  /// the library, which would make each swipe between categories stutter.
  void _saveSelectedCategory() {
    final settings = settingsRepository.currentOrNull;
    if (settings == null) return;
    if (lastLibraryCategoryId(settings, widget.itemType) ==
        _selectedCategoryId) {
      return;
    }
    final itemType = widget.itemType;
    final categoryId = _selectedCategoryId;
    settingsRepository.updateLocalState(
      (s) => setLastLibraryCategoryId(s, itemType, categoryId),
    );
  }

  @override
  void dispose() {
    _saveSelectedCategory();
    _lifecycleListener.dispose();
    _textEditingController.dispose();
    tabBarController?.dispose();
    // Anything waiting for the end of a frame that will now never come.
    for (final controller in _retiredTabControllers) {
      controller.dispose();
    }
    _retiredTabControllers.clear();
    _searchDebounce?.cancel();
    _headerCollapsed.dispose();
    super.dispose();
  }

  /// Whether the switcher at the top has scrolled out of sight, for the
  /// title to name the media instead of the group.
  final ValueNotifier<bool> _headerCollapsed = ValueNotifier(false);

  /// Controllers replaced this frame, disposed once nothing can still paint
  /// from them.
  final List<TabController> _retiredTabControllers = [];

  /// Schedules [controller] for disposal after the current frame.
  ///
  /// Held in a list rather than disposed inline because the widgets built in
  /// the previous frame still reference it until this frame is painted.
  void _retireTabController(TabController? controller) {
    if (controller == null) return;
    _retiredTabControllers.add(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_retiredTabControllers.remove(controller)) return;
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsStream = ref.watch(getSettingsStreamProvider);
    return settingsStream.when(
      data: (settings) => _buildWithSettings(settings),
      error: (error, _) => ErrorText(error),
      loading: _loadingLibrary,
    );
  }

  /// The settings of the build in progress, for the header's filter chips.
  late Settings _settings;

  Widget _buildWithSettings(Settings settings) {
    _settings = settings;
    // On Android TV the anime library shows the dedicated rows-based home
    // instead of the flat grid - a d-pad-first, cover-forward shelf. Toggleable
    // via tvHomeStyleProvider; every other surface keeps the grid.
    if (isTv &&
        widget.itemType == ItemType.anime &&
        ref.watch(tvHomeStyleProvider)) {
      return TvAnimeHomeView(settings: settings);
    }
    final categories = ref.watch(
      getMangaCategorieStreamProvider(itemType: widget.itemType),
    );
    final downloadedOnly = ref.watch(downloadedOnlyStateProvider);
    final mangaAll = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType),
    );

    // Read filter/sort settings once for the whole build
    T watchWithSettings<T>(
      ProviderListenable<T> Function({
        required ItemType itemType,
        required Settings settings,
      })
      providerFn,
    ) {
      return ref.watch(
        providerFn(itemType: widget.itemType, settings: settings),
      );
    }

    T watchWithSettingsAndManga<T>(
      ProviderListenable<T> Function({
        required ItemType itemType,
        required List<Manga> mangaList,
        required Settings settings,
      })
      providerFn,
    ) {
      return ref.watch(
        providerFn(
          itemType: widget.itemType,
          mangaList: const <Manga>[],
          settings: settings,
        ),
      );
    }

    final showCategoryTabs = watchWithSettings(
      libraryShowCategoryTabsStateProvider.call,
    );
    final reverse =
        watchWithSettings(sortLibraryMangaStateProvider.call).reverse ?? false;
    final continueReaderBtn = watchWithSettings(
      libraryShowContinueReadingButtonStateProvider.call,
    );
    final showNumbersOfItems = watchWithSettings(
      libraryShowNumbersOfItemsStateProvider.call,
    );
    final localSource = watchWithSettings(libraryLocalSourceStateProvider.call);
    final downloadedChapter = watchWithSettings(
      libraryDownloadedChaptersStateProvider.call,
    );
    final language = watchWithSettings(libraryLanguageStateProvider.call);
    final displayType = watchWithSettings(libraryDisplayTypeStateProvider.call);
    final downloadFilterType = watchWithSettingsAndManga(
      mangaFilterDownloadedStateProvider.call,
    );
    final unreadFilterType = watchWithSettingsAndManga(
      mangaFilterUnreadStateProvider.call,
    );
    final startedFilterType = watchWithSettingsAndManga(
      mangaFilterStartedStateProvider.call,
    );
    final bookmarkedFilterType = watchWithSettingsAndManga(
      mangaFilterBookmarkedStateProvider.call,
    );
    final completedFilterType = watchWithSettingsAndManga(
      mangaFilterCompletedStateProvider.call,
    );
    final trackingFilterType = watchWithSettingsAndManga(
      mangaFilterTrackingStateProvider.call,
    );
    final sortType =
        watchWithSettings(sortLibraryMangaStateProvider.call).index ?? 0;

    final searchQuery = _textEditingController.text;

    return Scaffold(
      body: mangaAll.when(
        data: (man) {
          return categories.when(
            data: (data) {
              final isNotFiltering = ref.watch(
                mangasFilterResultStateProvider(
                  itemType: widget.itemType,
                  mangaList: man,
                  settings: settings,
                ),
              );
              final sourceFilterIds = ref
                  .watch(
                    mangaFilterSourceStateProvider(
                      mangaList: man,
                      itemType: widget.itemType,
                      settings: settings,
                    ),
                  )
                  .$2;

              // Common body params
              Widget bodyForCategory({
                int? categoryId,
                bool withoutCategories = false,
              }) {
                return LibraryBody(
                  itemType: widget.itemType,
                  categoryId: categoryId,
                  withoutCategories: withoutCategories,
                  downloadFilterType: downloadFilterType,
                  unreadFilterType: unreadFilterType,
                  startedFilterType: startedFilterType,
                  bookmarkedFilterType: bookmarkedFilterType,
                  completedFilterType: completedFilterType,
                  trackingFilterType: trackingFilterType,
                  reverse: reverse,
                  downloadedChapter: downloadedChapter,
                  continueReaderBtn: continueReaderBtn,
                  localSource: localSource,
                  language: language,
                  displayType: displayType,
                  settings: settings,
                  downloadedOnly: downloadedOnly,
                  searchQuery: searchQuery,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  sourceIds: sourceFilterIds,
                );
              }

              Widget badgeForCategory(int categoryId) {
                return CategoryBadge(
                  itemType: widget.itemType,
                  categoryId: categoryId,
                  downloadFilterType: downloadFilterType,
                  unreadFilterType: unreadFilterType,
                  startedFilterType: startedFilterType,
                  bookmarkedFilterType: bookmarkedFilterType,
                  completedFilterType: completedFilterType,
                  trackingFilterType: trackingFilterType,
                  settings: settings,
                  downloadedOnly: downloadedOnly,
                  searchQuery: searchQuery,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  sourceIds: sourceFilterIds,
                );
              }

              final withoutCategory = man
                  .where((m) => m.categories == null || m.categories!.isEmpty)
                  .toList();
              // Get the number of items for the app bar
              final numberOfItemsList = ref.watch(
                filteredLibraryMangaProvider(
                  data: man,
                  downloadFilterType: downloadFilterType,
                  unreadFilterType: unreadFilterType,
                  startedFilterType: startedFilterType,
                  bookmarkedFilterType: bookmarkedFilterType,
                  completedFilterType: completedFilterType,
                  trackingFilterType: trackingFilterType,
                  sortType: sortType,
                  downloadedOnly: downloadedOnly,
                  searchQuery: searchQuery,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  sourceIds: sourceFilterIds,
                  settings: settings,
                ),
              );

              if (data.isNotEmpty && showCategoryTabs) {
                return _buildWithCategories(
                  data: data,
                  withoutCategory: withoutCategory,
                  man: man,
                  settings: settings,
                  showNumbersOfItems: showNumbersOfItems,
                  isNotFiltering: isNotFiltering,
                  numberOfItems: numberOfItemsList.length,
                  bodyForCategory: bodyForCategory,
                  badgeForCategory: badgeForCategory,
                  downloadFilterType: downloadFilterType,
                  downloadedOnly: downloadedOnly,
                );
              }

              return Scaffold(
                appBar: LibraryAppBar(
                  itemType: widget.itemType,
                  isNotFiltering: isNotFiltering,
                  showNumbersOfItems: showNumbersOfItems,
                  numberOfItems: numberOfItemsList.length,
                  entries: man,
                  isCategory: false,
                  categoryId: null,
                  settings: settings,
                  isSearch: _isSearch,
                  ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                  textEditingController: _textEditingController,
                  onSearchToggle: () => setState(() => _isSearch = !_isSearch),
                  onSearchClear: () {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        if (mounted) setState(() {});
                      },
                    );
                  },
                  onIgnoreFiltersChanged: (val) =>
                      setState(() => _ignoreFiltersOnSearch = val),
                  vsync: this,
                  headerCollapsed: _headerCollapsed,
                ),
                body: _withLibraryHeader(bodyForCategory()),
              );
            },
            error: (error, _) => ErrorText(error),
            loading: _loadingLibrary,
          );
        },
        error: (error, _) => ErrorText(error),
        loading: _loadingLibrary,
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildWithCategories({
    required List data,
    required List<Manga> withoutCategory,
    required List<Manga> man,
    required Settings settings,
    required bool showNumbersOfItems,
    required bool isNotFiltering,
    required int numberOfItems,
    required Widget Function({int? categoryId, bool withoutCategories})
    bodyForCategory,
    required Widget Function(int categoryId) badgeForCategory,
    required int downloadFilterType,
    required bool downloadedOnly,
  }) {
    final sortedData = [...data]
      ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
    final entr = sortedData.where((e) => !(e.hide ?? false)).toList();
    int tabCount = withoutCategory.isNotEmpty ? entr.length + 1 : entr.length;

    if (tabCount <= 0) {
      return bodyForCategory();
    }

    _tabCategoryIds = [
      if (withoutCategory.isNotEmpty) null,
      for (final category in entr) category.id,
    ];

    // Manage TabController
    if (tabCount > 0 &&
        (tabBarController == null || tabBarController!.length != tabCount)) {
      // Back on the selected category's tab, wherever it now sits: the first
      // build may come before the series load and the Default tab appears.
      final newTabIndex = libraryTabIndexFor(
        _tabCategoryIds,
        _selectedCategoryId,
        fallback: _tabIndex,
      );
      // Retire the old one after this frame rather than here. Disposing a
      // TabController sets its animation to null, and the TabBar built in the
      // previous frame is still holding this one: its _IndicatorPainter reads
      // `controller.animation!.value` on the next paint and dies on the null
      // check. That is #923, reported from the library screen with exactly
      // that frame at the top of the stack.
      _retireTabController(tabBarController);
      tabBarController = TabController(
        length: tabCount,
        vsync: this,
        initialIndex: newTabIndex,
      );
      _tabIndex = newTabIndex;
      tabBarController!.addListener(() {
        final index = tabBarController!.index;
        if (_tabIndex != index) {
          setState(() {
            _tabIndex = index;
            if (index < _tabCategoryIds.length) {
              _selectedCategoryId = _tabCategoryIds[index];
            }
          });
        }
      });
    }

    return DefaultTabController(
      length: entr.length,
      child: Scaffold(
        appBar: LibraryAppBar(
          itemType: widget.itemType,
          isNotFiltering: isNotFiltering,
          showNumbersOfItems: showNumbersOfItems,
          numberOfItems: numberOfItems,
          entries: man,
          isCategory: true,
          categoryId: withoutCategory.isNotEmpty && _tabIndex == 0
              ? null
              : entr[withoutCategory.isNotEmpty ? _tabIndex - 1 : _tabIndex]
                    .id!,
          settings: settings,
          isSearch: _isSearch,
          ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
          textEditingController: _textEditingController,
          onSearchToggle: () => setState(() => _isSearch = !_isSearch),
          onSearchClear: () {
            _searchDebounce?.cancel();
            _searchDebounce = Timer(const Duration(milliseconds: 300), () {
              if (mounted) setState(() {});
            });
          },
          onIgnoreFiltersChanged: (val) =>
              setState(() => _ignoreFiltersOnSearch = val),
          vsync: this,
          headerCollapsed: _headerCollapsed,
        ),
        // A single category doesn't need the tab bar + TabBarView. The
        // TabBarView (a PageView) blocks directional d-pad focus from crossing
        // into/out of the grid - which is why the anime tab couldn't reach the
        // grid while Browse (a direct grid) works. So for one category, render
        // the grid directly like Browse; keep the tabs only for 2+ categories.
        body: tabCount <= 1
            ? _withLibraryHeader(
                withoutCategory.isEmpty && entr.isNotEmpty
                    ? bodyForCategory(categoryId: entr.first.id!)
                    : bodyForCategory(),
              )
            : _withLibraryHeader(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryTabs(
                      entr: entr,
                      withoutCategory: withoutCategory,
                      showNumbersOfItems: showNumbersOfItems,
                      badgeForCategory: badgeForCategory,
                    ),
                    Flexible(
                      child: TabBarView(
                        controller: tabBarController,
                        children: _buildCategoryBodies(
                          entr: entr,
                          withoutCategory: withoutCategory,
                          bodyForCategory: bodyForCategory,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCategoryTabs({
    required List entr,
    required List<Manga> withoutCategory,
    required bool showNumbersOfItems,
    required Widget Function(int categoryId) badgeForCategory,
  }) {
    final l10n = l10nLocalizations(context)!;
    return TabBar(
      isScrollable: true,
      controller: tabBarController,
      tabs: [
        if (withoutCategory.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tab(text: l10n.default0),
              // Default category doesn't have a single ID — use inline count
              if (showNumbersOfItems)
                _DefaultCategoryBadge(itemType: widget.itemType),
            ],
          ),
        for (var i = 0; i < entr.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tab(text: entr[i].name),
              if (showNumbersOfItems) badgeForCategory(entr[i].id!),
            ],
          ),
      ],
    );
  }

  List<Widget> _buildCategoryBodies({
    required List entr,
    required List<Manga> withoutCategory,
    required Widget Function({int? categoryId, bool withoutCategories})
    bodyForCategory,
  }) {
    return [
      if (withoutCategory.isNotEmpty) bodyForCategory(withoutCategories: true),
      for (var i = 0; i < entr.length; i++)
        bodyForCategory(categoryId: entr[i].id!),
    ];
  }

  /// The library while its settings and series load, the first time a media
  /// is opened: its title, the media switcher and a grid of placeholder
  /// covers, so switching from Manga to Anime keeps the page's frame rather
  /// than flashing an empty screen for the moment the query takes.
  Widget _loadingLibrary() {
    final route = libraryRouteFor(widget.itemType);
    final tokens = context.shiori;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(
          isGroupedNavRoute(ref, route)
              ? navGroupTitle(context, route)
              : widget.itemType.localized(context.l10n),
          style: tokens.text.screenTitle.copyWith(color: tokens.color.fg),
        ),
      ),
      body: Column(
        children: [
          if (!isTv) NavGroupSwitcher(route: route),
          const Expanded(child: ShioriCoverGrid.skeleton()),
        ],
      ),
    );
  }

  /// [body] under the library's header: the media switcher when the
  /// navigation is grouped, then the "Continue" row. Both scroll away with
  /// the grid, so they never hold a phone's height for good. Left out while
  /// searching or selecting, where they would only be in the way, and on a
  /// TV, whose home already leads with what is in progress.
  Widget _withLibraryHeader(Widget body) {
    final route = libraryRouteFor(widget.itemType);
    final selecting = ref.watch(isLongPressedStateProvider);
    final showShelf = !isTv && !_isSearch && !selecting;
    // A sideways swipe switches media as the switcher does, and for the same
    // reason not while selecting.
    Widget swipe(Widget child) =>
        NavGroupSwipe(route: route, enabled: !selecting, child: child);
    if (!showShelf) {
      return swipe(
        Column(
          children: [
            // Not while selecting: switching to Anime mid-selection would mix
            // series of two kinds in one action, and the navigation bar is
            // already hidden for the same reason.
            if (!selecting) NavGroupSwitcher(route: route),
            ActiveFilterChips(itemType: widget.itemType, settings: _settings),
            Expanded(child: body),
          ],
        ),
      );
    }
    // The outer scroll of the NestedScrollView moves the header; past the
    // switcher's height the title names the media instead of the group.
    return swipe(
      CollapseOnScroll(
        collapsed: _headerCollapsed,
        threshold: context.shiori.density.minTarget + ShioriSpace.s12,
        accept: (notification) => notification.depth == 0,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NavGroupSwitcher(route: route),
                  ContinueShelf(itemType: widget.itemType),
                  ActiveFilterChips(
                    itemType: widget.itemType,
                    settings: _settings,
                  ),
                ],
              ),
            ),
          ],
          body: body,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Builder(
      builder: (context) {
        final mangaIds = ref.watch(mangasListStateProvider);
        final l10n = context.l10n;
        return BottomSelectBar(
          isVisible: ref.watch(isLongPressedStateProvider),
          actions: [
            BottomSelectButton(
              icon: const Icon(Symbols.label_rounded),
              tooltip: l10n.set_categories,
              onPressed: () {
                final List<Manga> bulkMangas = mangaIds
                    .map((id) => mangaRepository.getById(id))
                    .toList();
                showCategorySelectionDialog(
                  context: context,
                  ref: ref,
                  itemType: widget.itemType,
                  bulkMangas: bulkMangas,
                );
              },
            ),
            BottomSelectButton(
              icon: const Icon(Symbols.done_all_rounded),
              tooltip: l10n.mark_as_read,
              onPressed: () {
                ref
                    .read(
                      mangasSetIsReadStateProvider(
                        mangaIds: mangaIds,
                        markAsRead: true,
                      ).notifier,
                    )
                    .set();
                _invalidateStreams();
              },
            ),
            BottomSelectButton(
              icon: const Icon(Symbols.remove_done_rounded),
              tooltip: l10n.mark_as_unread,
              onPressed: () {
                ref
                    .read(
                      mangasSetIsReadStateProvider(
                        mangaIds: mangaIds,
                        markAsRead: false,
                      ).notifier,
                    )
                    .set();
                _invalidateStreams();
              },
            ),
            BottomSelectButton(
              icon: const Icon(Symbols.swap_horiz_rounded),
              tooltip: l10n.migrate,
              onPressed: () {
                final List<Manga> bulkMangas = mangaIds
                    .map((id) => mangaRepository.getById(id))
                    .whereType<Manga>()
                    .toList();
                ref.read(isLongPressedStateProvider.notifier).update(false);
                ref.read(mangasListStateProvider.notifier).clear();
                context.push(
                  '/massMigration',
                  extra: (widget.itemType, null, bulkMangas),
                );
              },
            ),
            BottomSelectButton(
              icon: const Icon(Symbols.delete_rounded),
              tooltip: l10n.delete,
              onPressed: () => showDeleteMangaDialog(
                context: context,
                ref: ref,
                itemType: widget.itemType,
              ),
            ),
          ],
        );
      },
    );
  }

  void _invalidateStreams() {
    ref.invalidate(
      getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType),
    );
  }
}

/// Badge for the "Default" (uncategorized) category tab.
class _DefaultCategoryBadge extends ConsumerWidget {
  final ItemType itemType;
  const _DefaultCategoryBadge({required this.itemType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangas = ref.watch(
      getAllMangaStreamProvider(categoryId: null, itemType: itemType),
    );
    return mangas.when(
      data: (data) {
        final count = data
            .where((m) => m.categories == null || m.categories!.isEmpty)
            .length;
        // The gap lives here so a tab with no badge keeps no trailing space.
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: ShioriSpace.s4),
          child: EntryBadgeChip(label: count.toString()),
        );
      },
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

/// Top-level utility — shows a dialog to add a torrent by URL or .torrent file.
void addTorrent(BuildContext context, {Manga? manga}) {
  final l10n = context.l10n;
  String torrentUrl = "";
  bool isLoading = false;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Consumer(
        builder: (context, ref, _) {
          // From the URL when one is given, else from a file picked on the
          // device.
          Future<void> add({required bool fromUrl}) async {
            setState(() => isLoading = true);
            try {
              await ref.watch(
                addTorrentFromUrlOrFromFileProvider(
                  manga,
                  init: true,
                  url: fromUrl ? torrentUrl : null,
                ).future,
              );
            } catch (_) {}
            if (!context.mounted) return;
            setState(() => isLoading = false);
            Navigator.pop(context);
          }

          return PopScope(
            canPop: !isLoading,
            child: ShioriDialog(
              title: l10n.add_torrent,
              content: TextField(
                enabled: !isLoading,
                keyboardType: TextInputType.url,
                onChanged: (value) => setState(() => torrentUrl = value),
                decoration: InputDecoration(
                  labelText: l10n.torrent_url,
                  hintText: l10n.enter_torrent_hint_text,
                ),
              ),
              actions: [
                ShioriButton.quiet(
                  label: l10n.cancel,
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                ),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(ShioriSpace.s8),
                    child: ShioriLoading.inline(),
                  )
                else ...[
                  ShioriButton.secondary(
                    icon: Symbols.file_open_rounded,
                    label: l10n.import_files,
                    onPressed: () => add(fromUrl: false),
                  ),
                  ShioriButton(
                    label: l10n.add,
                    onPressed: torrentUrl.trim().isEmpty
                        ? null
                        : () => add(fromUrl: true),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    ),
  );
}

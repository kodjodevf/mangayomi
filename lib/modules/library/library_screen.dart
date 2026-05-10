// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
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
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
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
  final List<Manga> _entries = [];
  final _textEditingController = TextEditingController();
  TabController? tabBarController;
  int _tabIndex = 0;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    if (widget.presetInput != null) {
      _isSearch = true;
      _textEditingController.text = widget.presetInput!;
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    tabBarController?.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsStream = ref.watch(getSettingsStreamProvider);
    return settingsStream.when(
      data: (settingsList) {
        final settings = settingsList.first;
        return _buildWithSettings(settings);
      },
      error: (error, _) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }

  Widget _buildWithSettings(Settings settings) {
    final categories = ref.watch(
      getMangaCategorieStreamProvider(itemType: widget.itemType),
    );
    final withoutCategories = ref.watch(
      getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType),
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
          mangaList: _entries,
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
    final isNotFiltering = watchWithSettingsAndManga(
      mangasFilterResultStateProvider.call,
    );
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

    // Common body params
    Widget bodyForCategory({int? categoryId, bool withoutCategories = false}) {
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
      );
    }

    return Scaffold(
      body: mangaAll.when(
        data: (man) {
          return withoutCategories.when(
            data: (withoutCategory) {
              return categories.when(
                data: (data) {
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
                    ),
                  );

                  if (data.isNotEmpty && showCategoryTabs) {
                    return _buildWithCategories(
                      data: data,
                      withoutCategory: withoutCategory,
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
                      entries: _entries,
                      isCategory: false,
                      categoryId: null,
                      settings: settings,
                      isSearch: _isSearch,
                      ignoreFiltersOnSearch: _ignoreFiltersOnSearch,
                      textEditingController: _textEditingController,
                      onSearchToggle: () =>
                          setState(() => _isSearch = !_isSearch),
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
                    ),
                    body: bodyForCategory(),
                  );
                },
                error: (error, _) => ErrorText(error),
                loading: () => const ProgressCenter(),
              );
            },
            error: (error, _) => ErrorText(error),
            loading: () => const ProgressCenter(),
          );
        },
        error: (error, _) => ErrorText(error),
        loading: () => const ProgressCenter(),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildWithCategories({
    required List data,
    required List<Manga> withoutCategory,
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
    data.sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
    final entr = data.where((e) => !(e.hide ?? false)).toList();
    int tabCount = withoutCategory.isNotEmpty ? entr.length + 1 : entr.length;

    if (tabCount <= 0) {
      return bodyForCategory();
    }

    // Manage TabController
    if (tabCount > 0 &&
        (tabBarController == null || tabBarController!.length != tabCount)) {
      int newTabIndex = _tabIndex;
      if (newTabIndex >= tabCount) newTabIndex = tabCount - 1;
      tabBarController?.dispose();
      tabBarController = TabController(
        length: tabCount,
        vsync: this,
        initialIndex: newTabIndex,
      );
      _tabIndex = newTabIndex;
      tabBarController!.addListener(() {
        setState(() => _tabIndex = tabBarController!.index);
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
          entries: _entries,
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
        ),
        body: Column(
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
            children: [
              Tab(text: l10n.default0),
              if (showNumbersOfItems) ...[
                const SizedBox(width: 4),
                // Default category doesn't have a single ID — use inline count
                _DefaultCategoryBadge(itemType: widget.itemType),
              ],
            ],
          ),
        for (var i = 0; i < entr.length; i++)
          Row(
            children: [
              Tab(text: entr[i].name),
              if (showNumbersOfItems) ...[
                const SizedBox(width: 4),
                badgeForCategory(entr[i].id!),
              ],
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

  Widget _buildBottomBar() {
    return Builder(
      builder: (context) {
        final mangaIds = ref.watch(mangasListStateProvider);
        final color = Theme.of(context).textTheme.bodyLarge!.color!;
        return BottomSelectBar(
          isVisible: ref.watch(isLongPressedStateProvider),
          actions: [
            BottomSelectButton(
              icon: Icon(Icons.label_outline_rounded, color: color),
              onPressed: () {
                final List<Manga> bulkMangas = mangaIds
                    .map((id) => isar.mangas.getSync(id)!)
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
              icon: Icon(Icons.done_all_sharp, color: color),
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
              icon: Icon(Icons.remove_done_sharp, color: color),
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
              icon: Icon(Icons.delete_outline_outlined, color: color),
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
      getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType),
    );
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
      getAllMangaWithoutCategoriesStreamProvider(itemType: itemType),
    );
    return mangas.when(
      data: (data) => CircleAvatar(
        backgroundColor: Theme.of(context).focusColor,
        radius: 8,
        child: Text(
          data.length.toString(),
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

/// Top-level utility — shows a dialog to add a torrent by URL or .torrent file.
void addTorrent(BuildContext context, {Manga? manga}) {
  final l10n = l10nLocalizations(context)!;
  String torrentUrl = "";
  bool isLoading = false;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.add_torrent),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, _) {
                return SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  torrentUrl = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: l10n.enter_torrent_hint_text,
                                labelText: l10n.torrent_url,
                                isDense: true,
                                filled: true,
                                fillColor: Colors.transparent,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: context.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await ref.watch(
                                        addTorrentFromUrlOrFromFileProvider(
                                          manga,
                                          init: true,
                                          url: torrentUrl,
                                        ).future,
                                      );
                                    } catch (_) {}

                                    setState(() {
                                      isLoading = false;
                                    });
                                    Navigator.pop(context);
                                  },
                            child: Text(l10n.add),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(l10n.or),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await ref.watch(
                                                addTorrentFromUrlOrFromFileProvider(
                                                  manga,
                                                  init: true,
                                                ).future,
                                              );
                                            } catch (_) {}

                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.archive_outlined),
                                        Text(
                                          "import .torrent file",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodySmall!.color,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                width: 300,
                                height: 150,
                                color: Colors.transparent,
                                child: UnconstrainedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: const Center(
                                      child: ProgressCenter(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}

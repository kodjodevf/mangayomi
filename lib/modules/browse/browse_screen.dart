import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/collapsing_header.dart';
import 'package:mangayomi/modules/widgets/side_swipe_detector.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';
import 'package:mangayomi/modules/browse/widgets/tv_browse_tab_strip.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

enum BrowseTabKind { sources, extensions }

class BrowseTab {
  final ItemType type;
  final BrowseTabKind kind;

  const BrowseTab(this.type, this.kind);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrowseTab && type == other.type && kind == other.kind;

  @override
  int get hashCode => Object.hash(type, kind);
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
    with TickerProviderStateMixin {
  final _textEditingController = TextEditingController();

  /// Which TV list row currently holds focus, so the rest of the list can
  /// fade back while one is active. Lives here so both the sources and the
  /// extensions tab share it.
  final _tvActiveRow = ValueNotifier<Object?>(null);
  late TabController _tabBarController;
  late List<BrowseTab> _tabList;

  /// Sources or Extensions, off TV: the media is picked by the segmented
  /// control above it, so this bar only ever has two tabs. Kept in step with
  /// [_tabBarController], which stays the one truth for every layout.
  late final TabController _kindController = TabController(
    length: 2,
    initialIndex: _tabList.isEmpty
        ? 0
        : _tabList[_tabBarController.index].kind.index,
    vsync: this,
  );

  // Hide manga & novel from Browse (sources + extensions) on the anime-only TV
  // layout so only anime shows, and respect media types hidden in Settings.
  // Recomputed live so toggling "Anime only" or hiding a media type updates
  // the tabs without a restart. Defaults to isTv, user-overridable. See #729.
  List<BrowseTab> _computeTabList(bool animeOnly, List<String> hideItems) => [
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      const BrowseTab(ItemType.manga, BrowseTabKind.sources),
    if (!hideItems.contains("/AnimeLibrary"))
      const BrowseTab(ItemType.anime, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      const BrowseTab(ItemType.novel, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      const BrowseTab(ItemType.manga, BrowseTabKind.extensions),
    if (!hideItems.contains("/AnimeLibrary"))
      const BrowseTab(ItemType.anime, BrowseTabKind.extensions),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      const BrowseTab(ItemType.novel, BrowseTabKind.extensions),
  ];

  @override
  void initState() {
    super.initState();
    _tabList = _computeTabList(
      ref.read(animeOnlyTvModeProvider),
      ref.read(hideItemsStateProvider),
    );
    _tabBarController = TabController(
      length: _tabList.length,
      initialIndex: _takeRequestedTabIndex(),
      vsync: this,
    );
    _tabBarController.addListener(_onTabChanged);
  }

  /// Each media's Sources and Extensions pages, side by side, off TV. One
  /// controller per media, so a media can be put on the right page while it
  /// is not on show: the one tab controller they used to share only moved a
  /// hidden pair when its animation value changed, and a swipe between the
  /// pages had already changed it, leaving the next media on Sources under an
  /// Extensions tab.
  final _pageControllers = <ItemType, PageController>{};

  PageController _pagesOf(ItemType type) => _pageControllers.putIfAbsent(
    type,
    () => PageController(initialPage: _kindController.index),
  );

  /// A swipe between Sources and Extensions of the media on show.
  void _onPageSwiped(ItemType type, int page) {
    // A hidden media's pages being put in place report it too.
    if (_tabList.isEmpty || type != _tabList[_tabBarController.index].type) {
      return;
    }
    if (_kindController.index != page) _kindController.animateTo(page);
    _open(type, BrowseTabKind.values[page]);
  }

  /// The index of the tab somebody asked us to open on, or zero.
  ///
  /// The request is cleared after this frame rather than as it is read.
  /// Riverpod counts initState as part of the build and throws on a write
  /// there, which took the whole Browse screen down.
  int _takeRequestedTabIndex() {
    final requested = ref.read(browseInitialTabProvider);
    if (requested == null) return 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(browseInitialTabProvider.notifier).clear();
    });
    final index = _tabList.indexWhere(
      (tab) => tab.kind == requested.kind && tab.type == requested.type,
    );
    return index < 0 ? 0 : index;
  }

  void _onTabChanged() {
    if (_tabList.isNotEmpty) {
      final kind = _tabList[_tabBarController.index].kind.index;
      if (_kindController.index != kind) _kindController.index = kind;
    }
    _chekPermission();
    setState(() {
      _textEditingController.clear();
      _isSearch = false;
    });
  }

  Future<void> _chekPermission() async {
    await StorageProvider().requestPermission();
  }

  @override
  void dispose() {
    _headerCollapsed.dispose();
    _tvActiveRow.dispose();
    _kindController.dispose();
    for (final pages in _pageControllers.values) {
      pages.dispose();
    }
    _tabBarController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  bool _isSearch = false;

  /// The top-bar action icons, which differ per tab (see #729): Sources =
  /// global-search + filter; Extensions = add + search + language filter.
  List<Widget> _actions(
    BuildContext context,
    bool isExtensionTab,
    ItemType tabType,
  ) {
    return [
      _isSearch
          ? SeachFormTextField(
              onChanged: (value) {
                setState(() {});
              },
              onSuffixPressed: () {
                _textEditingController.clear();
                setState(() {});
              },
              onPressed: () {
                setState(() {
                  _isSearch = false;
                });
                _textEditingController.clear();
              },
              controller: _textEditingController,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isExtensionTab && ref.watch(developerModeStateProvider))
                  IconButton(
                    tooltip: context.l10n.add,
                    onPressed: () {
                      context.push('/createExtension');
                    },
                    icon: Icon(
                      Symbols.add_rounded,
                      color: context.shiori.color.fgMuted,
                    ),
                  ),
                IconButton(
                  tooltip: isExtensionTab
                      ? MaterialLocalizations.of(context).searchFieldLabel
                      : context.l10n.global_search,
                  splashRadius: 20,
                  onPressed: () {
                    if (isExtensionTab) {
                      setState(() {
                        _isSearch = true;
                      });
                    } else {
                      context.push('/globalSearch', extra: (null, tabType));
                    }
                  },
                  icon: Icon(
                    fill: 1,
                    !isExtensionTab
                        ? Symbols.travel_explore_rounded
                        : Symbols.search_rounded,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
              ],
            ),
      IconButton(
        tooltip: context.l10n.filter,
        splashRadius: 20,
        onPressed: () {
          context.push(
            isExtensionTab ? '/ExtensionLang' : '/sourceFilter',
            extra: tabType,
          );
        },
        icon: Icon(
          fill: 1,
          !isExtensionTab
              ? Symbols.filter_list_rounded
              : Symbols.translate_rounded,
          color: context.shiori.color.fgMuted,
        ),
      ),
    ];
  }

  /// Whether the list has scrolled the media switch out of sight, in which
  /// case the title names the media rather than Browse.
  final ValueNotifier<bool> _headerCollapsed = ValueNotifier(false);

  /// Opens the tab for [type] and [kind], when it is visible.
  void _open(ItemType type, BrowseTabKind kind) {
    final index = _tabList.indexWhere((t) => t.type == type && t.kind == kind);
    if (index >= 0 && index != _tabBarController.index) {
      if (!isTv) _showPage(type, kind);
      _tabBarController.index = index;
      // The other list starts at its top: the switch comes back.
      _headerCollapsed.value = false;
    }
  }

  /// Puts [type]'s pages on [kind]: sliding there for the media on show, at
  /// once for another, before it shows.
  void _showPage(ItemType type, BrowseTabKind kind) {
    final pages = _pagesOf(type);
    if (!pages.hasClients) {
      // Never laid out: started over on the right page.
      pages.dispose();
      _pageControllers[type] = PageController(initialPage: kind.index);
      return;
    }
    if (pages.page?.round() == kind.index) return;
    final onShow = _tabList[_tabBarController.index].type == type;
    if (onShow) {
      pages.animateToPage(
        kind.index,
        duration: kTabScrollDuration,
        curve: Curves.ease,
      );
    } else {
      pages.jumpToPage(kind.index);
    }
  }

  List<Widget> _tabViews() => _tabList.map((tab) {
    if (tab.kind == BrowseTabKind.sources) {
      return SourcesScreen(
        itemType: tab.type,
        tabs: _tabList,
        tabIndex: (index) => _open(_tabList[index].type, _tabList[index].kind),
      );
    }
    return ExtensionScreen(
      query: _textEditingController.text,
      itemType: tab.type,
    );
  }).toList();

  // Android TV Browse: pill tabs (matching the home) + a top-bar focus ladder
  // (icons -> pills -> list) so nothing steals focus on Up. See #729.
  Widget _buildTvLayout(
    BuildContext context,
    BrowseTab currentTab,
    bool isExtensionTab,
    AppLocalizations l10n,
  ) {
    final horizontalInsets = tvOverscanHorizontalInsets(context);
    final tabLabels = [
      for (final tab in _tabList)
        tab.kind == BrowseTabKind.extensions
            ? tab.type.localizedExtensions(l10n)
            : tab.type.localizedSources(l10n),
    ];
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _tabList.length,
      child: Scaffold(
        // bottom: false so the inset reaches the tab views instead of being
        // consumed here. Each applies it to its own scroll padding, which lets
        // content pass under the translucent bar rather than stopping short of
        // it, and keeps the last row reachable either way.
        body: SafeArea(
          bottom: !FloatingNavigationScope.enabledOf(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: horizontalInsets.add(
                  const EdgeInsets.only(top: ShioriSpace.s8, bottom: 2),
                ),
                child: Row(
                  children: [
                    Text(
                      l10n.browse,
                      style: context.shiori.text.screenTitle.copyWith(
                        color: context.shiori.color.fg,
                      ),
                    ),
                    const Spacer(),
                    ..._actions(context, isExtensionTab, currentTab.type),
                  ],
                ),
              ),
              // Centred when they fit, horizontally scrollable when long
              // translations or a compact TV viewport need more room.
              Padding(
                padding: horizontalInsets.add(
                  const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
                ),
                child: TvBrowseTabStrip(
                  labels: tabLabels,
                  selectedIndex: _tabBarController.index,
                  onSelected: (index) {
                    _tabBarController.animateTo(index);
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: TvRowFocusScope(
                  notifier: _tvActiveRow,
                  child: TabBarView(
                    controller: _tabBarController,
                    children: _tabViews(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recompute the tab list live when "Anime only" or hidden media types
    // change; recreate the controller when the visible tabs change.
    final newTabs = _computeTabList(
      ref.watch(animeOnlyTvModeProvider),
      ref.watch(hideItemsStateProvider),
    );
    if (!listEquals(newTabs, _tabList)) {
      final selected = _tabList.isEmpty
          ? null
          : _tabList[_tabBarController.index];
      var initialIndex = selected == null ? -1 : newTabs.indexOf(selected);
      if (initialIndex < 0 && selected != null) {
        initialIndex = newTabs.indexWhere((t) => t.kind == selected.kind);
      }
      if (initialIndex < 0) initialIndex = 0;

      final visibleTypes = {for (final tab in newTabs) tab.type};
      _pageControllers.removeWhere((type, controller) {
        if (!visibleTypes.contains(type)) {
          controller.dispose();
          return true;
        }
        return false;
      });

      _tabList = newTabs;
      _tabBarController.removeListener(_onTabChanged);
      _tabBarController.dispose();
      _tabBarController = TabController(
        length: _tabList.length,
        initialIndex: _tabList.isEmpty ? 0 : initialIndex,
        vsync: this,
      );
      _tabBarController.addListener(_onTabChanged);
      if (_tabList.isNotEmpty) {
        final active = _tabList[_tabBarController.index];
        if (_kindController.index != active.kind.index) {
          _kindController.index = active.kind.index;
        }
        final pages = _pageControllers[active.type];
        if (pages != null &&
            pages.hasClients &&
            pages.page?.round() != active.kind.index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && pages.hasClients) {
              pages.jumpToPage(active.kind.index);
            }
          });
        }
      }
    }
    if (_tabList.isEmpty) {
      return SizedBox.shrink();
    }
    final currentTab = _tabList[_tabBarController.index];
    final isExtensionTab = currentTab.kind == BrowseTabKind.extensions;

    // Browse stays mounted between visits, so a request made while it is
    // already built (an empty library sending the user to its sources) is
    // taken here rather than only on the way in.
    ref.listen<BrowseTab?>(browseInitialTabProvider, (_, tab) {
      if (tab == null) return;
      _open(tab.type, tab.kind);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(browseInitialTabProvider.notifier).clear();
      });
      setState(() {});
    });
    final l10n = l10nLocalizations(context)!;
    if (isTv) {
      return _buildTvLayout(context, currentTab, isExtensionTab, l10n);
    }
    final types = [
      for (final tab in _tabList)
        if (tab.kind == BrowseTabKind.sources) tab.type,
    ];
    final tokens = context.shiori;
    final hasMediaSwitch = types.length > 1;
    final mediaIndex = types.contains(currentTab.type)
        ? types.indexOf(currentTab.type)
        : 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // A main destination's title, as Library, Activity and More set it.
        // Once the media switch scrolls away, it names the media instead.
        title: ValueListenableBuilder<bool>(
          valueListenable: _headerCollapsed,
          builder: (context, collapsed, _) => CollapsingTitle(
            collapsed && hasMediaSwitch
                ? currentTab.type.localized(l10n)
                : l10n.browse,
            style: tokens.text.screenTitle.copyWith(color: tokens.color.fg),
          ),
        ),
        actions: _actions(context, isExtensionTab, currentTab.type),
      ),
      // The switch and the tabs sit in the body, so the switch can fold
      // away while the list scrolls without resizing the app bar.
      body: CollapseOnScroll(
        collapsed: _headerCollapsed,
        child: Column(
          children: [
            // The media first, then what to browse for it: two tabs instead
            // of six.
            if (hasMediaSwitch)
              ValueListenableBuilder<bool>(
                valueListenable: _headerCollapsed,
                builder: (context, collapsed, child) =>
                    CollapsibleHeaderPart(collapsed: collapsed, child: child!),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ShioriSpace.s16,
                    ShioriSpace.s4,
                    ShioriSpace.s16,
                    ShioriSpace.s8,
                  ),
                  child: ShioriSegmentedControl<ItemType>(
                    // Another media's extension updates are counted on its
                    // segment; the current one's are on the Extensions tab.
                    segments: [
                      for (final type in types)
                        ShioriSegment(
                          value: type,
                          label: type.localized(l10n),
                          badge: type == currentTab.type
                              ? 0
                              : ref
                                        .watch(
                                          extensionUpdateCountProvider(type),
                                        )
                                        .asData
                                        ?.value ??
                                    0,
                        ),
                    ],
                    selected: currentTab.type,
                    onSelected: (type) => _open(type, currentTab.kind),
                  ),
                ),
              ),
            TabBar(
              controller: _kindController,
              onTap: (kind) =>
                  _open(currentTab.type, BrowseTabKind.values[kind]),
              tabs: [
                Tab(text: l10n.sources),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.extensions),
                      ExtensionUpdateNumbersBadge(itemType: currentTab.type),
                    ],
                  ),
                ),
              ],
            ),
            // Sources and Extensions of the media picked above, side by
            // side, so a swipe moves between them as a tap on their tabs
            // does.
            //
            // Each media's pair is mounted up front and kept, and switching
            // media fades through between them: rebuilding the lists on
            // every switch showed a loading frame first, a visible hitch.
            // Only the page on show of each is built (a PageView builds
            // the current page), so this loads each media's sources and
            // leaves its extensions until they are opened.
            //
            // A swipe past the last page opens the next media's Sources, and
            // past the first one the previous media's Extensions, as if the
            // pairs were one row of pages; the media slides along with it.
            Expanded(
              child: SideSwipeDetector(
                enabled: hasMediaSwitch,
                onNext: mediaIndex + 1 < types.length
                    ? () => _open(types[mediaIndex + 1], BrowseTabKind.sources)
                    : null,
                onPrevious: mediaIndex > 0
                    ? () =>
                          _open(types[mediaIndex - 1], BrowseTabKind.extensions)
                    : null,
                child: ShioriFadeThroughStack(
                  index: mediaIndex,
                  slideDirection: (from, to) => to - from,
                  children: [
                    for (final type in types)
                      PageView(
                        key: ValueKey(type),
                        controller: _pagesOf(type),
                        onPageChanged: (page) => _onPageSwiped(type, page),
                        children: [
                          for (final kind in BrowseTabKind.values)
                            KeyedSubtree(
                              key: ValueKey((type, kind)),
                              child:
                                  _tabViews()[_tabList.indexWhere(
                                    (t) => t.type == type && t.kind == kind,
                                  )],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final extensionUpdateCountProvider = StreamProvider.family<int, ItemType>((
  ref,
  itemType,
) {
  return sourceRepository
      .watchActiveByItemType(itemType)
      .map(
        (list) => list
            .where(
              (element) =>
                  (element.isAdded ?? false) &&
                  !(element.isObsolete ?? false) &&
                  compareVersions(
                        element.version ?? '',
                        element.versionLast ?? '',
                      ) <
                      0,
            )
            .length,
      );
});

class ExtensionUpdateNumbersBadge extends ConsumerWidget {
  final ItemType itemType;
  const ExtensionUpdateNumbersBadge({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(extensionUpdateCountProvider(itemType));
    return countAsync.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();
        // The gap lives here so a tab with no badge keeps no trailing space.
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: ShioriSpace.s8),
          child: EntryBadgeChip(
            label: count.toString(),
            tone: context.shiori.color.unread,
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

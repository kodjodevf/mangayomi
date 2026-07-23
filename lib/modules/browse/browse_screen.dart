import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
    with TickerProviderStateMixin {
  late final hideItems = ref.read(hideItemsStateProvider);
  final _textEditingController = TextEditingController();

  /// Which TV list row currently holds focus, so the rest of the list can
  /// fade back while one is active. Lives here so both the sources and the
  /// extensions tab share it.
  final _tvActiveRow = ValueNotifier<Object?>(null);
  late TabController _tabBarController;
  late List<BrowseTab> _tabList;

  // Hide manga & novel from Browse (sources + extensions) on the anime-only TV
  // layout so only anime shows. Recomputed live so toggling "Anime only" updates
  // the tabs without a restart. Defaults to isTv, user-overridable. See #729.
  List<BrowseTab> _computeTabList(bool animeOnly) => [
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.sources),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.sources),
    if (!animeOnly && !hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.extensions),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.extensions),
    if (!animeOnly && !hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.extensions),
  ];

  @override
  void initState() {
    super.initState();
    _tabList = _computeTabList(ref.read(animeOnlyTvModeProvider));
    _tabBarController = TabController(length: _tabList.length, vsync: this);
    _tabBarController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
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
    _tvActiveRow.dispose();
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
                if (isExtensionTab)
                  IconButton(
                    focusColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.4),
                    onPressed: () {
                      context.push('/createExtension');
                    },
                    icon: Icon(
                      Icons.add_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                IconButton(
                  splashRadius: 20,
                  focusColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.4),
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
                    !isExtensionTab
                        ? Icons.travel_explore_rounded
                        : Icons.search_rounded,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
      IconButton(
        splashRadius: 20,
        focusColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.4),
        onPressed: () {
          context.push(
            isExtensionTab ? '/ExtensionLang' : '/sourceFilter',
            extra: tabType,
          );
        },
        icon: Icon(
          !isExtensionTab ? Icons.filter_list_sharp : Icons.translate_rounded,
          color: Theme.of(context).hintColor,
        ),
      ),
    ];
  }

  List<Widget> _tabViews() => _tabList.map((tab) {
    if (tab.kind == BrowseTabKind.sources) {
      return SourcesScreen(
        itemType: tab.type,
        tabs: _tabList,
        tabIndex: (index) => _tabBarController.animateTo(index),
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
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _tabList.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 2),
                child: Row(
                  children: [
                    Text(
                      l10n.browse,
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    ..._actions(context, isExtensionTab, currentTab.type),
                  ],
                ),
              ),
              // Pills centred on screen, matching the home category filter.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _tabList.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        TvPill(
                          label: _tabList[i].kind == BrowseTabKind.extensions
                              ? _tabList[i].type.localizedExtensions(l10n)
                              : _tabList[i].type.localizedSources(l10n),
                          selected: i == _tabBarController.index,
                          onTap: () {
                            _tabBarController.animateTo(i);
                            setState(() {});
                          },
                        ),
                      ],
                    ],
                  ),
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
    // Recompute the tab list live when "Anime only" flips; recreate the
    // controller when the tab count changes.
    final newTabs = _computeTabList(ref.watch(animeOnlyTvModeProvider));
    if (newTabs.length != _tabList.length) {
      _tabList = newTabs;
      _tabBarController.removeListener(_onTabChanged);
      _tabBarController.dispose();
      _tabBarController = TabController(length: _tabList.length, vsync: this);
      _tabBarController.addListener(_onTabChanged);
    } else {
      _tabList = newTabs;
    }
    if (_tabList.isEmpty) {
      return SizedBox.shrink();
    }
    final currentTab = _tabList[_tabBarController.index];
    final isExtensionTab = currentTab.kind == BrowseTabKind.extensions;

    final l10n = l10nLocalizations(context)!;
    if (isTv) {
      return _buildTvLayout(context, currentTab, isExtensionTab, l10n);
    }
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _tabList.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            l10n.browse,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          actions: _actions(context, isExtensionTab, currentTab.type),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            controller: _tabBarController,
            tabs: _tabList.map((tab) {
              final type = tab.type;
              final isExt = tab.kind == BrowseTabKind.extensions;

              return Tab(
                child: Row(
                  children: [
                    Text(
                      isExt
                          ? type.localizedExtensions(l10n)
                          : type.localizedSources(l10n),
                    ),
                    if (isExt) ...[
                      const SizedBox(width: 8),
                      ExtensionUpdateNumbersBadge(itemType: type),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: _tabViews()),
      ),
    );
  }
}

final extensionUpdateCountProvider =
    StreamProvider.family<int, ItemType>((ref, itemType) {
  return isar.sources
      .filter()
      .idIsNotNull()
      .and()
      .isActiveEqualTo(true)
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true)
      .map((list) => list
          .where((element) =>
              compareVersions(element.version!, element.versionLast!) < 0)
          .length);
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
        return Badge(
          backgroundColor: Theme.of(context).focusColor,
          label: Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        );
      },
      error: (error, stackTrace) => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
    );
  }
}

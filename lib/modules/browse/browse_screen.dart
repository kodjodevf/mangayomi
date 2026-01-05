import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

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
  late TabController _tabBarController;

  late final List<BrowseTab> _tabList = [
    if (!hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.sources),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.sources),
    if (!hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.sources),

    if (!hideItems.contains("/MangaLibrary"))
      BrowseTab(ItemType.manga, BrowseTabKind.extensions),
    if (!hideItems.contains("/AnimeLibrary"))
      BrowseTab(ItemType.anime, BrowseTabKind.extensions),
    if (!hideItems.contains("/NovelLibrary"))
      BrowseTab(ItemType.novel, BrowseTabKind.extensions),
  ];

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: _tabList.length, vsync: this);
    _tabBarController.addListener(() {
      _chekPermission();
      setState(() {
        _textEditingController.clear();
        _isSearch = false;
      });
    });
  }

  Future<void> _chekPermission() async {
    await StorageProvider().requestPermission();
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
    if (_tabList.isEmpty) {
      return SizedBox.shrink();
    }
    final currentTab = _tabList[_tabBarController.index];
    final isExtensionTab = currentTab.kind == BrowseTabKind.extensions;

    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            l10n.browse,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          actions: [
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
                    children: [
                      if (isExtensionTab)
                        IconButton(
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
                        onPressed: () {
                          if (isExtensionTab) {
                            setState(() {
                              _isSearch = true;
                            });
                          } else {
                            context.push(
                              '/globalSearch',
                              extra: (null, currentTab.type),
                            );
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
              onPressed: () {
                context.push(
                  isExtensionTab ? '/ExtensionLang' : '/sourceFilter',
                  extra: currentTab.type,
                );
              },
              icon: Icon(
                !isExtensionTab
                    ? Icons.filter_list_sharp
                    : Icons.translate_rounded,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
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
                      _extensionUpdateNumbers(ref, type),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabBarController,
          children: _tabList.map((tab) {
            if (tab.kind == BrowseTabKind.sources) {
              return SourcesScreen(
                itemType: tab.type,
                tabs: _tabList,
                tabIndex: (index) => _tabBarController.animateTo(index),
              );
            } else {
              return ExtensionScreen(
                query: _textEditingController.text,
                itemType: tab.type,
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}

Widget _extensionUpdateNumbers(WidgetRef ref, ItemType itemType) {
  return StreamBuilder(
    stream: isar.sources
        .filter()
        .idIsNotNull()
        .and()
        .isActiveEqualTo(true)
        .itemTypeEqualTo(itemType)
        .watch(fireImmediately: true),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final entries = snapshot.data!
            .where(
              (element) =>
                  compareVersions(element.version!, element.versionLast!) < 0,
            )
            .toList();
        return entries.isEmpty
            ? SizedBox.shrink()
            : Badge(
                backgroundColor: Theme.of(context).focusColor,
                label: Text(
                  entries.length.toString(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              );
      }
      return Container();
    },
  );
}

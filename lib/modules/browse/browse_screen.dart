import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
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

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
    with TickerProviderStateMixin {
  late final hideItems = ref.read(hideItemsStateProvider);
  final _textEditingController = TextEditingController();
  late TabController _tabBarController;

  late final _tabList = [
    if (!hideItems.contains("/MangaLibrary")) 'manga',
    if (!hideItems.contains("/AnimeLibrary")) 'anime',
    if (!hideItems.contains("/NovelLibrary")) 'novel',
    if (!hideItems.contains("/MangaLibrary")) 'mangaExtension',
    if (!hideItems.contains("/AnimeLibrary")) 'animeExtension',
    if (!hideItems.contains("/NovelLibrary")) 'novelExtension',
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

  _chekPermission() async {
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
    final containsExtensionTab = [
      "mangaExtension",
      "animeExtension",
      "novelExtension",
    ].any((element) => _tabList[_tabBarController.index] == element);

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
                      if (_tabBarController.index == 3 ||
                          _tabBarController.index == 4 ||
                          _tabBarController.index == 5)
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
                          if (containsExtensionTab) {
                            setState(() {
                              _isSearch = true;
                            });
                          } else {
                            context.push(
                              '/globalSearch',
                              extra: (
                                null,
                                switch (_tabList[_tabBarController.index]) {
                                  "manga" => ItemType.manga,
                                  "anime" => ItemType.anime,
                                  _ => ItemType.novel,
                                },
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          !containsExtensionTab
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
                  containsExtensionTab ? '/ExtensionLang' : '/sourceFilter',
                  extra: switch (_tabList[_tabBarController.index]) {
                    "manga" || "mangaExtension" => ItemType.manga,
                    "anime" || "animeExtension" => ItemType.anime,
                    _ => ItemType.novel,
                  },
                );
              },
              icon: Icon(
                !containsExtensionTab
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
            tabs: [
              if (!hideItems.contains("/MangaLibrary"))
                Tab(text: l10n.manga_sources),
              if (!hideItems.contains("/AnimeLibrary"))
                Tab(text: l10n.anime_sources),
              if (!hideItems.contains("/NovelLibrary"))
                Tab(text: l10n.novel_sources),
              if (!hideItems.contains("/MangaLibrary"))
                Tab(
                  child: Row(
                    children: [
                      Text(l10n.manga_extensions),
                      const SizedBox(width: 8),
                      _extensionUpdateNumbers(ref, ItemType.manga),
                    ],
                  ),
                ),
              if (!hideItems.contains("/AnimeLibrary"))
                Tab(
                  child: Row(
                    children: [
                      Text(l10n.anime_extensions),
                      const SizedBox(width: 8),
                      _extensionUpdateNumbers(ref, ItemType.anime),
                    ],
                  ),
                ),
              if (!hideItems.contains("/NovelLibrary"))
                Tab(
                  child: Row(
                    children: [
                      Text(l10n.novel_extensions),
                      const SizedBox(width: 8),
                      _extensionUpdateNumbers(ref, ItemType.novel),
                    ],
                  ),
                ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabBarController,
          children: [
            if (!hideItems.contains("/MangaLibrary"))
              SourcesScreen(
                itemType: ItemType.manga,
                tabIndex: (index) {
                  _tabBarController.animateTo(index);
                },
              ),
            if (!hideItems.contains("/AnimeLibrary"))
              SourcesScreen(
                itemType: ItemType.anime,
                tabIndex: (index) {
                  _tabBarController.animateTo(index);
                },
              ),
            if (!hideItems.contains("/NovelLibrary"))
              SourcesScreen(
                itemType: ItemType.novel,
                tabIndex: (index) {
                  _tabBarController.animateTo(index);
                },
              ),
            if (!hideItems.contains("/MangaLibrary"))
              ExtensionScreen(
                query: _textEditingController.text,
                itemType: ItemType.manga,
              ),
            if (!hideItems.contains("/AnimeLibrary"))
              ExtensionScreen(
                query: _textEditingController.text,
                itemType: ItemType.anime,
              ),
            if (!hideItems.contains("/NovelLibrary"))
              ExtensionScreen(
                query: _textEditingController.text,
                itemType: ItemType.novel,
              ),
          ],
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

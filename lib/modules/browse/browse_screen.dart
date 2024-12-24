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
  late final hideManga = ref.watch(hideMangaStateProvider);
  late final hideAnime = ref.watch(hideAnimeStateProvider);
  late final hideNovel = ref.watch(hideNovelStateProvider);
  late TabController _tabBarController;

  late final _tabList = [
    if (!hideManga) 'manga',
    if (!hideAnime) 'anime',
    if (!hideNovel) 'novel',
    if (!hideManga) 'mangaExtension',
    if (!hideAnime) 'animeExtension',
    if (!hideNovel) 'novelExtension',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tabBarController = TabController(length: _tabList.length, vsync: this);
    _tabBarController.animateTo(0);
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

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
    if (_tabList.isEmpty) {
      return SizedBox.shrink();
    }
    final containsExtensionTab = [
      "mangaExtension",
      "animeExtension",
      "novelExtension"
    ].any((element) => _tabList[_tabBarController.index] == element);

    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(l10n.browse,
              style: TextStyle(color: Theme.of(context).hintColor)),
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
                            icon: Icon(Icons.add_outlined,
                                color: Theme.of(context).hintColor)),
                      IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            if (containsExtensionTab) {
                              setState(() {
                                _isSearch = true;
                              });
                            } else {
                              context.push('/globalSearch',
                                  extra: switch (
                                      _tabList[_tabBarController.index]) {
                                    "manga" => ItemType.manga,
                                    "anime" => ItemType.anime,
                                    _ => ItemType.novel,
                                  });
                            }
                          },
                          icon: Icon(
                              !containsExtensionTab
                                  ? Icons.travel_explore_rounded
                                  : Icons.search_rounded,
                              color: Theme.of(context).hintColor)),
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
                      });
                },
                icon: Icon(
                    !containsExtensionTab
                        ? Icons.filter_list_sharp
                        : Icons.translate_rounded,
                    color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              controller: _tabBarController,
              tabs: [
                if (!hideManga) Tab(text: l10n.manga_sources),
                if (!hideAnime) Tab(text: l10n.anime_sources),
                if (!hideNovel) Tab(text: l10n.novel_sources),
                if (!hideManga)
                  Tab(
                    child: Row(
                      children: [
                        Text(l10n.manga_extensions),
                        const SizedBox(width: 8),
                        _extensionUpdateNumbers(ref, ItemType.manga)
                      ],
                    ),
                  ),
                if (!hideAnime)
                  Tab(
                    child: Row(
                      children: [
                        Text(l10n.anime_extensions),
                        const SizedBox(width: 8),
                        _extensionUpdateNumbers(ref, ItemType.anime)
                      ],
                    ),
                  ),
                if (!hideNovel)
                  Tab(
                    child: Row(
                      children: [
                        Text(l10n.novel_extensions),
                        const SizedBox(width: 8),
                        _extensionUpdateNumbers(ref, ItemType.novel)
                      ],
                    ),
                  ),
              ]),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          if (!hideManga)
            SourcesScreen(
              itemType: ItemType.manga,
              tabIndex: (index) {
                _tabBarController.animateTo(index);
              },
            ),
          if (!hideAnime)
            SourcesScreen(
              itemType: ItemType.anime,
              tabIndex: (index) {
                _tabBarController.animateTo(index);
              },
            ),
          if (!hideNovel)
            SourcesScreen(
              itemType: ItemType.novel,
              tabIndex: (index) {
                _tabBarController.animateTo(index);
              },
            ),
          if (!hideManga)
            ExtensionScreen(
                query: _textEditingController.text, itemType: ItemType.manga),
          if (!hideAnime)
            ExtensionScreen(
                query: _textEditingController.text, itemType: ItemType.anime),
          if (!hideNovel)
            ExtensionScreen(
                query: _textEditingController.text, itemType: ItemType.novel),
        ]),
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
              .where((element) =>
                  compareVersions(element.version!, element.versionLast!) < 0)
              .toList();
          return entries.isEmpty
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).focusColor),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      entries.length.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall!.color),
                    ),
                  ),
                );
        }
        return Container();
      });
}

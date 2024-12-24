import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
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
  late TabController _tabBarController;

  @override
  void initState() {
    _tabBarController = TabController(length: 6, vsync: this);
    _tabBarController.animateTo(0);
    _tabBarController.addListener(() {
      _chekPermission();
      setState(() {
        _textEditingController.clear();
        _isSearch = false;
      });
    });
    super.initState();
  }

  _chekPermission() async {
    await StorageProvider().requestPermission();
  }

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
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
                            icon: Icon(Icons.add_outlined,
                                color: Theme.of(context).hintColor)),
                      _tabBarController.index != 4
                          ? IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                if (_tabBarController.index != 0 &&
                                    _tabBarController.index != 1 &&
                                    _tabBarController.index != 2) {
                                  setState(() {
                                    _isSearch = true;
                                  });
                                } else {
                                  context.push('/globalSearch',
                                      extra: _tabBarController.index == 0
                                          ? ItemType.manga
                                          : ItemType.anime);
                                }
                              },
                              icon: Icon(
                                  _tabBarController.index == 0 ||
                                          _tabBarController.index == 1 ||
                                          _tabBarController.index == 2
                                      ? Icons.travel_explore_rounded
                                      : Icons.search_rounded,
                                  color: Theme.of(context).hintColor))
                          : Container(),
                    ],
                  ),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (_tabBarController.index == 0) {
                    context.push('/sourceFilter', extra: ItemType.manga);
                  } else if (_tabBarController.index == 1) {
                    context.push('/sourceFilter', extra: ItemType.anime);
                  } else if (_tabBarController.index == 2) {
                    context.push('/sourceFilter', extra: ItemType.anime);
                  } else if (_tabBarController.index == 3) {
                    _textEditingController.clear();
                    context.push('/ExtensionLang', extra: ItemType.anime);
                  } else if (_tabBarController.index == 4) {
                    _textEditingController.clear();
                    context.push('/ExtensionLang', extra: ItemType.anime);
                  } else if (_tabBarController.index == 5) {
                    _textEditingController.clear();
                    context.push('/ExtensionLang', extra: ItemType.anime);
                  } else {}
                },
                icon: Icon(
                    _tabBarController.index == 0 ||
                            _tabBarController.index == 1 ||
                            _tabBarController.index == 2
                        ? Icons.filter_list_sharp
                        : _tabBarController.index == 3 ||
                                _tabBarController.index == 4 ||
                                _tabBarController.index == 5
                            ? Icons.translate_rounded
                            : Icons.help_outline_outlined,
                    color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            controller: _tabBarController,
            tabs: [
              Tab(text: l10n.manga_sources),
              Tab(text: l10n.anime_sources),
              Tab(text: l10n.novel_sources),
              Tab(
                child: Row(
                  children: [
                    Text(l10n.manga_extensions),
                    const SizedBox(width: 8),
                    _extensionUpdateNumbers(ref, ItemType.manga)
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Text(l10n.anime_extensions),
                    const SizedBox(width: 8),
                    _extensionUpdateNumbers(ref, ItemType.anime)
                  ],
                ),
              ),
              Tab(
                child: Row(
                  children: [
                    Text(l10n.novel_extensions),
                    const SizedBox(width: 8),
                    _extensionUpdateNumbers(ref, ItemType.novel)
                  ],
                ),
              ),
              // Tab(text: l10n.migrate),
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          SourcesScreen(
            itemType: ItemType.manga,
            tabIndex: (index) {
              _tabBarController.animateTo(index);
            },
          ),
          SourcesScreen(
            itemType: ItemType.anime,
            tabIndex: (index) {
              _tabBarController.animateTo(index);
            },
          ),
          SourcesScreen(
            itemType: ItemType.novel,
            tabIndex: (index) {
              _tabBarController.animateTo(index);
            },
          ),
          ExtensionScreen(
            query: _textEditingController.text,
            itemType: ItemType.manga,
          ),
          ExtensionScreen(
            query: _textEditingController.text,
            itemType: ItemType.anime,
          ),
          ExtensionScreen(
            query: _textEditingController.text,
            itemType: ItemType.novel,
          ),
          // const MigrateScreen()
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

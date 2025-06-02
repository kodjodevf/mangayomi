import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';

import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen>
    with TickerProviderStateMixin {
  late TabController _tabBarController;
  bool _isLoading = false;
  int tabs = 3;
  Future<void> _updateLibrary() async {
    setState(() {
      _isLoading = true;
    });
    bool isDark = ref.read(themeModeStateProvider);
    botToast(
      context.l10n.updating_library("0", "0", "0"),
      fontSize: 13,
      second: 30,
      alignY: !context.isTablet ? 0.85 : 1,
      themeDark: isDark,
    );
    final mangaList = isar.mangas
        .filter()
        .idIsNotNull()
        .favoriteEqualTo(true)
        .and()
        .itemTypeEqualTo(
          _tabBarController.index == 0
              ? ItemType.manga
              : _tabBarController.index == 1
              ? ItemType.anime
              : ItemType.novel,
        )
        .and()
        .isLocalArchiveEqualTo(false)
        .findAllSync();
    int numbers = 0;
    int failed = 0;

    for (var manga in mangaList) {
      try {
        await ref.read(
          updateMangaDetailProvider(
            mangaId: manga.id,
            isInit: false,
            showToast: false,
          ).future,
        );
      } catch (_) {
        failed++;
      }
      numbers++;
      if (mounted) {
        botToast(
          context.l10n.updating_library(numbers, failed, mangaList.length),
          fontSize: 13,
          second: 10,
          alignY: !context.isTablet ? 0.85 : 1,
          animationDuration: 0,
          dismissDirections: [DismissDirection.none],
          onlyOne: false,
          themeDark: isDark,
        );
      }
    }
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mangaList.length == numbers) {
        return false;
      }
      return true;
    });
    BotToast.cleanAll();
    setState(() {
      _isLoading = false;
    });
  }

  void tabListener() {
    setState(() {
      _textEditingController.clear();
      _isSearch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: tabs, vsync: this);
    _tabBarController.animateTo(0);
    _tabBarController.addListener(tabListener);
  }

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  List<History> entriesData = [];
  @override
  Widget build(BuildContext context) {
    int newTabs = 0;
    final hideItems = ref.watch(hideItemsStateProvider);
    if (!hideItems.contains("/MangaLibrary")) newTabs++;
    if (!hideItems.contains("/AnimeLibrary")) newTabs++;
    if (!hideItems.contains("/NovelLibrary")) newTabs++;
    if (newTabs == 0) {
      return SizedBox.shrink();
    }
    if (tabs != newTabs) {
      _tabBarController.removeListener(tabListener);
      _tabBarController.dispose();
      _tabBarController = TabController(length: newTabs, vsync: this);
      _tabBarController.animateTo(0);
      _tabBarController.addListener(tabListener);
      setState(() {
        tabs = newTabs;
      });
    }
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: newTabs,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _isSearch
              ? null
              : Text(
                  l10n.updates,
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
                : IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      setState(() {
                        _isSearch = true;
                      });
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                _updateLibrary();
              },
              icon: Icon(
                Icons.refresh_outlined,
                color: Theme.of(context).hintColor,
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(l10n.remove_everything),
                      content: Text(l10n.remove_all_update_msg),
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
                            TextButton(
                              onPressed: () => clearUpdates(hideItems, context),
                              child: Text(l10n.ok),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete_sweep_outlined,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: [
              if (!hideItems.contains("/MangaLibrary"))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tab(text: l10n.manga),
                    const SizedBox(width: 8),
                    _updateNumbers(ref, ItemType.manga),
                  ],
                ),
              if (!hideItems.contains("/AnimeLibrary"))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tab(text: l10n.anime),
                    const SizedBox(width: 8),
                    _updateNumbers(ref, ItemType.anime),
                  ],
                ),
              if (!hideItems.contains("/NovelLibrary"))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tab(text: l10n.novel),
                    const SizedBox(width: 8),
                    _updateNumbers(ref, ItemType.novel),
                  ],
                ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            controller: _tabBarController,
            children: [
              if (!hideItems.contains("/MangaLibrary"))
                UpdateTab(
                  itemType: ItemType.manga,
                  query: _textEditingController.text,
                  isLoading: _isLoading,
                ),
              if (!hideItems.contains("/AnimeLibrary"))
                UpdateTab(
                  itemType: ItemType.anime,
                  query: _textEditingController.text,
                  isLoading: _isLoading,
                ),
              if (!hideItems.contains("/NovelLibrary"))
                UpdateTab(
                  itemType: ItemType.novel,
                  query: _textEditingController.text,
                  isLoading: _isLoading,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void clearUpdates(List<String> hideItems, BuildContext context) {
    List<Update> updates = isar.updates
        .filter()
        .idIsNotNull()
        .chapter(
          (q) =>
              q.manga((q) => q.itemTypeEqualTo(getCurrentItemType(hideItems))),
        )
        .findAllSync()
        .toList();
    isar.writeTxnSync(() {
      for (var update in updates) {
        isar.updates.deleteSync(update.id!);
      }
    });
    if (mounted) {
      Navigator.pop(context);
    }
  }

  ItemType getCurrentItemType(List<String> hideItems) {
    return _tabBarController.index == 0 && !hideItems.contains("/MangaLibrary")
        ? ItemType.manga
        : _tabBarController.index ==
                  1 - (hideItems.contains("/MangaLibrary") ? 1 : 0) &&
              !hideItems.contains("/AnimeLibrary")
        ? ItemType.anime
        : ItemType.novel;
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  final bool isLoading;
  const UpdateTab({
    required this.itemType,
    required this.query,
    required this.isLoading,
    super.key,
  });

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final update = ref.watch(
      getAllUpdateStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          update.when(
            data: (entries) {
              final lastUpdatedList = entries
                  .map((e) => e.chapter.value!.manga.value!.lastUpdate!)
                  .toList();
              lastUpdatedList.sort((a, b) => b.compareTo(a));
              final lastUpdated = lastUpdatedList.firstOrNull;
              if (entries.isNotEmpty) {
                return CustomScrollView(
                  slivers: [
                    if (lastUpdated != null)
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          top: 10,
                          bottom: 20,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate.fixed([
                            Text(
                              l10n.library_last_updated(
                                dateFormat(
                                  lastUpdated.toString(),
                                  ref: ref,
                                  context: context,
                                  showHOURorMINUTE: true,
                                ),
                              ),
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: context.secondaryColor,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    CustomSliverGroupedListView<Update, String>(
                      elements: entries,
                      groupBy: (element) => dateFormat(
                        element.date!,
                        context: context,
                        ref: ref,
                        forHistoryValue: true,
                        useRelativeTimesTamps: false,
                      ),
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 12),
                        child: Row(
                          children: [
                            Text(
                              dateFormat(
                                null,
                                context: context,
                                stringDate: groupByValue,
                                ref: ref,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, element) {
                        final chapter = element.chapter.value!;
                        return UpdateChapterListTileWidget(
                          chapter: chapter,
                          sourceExist: true,
                        );
                      },
                      itemComparator: (item1, item2) =>
                          item1.date!.compareTo(item2.date!),
                      order: GroupedListOrder.DESC,
                    ),
                  ],
                );
              }
              return Center(child: Text(l10n.no_recent_updates));
            },
            error: (Object error, StackTrace stackTrace) {
              return ErrorText(error);
            },
            loading: () {
              return const ProgressCenter();
            },
          ),
          if (widget.isLoading)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: RefreshProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _updateNumbers(WidgetRef ref, ItemType itemType) {
  return StreamBuilder(
    stream: isar.updates
        .filter()
        .idIsNotNull()
        .and()
        .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
        .watch(fireImmediately: true),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final entries = snapshot.data!.toList();
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

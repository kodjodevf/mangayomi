import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with TickerProviderStateMixin {
  final _textEditingController = TextEditingController();
  late TabController _tabBarController;
  int tabs = 3;

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

  @override
  void dispose() {
    _tabBarController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

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
                  l10n.history,
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
                      Icons.search,
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
                      content: Text(l10n.remove_everything_msg),
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
                              onPressed: () => clearHistory(hideItems),
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
              if (!hideItems.contains("/MangaLibrary")) Tab(text: l10n.manga),
              if (!hideItems.contains("/AnimeLibrary")) Tab(text: l10n.anime),
              if (!hideItems.contains("/NovelLibrary")) Tab(text: l10n.novel),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            controller: _tabBarController,
            children: [
              if (!hideItems.contains("/MangaLibrary"))
                HistoryTab(
                  itemType: ItemType.manga,
                  query: _textEditingController.text,
                ),
              if (!hideItems.contains("/AnimeLibrary"))
                HistoryTab(
                  itemType: ItemType.anime,
                  query: _textEditingController.text,
                ),
              if (!hideItems.contains("/NovelLibrary"))
                HistoryTab(
                  itemType: ItemType.novel,
                  query: _textEditingController.text,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void clearHistory(List<String> hideItems) {
    List<History> histories = isar.historys
        .filter()
        .idIsNotNull()
        .chapter(
          (q) =>
              q.manga((q) => q.itemTypeEqualTo(getCurrentItemType(hideItems))),
        )
        .findAllSync()
        .toList();
    isar.writeTxnSync(() {
      for (var history in histories) {
        isar.historys.deleteSync(history.id!);
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

class HistoryTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  const HistoryTab({required this.itemType, required this.query, super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final history = ref.watch(
      getAllHistoryStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );
    return Scaffold(
      body: history.when(
        data: (entries) {
          if (entries.isNotEmpty) {
            return CustomScrollView(
              slivers: [
                CustomSliverGroupedListView<History, String>(
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
                  itemBuilder: (context, History element) {
                    final manga = element.chapter.value!.manga.value!;
                    final chapter = element.chapter.value!;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        await chapter.pushToReaderView(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          height: 105,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 90,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.push(
                                      '/manga-reader/detail',
                                      extra: manga.id,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: getCoverImage(manga),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                manga.name!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge!.color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.end,
                                                children: [
                                                  Text(
                                                    chapter.name!,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color,
                                                    ),
                                                  ),
                                                  Text(
                                                    " - ${dateFormatHour(element.date!, context)}",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!
                                                          .color,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => openDeleteDialog(
                                        l10n,
                                        manga,
                                        element.id,
                                      ),
                                      icon: Icon(
                                        Icons.delete_outline,
                                        size: 25,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge!.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemComparator: (item1, item2) =>
                      item1.date!.compareTo(item2.date!),
                  order: GroupedListOrder.DESC,
                ),
              ],
            );
          }
          return Center(child: Text(l10n.nothing_read_recently));
        },
        error: (Object error, StackTrace stackTrace) {
          return ErrorText(error);
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
    );
  }

  Widget getCoverImage(Manga manga) {
    return manga.customCoverImage != null
        ? Image.memory(manga.customCoverImage as Uint8List)
        : cachedCompressedNetworkImage(
            headers: ref.watch(
              headersProvider(source: manga.source!, lang: manga.lang!),
            ),
            imageUrl: toImgUrl(
              manga.customCoverFromTracker ?? manga.imageUrl ?? "",
            ),
            width: 60,
            height: 90,
            fit: BoxFit.cover,
          );
  }

  void openDeleteDialog(AppLocalizations l10n, Manga manga, int? deleteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.remove),
          content: Text(l10n.remove_history_msg),
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
                  onPressed: () async => deleteManga(context, manga, deleteId),
                  child: Text(l10n.remove),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteManga(
    BuildContext context,
    Manga manga,
    int? deleteId,
  ) async {
    await manga.chapters.load();
    final chapters = manga.chapters;
    await isar.writeTxn(() async {
      await isar.historys.delete(deleteId!);
      for (var chapter in chapters) {
        await isar.chapters.delete(chapter.id!);
        await ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPartAsync(
              ActionType.removeChapter,
              chapter.id,
              "{}",
              false,
            );
      }
      await isar.mangas.delete(manga.id!);
      await ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPartAsync(ActionType.removeHistory, deleteId, "{}", false);
      await ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPartAsync(ActionType.removeItem, manga.id, "{}", false);
    });
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}

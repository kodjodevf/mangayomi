import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/feed.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/feed/widgets/feed_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with TickerProviderStateMixin {
  late TabController _tabBarController;

  @override
  void initState() {
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.animateTo(0);
    _tabBarController.addListener(() {
      setState(() {
        _textEditingController.clear();
        _isSearch = false;
      });
    });
    super.initState();
  }

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  List<History> entriesData = [];
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _isSearch
              ? null
              : Text(
                  l10n.feed,
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
                    icon:
                        Icon(Icons.search, color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            l10n.remove_everything,
                          ),
                          content: Text(l10n.remove_all_feed_msg),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(l10n.cancel)),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      List<Feed> feeds = isar.feeds
                                          .filter()
                                          .idIsNotNull()
                                          .chapter((q) => q.manga((q) =>
                                              q.isMangaEqualTo(
                                                  _tabBarController.index ==
                                                      0)))
                                          .findAllSync()
                                          .toList();
                                      isar.writeTxnSync(() {
                                        for (var feed in feeds) {
                                          isar.feeds.deleteSync(feed.id!);
                                        }
                                      });
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(l10n.ok)),
                              ],
                            )
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete_sweep_outlined,
                    color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: [
              Tab(text: l10n.manga),
              Tab(text: l10n.anime),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(controller: _tabBarController, children: [
            FeedTab(
              isManga: true,
              query: _textEditingController.text,
            ),
            FeedTab(
              isManga: false,
              query: _textEditingController.text,
            )
          ]),
        ),
      ),
    );
  }
}

class FeedTab extends ConsumerStatefulWidget {
  final String query;
  final bool isManga;
  const FeedTab({required this.isManga, required this.query, super.key});

  @override
  ConsumerState<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends ConsumerState<FeedTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final feed = ref.watch(getAllFeedStreamProvider(isManga: widget.isManga));
    return Scaffold(
        body: feed.when(
      data: (data) {
        final entries = data
            .where((element) => widget.query.isNotEmpty
                ? element.chapter.value!.manga.value!.name!
                    .toLowerCase()
                    .contains(widget.query.toLowerCase())
                : true)
            .toList();
        final lastUpdatedList =
            data.map((e) => e.chapter.value!.manga.value!.lastUpdate!).toList();
        lastUpdatedList.sort((a, b) => a.compareTo(b));
        final lastUpdated = lastUpdatedList.firstOrNull;
        if (entries.isNotEmpty) {
          return CustomScrollView(
            slivers: [
              if (lastUpdated != null)
                SliverPadding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 20),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate.fixed([
                    Text(
                        l10n.library_last_updated(dateFormat(
                            lastUpdated.toString(),
                            ref: ref,
                            context: context,
                            showHOURorMINUTE: true)),
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: context.secondaryColor))
                  ])),
                ),
              SliverGroupedListView<Feed, String>(
                elements: entries,
                groupBy: (element) => dateFormat(element.date!,
                    context: context,
                    ref: ref,
                    forHistoryValue: true,
                    useRelativeTimesTamps: false),
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 12),
                  child: Row(
                    children: [
                      Text(dateFormat(
                        null,
                        context: context,
                        stringDate: groupByValue,
                        ref: ref,
                      )),
                    ],
                  ),
                ),
                itemBuilder: (context, Feed element) {
                  final chapter = element.chapter.value!;
                  return FeedChapterListTileWidget(
                      chapter: chapter, sourceExist: true);
                },
                itemComparator: (item1, item2) =>
                    item1.date!.compareTo(item2.date!),
                order: GroupedListOrder.DESC,
              ),
            ],
          );
        }
        return Center(
          child: Text(l10n.no_recent_updates),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    ));
  }
}

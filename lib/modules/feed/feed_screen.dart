import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/feed.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

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
    final feed =
        ref.watch(getAllFeedStreamProvider(isManga: widget.isManga));
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

        if (entries.isNotEmpty) {
          return CustomScrollView(
            slivers: [
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
                  final manga = element.chapter.value!.manga.value!;
                  final chapter = element.chapter.value!;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        elevation: 0,
                        shadowColor: Colors.transparent),
                    onPressed: () {
                      chapter.pushToReaderView(context);
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
                                      borderRadius: BorderRadius.circular(7)),
                                ),
                                onPressed: () {
                                  context.push('/manga-reader/detail',
                                      extra: manga.id);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: manga.customCoverImage != null
                                      ? Image.memory(
                                          manga.customCoverImage as Uint8List)
                                      : cachedNetworkImage(
                                          headers: ref.watch(headersProvider(
                                              source: manga.source!,
                                              lang: manga.lang!)),
                                          imageUrl: toImgUrl(
                                              manga.customCoverFromTracker ??
                                                  manga.imageUrl ??
                                                  ""),
                                          width: 60,
                                          height: 90,
                                          fit: BoxFit.cover),
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
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color,
                                                  fontWeight: FontWeight.bold),
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
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
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
        return Center(
          child: Text(l10n.nothing_read_recently),
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

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
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
                          content: Text(l10n.remove_everything_msg),
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
                                      List<History> histories = isar.historys
                                          .filter()
                                          .idIsNotNull()
                                          .chapter((q) => q.manga((q) =>
                                              q.isMangaEqualTo(
                                                  _tabBarController.index ==
                                                      0)))
                                          .findAllSync()
                                          .toList();
                                      isar.writeTxnSync(() {
                                        // _tabBarController.index != 1

                                        for (var history in histories) {
                                          isar.historys.deleteSync(history.id!);
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
            HistoryTab(
              isManga: true,
              query: _textEditingController.text,
            ),
            HistoryTab(
              isManga: false,
              query: _textEditingController.text,
            )
          ]),
        ),
      ),
    );
  }
}

class HistoryTab extends ConsumerStatefulWidget {
  final String query;
  final bool isManga;
  const HistoryTab({required this.isManga, required this.query, super.key});

  @override
  ConsumerState<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends ConsumerState<HistoryTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final history =
        ref.watch(getAllHistoryStreamProvider(isManga: widget.isManga));
    return Scaffold(
        body: history.when(
      data: (data) {
        final entries = data
            .where((element) => widget.query.isNotEmpty
                ? element.chapter.value!.manga.value!.name!
                    .toLowerCase()
                    .contains(widget.query.toLowerCase())
                : true)
            .toList();

        if (entries.isNotEmpty) {
          return GroupedListView<History, String>(
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
            itemBuilder: (context, History element) {
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
                  pushMangaReaderView(context: context, chapter: chapter);
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
                                      imageUrl: manga.imageUrl!,
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
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              l10n.remove,
                                            ),
                                            content:
                                                Text(l10n.remove_history_msg),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
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
                                                      onPressed: () async {
                                                        await isar
                                                            .writeTxn(() async {
                                                          await isar.historys
                                                              .delete(
                                                                  element.id!);
                                                        });
                                                        if (mounted) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Text(l10n.remove)),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 25,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  )),
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

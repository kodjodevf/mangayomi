import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  List<MangaHistoryModel> entriesData = [];
  List<MangaHistoryModel> entriesFilter = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: _isSearch
            ? null
            : Text(
                'History',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
        actions: [
          _isSearch
              ? SeachFormTextField(
                  onChanged: (value) {
                    log(value.toString());
                    setState(() {
                      entriesFilter = entriesData
                          .where((element) => element.modelManga.name!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
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
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.delete_sweep_outlined,
                  color: Theme.of(context).hintColor)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ValueListenableBuilder<Box<MangaHistoryModel>>(
          valueListenable: ref.watch(hiveBoxMangaHistory).listenable(),
          builder: (context, value, child) {
            final entries = value.values.toList();
            final entriesHistory = _textEditingController.text.isNotEmpty
                ? entriesFilter
                : entries;
            if (entries.isNotEmpty) {
              return GroupedListView<MangaHistoryModel, String>(
                elements: entriesHistory,
                groupBy: (element) => element.date.substring(0, 10),
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(dateFormat(DateTime.parse(groupByValue))),
                    ],
                  ),
                ),
                itemBuilder: (context, MangaHistoryModel element) {
                  return SizedBox(
                    height: 105,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 90,
                          child: GestureDetector(
                            onTap: () {
                              final model = ModelManga(
                                  status: element.modelManga.status,
                                  imageUrl: element.modelManga.imageUrl,
                                  name: element.modelManga.name,
                                  genre: element.modelManga.genre,
                                  author: element.modelManga.author,
                                  chapterDate: element.modelManga.chapterDate,
                                  chapterTitle: element.modelManga.chapterTitle,
                                  chapterUrl: element.modelManga.chapterUrl,
                                  description: element.modelManga.description,
                                  favorite: element.modelManga.favorite,
                                  link: element.modelManga.link,
                                  source: element.modelManga.source,
                                  lang: element.modelManga.lang);

                              context.push('/manga-reader/detail',
                                  extra: model);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: cachedNetworkImage(
                                  imageUrl: element.modelManga.imageUrl!,
                                  width: 60,
                                  height: 90,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Flexible(
                          child: ValueListenableBuilder<Box>(
                            valueListenable:
                                ref.watch(hiveBoxMangaInfo).listenable(),
                            builder: (context, value, child) {
                              final values = value.get(
                                  "${element.modelManga.source}/${element.modelManga.name}-chapter_index",
                                  defaultValue: '');
                              if (values.isNotEmpty) {
                                return Row(
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          pushMangaReaderView(
                                              context: context,
                                              modelManga: element.modelManga,
                                              index:
                                                  int.parse(values.toString()));
                                        },
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
                                                  element.modelManga.name!,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      element.modelManga
                                                              .chapterTitle![
                                                          int.parse(values
                                                              .toString())],
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    const Text(' - '),
                                                    Text(
                                                      DateFormat.Hm().format(
                                                          DateTime.parse(
                                                              element.date)),
                                                      style: const TextStyle(
                                                          fontSize: 11,
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
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Delete",
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "No")),
                                                        TextButton(
                                                            onPressed: () {
                                                              ref
                                                                  .watch(
                                                                      hiveBoxMangaHistory)
                                                                  .delete(element
                                                                      .modelManga
                                                                      .link);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Yes")),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 25,
                                        )),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemComparator: (item1, item2) =>
                    item1.date.compareTo(item2.date),
                order: GroupedListOrder.DESC,
              );
            }
            return const Center(child: Text(""));
          },
        ),
      ),
    );
  }
}

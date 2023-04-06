import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/library/providers/state_providers.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with TickerProviderStateMixin {
  bool isOk = false;
  bool isSearch = false;
  List<ModelManga> entries = [];
  List<ModelManga> entriesFilter = [];
  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final reverse = ref.watch(reverseStateProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: isSearch
            ? null
            : Text(
                'Library',
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
        actions: [
          isSearch
              ? SeachFormTextField(
                  onChanged: (value) {
                    setState(() {
                      entriesFilter = entries
                          .where((element) =>
                              element.name!.toLowerCase().contains(value))
                          .toList();
                    });
                  },
                  onPressed: () {
                    setState(() {
                      isSearch = false;
                    });
                  },
                  controller: _textEditingController,
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                    _textEditingController.clear();
                  },
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                _showModalSort();
              },
              icon: Icon(Icons.filter_list_sharp,
                  color: Theme.of(context).hintColor)),
          PopupMenuButton(
              color: Theme.of(context).hintColor,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(value: 0, child: Text("1")),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("2"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("3"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                } else if (value == 1) {
                } else if (value == 2) {}
              }),
        ],
      ),
      body: ValueListenableBuilder<Box<ModelManga>>(
        valueListenable: ref.watch(hiveBoxManga).listenable(),
        builder: (context, value, child) {
          entries = value.values.where((element) => element.favorite).toList();
          final entriesManga = _textEditingController.text.isNotEmpty
              ? entriesFilter
              : reverse
                  ? entries.reversed.toList()
                  : entries;
          if (entries.isNotEmpty || entriesFilter.isNotEmpty) {
            return GridViewWidget(
              itemCount: entriesManga.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final model = ModelManga(
                        imageUrl: entriesManga[index].imageUrl,
                        name: entriesManga[index].name,
                        genre: entriesManga[index].genre,
                        author: entriesManga[index].author,
                        status: entriesManga[index].status,
                        chapterDate: entriesManga[index].chapterDate,
                        chapterTitle: entriesManga[index].chapterTitle,
                        chapterUrl: entriesManga[index].chapterUrl,
                        description: entriesManga[index].description,
                        favorite: entriesManga[index].favorite,
                        link: entriesManga[index].link,
                        source: entriesManga[index].source,
                        lang: entriesManga[index].lang);

                    context.push('/manga-reader/detail', extra: model);
                  },
                  child: CoverViewWidget(
                    children: [
                      Stack(
                        children: [
                          cachedNetworkImage(
                              imageUrl: entriesManga[index].imageUrl!,
                              width: 200,
                              height: 270,
                              fit: BoxFit.cover),
                          Positioned(
                              top: 0,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Theme.of(context).cardColor),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Text(entriesManga[index]
                                        .chapterDate!
                                        .length
                                        .toString()),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      BottomTextWidget(text: entriesManga[index].name!)
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Empty Library"));
        },
      ),
    );
  }

  _showModalSort() {
    List<String> sortList = [
      "Alphabetically",
      "Total chapters",
      "Latest chapter",
      "Date added"
    ];
    late TabController tabBarController;
    showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        enableDrag: true,
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          if (!isOk) {
            tabBarController = TabController(length: 3, vsync: this);
            tabBarController.animateTo(0);
          }
          return SizedBox(
              height: mediaHeight(context, 0.4),
              child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    body: Column(
                      children: [
                        TabBar(
                          controller: tabBarController,
                          tabs: const [
                            Tab(text: "Filter"),
                            Tab(text: "Sort"),
                            Tab(text: "Display"),
                          ],
                        ),
                        Flexible(
                          child: TabBarView(
                              controller: tabBarController,
                              children: [
                                const Center(child: Text("soon")),
                                Consumer(builder: (context, ref, chil) {
                                  final reverse =
                                      ref.watch(reverseStateProvider);
                                  final sortedValue =
                                      ref.watch(sortedValueStateProvider);
                                  return Column(
                                    children: [
                                      for (var i = 0; i < sortList.length; i++)
                                        ListTile(
                                          onTap: () {
                                            ref
                                                .read(reverseStateProvider
                                                    .notifier)
                                                .state = !reverse;
                                            ref
                                                .read(sortedValueStateProvider
                                                    .notifier)
                                                .state = sortList[i];
                                          },
                                          dense: true,
                                          leading: sortedValue == sortList[i]
                                              ? Icon(reverse
                                                  ? Icons.arrow_downward_sharp
                                                  : Icons.arrow_upward_sharp)
                                              : const Icon(
                                                  Icons.arrow_upward_sharp,
                                                  color: Colors.transparent,
                                                ),
                                          title: Text(sortList[i]),
                                        ),
                                    ],
                                  );
                                }),
                                const Center(child: Text("soon"))
                              ]),
                        ),
                      ],
                    ),
                  )));
        });
  }
}

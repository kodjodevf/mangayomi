import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/library/providers/library_state_provider.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';
import 'package:mangayomi/views/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/views/library/widgets/library_listview_widget.dart';
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
    final reverse = ref.watch(libraryReverseListStateProvider);
    final displayType = ref
        .read(libraryDisplayTypeStateProvider.notifier)
        .getLibraryDisplayTypeValue(ref.watch(libraryDisplayTypeStateProvider));
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
                    _textEditingController.clear();
                  },
                  controller: _textEditingController,
                  onSuffixPressed: () {
                    _textEditingController.clear();
                    setState(() {});
                  },
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
          // PopupMenuButton(
          //     color: Theme.of(context).hintColor,
          //     itemBuilder: (context) {
          //       return [
          //         const PopupMenuItem<int>(
          //             value: 0, child: Text("Open random entry")),
          //       ];
          //     },
          //     onSelected: (value) {}),
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
            return displayType == DisplayType.list
                ? LibraryListViewWidget(
                    entriesManga: entriesManga,
                  )
                : LibraryGridViewWidget(
                    entriesManga: entriesManga,
                    isCoverOnlyGrid:
                        displayType == DisplayType.compactGrid ? false : true,
                    isComfortableGrid:
                        displayType == DisplayType.comfortableGrid
                            ? true
                            : false,
                  );
          }
          return const Center(child: Text("Empty Library"));
        },
      ),
    );
  }

  _showModalSort() {
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
                                  final reverse = ref
                                      .watch(libraryReverseListStateProvider);

                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          ref
                                              .read(
                                                  libraryReverseListStateProvider
                                                      .notifier)
                                              .setLibraryReverseList(!reverse);
                                        },
                                        dense: true,
                                        leading: Icon(reverse
                                            ? Icons.arrow_downward_sharp
                                            : Icons.arrow_upward_sharp),
                                        title: const Text("Alphabetically"),
                                      ),
                                    ],
                                  );
                                }),
                                Consumer(builder: (context, ref, chil) {
                                  final display = ref
                                      .watch(libraryDisplayTypeStateProvider);
                                  final displayV = ref.read(
                                      libraryDisplayTypeStateProvider.notifier);

                                  return Column(
                                    children: [
                                      for (var i = 0;
                                          i < DisplayType.values.length;
                                          i++)
                                        RadioListTile<DisplayType>(
                                          title: Text(displayV
                                              .getLibraryDisplayTypeName(
                                                  DisplayType.values[i].name)),
                                          value: DisplayType.values[i],
                                          groupValue: displayV
                                              .getLibraryDisplayTypeValue(
                                                  display),
                                          selected: true,
                                          onChanged: (value) {
                                            displayV
                                                .setLibraryDisplayType(value!);
                                          },
                                        ),
                                    ],
                                  );
                                }),
                              ]),
                        ),
                      ],
                    ),
                  )));
        });
  }
}

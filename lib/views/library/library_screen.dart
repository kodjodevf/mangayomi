import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool isSearch = false;
  List<ModelManga> entries = [];
  List<ModelManga> entriesFilter = [];
  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              ? Flexible(
                  child: TextFormField(
                    style: const TextStyle(fontFamily: 'Lato'),
                    controller: _textEditingController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      setState(() {
                        entriesFilter = entries
                            .where((element) =>
                                element.name!.toLowerCase().contains(value))
                            .toList();
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Seach...',
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isSearch = false;
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                            )),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
          IconButton(
              splashRadius: 20,
              onPressed: () {},
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
          final entriesManga =
              _textEditingController.text.isNotEmpty ? entriesFilter : entries;
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
                      cachedNetworkImage(
                          imageUrl: entriesManga[index].imageUrl!,
                          width: 200,
                          height: 270,
                          fit: BoxFit.cover),
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
}

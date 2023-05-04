import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/categories.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final ModelManga modelManga;
  final Function(bool) isFavorite;
  const MangaDetailsView({
    super.key,
    required this.isFavorite,
    required this.modelManga,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  bool isFavorite = false;
  bool _isOk = false;
  bool isGplay = false;
  _checkFavorite(bool i) async {
    if (!_isOk) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        setState(() {
          widget.isFavorite(i);
          isFavorite = i;
          _isOk = true;
        });
      }
    }
  }

  _setFavorite(bool i) async {
    if (mounted) {
      setState(() {
        widget.isFavorite(i);
        isFavorite = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkFavorite(widget.modelManga.favorite);
    return Scaffold(
      // floatingActionButton: ref.watch(isLongPressedStateProvider) == true
      //     ? null
      //     : widget.modelManga.chapters!.isNotEmpty
      //         ? ValueListenableBuilder<Box>(
      //             valueListenable:
      //                 ref.watch(hiveBoxMangaInfoProvider).listenable(),
      //             builder: (context, value, child) {
      //               final entries = value.get(
      //                   "${widget.modelManga.lang}-${widget.modelManga.source}/${widget.modelManga.name}-chapter_index",
      //                   defaultValue: '');
      //               final incognitoMode = ref.watch(incognitoModeStateProvider);

      //               if (entries.isNotEmpty && !incognitoMode) {
      //                 return Consumer(builder: (context, ref, child) {
      //                   final isExtended = ref.watch(isExtendedStateProvider);
      //                   return Row(
      //                     mainAxisAlignment: MainAxisAlignment.end,
      //                     children: [
      //                       AnimatedContainer(
      //                         height: 55,
      //                         width: !isExtended ? 63 : 130,
      //                         duration: const Duration(milliseconds: 200),
      //                         curve: Curves.easeIn,
      //                         child: ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                               backgroundColor: primaryColor(context),
      //                               shape: RoundedRectangleBorder(
      //                                   borderRadius:
      //                                       BorderRadius.circular(15))),
      //                           onPressed: () {
      //                             pushMangaReaderView(
      //                                 context: context,
      //                                 modelManga: widget.modelManga,
      //                                 index: int.parse(entries.toString()));
      //                           },
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               const Icon(
      //                                 Icons.play_arrow,
      //                                 color: Colors.white,
      //                               ),
      //                               AnimatedContainer(
      //                                 curve: Curves.easeIn,
      //                                 width: !isExtended ? 0 : 8,
      //                                 duration:
      //                                     const Duration(milliseconds: 500),
      //                               ),
      //                               AnimatedContainer(
      //                                 curve: Curves.easeIn,
      //                                 width: !isExtended ? 0 : 60,
      //                                 duration:
      //                                     const Duration(milliseconds: 200),
      //                                 child: const Text(
      //                                   "Continue",
      //                                   overflow: TextOverflow.ellipsis,
      //                                   style: TextStyle(
      //                                       fontSize: 14, color: Colors.white),
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 });
      //               }
      //               return Consumer(builder: (context, ref, child) {
      //                 final isExtended = ref.watch(isExtendedStateProvider);
      //                 return Row(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     AnimatedContainer(
      //                       height: 55,
      //                       width: !isExtended ? 60 : 105,
      //                       duration: const Duration(milliseconds: 300),
      //                       curve: Curves.easeIn,
      //                       child: ElevatedButton(
      //                         style: ElevatedButton.styleFrom(
      //                             backgroundColor: primaryColor(context),
      //                             shape: RoundedRectangleBorder(
      //                                 borderRadius: BorderRadius.circular(15))),
      //                         onPressed: () {
      //                           pushMangaReaderView(
      //                               context: context,
      //                               modelManga: widget.modelManga,
      //                               index:
      //                                   widget.modelManga.chapters!.length - 1);
      //                         },
      //                         child: Row(
      //                           children: [
      //                             const Icon(
      //                               Icons.play_arrow,
      //                               color: Colors.white,
      //                             ),
      //                             AnimatedContainer(
      //                               curve: Curves.easeIn,
      //                               width: !isExtended ? 0 : 5,
      //                               duration: const Duration(milliseconds: 300),
      //                             ),
      //                             AnimatedContainer(
      //                               curve: Curves.easeIn,
      //                               width: !isExtended ? 0 : 40,
      //                               duration: const Duration(milliseconds: 300),
      //                               child: const Text(
      //                                 "Read",
      //                                 overflow: TextOverflow.ellipsis,
      //                                 style: TextStyle(
      //                                   fontSize: 14,
      //                                   color: Colors.white,
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 );
      //               });
      //             },
      //           )
      //         : null,
      body: MangaDetailView(
        titleDescription: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.modelManga.author!,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                const Icon(
                  FontAwesomeIcons.clock,
                  size: 12,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(widget.modelManga.status!),
                const Text(' • '),
                Row(
                  children: [
                    Text(widget.modelManga.source!),
                    Text(' (${widget.modelManga.lang!.toUpperCase()})'),
                  ],
                )
              ],
            )
          ],
        ),
        action: widget.modelManga.favorite
            ? SizedBox(
                width: mediaWidth(context, 0.4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0),
                  onPressed: () async {
                    _setFavorite(false);
                    final model = widget.modelManga;
                    await isar.writeTxn(() async {
                      model.favorite = false;
                      await isar.modelMangas.put(model);
                    });
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.favorite,
                        size: 22,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'In library',
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: mediaWidth(context, 0.4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0),
                  onPressed: () async {
                    final checkCategoryList = await isar.categoriesModels
                        .filter()
                        .idIsNotNull()
                        .isNotEmpty();
                    if (checkCategoryList) {
                      _openCategory(widget.modelManga);
                    } else {
                      _setFavorite(true);
                      final model = widget.modelManga;
                      await isar.writeTxn(() async {
                        model.favorite = true;
                        await isar.modelMangas.put(model);
                      });
                    }
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 22,
                        color: secondaryColor(context),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Add to library',
                        style: TextStyle(
                            color: secondaryColor(context), fontSize: 13),
                      )
                    ],
                  ),
                ),
              ),

        // ValueListenableBuilder<Box<ModelManga>>(
        //   valueListenable: ref.watch(hiveBoxMangaProvider).listenable(),
        //   builder: (context, value, child) {
        //     final entries = value.values
        //         .where((element) =>
        //             '${element.lang}-${element.link}' ==
        //             '${widget.modelManga.lang}-${widget.modelManga.link}')
        //         .toList();
        //     if (entries.isNotEmpty) {
        //       if (entries[0].favorite == true) {
        //         _checkFavorite(true);

        //         return ;
        //       } else {
        //         _checkFavorite(false);
        //         return ;
        //       }
        //     }
        //     return SizedBox(
        //       width: mediaWidth(context, 0.4),
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //             elevation: 0),
        //         onPressed: () {
        //           final checkCategoryList = ref
        //               .watch(hiveBoxCategoriesProvider)
        //               .values
        //               .toList()
        //               .isNotEmpty;
        //           if (checkCategoryList) {
        //             _openCategory(manga);
        //           } else {
        //             _setFavorite(true);
        //             final model = ModelManga(
        //                 imageUrl: widget.modelManga.imageUrl,
        //                 name: widget.modelManga.name,
        //                 genre: widget.modelManga.genre,
        //                 author: widget.modelManga.author,
        //                 status: widget.modelManga.status,
        //                 description: widget.modelManga.description,
        //                 favorite: true,
        //                 link: widget.modelManga.link,
        //                 source: widget.modelManga.source,
        //                 lang: widget.modelManga.lang,
        //                 dateAdded: DateTime.now().microsecondsSinceEpoch,
        //                 lastUpdate: DateTime.now().microsecondsSinceEpoch,
        //                 chapters: widget.modelManga.chapters,
        //                 categories: [],
        //                 lastRead: '');
        //             manga.put(
        //                 '${widget.modelManga.lang}-${widget.modelManga.link}',
        //                 model);
        //           }
        //         },
        //         child: Column(
        //           children: [
        //             Icon(
        //               Icons.favorite_border_rounded,
        //               size: 22,
        //               color: secondaryColor(context),
        //             ),
        //             const SizedBox(
        //               height: 4,
        //             ),
        //             Text(
        //               'Add to library',
        //               style: TextStyle(
        //                   color: secondaryColor(context), fontSize: 13),
        //             )
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
        modelManga: widget.modelManga,
        listLength: widget.modelManga.chapters.length + 1,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
      ),
    );
  }

  _openCategory(ModelManga manga) {
    List<int> categoryIds = [];
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Set categories",
                ),
                content: SizedBox(
                  width: mediaWidth(context, 0.8),
                  child: StreamBuilder(
                      stream: isar.categoriesModels
                          .filter()
                          .idIsNotNull()
                          .watch(fireImmediately: true),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          final entries = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              return ListTileChapterFilter(
                                label: entries[index].name!,
                                onTap: () {
                                  setState(() {
                                    if (categoryIds
                                        .contains(entries[index].id)) {
                                      categoryIds.remove(entries[index].id);
                                    } else {
                                      categoryIds.add(entries[index].id!);
                                    }
                                  });
                                },
                                type: categoryIds.contains(entries[index].id)
                                    ? 1
                                    : 0,
                              );
                            },
                          );
                        }
                        return Container();
                      }),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            context.push("/categories");
                            Navigator.pop(context);
                          },
                          child: const Text("Edit")),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                              onPressed: () async {
                                _setFavorite(true);
                                final model = widget.modelManga;
                                await isar.writeTxn(() async {
                                  model.favorite = true;
                                  model.categories = categoryIds;
                                  await isar.modelMangas.put(model);
                                });
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                "OK",
                              )),
                        ],
                      ),
                    ],
                  )
                ],
              );
            },
          );
        });
  }
}

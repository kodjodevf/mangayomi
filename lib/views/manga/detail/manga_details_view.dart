import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/views/history/providers/isar_providers.dart';
import 'package:mangayomi/views/manga/reader/providers/push_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  const MangaDetailsView({
    super.key,
    required this.manga,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  @override
  Widget build(BuildContext context) {
    final history = ref.watch(getAllHistoryStreamProvider);
    final chaptersList = ref.watch(chaptersListttStateProvider);
    return Scaffold(
      floatingActionButton: ref.watch(isLongPressedStateProvider) == true
          ? null
          : chaptersList.isNotEmpty &&
                  chaptersList
                      .where((element) => !element.isRead!)
                      .toList()
                      .isNotEmpty
              ? history.when(
                  data: (data) {
                    final incognitoMode = ref.watch(incognitoModeStateProvider);
                    final entries = data
                        .where((element) => element.mangaId == widget.manga.id)
                        .toList();
                    if (entries.isNotEmpty && !incognitoMode) {
                      return Consumer(builder: (context, ref, child) {
                        final isExtended = ref.watch(isExtendedStateProvider);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              height: 55,
                              width: !isExtended ? 63 : 130,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor(context),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                                onPressed: () {
                                  pushMangaReaderView(
                                    context: context,
                                    chapter: entries.first.chapter.value!,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    AnimatedContainer(
                                      curve: Curves.easeIn,
                                      width: !isExtended ? 0 : 8,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    ),
                                    AnimatedContainer(
                                      curve: Curves.easeIn,
                                      width: !isExtended ? 0 : 60,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: const Text(
                                        "Resume",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    }
                    return Consumer(builder: (context, ref, child) {
                      final isExtended = ref.watch(isExtendedStateProvider);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            height: 55,
                            width: !isExtended ? 60 : 105,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor(context),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                pushMangaReaderView(
                                    context: context,
                                    chapter: widget.manga.chapters.last);
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.easeIn,
                                    width: !isExtended ? 0 : 5,
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.easeIn,
                                    width: !isExtended ? 0 : 40,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Text(
                                      "Read",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    });
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return ErrorText(error);
                  },
                  loading: () {
                    return const ProgressCenter();
                  },
                )
              : null,
      body: MangaDetailView(
        titleDescription: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.manga.author!,
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
                Text(widget.manga.status!),
                const Text(' • '),
                Row(
                  children: [
                    Text(widget.manga.source!),
                    Text(' (${widget.manga.lang!.toUpperCase()})'),
                  ],
                )
              ],
            )
          ],
        ),
        action: widget.manga.favorite
            ? SizedBox(
                width: mediaWidth(context, 0.4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0),
                  onPressed: () {
                    final model = widget.manga;
                    isar.writeTxnSync(() {
                      model.favorite = false;
                      model.dateAdded = 0;
                      isar.mangas.putSync(model);
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
                  onPressed: () {
                    final checkCategoryList =
                        isar.categorys.filter().idIsNotNull().isNotEmptySync();
                    if (checkCategoryList) {
                      _openCategory(widget.manga);
                    } else {
                      final model = widget.manga;
                      isar.writeTxnSync(() {
                        model.favorite = true;
                        model.dateAdded = DateTime.now().millisecondsSinceEpoch;
                        isar.mangas.putSync(model);
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
        manga: widget.manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
      ),
    );
  }

  _openCategory(Manga manga) {
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
                      stream: isar.categorys
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
                              onPressed: () {
                                final model = widget.manga;
                                isar.writeTxnSync(() {
                                  model.favorite = true;
                                  model.categories = categoryIds;
                                  model.dateAdded =
                                      DateTime.now().millisecondsSinceEpoch;
                                  isar.mangas.putSync(model);
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

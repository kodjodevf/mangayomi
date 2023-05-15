import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/views/history/providers/isar_providers.dart';
import 'package:mangayomi/views/manga/detail/widgets/custom_floating_action_btn.dart';
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
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final history = ref.watch(getAllHistoryStreamProvider);
          final chaptersList = ref.watch(chaptersListttStateProvider);
          final isExtended = ref.watch(isExtendedStateProvider);
          return ref.watch(isLongPressedStateProvider) == true
              ? Container()
              : chaptersList.isNotEmpty &&
                      chaptersList
                          .where((element) => !element.isRead!)
                          .toList()
                          .isNotEmpty
                  ? history.when(
                      data: (data) {
                        final incognitoMode =
                            ref.watch(incognitoModeStateProvider);
                        final entries = data
                            .where(
                                (element) => element.mangaId == widget.manga.id)
                            .toList();
                        if (entries.isNotEmpty && !incognitoMode) {
                          return CustomFloatingActionBtn(
                            isExtended: !isExtended,
                            label: 'Resume',
                            onPressed: () {
                              pushMangaReaderView(
                                context: context,
                                chapter: entries.first.chapter.value!,
                              );
                            },
                            textWidth: 70,
                            width: 110,
                          );
                        }
                        return CustomFloatingActionBtn(
                          isExtended: !isExtended,
                          label: 'Read',
                          onPressed: () {
                            pushMangaReaderView(
                                context: context,
                                chapter: widget.manga.chapters.last);
                          },
                          textWidth: 40,
                          width: 90,
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return ErrorText(error);
                      },
                      loading: () {
                        return const ProgressCenter();
                      },
                    )
                  : Container();
        },
      ),
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
                  child: const Column(
                    children: [
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

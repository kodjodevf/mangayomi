import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  final bool sourceExist;
  const MangaDetailsView({
    super.key,
    required this.sourceExist,
    required this.manga,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    bool? isLocalArchive = widget.manga.isLocalArchive ?? false;
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final history = ref.watch(
              getAllHistoryStreamProvider(isManga: widget.manga.isManga!));
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
                        final isFr =
                            ref.watch(l10nLocaleStateProvider).languageCode ==
                                "fr";
                        if (entries.isNotEmpty && !incognitoMode) {
                          return CustomFloatingActionBtn(
                            isExtended: !isExtended,
                            label: l10n.resume,
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
                          label: l10n.read,
                          onPressed: () {
                            pushMangaReaderView(
                                context: context,
                                chapter: widget.manga.chapters.last);
                          },
                          textWidth: isFr ? 80 : 40,
                          width: isFr ? 130 : 90,
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
        titleDescription: isLocalArchive
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.manga.author!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        getMangaStatusIcon(widget.manga.status),
                        size: 14,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(getMangaStatusName(widget.manga.status, context)),
                      const Text(' • '),
                      Text(widget.manga.source!),
                      Text(' (${widget.manga.lang!.toUpperCase()})'),
                      if (!widget.sourceExist)
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.warning_amber,
                            color: Colors.deepOrangeAccent,
                            size: 14,
                          ),
                        )
                    ],
                  )
                ],
              ),
        action: widget.manga.favorite
            ? SizedBox(
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
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 20,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        l10n.in_library,
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0),
                onPressed: () {
                  final checkCategoryList = isar.categorys
                      .filter()
                      .idIsNotNull()
                      .and()
                      .forMangaEqualTo(widget.manga.isManga)
                      .isNotEmptySync();
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
                      size: 20,
                      color: secondaryColor(context),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      l10n.add_to_library,
                      style: TextStyle(
                          color: secondaryColor(context), fontSize: 11),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
        manga: widget.manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
        sourceExist: widget.sourceExist,
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
              final l10n = l10nLocalizations(context)!;
              return AlertDialog(
                title: Text(
                  l10n.set_categories,
                ),
                content: SizedBox(
                  width: mediaWidth(context, 0.8),
                  child: StreamBuilder(
                      stream: isar.categorys
                          .filter()
                          .idIsNotNull()
                          .and()
                          .forMangaEqualTo(widget.manga.isManga)
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
                            context.push("/categories",
                                extra: (true, widget.manga.isManga! ? 0 : 1));
                            Navigator.pop(context);
                          },
                          child: Text(l10n.edit)),
                      Row(
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
                              child: Text(
                                l10n.ok,
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

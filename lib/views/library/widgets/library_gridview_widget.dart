import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/views/history/providers/isar_providers.dart';
import 'package:mangayomi/views/library/providers/library_state_provider.dart';
import 'package:mangayomi/views/manga/reader/providers/push_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/views/widgets/bottom_text_widget.dart';
import 'package:mangayomi/views/widgets/cover_view_widget.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/gridview_widget.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

class LibraryGridViewWidget extends StatelessWidget {
  final bool isCoverOnlyGrid;
  final bool isComfortableGrid;
  final List<int> mangaIdsList;
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  const LibraryGridViewWidget(
      {super.key,
      required this.entriesManga,
      required this.isCoverOnlyGrid,
      this.isComfortableGrid = false,
      required this.language,
      required this.downloadedChapter,
      required this.continueReaderBtn,
      required this.mangaIdsList});

  @override
  Widget build(BuildContext context) {
    return GridViewWidget(
      mainAxisExtent: isComfortableGrid ? 310 : 280,
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        return Consumer(builder: (context, ref, child) {
          final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
          return Padding(
            padding: const EdgeInsets.all(2),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: mangaIdsList.contains(entriesManga[index].id)
                      ? primaryColor(context).withOpacity(0.4)
                      : Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  shadowColor: Colors.transparent),
              onPressed: () {
                if (isLongPressed) {
                  ref
                      .read(mangasListStateProvider.notifier)
                      .update(entriesManga[index]);
                } else {
                  context.push('/manga-reader/detail',
                      extra: entriesManga[index].id);
                }
              },
              onLongPress: () {
                if (!isLongPressed) {
                  ref
                      .read(mangasListStateProvider.notifier)
                      .update(entriesManga[index]);

                  ref
                      .read(isLongPressedMangaStateProvider.notifier)
                      .update(!isLongPressed);
                } else {
                  ref
                      .read(mangasListStateProvider.notifier)
                      .update(entriesManga[index]);
                }
              },
              child: CoverViewWidget(
                bottomTextWidget: BottomTextWidget(
                  text: entriesManga[index].name!,
                  isComfortableGrid: isComfortableGrid,
                ),
                isComfortableGrid: isComfortableGrid,
                children: [
                  Stack(
                    children: [
                      cachedNetworkImage(
                          headers: headers(entriesManga[index].source!),
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
                                color: primaryColor(context),
                              ),
                              child: Row(
                                children: [
                                  if (downloadedChapter)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          List nbrDown = [];
                                          for (var i = 0;
                                              i <
                                                  entriesManga[index]
                                                      .chapters
                                                      .length;
                                              i++) {
                                            final entries = ref
                                                .watch(
                                                    hiveBoxMangaDownloadsProvider)
                                                .values
                                                .where((element) =>
                                                    element.chapterName ==
                                                    entriesManga[index]
                                                        .chapters
                                                        .toList()[i]
                                                        .name)
                                                .toList();
                                            if (entries.isNotEmpty &&
                                                entries.first.isDownload) {
                                              nbrDown.add(entries.first);
                                            }
                                          }
                                          if (nbrDown.isNotEmpty) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(3),
                                                        bottomLeft:
                                                            Radius.circular(3)),
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3, right: 3),
                                                child: Text(
                                                  nbrDown.length.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: Text(
                                      entriesManga[index]
                                          .chapters
                                          .length
                                          .toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      if (language)
                        Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                color: primaryColor(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                    color: Theme.of(context).hintColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 3, right: 3),
                                    child: Text(
                                      entriesManga[index].lang!.toUpperCase(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                  if (!isComfortableGrid)
                    if (!isCoverOnlyGrid)
                      BottomTextWidget(text: entriesManga[index].name!),
                  if (continueReaderBtn)
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                            padding: const EdgeInsets.all(9),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final history =
                                    ref.watch(getAllHistoryStreamProvider);
                                return history.when(
                                  data: (data) {
                                    final incognitoMode =
                                        ref.watch(incognitoModeStateProvider);
                                    final entries = data
                                        .where((element) =>
                                            element.mangaId ==
                                            entriesManga[index].id)
                                        .toList();
                                    if (entries.isNotEmpty && !incognitoMode) {
                                      return GestureDetector(
                                        onTap: () {
                                          pushMangaReaderView(
                                            context: context,
                                            chapter:
                                                entries.first.chapter.value!,
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: primaryColor(context)
                                                .withOpacity(0.9),
                                          ),
                                          child: const Padding(
                                              padding: EdgeInsets.all(7),
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 19,
                                                color: Colors.white,
                                              )),
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        pushMangaReaderView(
                                            context: context,
                                            chapter: entriesManga[index]
                                                .chapters
                                                .last);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: primaryColor(context)
                                              .withOpacity(0.9),
                                        ),
                                        child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 19,
                                              color: Colors.white,
                                            )),
                                      ),
                                    );
                                  },
                                  error: (Object error, StackTrace stackTrace) {
                                    return ErrorText(error);
                                  },
                                  loading: () {
                                    return const ProgressCenter();
                                  },
                                );
                              },
                            )))
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

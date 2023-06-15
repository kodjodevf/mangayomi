import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final List<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;
  const LibraryListViewWidget(
      {super.key,
      required this.entriesManga,
      required this.language,
      required this.downloadedChapter,
      required this.continueReaderBtn,
      required this.mangaIdsList,
      required this.localSource});

  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        bool isLocalArchive = entriesManga[index].isLocalArchive ?? false;
        return Consumer(builder: (context, ref, child) {
          final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
          return Material(
            borderRadius: BorderRadius.circular(5),
            color: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () {
                if (isLongPressed) {
                  ref
                      .read(mangasListStateProvider.notifier)
                      .update(entriesManga[index]);
                } else {
                  pushToMangaReaderDetail(
                      archiveId: isLocalArchive ? entriesManga[index].id : null,
                      context: context,
                      lang: entriesManga[index].lang!,
                      mangaM: entriesManga[index]);
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
              child: Container(
                color: mangaIdsList.contains(entriesManga[index].id)
                    ? primaryColor(context).withOpacity(0.4)
                    : Colors.transparent,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Container(
                    height: 45,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Material(
                                  child: Ink.image(
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 45,
                                    image: entriesManga[index]
                                                .customCoverImage !=
                                            null
                                        ? MemoryImage(
                                            entriesManga[index].customCoverImage
                                                as Uint8List) as ImageProvider
                                        : CachedNetworkImageProvider(
                                            entriesManga[index].imageUrl!,
                                            headers: ref.watch(headersProvider(
                                                source: entriesManga[index]
                                                    .source!)),
                                          ),
                                    child: InkWell(
                                        child: Container(
                                      color: mangaIdsList
                                              .contains(entriesManga[index].id)
                                          ? primaryColor(context)
                                              .withOpacity(0.4)
                                          : Colors.transparent,
                                    )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(entriesManga[index].name!),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: primaryColor(context)),
                            child: SizedBox(
                              height: 22,
                              child: Row(
                                children: [
                                  if (localSource && isLocalArchive)
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(3),
                                            bottomLeft: Radius.circular(3)),
                                        color: Theme.of(context).hintColor,
                                      ),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 3, right: 3),
                                        child: Text(
                                          "Local",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  if (downloadedChapter)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          List nbrDown = [];
                                          isar.txnSync(() {
                                            for (var i = 0;
                                                i <
                                                    entriesManga[index]
                                                        .chapters
                                                        .length;
                                                i++) {
                                              final entries = isar.downloads
                                                  .filter()
                                                  .idIsNotNull()
                                                  .chapterIdEqualTo(
                                                      entriesManga[index]
                                                          .chapters
                                                          .toList()[i]
                                                          .id)
                                                  .findAllSync();

                                              if (entries.isNotEmpty &&
                                                  entries.first.isDownload!) {
                                                nbrDown.add(entries.first);
                                              }
                                            }
                                          });
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
                                  if (language &&
                                      entriesManga[index].lang!.isNotEmpty)
                                    Container(
                                      color: primaryColor(context),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(3),
                                              bottomRight: Radius.circular(3)),
                                          color: Theme.of(context).hintColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: Text(
                                            entriesManga[index]
                                                .lang!
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (continueReaderBtn)
                          Consumer(
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
                                          chapter: entries.first.chapter.value!,
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
                                        borderRadius: BorderRadius.circular(5),
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
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

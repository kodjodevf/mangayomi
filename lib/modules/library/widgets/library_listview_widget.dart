import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final List<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;
  const LibraryListViewWidget({
    super.key,
    required this.entriesManga,
    required this.language,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
  });

  @override
  Widget build(BuildContext context) {
    return SuperListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        final entry = entriesManga[index];
        bool isLocalArchive = entry.isLocalArchive ?? false;
        return Consumer(
          builder: (context, ref, child) {
            final isLongPressed = ref.watch(isLongPressedStateProvider);
            return Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () async {
                  if (isLongPressed) {
                    ref.read(mangasListStateProvider.notifier).update(entry);
                  } else {
                    await pushToMangaReaderDetail(
                      ref: ref,
                      archiveId: isLocalArchive ? entry.id : null,
                      context: context,
                      lang: entry.lang!,
                      mangaM: entry,
                      source: entry.source!,
                      sourceId: entry.sourceId,
                    );
                    ref.invalidate(
                      getAllMangaWithoutCategoriesStreamProvider(
                        itemType: entry.itemType,
                      ),
                    );
                    ref.invalidate(
                      getAllMangaStreamProvider(
                        categoryId: null,
                        itemType: entry.itemType,
                      ),
                    );
                  }
                },
                onLongPress: () {
                  if (!isLongPressed) {
                    ref.read(mangasListStateProvider.notifier).update(entry);

                    ref
                        .read(isLongPressedStateProvider.notifier)
                        .update(!isLongPressed);
                  } else {
                    ref.read(mangasListStateProvider.notifier).update(entry);
                  }
                },
                onSecondaryTap: () {
                  if (!isLongPressed) {
                    ref.read(mangasListStateProvider.notifier).update(entry);

                    ref
                        .read(isLongPressedStateProvider.notifier)
                        .update(!isLongPressed);
                  } else {
                    ref.read(mangasListStateProvider.notifier).update(entry);
                  }
                },
                child: Container(
                  color: mangaIdsList.contains(entry.id)
                      ? context.primaryColor.withValues(alpha: 0.4)
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
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
                                      image: entry.customCoverImage != null
                                          ? MemoryImage(
                                                  entry.customCoverImage
                                                      as Uint8List,
                                                )
                                                as ImageProvider
                                          : CustomExtendedNetworkImageProvider(
                                              toImgUrl(
                                                entry.customCoverFromTracker ??
                                                    entry.imageUrl!,
                                              ),
                                              headers: ref.watch(
                                                headersProvider(
                                                  source: entry.source!,
                                                  lang: entry.lang!,
                                                  sourceId: entry.sourceId,
                                                ),
                                              ),
                                            ),
                                      child: InkWell(
                                        child: Container(
                                          color: mangaIdsList.contains(entry.id)
                                              ? context.primaryColor.withValues(
                                                  alpha: 0.4,
                                                )
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(entry.name!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: context.primaryColor,
                              ),
                              child: SizedBox(
                                height: 22,
                                child: Row(
                                  children: [
                                    if (localSource && isLocalArchive)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(3),
                                            bottomLeft: Radius.circular(3),
                                          ),
                                          color: Theme.of(context).hintColor,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                          ),
                                          child: Text(
                                            "Local",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (downloadedChapter)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5,
                                        ),
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            List nbrDown = [];
                                            isar.txnSync(() {
                                              for (
                                                var i = 0;
                                                i < entry.chapters.length;
                                                i++
                                              ) {
                                                final entries = isar.downloads
                                                    .filter()
                                                    .idEqualTo(
                                                      entry.chapters
                                                          .toList()[i]
                                                          .id,
                                                    )
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
                                                            Radius.circular(3),
                                                      ),
                                                  color: Theme.of(
                                                    context,
                                                  ).hintColor,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 3,
                                                        right: 3,
                                                      ),
                                                  child: Text(
                                                    nbrDown.length.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
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
                                        entry.chapters.length.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (language && entry.lang!.isNotEmpty)
                                      Container(
                                        color: context.primaryColor,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topRight: Radius.circular(3),
                                                  bottomRight: Radius.circular(
                                                    3,
                                                  ),
                                                ),
                                            color: Theme.of(context).hintColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 3,
                                              right: 3,
                                            ),
                                            child: Text(
                                              entry.lang!.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
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
                                return StreamBuilder(
                                  stream: isar.historys
                                      .filter()
                                      .idIsNotNull()
                                      .and()
                                      .chapter(
                                        (q) => q.manga(
                                          (q) =>
                                              q.itemTypeEqualTo(entry.itemType),
                                        ),
                                      )
                                      .watch(fireImmediately: true),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.isNotEmpty) {
                                      final incognitoMode = ref.watch(
                                        incognitoModeStateProvider,
                                      );
                                      final entries = snapshot.data!
                                          .where(
                                            (element) =>
                                                element.mangaId == entry.id,
                                          )
                                          .toList();
                                      if (entries.isNotEmpty &&
                                          !incognitoMode) {
                                        final chap =
                                            entries.first.chapter.value!;
                                        return GestureDetector(
                                          onTap: () {
                                            chap.pushToReaderView(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: context.primaryColor
                                                  .withValues(alpha: 0.9),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(7),
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 19,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          entry.chapters
                                              .toList()
                                              .reversed
                                              .toList()
                                              .last
                                              .pushToReaderView(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: context.primaryColor
                                                .withValues(alpha: 0.9),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 19,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        entry.chapters
                                            .toList()
                                            .reversed
                                            .toList()
                                            .last
                                            .pushToReaderView(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: context.primaryColor
                                              .withValues(alpha: 0.9),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 19,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

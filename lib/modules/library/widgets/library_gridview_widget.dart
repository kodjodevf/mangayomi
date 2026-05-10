import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_reader_button.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';

class LibraryGridViewWidget extends StatefulWidget {
  final bool isCoverOnlyGrid;
  final bool isComfortableGrid;
  final Set<int> mangaIdsList;
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final bool continueReaderBtn;
  final bool localSource;
  final ItemType itemType;
  const LibraryGridViewWidget({
    super.key,
    required this.entriesManga,
    required this.isCoverOnlyGrid,
    this.isComfortableGrid = false,
    required this.language,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
    required this.itemType,
  });

  @override
  State<LibraryGridViewWidget> createState() => _LibraryGridViewWidgetState();
}

class _LibraryGridViewWidgetState extends State<LibraryGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isLongPressed = ref.watch(isLongPressedStateProvider);
        final itemType = widget.itemType;

        final gridSize = ref.watch(
          libraryGridSizeStateProvider(itemType: itemType),
        );
        return GridViewWidget(
          gridSize: gridSize,
          childAspectRatio: widget.isComfortableGrid ? 0.642 : 0.69,
          itemCount: widget.entriesManga.length,
          itemBuilder: (context, index) {
            final entry = widget.entriesManga[index];

            return Builder(
              builder: (context) {
                bool isLocalArchive = entry.isLocalArchive ?? false;
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: CoverViewWidget(
                    isLongPressed: widget.mangaIdsList.contains(entry.id),
                    bottomTextWidget: BottomTextWidget(
                      maxLines: 1,
                      text: entry.name!,
                      isComfortableGrid: widget.isComfortableGrid,
                    ),
                    isComfortableGrid: widget.isComfortableGrid,
                    image: entry.customCoverImage != null
                        ? MemoryImage(entry.customCoverImage as Uint8List)
                              as ImageProvider
                        : CustomExtendedNetworkImageProvider(
                            toImgUrl(
                              entry.customCoverFromTracker ??
                                  entry.imageUrl ??
                                  "",
                            ),
                            headers: entry.isLocalArchive!
                                ? null
                                : ref.watch(
                                    headersProvider(
                                      source: entry.source!,
                                      lang: entry.lang!,
                                      sourceId: entry.sourceId,
                                    ),
                                  ),
                          ),
                    onTap: () async {
                      if (isLongPressed) {
                        ref
                            .read(mangasListStateProvider.notifier)
                            .update(entry);
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
                        if (context.mounted) {
                          ref.invalidate(
                            getAllMangaWithoutCategoriesStreamProvider(
                              itemType: widget.itemType,
                            ),
                          );
                          ref.invalidate(
                            getAllMangaStreamProvider(
                              categoryId: null,
                              itemType: widget.itemType,
                            ),
                          );
                        }
                      }
                    },
                    onLongPress: () {
                      _handleLongOrSecondaryTap(isLongPressed, ref, entry);
                    },
                    onSecondaryTap: () {
                      _handleLongOrSecondaryTap(isLongPressed, ref, entry);
                    },
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: context.primaryColor,
                                ),
                                child: Row(
                                  children: [
                                    if (widget.localSource && isLocalArchive)
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(3),
                                            bottomLeft: Radius.circular(3),
                                          ),
                                          color: Theme.of(context).hintColor,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 3,
                                            right: 3,
                                          ),
                                          child: Text(
                                            "Local",
                                            style: TextStyle(
                                              color: context
                                                  .dynamicBlackWhiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Consumer(
                                        builder: (context, ref, child) {
                                          int downloadCount = 0;
                                          if (widget.downloadedChapter) {
                                            final downloadedIds =
                                                ref
                                                    .watch(
                                                      downloadedChapterIdsProvider,
                                                    )
                                                    .asData
                                                    ?.value ??
                                                const <int>{};
                                            downloadCount = entry.chapters
                                                .where(
                                                  (c) =>
                                                      c.id != null &&
                                                      downloadedIds.contains(
                                                        c.id,
                                                      ),
                                                )
                                                .length;
                                          }
                                          return Row(
                                            children: [
                                              if (downloadCount > 0 &&
                                                  widget.downloadedChapter)
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                3,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                    color: Theme.of(
                                                      context,
                                                    ).secondaryHeaderColor,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 3,
                                                          right: 3,
                                                        ),
                                                    child: Text(
                                                      downloadCount.toString(),
                                                    ),
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 3,
                                                ),
                                                child: Text(
                                                  entry.chapters
                                                      .where((e) => !e.isRead!)
                                                      .length
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: context
                                                        .dynamicBlackWhiteColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (widget.language && entry.lang!.isNotEmpty)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  color: context.themeData.cardColor,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3),
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
                              ),
                            ),
                        ],
                      ),
                      if (!widget.isComfortableGrid && !widget.isCoverOnlyGrid)
                        BottomTextWidget(text: entry.name!),
                      if (widget.continueReaderBtn)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(9),
                            child: ContinueReaderButton(entry: entry),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleLongOrSecondaryTap(
    bool isLongPressed,
    WidgetRef ref,
    Manga entry,
  ) {
    if (!isLongPressed) {
      ref.read(mangasListStateProvider.notifier).update(entry);
      ref.read(isLongPressedStateProvider.notifier).update(!isLongPressed);
    } else {
      ref.read(mangasListStateProvider.notifier).update(entry);
    }
  }
}

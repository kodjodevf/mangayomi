import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:marquee/marquee.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final Manga manga;
  final List<Chapter> chapterList;
  final List<Chapter> allChapters;
  final bool sourceExist;
  const ChapterListTileWidget({
    required this.chapterList,
    required this.chapter,
    required this.manga,
    required this.allChapters,
    required this.sourceExist,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    return Dismissible(
      key: ValueKey('chapter_swipe_${chapter.id}'),
      direction: isLongPressed
          ? DismissDirection.none
          : DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right → toggle bookmark
          final chap = chapter;
          chap.isBookmarked = !chap.isBookmarked!;
          chapterRepository.save(chap);
        } else if (direction == DismissDirection.endToStart) {
          // Swipe left → toggle read
          final chap = chapter;
          chap.isRead = !chap.isRead!;
          if (!chap.isRead!) {
            chap.lastPageRead = "1";
          }
          chapterRepository.save(chap);
        }
        return false; // Don't dismiss, snap back
      },
      background: Container(
        color: context.primaryColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          chapter.isBookmarked! ? Icons.bookmark_remove : Icons.bookmark_add,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: chapter.isRead! ? Colors.grey : Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          chapter.isRead! ? Icons.remove_done_sharp : Icons.done_all,
          color: Colors.white,
        ),
      ),
      child: Material(
        color: chapterList.contains(chapter)
            ? context.primaryColor.withValues(alpha: 0.4)
            : (chapter.isFiller ?? false)
            ? context.primaryColor.withValues(alpha: 0.15)
            : Colors.transparent,
        child: InkWell(
          onTap: () async => _handleInteraction(ref, context),
          onLongPress: () => _handleInteraction(ref),
          onSecondaryTap: () => _handleInteraction(ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    color: chapter.isRead!
                        ? Colors.grey.withValues(alpha: 0.3)
                        : context.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chapter.thumbnailUrl != null)
                            _thumbnailPreview(context, chapter.thumbnailUrl),
                          if (chapter.isBookmarked!)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.bookmark,
                                size: 16,
                                color: context.primaryColor,
                              ),
                            ),
                          chapter.description != null
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTitle(chapter.name!, context),
                                      Text(
                                        chapter.description!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: chapter.isRead!
                                              ? context.isLight
                                                    ? Colors.black.withValues(
                                                        alpha: 0.4,
                                                      )
                                                    : Colors.white.withValues(
                                                        alpha: 0.3,
                                                      )
                                              : context.secondaryColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: _buildTitle(chapter.name!, context),
                                ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 11,
                          color: chapter.isRead!
                              ? context.isLight
                                    ? Colors.black.withValues(alpha: 0.4)
                                    : Colors.white.withValues(alpha: 0.3)
                              : context.secondaryColor,
                        ),
                        child: Row(
                          children: [
                            if (chapter.isFiller ?? false)
                              Row(
                                children: [
                                  Icon(
                                    Icons.label,
                                    size: 16,
                                    color: context.primaryColor,
                                  ),
                                  Text(
                                    " Filler ",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            if ((manga.isLocalArchive ?? false) == false)
                              Text(
                                chapter.dateUpload == null ||
                                        chapter.dateUpload!.isEmpty
                                    ? ""
                                    : dateFormat(
                                        chapter.dateUpload!,
                                        ref: ref,
                                        context: context,
                                      ),
                              ),
                            if (!chapter.isRead!)
                              if (chapter.lastPageRead!.isNotEmpty &&
                                  chapter.lastPageRead != "1")
                                Row(
                                  children: [
                                    const Text(' • '),
                                    Text(
                                      manga.itemType == ItemType.anime
                                          ? l10n.episode_progress(
                                              Duration(
                                                milliseconds: int.parse(
                                                  chapter.lastPageRead!,
                                                ),
                                              ).toString().substringBefore("."),
                                            )
                                          : l10n.page(
                                              manga.itemType == ItemType.manga
                                                  ? chapter.lastPageRead!
                                                  : "${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %",
                                            ),
                                    ),
                                  ],
                                ),
                            if (chapter.scanlator?.isNotEmpty ?? false)
                              Row(
                                children: [
                                  const Text(' • '),
                                  Text(chapter.scanlator!),
                                ],
                              ),
                            if (chapter.downloadSize != null)
                              Row(
                                children: [
                                  const Text(' • '),
                                  Text(chapter.downloadSize!),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isTv &&
                    sourceExist &&
                    !(manga.isLocalArchive ?? false)) ...[
                  const SizedBox(width: 8),
                  ChapterPageDownload(chapter: chapter),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleInteraction(WidgetRef ref, [BuildContext? context]) {
    final isLongPressed = ref.read(isLongPressedStateProvider);
    if (isLongPressed) {
      // Shift-click range selection on desktop
      if (HardwareKeyboard.instance.isShiftPressed) {
        ref
            .read(chaptersListStateProvider.notifier)
            .selectRange(chapter, allChapters);
      } else {
        ref.read(chaptersListStateProvider.notifier).update(chapter);
      }
    } else {
      if (context != null) {
        chapter.pushToReaderView(context, ignoreIsRead: true);
      } else {
        ref.read(chaptersListStateProvider.notifier).update(chapter);
        ref.read(isLongPressedStateProvider.notifier).update(!isLongPressed);
      }
    }
  }

  Widget _buildTitle(String text, BuildContext context) {
    final titleColor = chapter.isRead!
        ? context.isLight
              ? Colors.black.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.3)
        : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        if (availableWidth <= 0) return const SizedBox.shrink();
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(fontSize: 13, color: titleColor),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: availableWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        if (isOverflowing && availableWidth > 50) {
          return SizedBox(
            height: 20,
            child: Marquee(
              text: text,
              style: TextStyle(fontSize: 13, color: titleColor),
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
            ),
          );
        } else {
          return Text(
            text,
            style: TextStyle(fontSize: 13, color: titleColor),
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }

  Widget _thumbnailPreview(BuildContext context, String? imageUrl) {
    final imageProvider = CustomExtendedNetworkImageProvider(
      toImgUrl(imageUrl ?? ""),
    );
    // Decode the 50x65 preview at thumbnail resolution; the full-resolution
    // provider is only handed to the zoom dialog.
    final thumbnailProvider = coverProvider(toImgUrl(imageUrl ?? ""));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _openImage(context, imageProvider);
        },
        child: SizedBox(
          width: 50,
          height: 65,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: thumbnailProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openImage(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: PhotoViewGallery.builder(
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  itemCount: 1,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: imageProvider,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: 2.0,
                    );
                  },
                  loadingBuilder: (context, event) {
                    return const ProgressCenter();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

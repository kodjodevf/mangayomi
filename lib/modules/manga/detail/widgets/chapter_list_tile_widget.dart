import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:marquee/marquee.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final List<Chapter> chapterList;
  final bool sourceExist;
  const ChapterListTileWidget({
    required this.chapterList,
    required this.chapter,
    required this.sourceExist,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Container(
      color: chapterList.contains(chapter)
          ? context.primaryColor.withValues(alpha: 0.4)
          : null,
      child: GestureDetector(
        onLongPress: () => _handleInteraction(ref),
        onSecondaryTap: () => _handleInteraction(ref),
        child: ListTile(
          tileColor: (chapter.isFiller ?? false)
              ? context.primaryColor.withValues(alpha: 0.15)
              : null,
          textColor: chapter.isRead!
              ? context.isLight
                    ? Colors.black.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.3)
              : null,
          selectedColor: chapter.isRead!
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.white,
          onTap: () async => _handleInteraction(ref, context),
          title: Row(
            children: [
              if (chapter.thumbnailUrl != null)
                _thumbnailPreview(context, chapter.thumbnailUrl),
              chapter.isBookmarked!
                  ? Icon(Icons.bookmark, size: 16, color: context.primaryColor)
                  : Container(),
              chapter.description != null
                  ? Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(chapter.name!, context),
                          Text(
                            chapter.description!,
                            style: const TextStyle(fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  : Flexible(child: _buildTitle(chapter.name!, context)),
            ],
          ),
          subtitle: Row(
            children: [
              if (chapter.isFiller ?? false)
                Row(
                  children: [
                    Icon(Icons.label, size: 16, color: context.primaryColor),
                    Text(
                      " Filler ",
                      style: TextStyle(
                        fontSize: 11,
                        color: context.primaryColor,
                      ),
                    ),
                  ],
                ),
              if ((chapter.manga.value!.isLocalArchive ?? false) == false)
                Text(
                  chapter.dateUpload == null || chapter.dateUpload!.isEmpty
                      ? ""
                      : dateFormat(
                          chapter.dateUpload!,
                          ref: ref,
                          context: context,
                        ),
                  style: const TextStyle(fontSize: 11),
                ),
              if (!chapter.isRead!)
                if (chapter.lastPageRead!.isNotEmpty &&
                    chapter.lastPageRead != "1")
                  Row(
                    children: [
                      const Text(' • '),
                      Text(
                        chapter.manga.value!.itemType == ItemType.anime
                            ? l10n.episode_progress(
                                Duration(
                                  milliseconds: int.parse(
                                    chapter.lastPageRead!,
                                  ),
                                ).toString().substringBefore("."),
                              )
                            : l10n.page(
                                chapter.manga.value!.itemType == ItemType.manga
                                    ? chapter.lastPageRead!
                                    : "${((double.tryParse(chapter.lastPageRead!) ?? 0) * 100).toStringAsFixed(0)} %",
                              ),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.isLight
                              ? Colors.black.withValues(alpha: 0.4)
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
              if (chapter.scanlator?.isNotEmpty ?? false)
                Row(
                  children: [
                    const Text(' • '),
                    Text(
                      chapter.scanlator!,
                      style: TextStyle(
                        fontSize: 11,
                        color: chapter.isRead!
                            ? context.isLight
                                  ? Colors.black.withValues(alpha: 0.4)
                                  : Colors.white.withValues(alpha: 0.3)
                            : null,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          trailing:
              !sourceExist || (chapter.manga.value!.isLocalArchive ?? false)
              ? null
              : ChapterPageDownload(chapter: chapter),
        ),
      ),
    );
  }

  void _handleInteraction(WidgetRef ref, [BuildContext? context]) {
    final isLongPressed = ref.read(isLongPressedStateProvider);
    if (isLongPressed) {
      ref.read(chaptersListStateProvider.notifier).update(chapter);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make sure that (constraints.maxWidth - (35 + 5)) is strictly positive.
        final double availableWidth = constraints.maxWidth - (35 + 5);
        final textPainter =
            TextPainter(
              text: TextSpan(text: text, style: const TextStyle(fontSize: 13)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout(
              maxWidth: availableWidth > 0 ? availableWidth : 1.0,
            ); // - Download icon size (download_page_widget.dart, Widget Build SizedBox width: 35)

        final isOverflowing = textPainter.didExceedMaxLines;

        if (isOverflowing) {
          return SizedBox(
            height: 20,
            child: Marquee(
              text: text,
              style: const TextStyle(fontSize: 13),
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
            ),
          );
        } else {
          return Text(
            text,
            style: const TextStyle(fontSize: 13),
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
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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

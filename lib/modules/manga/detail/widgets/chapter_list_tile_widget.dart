import 'package:flutter/material.dart';
import 'package:mangayomi/utils/haptics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/providers/chapter_display.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:marquee/marquee.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_swipe.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

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
    final tokens = context.shiori;
    final c = tokens.color;
    final isRead = chapter.isRead!;
    final title = chapterDisplayName(
      chapter,
      manga,
      l10n,
      byNumber: ref.watch(
        chapterNumberDisplayProvider.select((ids) => ids.contains(manga.id)),
      ),
    );
    // Read chapters step back; their metadata steps back further.
    final metaColor = isRead
        ? c.fgMuted.withValues(alpha: Alphas.secondary)
        : c.fgMuted;

    return ChapterSwipe(
      chapter: chapter,
      enabled: !isLongPressed,
      child: Material(
        color: chapterList.contains(chapter)
            ? c.accent.withValues(alpha: Alphas.accentTint)
            : (chapter.isFiller ?? false)
            ? c.accent.withValues(alpha: Alphas.tint)
            : Colors.transparent,
        child: InkWell(
          onTap: () async => _handleInteraction(ref, context),
          onLongPress: () => _handleInteraction(ref),
          onSecondaryTap: () => _handleInteraction(ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ShioriSpace.s16,
              vertical: ShioriSpace.s12,
            ),
            child: Row(
              children: [
                // Unread chapters carry the accent down their edge, so the
                // place to resume reads at a glance.
                Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isRead ? c.hairline : c.accent,
                    borderRadius: BorderRadius.circular(ShioriShape.pill),
                  ),
                ),
                const SizedBox(width: ShioriSpace.s12),
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
                              padding: const EdgeInsetsDirectional.only(
                                end: ShioriSpace.s4,
                              ),
                              child: Icon(
                                Symbols.bookmark_rounded,
                                fill: 1,
                                size: tokens.scaled(16),
                                color: c.accentInk,
                              ),
                            ),
                          chapter.description != null
                              ? Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTitle(title, context),
                                      Text(
                                        chapter.description!,
                                        style: tokens.text.meta.copyWith(
                                          color: metaColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(child: _buildTitle(title, context)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      DefaultTextStyle(
                        style: tokens.text.meta.copyWith(color: metaColor),
                        child: Row(
                          children: [
                            if (chapter.isFiller ?? false)
                              Row(
                                children: [
                                  Icon(
                                    Symbols.label_rounded,
                                    fill: 1,
                                    size: tokens.scaled(16),
                                    color: c.accentInk,
                                  ),
                                  Text(
                                    " Filler ",
                                    style: tokens.text.meta.copyWith(
                                      color: c.accentInk,
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
                                    const Text(' · '),
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
                                  const Text(' · '),
                                  Text(chapter.scanlator!),
                                ],
                              ),
                            if (chapter.downloadSize != null)
                              Row(
                                children: [
                                  const Text(' · '),
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
                  const SizedBox(width: ShioriSpace.s8),
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
        selectionHaptic();
        ref.read(chaptersListStateProvider.notifier).update(chapter);
        ref.read(isLongPressedStateProvider.notifier).update(!isLongPressed);
      }
    }
  }

  Widget _buildTitle(String text, BuildContext context) {
    final tokens = context.shiori;
    final style = tokens.text.row.copyWith(
      color: chapter.isRead! ? tokens.color.fgMuted : tokens.color.fg,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        if (availableWidth <= 0) return const SizedBox.shrink();
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: availableWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        if (isOverflowing && availableWidth > 50) {
          return SizedBox(
            height: style.fontSize! * 1.45,
            child: Marquee(
              text: text,
              style: style,
              blankSpace: 40.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
            ),
          );
        } else {
          return Text(text, style: style, overflow: TextOverflow.ellipsis);
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
      padding: const EdgeInsetsDirectional.only(
        end: ShioriSpace.s8,
        top: ShioriSpace.s4,
        bottom: ShioriSpace.s4,
      ),
      child: GestureDetector(
        onTap: () {
          _openImage(context, imageProvider);
        },
        child: SizedBox(
          width: 50,
          height: 65,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ShioriShape.cover),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/library_entry_utils.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// A cover card: reuses [CoverViewWidget] (focus ring + badges) and scrolls
/// itself into view when focused (focus drives scroll). Select → detail.
class TvHomeCard extends ConsumerWidget {
  const TvHomeCard({super.key, required this.manga});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = manga.chapters.length;
    final read = manga.chapters.where((c) => c.isRead ?? false).length;
    final unread = manga.chapters.where((c) => !(c.isRead ?? true)).length;
    // Series progress = episodes watched / total (episode duration isn't
    // reliably stored, so within-episode progress isn't available).
    final progress = (total > 0 && read > 0 && read < total)
        ? read / total
        : 0.0;
    final source = manga.source ?? '';
    return CoverViewWidget(
      isComfortableGrid: true,
      progress: progress,
      bottomTextWidget: BottomTextWidget(
        text: manga.name ?? '',
        maxLines: 1,
        isComfortableGrid: true,
      ),
      image: resolveCoverImage(manga, ref),
      onFocusChange: (focused) {
        if (focused && context.mounted) {
          // Reveal the focused card in both the row (horizontal) and the page
          // (vertical) — one call walks up every enclosing scrollable.
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
          );
        }
      },
      onTap: () => onTapEntry(
        isLongPressed: false,
        ref: ref,
        context: context,
        entry: manga,
      ),
      // Long-press (hold OK on a remote) → assign this title to categories.
      onLongPress: () => showCategorySelectionDialog(
        context: context,
        ref: ref,
        itemType: ItemType.anime,
        singleManga: manga,
      ),
      children: [
        if (unread > 0)
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '$unread',
                  style: TextStyle(
                    color: context.dynamicBlackWhiteColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        if (source.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 92),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                  ),
                ),
                child: Text(
                  source,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

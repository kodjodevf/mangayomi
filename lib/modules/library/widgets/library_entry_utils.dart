import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_filter_provider.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/headers.dart';

/// Resolves the correct [ImageProvider] for a manga entry, preferring a custom
/// local cover over the remote URL. Remote covers are wrapped in
/// [coverProvider] so they decode at thumbnail resolution rather than the
/// source resolution — see refs #609.
ImageProvider resolveCoverImage(Manga entry, WidgetRef ref) {
  if (entry.customCoverImage != null) {
    return MemoryImage(entry.customCoverImage as Uint8List);
  }
  return coverProvider(
    toImgUrl(entry.customCoverFromTracker ?? entry.imageUrl ?? ''),
    headers: (entry.isLocalArchive ?? false)
        ? null
        : ref.watch(
            headersProvider(
              source: entry.source!,
              lang: entry.lang!,
              sourceId: entry.sourceId,
            ),
          ),
  );
}

/// Handles a long-press or secondary tap on a library entry.
///
/// Toggles long-press selection mode on the first activation, then simply
/// toggles the individual entry on subsequent taps.
void handleLongOrSecondaryTap(bool isLongPressed, WidgetRef ref, Manga entry) {
  ref.read(mangasListStateProvider.notifier).update(entry);
  if (!isLongPressed) {
    ref.read(isLongPressedStateProvider.notifier).update(!isLongPressed);
  }
}

/// Handles a primary tap on a library entry.
///
/// In selection mode ([isLongPressed]) it toggles the entry. Otherwise it
/// navigates to the reader and refreshes the library providers on return.
Future<void> onTapEntry({
  required bool isLongPressed,
  required WidgetRef ref,
  required BuildContext context,
  required Manga entry,
}) async {
  if (isLongPressed) {
    ref.read(mangasListStateProvider.notifier).update(entry);
    return;
  }

  final isLocalArchive = entry.isLocalArchive ?? false;
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
      getAllMangaWithoutCategoriesStreamProvider(itemType: entry.itemType),
    );
    ref.invalidate(
      getAllMangaStreamProvider(categoryId: null, itemType: entry.itemType),
    );
  }
}

/// A small rounded chip using the theme's hint colour as its background.
///
/// Used for the Local, download-count, and language badges.
class EntryBadgeChip extends StatelessWidget {
  const EntryBadgeChip({
    super.key,
    required this.label,
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(3),
      bottomLeft: Radius.circular(3),
    ),
  });

  final String label;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Theme.of(context).hintColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        label,
        style: TextStyle(color: context.dynamicBlackWhiteColor),
      ),
    );
  }
}

/// Shows the number of downloaded chapters for [entry], or nothing when zero.
///
/// Uses a [Consumer] internally so it can watch [downloadedChapterIdsProvider]
/// without forcing its parent to rebuild.
class DownloadCountBadge extends ConsumerWidget {
  const DownloadCountBadge({super.key, required this.entry});

  final Manga entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadedIds =
        ref.watch(downloadedChapterIdsProvider).asData?.value ?? const <int>{};

    final count = entry.chapters
        .where((c) => c.id != null && downloadedIds.contains(c.id))
        .length;

    if (count == 0) return const SizedBox.shrink();

    return EntryBadgeChip(label: count.toString());
  }
}

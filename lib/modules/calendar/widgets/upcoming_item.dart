import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

const _upcomingItemHeight = 96.0;

class UpcomingItem extends ConsumerWidget {
  final Manga manga;
  final VoidCallback onTap;

  const UpcomingItem({required this.manga, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: _upcomingItemHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Cover image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 56,
                  height: _upcomingItemHeight - 16,
                  child: Image(
                    image: _getImageProvider(ref),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.broken_image, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Title
              Expanded(
                child: Text(
                  manga.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(WidgetRef ref) {
    if (manga.customCoverImage != null) {
      return MemoryImage(manga.customCoverImage as Uint8List);
    }
    return CustomExtendedNetworkImageProvider(
      toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl ?? ''),
      headers: ref.watch(
        headersProvider(
          source: manga.source ?? '',
          lang: manga.lang ?? '',
          sourceId: manga.sourceId,
        ),
      ),
    );
  }
}

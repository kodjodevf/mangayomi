import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

const _upcomingItemHeight = 96.0;

class UpcomingItem extends ConsumerWidget {
  final Manga manga;
  final VoidCallback onTap;

  const UpcomingItem({required this.manga, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final days = manga.smartUpdateDays;
    return ShioriListRow(
      leading: ShioriThumbnail(
        height: _upcomingItemHeight - ShioriSpace.s16,
        child: Image(
          image: _getImageProvider(ref),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) =>
              const Center(child: Icon(Symbols.broken_image_rounded, size: 24)),
        ),
      ),
      title: manga.name ?? '',
      titleMaxLines: 2,
      // Where it comes from, and how often it has been coming out: what
      // "upcoming" is based on.
      subtitle: [
        ?manga.source,
        if (days != null) l10n.every_n_days(days),
      ].join(' · '),
      onTap: onTap,
    );
  }

  ImageProvider _getImageProvider(WidgetRef ref) {
    if (manga.customCoverImage != null) {
      return MemoryImage(manga.customCoverImage as Uint8List);
    }
    return coverProvider(
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

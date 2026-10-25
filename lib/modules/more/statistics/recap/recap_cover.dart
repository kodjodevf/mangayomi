import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

final recapMangaProvider = FutureProvider.autoDispose.family<Manga?, int>(
  (ref, id) => mangaRepository.findByIdAsync(id),
);

/// A series' cover the way the rest of the app loads it (custom cover,
/// tracker cover, source headers), or [placeholder] until it's known.
class RecapCover extends ConsumerWidget {
  const RecapCover({
    super.key,
    required this.mangaId,
    required this.placeholder,
    this.width,
    this.height,
  });

  final int mangaId;
  final Color placeholder;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = ref.watch(recapMangaProvider(mangaId)).value;
    final fallback = SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: placeholder),
    );
    if (manga == null) return fallback;
    if (manga.customCoverImage != null) {
      return Image.memory(
        manga.customCoverImage as Uint8List,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    return cachedCompressedNetworkImage(
      headers: ref.watch(
        headersProvider(
          source: manga.source!,
          lang: manga.lang!,
          sourceId: manga.sourceId,
        ),
      ),
      imageUrl: toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl ?? ''),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: fallback,
    );
  }
}

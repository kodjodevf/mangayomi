import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:shiori/shiori.dart';

final recapMangaProvider = FutureProvider.autoDispose.family<Manga?, int>(
  (ref, id) => mangaRepository.findByIdAsync(id),
);

/// A series' cover the way the rest of the app loads it (custom cover,
/// tracker cover, source headers), or [placeholder] until it's known.
///
/// With [showTitle], a series without a cover, or whose cover won't load,
/// shows its title on the placeholder instead of an empty box.
class RecapCover extends ConsumerWidget {
  const RecapCover({
    super.key,
    required this.mangaId,
    required this.placeholder,
    this.width,
    this.height,
    this.showTitle = false,
    this.titlePadding = const EdgeInsets.all(ShioriSpace.s8),
  });

  final int mangaId;
  final Color placeholder;
  final double? width;
  final double? height;
  final bool showTitle;

  /// Keeps the title off any part of the cover something else hides.
  final EdgeInsets titlePadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = ref.watch(recapMangaProvider(mangaId)).value;
    Widget box([Widget? child]) => SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: placeholder, child: child),
    );
    if (manga == null) return box();
    if (manga.customCoverImage != null) {
      return Image.memory(
        manga.customCoverImage as Uint8List,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
    final missing = showTitle && manga.name != null
        ? box(_Title(manga.name!, ground: placeholder, padding: titlePadding))
        : box();
    final url = manga.customCoverFromTracker ?? manga.imageUrl ?? '';
    if (url.isEmpty) return missing;
    // Same guard as the library: an orphaned entry has no source or lang.
    final canUseSourceHeaders =
        !(manga.isLocalArchive ?? false) &&
        manga.source != null &&
        manga.lang != null;
    return cachedCompressedNetworkImage(
      headers: canUseSourceHeaders
          ? ref.watch(
              headersProvider(
                source: manga.source!,
                lang: manga.lang!,
                sourceId: manga.sourceId,
              ),
            )
          : null,
      imageUrl: toImgUrl(url),
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: missing,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.title, {required this.ground, required this.padding});

  static const _size = 12.0;
  static const _minSize = 8.0;

  final String title;
  final Color ground;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final dark =
        ThemeData.estimateBrightnessForColor(ground) == Brightness.dark;
    final base = DefaultTextStyle.of(context).style.merge(
      TextStyle(
        fontSize: _size,
        fontWeight: FontWeight.w600,
        height: 1.2,
        // shiori: ink on the recap's fixed cover placeholder, not a theme surface.
        color: dark ? Colors.white70 : Colors.black87,
      ),
    );
    return Padding(
      padding: padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Shrink until the longest word fits, so no word splits mid-way.
          final longest = title
              .split(RegExp(r'\s+'))
              .map(
                (word) => (TextPainter(
                  text: TextSpan(text: word, style: base),
                  textDirection: Directionality.of(context),
                  textScaler: MediaQuery.textScalerOf(context),
                )..layout()).width,
              )
              .fold(0.0, max);
          final size = longest > constraints.maxWidth
              ? max(_minSize, _size * constraints.maxWidth / longest)
              : _size;
          return Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: base.copyWith(fontSize: size),
            ),
          );
        },
      ),
    );
  }
}

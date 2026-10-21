import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

class MassMigrationSourceIcon extends StatelessWidget {
  const MassMigrationSourceIcon({required this.source, super.key});

  final Source? source;

  @override
  Widget build(BuildContext context) => SourceIcon(iconUrl: source?.iconUrl);
}

class MassMigrationCover extends ConsumerWidget {
  const MassMigrationCover({
    this.libraryItem,
    this.remoteItem,
    this.source,
    this.width = 72,
    this.height = 104,
    super.key,
  });

  final Manga? libraryItem;
  final MManga? remoteItem;
  final Source? source;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customCover = libraryItem?.customCoverImage;
    if (customCover != null && customCover.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        child: Image.memory(
          Uint8List.fromList(customCover),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      );
    }

    final imageUrl = toImgUrl(
      remoteItem?.imageUrl ??
          libraryItem?.customCoverFromTracker ??
          libraryItem?.imageUrl ??
          '',
    );
    final headers =
        source == null ||
            (source!.name?.isEmpty ?? true) ||
            (source!.lang?.isEmpty ?? true)
        ? null
        : ref.watch(
            headersProvider(
              source: source!.name!,
              lang: source!.lang!,
              sourceId: source!.id,
            ),
          );

    return ClipRRect(
      borderRadius: BorderRadius.circular(ShioriShape.cover),
      child: cachedNetworkImage(
        headers: headers,
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorWidget: Container(
          width: width,
          height: height,
          color: context.shiori.color.ink2,
          child: const Icon(Symbols.image_not_supported_rounded),
        ),
      ),
    );
  }
}

class MassMigrationChapterSection extends StatelessWidget {
  const MassMigrationChapterSection({
    required this.title,
    required this.chapters,
    super.key,
  });

  final String title;
  final List<String> chapters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      dense: true,
      title: Text.rich(
        TextSpan(
          text: title,
          children: [
            TextSpan(
              text: ' · ${chapters.length}',
              style: TextStyle(
                color: context.shiori.color.fgMuted,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
      children: [
        if (chapters.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.mass_migration_no_chapters_found,
                style: context.shiori.caption,
              ),
            ),
          )
        else
          ...chapters
              .take(12)
              .map(
                (chapter) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    chapter,
                    style: context.shiori.text.row.copyWith(
                      color: context.shiori.color.fg,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
        if (chapters.length > 12)
          Padding(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.mass_migration_and_more_chapters(chapters.length - 12),
                style: context.shiori.caption,
              ),
            ),
          ),
      ],
    );
  }
}

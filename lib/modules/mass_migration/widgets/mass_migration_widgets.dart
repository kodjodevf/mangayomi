import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

class MassMigrationSourceIcon extends StatelessWidget {
  const MassMigrationSourceIcon({required this.source, super.key});

  final Source? source;

  @override
  Widget build(BuildContext context) {
    final iconUrl = source?.iconUrl ?? '';
    return Container(
      height: 37,
      width: 37,
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: iconUrl.isEmpty
          ? const Icon(Icons.extension_rounded)
          : cachedNetworkImage(
              imageUrl: iconUrl,
              fit: BoxFit.contain,
              width: 37,
              height: 37,
              errorWidget: const SizedBox(
                width: 37,
                height: 37,
                child: Center(child: Icon(Icons.extension_rounded)),
              ),
              useCustomNetworkImage: false,
            ),
    );
  }
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
        borderRadius: BorderRadius.circular(8),
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
      borderRadius: BorderRadius.circular(8),
      child: cachedNetworkImage(
        headers: headers,
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorWidget: Container(
          width: width,
          height: height,
          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.4),
          child: const Icon(Icons.image_not_supported_outlined),
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
      title: Text('$title (${chapters.length})'),
      children: [
        if (chapters.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.mass_migration_no_chapters_found),
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
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
        if (chapters.length > 12)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.mass_migration_and_more_chapters(chapters.length - 12),
              ),
            ),
          ),
      ],
    );
  }
}

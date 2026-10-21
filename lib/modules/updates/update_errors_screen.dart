import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/services/update_errors_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';

/// Persistent list of the last library update's failures. Each entry can be
/// dismissed or migrated away, so recurring source failures don't have to be
/// caught in the transient post-update dialog.
///
/// Failures are grouped by source: a source that is down fails for every
/// series it holds, usually with the same message, and reads as one group
/// with that message said once rather than a wall of identical rows.
class UpdateErrorsScreen extends ConsumerWidget {
  const UpdateErrorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final errors = ref.watch(updateErrorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.update_errors),
        actions: [
          if (errors.isNotEmpty)
            IconButton(
              tooltip: l10n.clear_all,
              icon: const Icon(Symbols.clear_all_rounded, fill: 1),
              onPressed: () => ref.read(updateErrorsProvider.notifier).clear(),
            ),
        ],
      ),
      body: errors.isEmpty
          ? ShioriEmptyState(
              icon: Symbols.check_circle_rounded,
              title: l10n.no_update_errors,
              compact: true,
            )
          : _groups(context, ref, errors),
    );
  }

  Widget _groups(
    BuildContext context,
    WidgetRef ref,
    List<UpdateError> errors,
  ) {
    final l10n = context.l10n;
    // Source name → its failures, in the order they first appear.
    final groups = <String, List<(UpdateError, Manga?)>>{};
    for (final err in errors) {
      final manga = mangaRepository.findById(err.mangaId);
      final source = (manga?.source ?? '').isEmpty
          ? l10n.mass_migration_unknown_source
          : manga!.source!;
      groups.putIfAbsent(source, () => []).add((err, manga));
    }
    return ListView(
      children: [
        for (final MapEntry(key: source, value: entries) in groups.entries)
          ..._group(context, ref, source, entries),
      ],
    );
  }

  List<Widget> _group(
    BuildContext context,
    WidgetRef ref,
    String source,
    List<(UpdateError, Manga?)> entries,
  ) {
    final tokens = context.shiori;
    final messages = entries.map((e) => e.$1.error.trim()).toSet();
    // Said once under the source when every series failed the same way.
    final shared = messages.length == 1 ? messages.first : null;
    return [
      ShioriSectionHeader(title: source, count: entries.length, overline: true),
      if (shared != null && shared.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            0,
            ShioriSpace.s16,
            ShioriSpace.s8,
          ),
          child: Text(
            shared,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: tokens.text.meta.copyWith(
              color: tokens.color.error.foreground,
            ),
          ),
        ),
      for (final (err, manga) in entries)
        ShioriListRow(
          leading: ShioriThumbnail(child: _cover(context, ref, manga)),
          title: err.name,
          subtitle: shared == null ? err.error : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (manga != null)
                IconButton(
                  tooltip: context.l10n.migrate,
                  icon: const Icon(Symbols.swap_horiz_rounded),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MigrationScreen(manga: manga),
                    ),
                  ),
                ),
              IconButton(
                tooltip: context.l10n.dismiss,
                icon: const Icon(Symbols.close_rounded),
                onPressed: () =>
                    ref.read(updateErrorsProvider.notifier).remove(err.mangaId),
              ),
            ],
          ),
        ),
    ];
  }

  /// The series' cover as the other lists draw it: the custom one, else the
  /// tracker's or the source's, with the source's headers.
  Widget _cover(BuildContext context, WidgetRef ref, Manga? manga) {
    final placeholder = Icon(
      Symbols.image_rounded,
      color: context.shiori.color.fgMuted,
    );
    if (manga == null) return placeholder;
    final custom = manga.customCoverImage;
    if (custom != null && custom.isNotEmpty) {
      return Image.memory(Uint8List.fromList(custom), fit: BoxFit.cover);
    }
    final url = manga.customCoverFromTracker ?? manga.imageUrl ?? '';
    if (url.isEmpty || manga.source == null) return placeholder;
    return Image(
      image: coverProvider(
        toImgUrl(url),
        headers: ref.watch(
          headersProvider(
            source: manga.source!,
            lang: manga.lang ?? '',
            sourceId: manga.sourceId,
          ),
        ),
      ),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

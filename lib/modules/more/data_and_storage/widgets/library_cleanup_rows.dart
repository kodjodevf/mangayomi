import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

/// The actions that remove series from the database: what is not in the
/// library, the library by kind, and the local library. They lived under
/// Browse, which is about sources; they sit with the library's upkeep now.
class LibraryCleanupRows extends ConsumerWidget {
  const LibraryCleanupRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShioriSettingRow(
          icon: Symbols.cleaning_services_rounded,
          title: l10n.clean_database,
          subtitle: l10n.clean_database_desc,
          destructive: true,
          onTap: () => _wipe(context, ref, mangaRepository.getNonFavorites()),
        ),
        ShioriSettingRow(
          icon: Symbols.delete_rounded,
          title: l10n.clear_library,
          subtitle: l10n.clear_library_desc,
          destructive: true,
          onTap: () => _clearLibrary(context, ref),
        ),
        ShioriSettingRow(
          icon: Symbols.folder_delete_rounded,
          title: l10n.clear_local_library,
          subtitle: l10n.clear_local_library_desc,
          destructive: true,
          onTap: () => _wipe(
            context,
            ref,
            mangaRepository.getBySourceLocalOrArchive(),
            message: l10n.clear_local_library_msg,
          ),
        ),
      ],
    );
  }
}

/// Asks which kinds to remove, ticked rather than typed, then removes them.
Future<void> _clearLibrary(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final types = await showShioriMultiChoice<ItemType>(
    context,
    title: l10n.clear_library,
    confirmLabel: l10n.remove,
    options: [
      ShioriChoice(ItemType.manga, l10n.manga),
      ShioriChoice(ItemType.anime, l10n.anime),
      ShioriChoice(ItemType.novel, l10n.novel),
    ],
  );
  if (types == null || types.isEmpty || !context.mounted) return;
  await _wipe(context, ref, mangaRepository.getByItemTypeNames(types));
}

/// Removes [mangas] after saying how many, which is the one number the
/// reader needs before an action that can't be undone.
Future<void> _wipe(
  BuildContext context,
  WidgetRef ref,
  List<Manga> mangas, {
  String? message,
}) async {
  final l10n = context.l10n;
  final confirmed = await showShioriConfirm(
    context,
    title: l10n.remove_entries_confirm(mangas.length),
    message: message,
    confirmLabel: l10n.remove,
    destructive: true,
  );
  if (!confirmed) return;
  mangaRepository.wipeMangas(mangas);
  botToast(l10n.cleaned_database(mangas.length));
}

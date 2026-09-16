// The detail screen's overflow menu actions (update check, categories,
// share link, migrate, view source, export metadata, mass migration),
// shared by the popup menu off-TV and the centred TV menu. Split out of
// _MangaDetailViewState so this dispatch logic - which has nothing to do
// with rendering - can be read and changed without touching the 800+ line
// build method it used to sit next to.
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/export_metadata.dart';
import 'package:mangayomi/modules/widgets/category_selection_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

Future<void> handleDetailOverflowAction({
  required int value,
  required BuildContext context,
  required WidgetRef ref,
  required Manga manga,
  required bool isLocalArchive,
  required void Function(bool) checkForUpdate,
}) async {
  final l10n = l10nLocalizations(context)!;
  switch (value) {
    case 0:
      checkForUpdate(true);
      break;
    case 1:
      showCategorySelectionDialog(
        context: context,
        ref: ref,
        itemType: manga.itemType,
        singleManga: manga,
      );
      break;
    case 2:
      final source = getSource(
        manga.lang!,
        manga.source!,
        manga.sourceId,
        installedOnly: true,
      );
      if (source == null) return;
      final url = "${source.baseUrl}${manga.link!.getUrlWithoutDomain}";
      final box = context.findRenderObject() as RenderBox?;
      shareOrCopy(
        ShareParams(
          text: url,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        ),
      );
      break;
    case 3:
      context.push("/migrate", extra: manga);
      break;
    case 4:
      final source = getSource(
        manga.lang!,
        manga.source!,
        manga.sourceId,
        installedOnly: true,
      );
      if (source == null) return;
      context.push('/extension_detail', extra: source);
      break;
    case 5:
      try {
        final result = await FilePicker.getDirectoryPath(
          linuxOptions: const LinuxOptions(lockParentWindow: true),
        );
        if (result != null) {
          final headers = isLocalArchive
              ? null
              : ref.read(
                  headersProvider(
                    source: manga.source!,
                    lang: manga.lang!,
                    sourceId: manga.sourceId,
                  ),
                );
          await exportMangaMetadata(
            manga: manga,
            directory: Directory(result),
            headers: headers,
          );
          botToast(l10n.exported);
        }
      } catch (e) {
        botToast(l10n.failed_to_export_metadata(e));
      }
      break;
    case 6:
      context.push("/massMigration", extra: (manga.itemType, manga));
      break;
  }
}

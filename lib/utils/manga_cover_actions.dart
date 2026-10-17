import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

/// Shows the "use this as cover" confirmation.
/// Returns whether the user confirmed.
Future<bool> confirmUseAsMangaCover(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(context.l10n.use_this_as_cover_art),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            const SizedBox(width: 15),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.ok),
            ),
          ],
        ),
      ],
    ),
  );
  return res ?? false;
}

/// Applies [bytes] as [manga]'s custom cover and saves it
Future<void> applyMangaCover(
  BuildContext context,
  Manga manga,
  Uint8List? bytes,
) async {
  final coverImage = bytes?.getCoverImage;
  if (coverImage == null) return;
  await mangaRepository.save(manga..customCoverImage = coverImage);
  if (context.mounted) botToast(context.l10n.cover_updated, second: 3);
}

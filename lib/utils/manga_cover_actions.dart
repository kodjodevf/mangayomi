import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/manga_repository.dart';

extension Uint8ListExtensions on Uint8List {
  Uint8List? get getCoverImage {
    final length = lengthInBytes / (1024 * 1024);
    if (length < 5) {
      return this;
    }
    botToast(
      "Cover image is larger than 5MB (${length.toStringAsFixed(2)}MB). Skipping cover image.",
    );
    return null;
  }
}

/// Shows the "use this as cover" confirmation.
/// Returns whether the user confirmed.
Future<bool> confirmUseAsMangaCover(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (context) => ShioriDialog(
      title: context.l10n.use_this_as_cover_art,
      actions: [
        ShioriButton.quiet(
          label: context.l10n.cancel,
          onPressed: () => Navigator.pop(context, false),
        ),
        ShioriButton(
          label: context.l10n.ok,
          onPressed: () => Navigator.pop(context, true),
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

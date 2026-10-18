import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Confirms whether to split an imported EPUB into one chapter per file.
/// Shared by the detail page's tablet header and its non-tablet
/// [MangaInfoHeader] "add chapters" buttons.
Future<bool> showSplitChaptersDialog(BuildContext context) async {
  final l10n = l10nLocalizations(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (context) => ShioriDialog(
          title: l10n.split_epub_chapters,
          content: Text(l10n.split_epub_chapters_description),
          actions: [
            ShioriButton.quiet(
              label: l10n.cancel,
              onPressed: () => Navigator.pop(context, false),
            ),
            ShioriButton(
              label: l10n.split_epub_chapters,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ) ??
      true;
}

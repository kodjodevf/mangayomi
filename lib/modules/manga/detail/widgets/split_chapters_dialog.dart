import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Confirms whether to split an imported EPUB into one chapter per file.
/// Shared by the detail page's tablet header and its non-tablet
/// [MangaInfoHeader] "add chapters" buttons.
Future<bool> showSplitChaptersDialog(BuildContext context) async {
  final l10n = l10nLocalizations(context)!;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.split_epub_chapters),
          content: Text(l10n.split_epub_chapters_description),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.split_epub_chapters),
            ),
          ],
        ),
      ) ??
      true;
}

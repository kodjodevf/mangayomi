import 'package:flutter/material.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:shiori/shiori.dart';

/// Shows a dialog allowing the user to edit name and description of a local archive title.
void showEditLocalArchiveDialog(
  BuildContext context, {
  required Manga manga,
  required AppLocalizations l10n,
}) {
  final nameController = TextEditingController(text: manga.name ?? '');
  final descriptionController = TextEditingController(
    text: manga.description ?? '',
  );

  showDialog(
    context: context,
    builder: (context) => ShioriDialog(
      title: l10n.edit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s16,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          TextField(
            controller: descriptionController,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(labelText: l10n.description),
          ),
        ],
      ),
      actions: [
        ShioriButton.quiet(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context),
        ),
        ShioriButton(
          label: l10n.save,
          onPressed: () {
            manga.description = descriptionController.text;
            manga.name = nameController.text;
            mangaRepository.save(manga);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

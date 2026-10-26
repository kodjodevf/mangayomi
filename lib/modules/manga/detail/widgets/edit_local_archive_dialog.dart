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
  showDialog<void>(
    context: context,
    builder: (context) => _EditLocalArchiveDialog(manga: manga, l10n: l10n),
  );
}

class _EditLocalArchiveDialog extends StatefulWidget {
  final Manga manga;
  final AppLocalizations l10n;

  const _EditLocalArchiveDialog({required this.manga, required this.l10n});

  @override
  State<_EditLocalArchiveDialog> createState() =>
      _EditLocalArchiveDialogState();
}

class _EditLocalArchiveDialogState extends State<_EditLocalArchiveDialog> {
  late final _nameController = TextEditingController(
    text: widget.manga.name ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.manga.description ?? '',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ShioriDialog(
      title: l10n.edit,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s16,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.name),
          ),
          TextField(
            controller: _descriptionController,
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
            widget.manga.description = _descriptionController.text;
            widget.manga.name = _nameController.text;
            mangaRepository.save(widget.manga);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

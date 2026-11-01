import 'package:flutter/material.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/extension_update.dart';
import 'package:shiori/shiori.dart';

/// What to do with the updates that come from another repository when
/// updating everything.
enum ForeignUpdatesChoice { includeThem, skipThem }

/// Asks once, for all of [foreign] together, whether "Update all" takes the
/// updates another repository offers. Each extension then follows that
/// repository, so the same one is not asked about again.
///
/// Null when dismissed: nothing is updated. [hasOthers] says whether anything
/// is left to update without them; if not, skipping them is no choice.
Future<ForeignUpdatesChoice?> showForeignUpdatesDialog(
  BuildContext context, {
  required List<Source> foreign,
  required bool hasOthers,
}) {
  final l10n = context.l10n;
  return showDialog<ForeignUpdatesChoice>(
    context: context,
    builder: (dialogContext) {
      final tokens = dialogContext.shiori;
      return ShioriDialog(
        title: l10n.update_all_foreign,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s12,
            children: [
              Text(l10n.update_all_foreign_msg),
              for (final source in foreign)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.name ?? '',
                      style: tokens.text.row.copyWith(color: tokens.color.fg),
                    ),
                    Text(
                      '${repoLabel(source.repo, source.updateRepo)} → '
                      '${repoLabel(source.updateRepo, source.repo)}',
                      style: tokens.caption,
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          ShioriButton.quiet(
            label: MaterialLocalizations.of(dialogContext).cancelButtonLabel,
            onPressed: () => Navigator.pop(dialogContext),
          ),
          if (hasOthers)
            ShioriButton.secondary(
              label: l10n.update_all_skip_foreign,
              onPressed: () =>
                  Navigator.pop(dialogContext, ForeignUpdatesChoice.skipThem),
            ),
          ShioriButton(
            label: l10n.update_all,
            onPressed: () =>
                Navigator.pop(dialogContext, ForeignUpdatesChoice.includeThem),
          ),
        ],
      );
    },
  );
}

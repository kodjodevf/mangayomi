import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/title_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The Prologue's title page: all time, before the log began.
class ProloguePanel extends StatelessWidget {
  const ProloguePanel({super.key, required this.data, required this.text});

  final StatusWindowData data;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final since = data.since;
    return TitlePanel(
      label: l10n.recapPrologue.toUpperCase(),
      title: l10n.recapStripPrologueTitle,
      tagline: since == null
          ? l10n.recapStripPrologueUndated
          : l10n.recapStripPrologueSince(monthLabel(context, since)),
      coverIds: [for (final s in data.bonded) s.id],
      text: text,
    );
  }
}

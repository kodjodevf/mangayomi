import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_routes.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The way into the monthly Episodes.
class SwGate extends StatelessWidget {
  const SwGate({super.key, required this.itemType, required this.text});

  final ItemType itemType;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: SwShape.window,
        onTap: () => context.push(episodeListLocation(itemType)),
        child: Ink(
          padding: const EdgeInsets.all(ShioriSpace.s16),
          decoration: BoxDecoration(
            borderRadius: SwShape.window,
            border: Border.all(color: SwColors.rose),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                SwColors.rose.withAlpha(56),
                SwColors.violet.withAlpha(56),
              ],
            ),
            boxShadow: [
              BoxShadow(color: SwColors.rose.withAlpha(89), blurRadius: 22),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ShioriSpace.s4,
            children: [
              Text(
                l10n.recapGateTitle,
                style: text.label.copyWith(color: SwColors.rose),
              ),
              Text(l10n.recapGateHeadline, style: text.gateTitle),
              Text(
                l10n.recapGateBody(l10n.recapUnits(2, itemType.name)),
                style: text.body,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: recapIconText(
                  l10n.recapGateEnter,
                  Symbols.play_arrow_rounded,
                  text.bodyStrong.copyWith(color: SwColors.rose),
                  trailing: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

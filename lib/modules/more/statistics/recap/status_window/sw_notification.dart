import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// One system message built from a real number, a different one each day.
class SwNotification extends StatelessWidget {
  const SwNotification({
    super.key,
    required this.data,
    required this.itemType,
    required this.text,
  });

  final StatusWindowData data;
  final ItemType itemType;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final type = itemType.name;
    final hours = wholeHours(data.totalSeconds);
    final top = data.bonded.isEmpty ? null : data.bonded.first;
    final candidates = [
      if (hours > 0) l10n.recapNotifyHours(formatCount(context, hours), type),
      if (data.units > 0)
        l10n.recapNotifyUnits(
          formatCount(context, data.units),
          type,
          l10n.recapUnits(data.units, type),
        ),
      if (data.libraryCount > 0)
        l10n.recapNotifyLibrary(formatCount(context, data.libraryCount)),
      if (top != null && wholeHours(top.seconds) > 0)
        l10n.recapNotifyTop(tenthHours(context, top.seconds), top.name),
    ];
    final message = candidates.isEmpty
        ? l10n.recapNotifyEmpty(type)
        : candidates[DateTime.now().day % candidates.length];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s12,
        vertical: ShioriSpace.s8,
      ),
      decoration: BoxDecoration(
        color: SwColors.toastFill,
        borderRadius: SwShape.toast,
        border: Border.all(color: SwColors.border),
        boxShadow: const [BoxShadow(color: SwColors.glow, blurRadius: 18)],
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${l10n.recapNotificationTag}  ',
              style: text.body.copyWith(color: SwColors.cyan),
            ),
            TextSpan(text: message),
          ],
        ),
        style: text.body,
      ),
    );
  }
}

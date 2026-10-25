import 'package:flutter/material.dart' hide Badge;
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Titles earned from real milestones. A locked one shows "???" and what it
/// takes.
class SwBadges extends StatelessWidget {
  const SwBadges({
    super.key,
    required this.badges,
    required this.itemType,
    required this.text,
  });

  final List<Badge> badges;
  final ItemType itemType;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Earned titles first, in their usual order.
    final ordered = [
      ...badges.where((b) => b.unlocked),
      ...badges.where((b) => !b.unlocked),
    ];
    return SwWindow(
      title: l10n.recapTitlesTitle,
      text: text,
      child: Column(
        spacing: ShioriSpace.s8,
        children: [
          for (var i = 0; i < ordered.length; i += 2)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: ShioriSpace.s8,
                children: [
                  Expanded(child: _tile(context, l10n, ordered[i])),
                  Expanded(
                    child: i + 1 < ordered.length
                        ? _tile(context, l10n, ordered[i + 1])
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, AppLocalizations l10n, Badge badge) {
    final (name, detail, goal) = _copy(context, l10n, badge);
    final locked = !badge.unlocked;
    return Container(
      padding: const EdgeInsets.all(ShioriSpace.s8),
      decoration: BoxDecoration(
        borderRadius: SwShape.window,
        border: Border.all(
          color: locked ? SwColors.hairline : SwColors.gold.withAlpha(115),
        ),
        color: locked ? null : SwColors.gold.withAlpha(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locked ? l10n.recapLocked : name,
            style: locked
                ? text.badgeName.copyWith(color: SwColors.muted)
                : text.badgeName,
          ),
          Text(locked ? goal : detail, style: text.badgeDetail),
        ],
      ),
    );
  }

  /// Name, detail when earned, and the goal when locked.
  (String, String, String) _copy(
    BuildContext context,
    AppLocalizations l10n,
    Badge badge,
  ) {
    final type = itemType.name;
    final value = formatCount(context, badge.value);
    String units(int count) => l10n.recapUnits(count, type);
    return switch (badge.id) {
      BadgeId.regressor => (
        l10n.recapBadgeRegressor,
        l10n.recapBadgeRegressorDetail(value),
        l10n.recapBadgeRegressorGoal,
      ),
      BadgeId.sourceLoyalist => (
        badge.label == null
            ? l10n.recapBadgeLoyalistName
            : l10n.recapBadgeLoyalist(badge.label!),
        l10n.recapBadgeLoyalistDetail(value, badge.label ?? ''),
        l10n.recapBadgeLoyalistGoal,
      ),
      BadgeId.marathoner => (
        l10n.recapBadgeMarathoner,
        l10n.recapBadgeMarathonerDetail(
          value,
          badge.label ?? '',
          units(badge.value),
        ),
        l10n.recapBadgeMarathonerGoal(units(300)),
      ),
      BadgeId.collector => (
        l10n.recapBadgeCollector,
        l10n.recapBadgeCollectorDetail(value),
        l10n.recapBadgeCollectorGoal,
      ),
      BadgeId.dawnCultivator => (
        l10n.recapBadgeDawn,
        l10n.recapBadgePeakDetail(_hour(context, badge.value)),
        l10n.recapBadgeDawnGoal,
      ),
      BadgeId.nightOwl => (
        l10n.recapBadgeNightOwl,
        l10n.recapBadgePeakDetail(_hour(context, badge.value)),
        l10n.recapBadgeNightOwlGoal,
      ),
      BadgeId.completionist => (
        l10n.recapBadgeCompletionist,
        l10n.recapBadgeCompletionistDetail(value),
        l10n.recapBadgeCompletionistGoal,
      ),
      BadgeId.veteran => (
        l10n.recapBadgeVeteran,
        l10n.recapBadgeVeteranDetail(value),
        l10n.recapBadgeVeteranGoal,
      ),
      BadgeId.binger => (
        l10n.recapBadgeBinger,
        l10n.recapBadgeBingerDetail(value, units(badge.value)),
        l10n.recapBadgeBingerGoal(units(100)),
      ),
    };
  }

  String _hour(BuildContext context, int hour) =>
      hour < 0 ? '' : hourLabel(context, hour);
}

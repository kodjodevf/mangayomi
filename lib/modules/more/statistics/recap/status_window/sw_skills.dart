import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

String rankLabel(SkillRank rank) => rank.name.toUpperCase();

/// Genres as skill bars, ranked SSS to D by share of the library.
class SwSkills extends StatelessWidget {
  const SwSkills({super.key, required this.skills, required this.text});

  final List<Skill> skills;
  final SwText text;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SwWindow(
      title: l10n.recapSkillsTitle,
      text: text,
      child: skills.isEmpty
          ? Text(l10n.recapSkillsEmpty, style: text.body)
          : Column(
              spacing: ShioriSpace.s8,
              children: [for (final skill in skills) _row(skill)],
            ),
    );
  }

  Widget _row(Skill skill) {
    final shining = skill.rank.index <= SkillRank.s.index;
    return Row(
      spacing: ShioriSpace.s8,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            skill.genre,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.body,
          ),
        ),
        Expanded(child: SwBar(value: skill.share)),
        SizedBox(
          width: 36,
          child: Text(
            rankLabel(skill.rank),
            textAlign: TextAlign.end,
            style: shining
                ? text.rank.copyWith(
                    color: SwColors.gold,
                    shadows: const [
                      Shadow(color: SwColors.gold, blurRadius: 8),
                    ],
                  )
                : skill.rank == SkillRank.d
                ? text.rank.copyWith(color: SwColors.muted)
                : text.rank,
          ),
        ),
      ],
    );
  }
}

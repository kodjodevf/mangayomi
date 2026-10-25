import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:shiori/shiori.dart';

/// Genres as a cloud of sound effects, biggest first.
class GenresPanel extends StatelessWidget {
  const GenresPanel({
    super.key,
    required this.genres,
    required this.label,
    required this.text,
  });

  static const _sizes = [64.0, 50.0, 38.0, 30.0, 24.0, 20.0, 16.0];
  static const _colors = [
    StripColors.paper,
    StripColors.red,
    StripColors.paper,
    StripColors.blue,
    StripColors.paper,
    StripColors.red,
    StripColors.paper,
  ];

  final List<Skill> genres;
  final String label;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    return StripPanel(
      height: null,
      color: StripColors.yellow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          ShioriSpace.s12,
          ShioriSpace.s24,
          ShioriSpace.s12,
          ShioriSpace.s24,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Text(label, textAlign: TextAlign.center, style: text.label),
              const SizedBox(height: ShioriSpace.s8),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: ShioriSpace.s8,
                children: [
                  for (final (i, skill) in genres.take(_sizes.length).indexed)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: StripSfx(
                          i == 0
                              ? '${skill.genre.toUpperCase()}!'
                              : skill.genre.toUpperCase(),
                          style: text.sfx(_sizes[i], color: _colors[i]),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

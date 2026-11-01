import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:shiori/shiori.dart';

/// The episode's title page: the month's covers behind its name.
class TitlePanel extends StatelessWidget {
  const TitlePanel({
    super.key,
    required this.label,
    required this.title,
    required this.tagline,
    required this.coverIds,
    required this.text,
  });

  static const _columns = 4;
  static const _rows = 2;

  final String label;
  final String title;
  final String tagline;
  final List<int> coverIds;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    return StripPanel(
      height: 300,
      color: StripColors.ink,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (coverIds.isNotEmpty)
            Opacity(
              opacity: 0.55,
              child: Column(
                spacing: 2,
                children: [
                  for (var row = 0; row < _rows; row++)
                    Expanded(
                      child: Row(
                        spacing: 2,
                        children: [
                          for (var col = 0; col < _columns; col++)
                            Expanded(
                              child: RecapCover(
                                mangaId:
                                    coverIds[(row * _columns + col) %
                                        coverIds.length],
                                placeholder: StripColors.coverPlaceholder,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [StripColors.veil, StripColors.shade],
              ),
            ),
          ),
          Positioned(
            left: ShioriSpace.s16,
            right: ShioriSpace.s16,
            bottom: ShioriSpace.s16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: text.label.copyWith(color: StripColors.yellow),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: StripSfx(title, stroke: 0, style: text.sfx(54)),
                ),
                Text(
                  tagline,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.body.copyWith(color: StripColors.paper),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

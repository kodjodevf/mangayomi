import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:shiori/shiori.dart';

/// Chapters (or episodes) as a big number, with the series lines under it.
class CountsPanel extends StatelessWidget {
  const CountsPanel({
    super.key,
    required this.count,
    required this.label,
    required this.lines,
    required this.text,
  });

  final int count;
  final String label;
  final List<String> lines;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    return StripPanel(
      height: 230,
      color: StripColors.sky,
      halftone: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // A long strip of panels running off the corner.
          Positioned(
            right: -6,
            bottom: -6,
            width: 110,
            height: 200,
            child: Transform.rotate(
              angle: 8 * pi / 180,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: StripShape.panelBorder),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      StripColors.paper,
                      StripColors.paper,
                      StripColors.ink,
                      StripColors.paper,
                      StripColors.paper,
                      StripColors.ink,
                      StripColors.paper,
                    ],
                    stops: [0, 0.3, 0.31, 0.32, 0.55, 0.56, 0.57],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: ShioriSpace.s16,
            top: ShioriSpace.s16,
            right: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: StripSfx(
                    formatCount(context, count),
                    style: text.numeral(58),
                  ),
                ),
                const SizedBox(height: ShioriSpace.s4),
                Text(label, style: text.heavy),
                const SizedBox(height: ShioriSpace.s8),
                for (final line in lines)
                  Text(
                    line,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.body,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

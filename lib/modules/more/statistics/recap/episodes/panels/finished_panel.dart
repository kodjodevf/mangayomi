import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Series finished or caught up this month, as tilted covers.
class FinishedPanel extends StatelessWidget {
  const FinishedPanel({super.key, required this.ids, required this.text});

  static const _shown = 5;
  static const _coverWidth = 92.0;
  static const _coverHeight = 132.0;
  static const _tilts = [-7.0, 4.0, -3.0, 6.0, -5.0];
  static const _drops = [8.0, 30.0, 4.0, 34.0, 14.0];

  /// Latest first.
  final List<int> ids;
  final StripText text;

  @override
  Widget build(BuildContext context) {
    final shown = ids.take(_shown).toList();
    return StripPanel(
      height: 250,
      color: StripColors.mint,
      halftone: true,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: ShioriSpace.s8,
            left: ShioriSpace.s8,
            right: ShioriSpace.s48,
            child: Align(
              alignment: Alignment.topLeft,
              child: StripCaption(
                '${context.l10n.recapStripFinishedLabel} · '
                '${context.l10n.recapStripFinishedCaption(ids.length)}',
                style: text,
              ),
            ),
          ),
          Positioned.fill(
            top: ShioriSpace.s48,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final room = constraints.maxWidth - 2 * ShioriSpace.s12;
                final step = shown.length < 2
                    ? 0.0
                    : min(
                        _coverWidth - ShioriSpace.s8,
                        (room - _coverWidth) / (shown.length - 1),
                      );
                return Stack(
                  children: [
                    for (final (i, id) in shown.indexed)
                      Positioned(
                        left: ShioriSpace.s12 + i * step,
                        top: _drops[i],
                        child: Transform.rotate(
                          angle: _tilts[i] * pi / 180,
                          child: GestureDetector(
                            onTap: () => openSeries(context, id),
                            child: Container(
                              width: _coverWidth,
                              height: _coverHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: StripShape.panelBorder,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: StripColors.ink,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: RecapCover(
                                mangaId: id,
                                placeholder: StripColors.coverPlaceholder,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

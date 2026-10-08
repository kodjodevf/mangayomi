import 'dart:math' as math;

import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';

class TemporaryPlaybackSpeedSelector extends StatelessWidget {
  const TemporaryPlaybackSpeedSelector({
    super.key,
    required this.position,
    required this.speed,
  });

  final Offset position;
  final double speed;

  static const double _width = 88;
  static const double _edgePadding = 8;
  static const double _fingerGap = 24;
  static const double _maximumItemExtent = 34;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedIndex = temporaryPlaybackSpeeds.indexOf(speed);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = math.max(
          0.0,
          constraints.maxHeight - (_edgePadding * 2),
        );
        final itemExtent = math.min(
          _maximumItemExtent,
          availableHeight / temporaryPlaybackSpeeds.length,
        );
        final selectorHeight = itemExtent * temporaryPlaybackSpeeds.length;
        final maxLeft = math.max(
          _edgePadding,
          constraints.maxWidth - _width - _edgePadding,
        );
        final preferredLeft =
            position.dx + _fingerGap + _width <=
                constraints.maxWidth - _edgePadding
            ? position.dx + _fingerGap
            : position.dx - _width - _fingerGap;
        final left = preferredLeft.clamp(_edgePadding, maxLeft).toDouble();
        final preferredTop =
            position.dy - (selectedIndex * itemExtent) - (itemExtent / 2);
        final maxTop = math.max(
          _edgePadding,
          constraints.maxHeight - selectorHeight - _edgePadding,
        );
        final top = preferredTop.clamp(_edgePadding, maxTop).toDouble();

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: _width,
              child: Semantics(
                label:
                    '${context.l10n.playback_speed}: ${temporaryPlaybackSpeedLabel(speed)}',
                liveRegion: true,
                child: Material(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.94,
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(18),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final level in temporaryPlaybackSpeeds)
                        AnimatedContainer(
                          key: ValueKey('temporary-speed-$level'),
                          duration: const Duration(milliseconds: 100),
                          height: itemExtent,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: level == speed
                                ? colorScheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            temporaryPlaybackSpeedLabel(level),
                            style: (textTheme.labelLarge ?? const TextStyle())
                                .copyWith(
                                  color: level == speed
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: level == speed
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

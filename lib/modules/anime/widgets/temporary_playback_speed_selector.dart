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

  static const double _width = 76;
  static const double _height = 48;
  static const double _edgePadding = 12;
  static const double _fingerGap = 20;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLeft = (constraints.maxWidth - _width - _edgePadding).clamp(
          _edgePadding,
          double.infinity,
        );
        final preferredLeft =
            position.dx + _fingerGap + _width <=
                constraints.maxWidth - _edgePadding
            ? position.dx + _fingerGap
            : position.dx - _width - _fingerGap;
        final left = preferredLeft.clamp(_edgePadding, maxLeft).toDouble();
        final maxTop = (constraints.maxHeight - _height - _edgePadding).clamp(
          _edgePadding,
          double.infinity,
        );
        final top = (position.dy - (_height / 2))
            .clamp(_edgePadding, maxTop)
            .toDouble();

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: _width,
              height: _height,
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
                  borderRadius: BorderRadius.circular(_height / 2),
                  clipBehavior: Clip.antiAlias,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        temporaryPlaybackSpeedLabel(speed),
                        key: ValueKey(speed),
                        style: (textTheme.titleMedium ?? const TextStyle())
                            .copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w800,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ),
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

import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:shiori/shiori.dart';

class TemporaryPlaybackSpeedSelector extends StatelessWidget {
  const TemporaryPlaybackSpeedSelector({super.key, required this.speed});

  final double speed;

  static const double _width = 58;
  static const double _height = 34;

  /// Clears the 48-point control row, its 30-point bottom offset, and a
  /// 12-point visual gap in portrait.
  static const double portraitBottomClearance = 90;
  static const double _landscapeTopInset = 12;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final edgePadding = isPortrait
        ? EdgeInsets.only(
            bottom: mediaQuery.viewPadding.bottom + portraitBottomClearance,
          )
        : EdgeInsets.only(
            top: mediaQuery.viewPadding.top > _landscapeTopInset
                ? mediaQuery.viewPadding.top
                : _landscapeTopInset,
          );

    return Padding(
      padding: edgePadding,
      child: Align(
        alignment: isPortrait ? Alignment.bottomCenter : Alignment.topCenter,
        child: Semantics(
          container: true,
          label:
              '${context.l10n.playback_speed}: ${temporaryPlaybackSpeedLabel(speed)}',
          liveRegion: true,
          child: ConstrainedBox(
            key: const ValueKey('temporary-speed-indicator'),
            constraints: const BoxConstraints(
              minWidth: _width,
              minHeight: _height,
            ),
            child: PlayerOverlaySurface(
              padding: const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s12,
                vertical: ShioriSpace.s4,
              ),
              child: ExcludeSemantics(
                child: AnimatedSwitcher(
                  duration: ShioriMotion.fast,
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    temporaryPlaybackSpeedLabel(speed),
                    key: ValueKey(speed),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
          child: Material(
            key: const ValueKey('temporary-speed-indicator'),
            color: colorScheme.scrim.withValues(alpha: 0.68),
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.25),
            shape: StadiumBorder(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
            ),
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _width,
                minHeight: _height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ExcludeSemantics(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Text(
                      temporaryPlaybackSpeedLabel(speed),
                      key: ValueKey(speed),
                      textAlign: TextAlign.center,
                      style: (textTheme.labelLarge ?? const TextStyle())
                          .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                    ),
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

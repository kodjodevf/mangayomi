import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

class MediaIndicatorBuilder extends StatelessWidget {
  final bool isVolumeIndicator;
  final bool adaptiveMobilePlacement;
  final bool showAtZero;
  final ValueNotifier<double> value;
  const MediaIndicatorBuilder({
    super.key,
    required this.value,
    required this.isVolumeIndicator,
    this.adaptiveMobilePlacement = false,
    this.showAtZero = false,
  });

  IconData _icon(double value) => isVolumeIndicator
      ? switch (value) {
          == 0.0 => Symbols.volume_off_rounded,
          < 0.5 => Symbols.volume_down_rounded,
          _ => Symbols.volume_up_rounded,
        }
      : switch (value) {
          < 1.0 / 3.0 => Symbols.brightness_low_rounded,
          < 2.0 / 3.0 => Symbols.brightness_medium_rounded,
          _ => Symbols.brightness_high_rounded,
        };

  @override
  Widget build(BuildContext context) {
    // On a phone the level stands on the side the thumb slides on, the
    // brightness left and the volume right, as a gauge that fills: the
    // finger and the figure in the same place.
    if (adaptiveMobilePlacement) {
      final insets = MediaQuery.viewPaddingOf(context);
      final landscape =
          MediaQuery.orientationOf(context) == Orientation.landscape;
      return ValueListenableBuilder(
        valueListenable: value,
        builder: (context, value, _) => Visibility(
          visible: showAtZero || value > 0,
          child: IgnorePointer(
            child: Align(
              alignment: isVolumeIndicator
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: insets.left + ShioriSpace.s32,
                  end: insets.right + ShioriSpace.s32,
                ),
                child: ShioriGestureGauge(
                  key: ValueKey(
                    isVolumeIndicator
                        ? 'volume-indicator-card'
                        : 'brightness-indicator-card',
                  ),
                  value: value,
                  icon: _icon(value),
                  label: isVolumeIndicator
                      ? context.l10n.volume
                      : context.l10n.brightness,
                  height: landscape ? 120 : 160,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // On desktop, a card under the top bar, set by the wheel.
    const top = 80.0;

    return ValueListenableBuilder(
      valueListenable: value,
      builder: (context, value, child) => Visibility(
        visible: showAtZero || value > 0,
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: top),
              child: SizedBox(
                key: ValueKey(
                  isVolumeIndicator
                      ? 'volume-indicator-card'
                      : 'brightness-indicator-card',
                ),
                height: 42,
                width: 210,
                child: PlayerOverlaySurface(
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ShioriSpace.s12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(fill: 1, _icon(value), size: 20),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ShioriSpace.s12,
                              ),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    ShioriShape.pill,
                                  ),
                                ),
                                child: SizedBox(
                                  height: 6,
                                  child: LinearProgressIndicator(
                                    value: value,
                                    color: context.shiori.color.accentInk,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: Alphas.hairline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            fill: 1,
                            _icon(value),
                            size: 16,
                            color: Colors.white.withValues(
                              alpha: Alphas.secondary,
                            ),
                          ),
                        ],
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

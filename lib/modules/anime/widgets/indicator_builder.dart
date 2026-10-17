import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final portraitTop = math.max(
      mediaQuery.viewPadding.top + 72,
      mediaQuery.size.height * 0.18,
    );
    final top = adaptiveMobilePlacement
        ? (MediaQuery.orientationOf(context) == Orientation.portrait
              ? portraitTop.clamp(0.0, 240.0).toDouble()
              : mediaQuery.viewPadding.top + 72)
        : 80.0;

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
                          Icon(
                            fill: 1,
                            isVolumeIndicator
                                ? switch (value) {
                                    == 0.0 => Symbols.volume_off_rounded,
                                    < 0.5 => Symbols.volume_down_rounded,
                                    _ => Symbols.volume_up_rounded,
                                  }
                                : switch (value) {
                                    < 1.0 / 3.0 =>
                                      Symbols.brightness_low_rounded,
                                    < 2.0 / 3.0 =>
                                      Symbols.brightness_medium_rounded,
                                    _ => Symbols.brightness_high_rounded,
                                  },
                            size: 20,
                          ),
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
                            isVolumeIndicator
                                ? switch (value) {
                                    == 0.0 => Symbols.volume_off_rounded,
                                    < 0.5 => Symbols.volume_down_rounded,
                                    _ => Symbols.volume_up_rounded,
                                  }
                                : switch (value) {
                                    < 1.0 / 3.0 =>
                                      Symbols.brightness_low_rounded,
                                    < 2.0 / 3.0 =>
                                      Symbols.brightness_medium_rounded,
                                    _ => Symbols.brightness_high_rounded,
                                  },
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

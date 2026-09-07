import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_theme.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MediaIndicatorBuilder extends StatelessWidget {
  final bool isVolumeIndicator;
  final ValueNotifier<double> value;
  const MediaIndicatorBuilder({
    super.key,
    required this.value,
    required this.isVolumeIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: value,
      builder: (context, value, child) => Visibility(
        visible: value > 0,
        child: IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 40,
                  width: 200,
                  color: PlayerTheme.glassStrong,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isVolumeIndicator
                                ? switch (value) {
                                    == 0.0 => Icons.volume_off,
                                    < 0.5 => Icons.volume_down,
                                    _ => Icons.volume_up,
                                  }
                                : switch (value) {
                                    < 1.0 / 3.0 => Icons.brightness_low,
                                    < 2.0 / 3.0 => Icons.brightness_medium,
                                    _ => Icons.brightness_high,
                                  },
                            color: PlayerTheme.ink,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: SizedBox.fromSize(
                                  size: const Size(130, 20),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    color: context.primaryColor,
                                    backgroundColor: PlayerTheme.trackIdle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            isVolumeIndicator
                                ? switch (value) {
                                    == 0.0 => Icons.volume_off,
                                    < 0.5 => Icons.volume_down,
                                    _ => Icons.volume_up,
                                  }
                                : switch (value) {
                                    < 1.0 / 3.0 => Icons.brightness_low,
                                    < 2.0 / 3.0 => Icons.brightness_medium,
                                    _ => Icons.brightness_high,
                                  },
                            size: 16,
                            color: PlayerTheme.ink,
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

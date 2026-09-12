import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 42,
                  width: 210,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.92,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: SizedBox(
                                  height: 6,
                                  child: LinearProgressIndicator(
                                    value: value,
                                    color: colorScheme.primary,
                                    backgroundColor: colorScheme.onSurface
                                        .withValues(alpha: 0.18),
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
                            color: colorScheme.onSurfaceVariant,
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

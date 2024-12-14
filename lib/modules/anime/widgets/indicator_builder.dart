import 'package:flutter/material.dart';

class MediaIndicatorBuilder extends StatelessWidget {
  final bool isVolumeIndicator;
  final ValueNotifier<double> value;
  const MediaIndicatorBuilder({super.key, required this.value, required this.isVolumeIndicator});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: value,
        builder: (context, value, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: isVolumeIndicator ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    width: 30,
                    child: UnconstrainedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              (value * 100).ceil().toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: SizedBox.fromSize(
                                      size: const Size(130, 20),
                                      child:
                                          LinearProgressIndicator(value: value, backgroundColor: Colors.transparent)),
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
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

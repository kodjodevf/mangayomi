import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shiori/shiori.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final height = sliderTheme.trackHeight;
    final left = offset.dx;
    final top = offset.dy + (parentBox.size.height - height!) / 2;
    final width = parentBox.size.width;
    return Rect.fromLTWH(left, top, width, height);
  }
}

/// MaterialDesktop design volume button & slider.
class CustomMaterialDesktopVolumeButton extends StatefulWidget {
  final VideoController controller;

  const CustomMaterialDesktopVolumeButton({
    super.key,
    required this.controller,
  });

  @override
  CustomMaterialDesktopVolumeButtonState createState() =>
      CustomMaterialDesktopVolumeButtonState();
}

class CustomMaterialDesktopVolumeButtonState
    extends State<CustomMaterialDesktopVolumeButton>
    with SingleTickerProviderStateMixin {
  late double volume = widget.controller.player.state.volume;

  StreamSubscription<double>? subscription;

  bool hover = false;

  bool mute = false;
  double _volume = 0.0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??= widget.controller.player.stream.volume.listen((event) {
      setState(() {
        volume = event;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() {
          hover = true;
        });
      },
      onExit: (e) {
        setState(() {
          hover = false;
        });
      },
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            if (event.scrollDelta.dy < 0) {
              widget.controller.player.setVolume(
                (volume + 5.0).clamp(0.0, 100.0),
              );
            }
            if (event.scrollDelta.dy > 0) {
              widget.controller.player.setVolume(
                (volume - 5.0).clamp(0.0, 100.0),
              );
            }
          }
        },
        child: Row(
          children: [
            const SizedBox(width: ShioriSpace.s4),
            AnimatedContainer(
              duration: ShioriMotion.fast,
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hover
                    ? Colors.white.withValues(alpha: Alphas.hairline)
                    : Colors.transparent,
              ),
              child: IconButton(
                tooltip: mute ? context.l10n.unmute : context.l10n.mute,
                onPressed: () async {
                  if (mute) {
                    await widget.controller.player.setVolume(_volume);
                    mute = !mute;
                  }
                  // https://github.com/media-kit/media-kit/pull/250#issuecomment-1605588306
                  else if (volume == 0.0) {
                    _volume = 100.0;
                    await widget.controller.player.setVolume(100.0);
                    mute = false;
                  } else {
                    _volume = volume;
                    await widget.controller.player.setVolume(0.0);
                    mute = !mute;
                  }

                  setState(() {});
                },
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: context.shiori.density.minTarget,
                  minHeight: context.shiori.density.minTarget,
                ),
                color: Colors.white,
                icon: AnimatedSwitcher(
                  duration: ShioriMotion.fast,
                  child: volume == 0.0
                      ? const Icon(
                          Symbols.volume_off_rounded,
                          fill: 1,
                          key: ValueKey(Symbols.volume_off_rounded),
                        )
                      : volume < 50.0
                      ? const Icon(
                          Symbols.volume_down_rounded,
                          fill: 1,
                          key: ValueKey(Symbols.volume_down_rounded),
                        )
                      : const Icon(
                          Symbols.volume_up_rounded,
                          fill: 1,
                          key: ValueKey(Symbols.volume_up_rounded),
                        ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: hover ? 1.0 : 0.0,
              duration: ShioriMotion.fast,
              child: AnimatedContainer(
                width: hover ? (12.0 + 52.0 + 18.0) : 12.0,
                duration: ShioriMotion.fast,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: ShioriSpace.s12),
                      SizedBox(
                        width: 52.0,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 1.2,
                            inactiveTrackColor: Colors.white.withValues(
                              alpha: Alphas.hairline,
                            ),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12 / 2,
                              elevation: 0.0,
                              pressedElevation: 0.0,
                            ),
                            trackShape: CustomTrackShape(),
                            overlayColor: Colors.transparent,
                          ),
                          child: Slider(
                            value: volume.clamp(0.0, 100.0),
                            min: 0.0,
                            max: 100.0,
                            onChanged: (value) async {
                              await widget.controller.player.setVolume(value);
                              mute = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: ShioriSpace.s16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

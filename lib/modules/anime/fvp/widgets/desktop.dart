import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/anime_player_view.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/fvp/widgets/custom_seekbar.dart';
import 'package:mangayomi/modules/anime/fvp/widgets/subtitle_view.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:video_player/video_player.dart';
import 'package:window_manager/window_manager.dart';

class DesktopControllerWidget extends StatefulWidget {
  final Function(Duration?) tempDuration;
  final AnimeStreamController streamController;
  final VideoPlayerController videoController;
  final Widget topButtonBarWidget;
  final Widget bottomButtonBarWidget;
  final Widget seekToWidget;
  final bool isFullScreen;
  const DesktopControllerWidget(
      {super.key,
      required this.videoController,
      required this.topButtonBarWidget,
      required this.bottomButtonBarWidget,
      required this.streamController,
      required this.seekToWidget,
      required this.tempDuration,
      required this.isFullScreen});

  @override
  State<DesktopControllerWidget> createState() =>
      _DesktopControllerWidgetState();
}

class _DesktopControllerWidgetState extends State<DesktopControllerWidget> {
  bool mount = true;
  bool visible = true;
  Duration controlsTransitionDuration = const Duration(milliseconds: 300);
  Color backdropColor = const Color(0x66000000);
  Timer? _timer;

  int swipeDuration = 0; // Duration to seek in video
  bool showSwipeDuration = false; // Whether to show the seek duration overlay

  late bool buffering = widget.videoController.value.isBuffering;
  final controlsHoverDuration = const Duration(seconds: 3);
  double buttonBarHeight = 100;
  final bottomButtonBarMargin = const EdgeInsets.only(left: 16.0, right: 8.0);

  DateTime last = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!mounted) return;
    widget.videoController.addListener(
      () {
        setState(() {
          buffering = widget.videoController.value.isBuffering;
        });
      },
    );

    _timer = Timer(
      controlsHoverDuration,
      () {
        if (mounted) {
          setState(() {
            visible = false;
          });
        }
      },
    );
  }

  void onHover() {
    setState(() {
      mount = true;
      visible = true;
    });

    _timer?.cancel();
    _timer = Timer(controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
        });
      }
    });
  }

  void onEnter() {
    setState(() {
      mount = true;
      visible = true;
    });

    _timer?.cancel();
    _timer = Timer(controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
        });
      }
    });
  }

  void onExit() {
    setState(() {
      visible = false;
    });

    _timer?.cancel();
  }

  final bool modifyVolumeOnScroll = true;
  final bool toggleFullscreenOnDoublePress = true;
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
            widget.videoController.play(),
        const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
            widget.videoController.pause(),
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
            widget.videoController.value.isPlaying
                ? widget.videoController.pause()
                : widget.videoController.play(),
        const SingleActivator(LogicalKeyboardKey.space): () =>
            widget.videoController.value.isPlaying
                ? widget.videoController.pause()
                : widget.videoController.play(),
        const SingleActivator(LogicalKeyboardKey.keyJ): () {
          final rate = widget.videoController.value.position -
              const Duration(seconds: 10);
          widget.videoController.seekTo(rate);
        },
        const SingleActivator(LogicalKeyboardKey.keyI): () {
          final rate = widget.videoController.value.position +
              const Duration(seconds: 10);
          widget.videoController.seekTo(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          final rate = widget.videoController.value.position -
              const Duration(seconds: 2);
          widget.videoController.seekTo(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          final rate = widget.videoController.value.position +
              const Duration(seconds: 2);
          widget.videoController.seekTo(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          final volume = widget.videoController.value.volume + 5.0;
          widget.videoController.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          final volume = widget.videoController.value.volume - 5.0;
          widget.videoController.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.keyF): () => setFullScreen(),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            setFullScreen(value: false),
      },
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, _) => Positioned(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: CustomSubtitleView(
                controller: widget.videoController,
              ),
            )),
          ),
          Focus(
            autofocus: true,
            child: Listener(
              onPointerSignal: modifyVolumeOnScroll
                  ? (e) {
                      if (e is PointerScrollEvent) {
                        if (e.delta.dy > 0) {
                          final volume =
                              widget.videoController.value.volume - 5.0;
                          widget.videoController
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              widget.videoController.value.volume + 5.0;
                          widget.videoController
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                      }
                    }
                  : null,
              child: GestureDetector(
                onTapUp: !toggleFullscreenOnDoublePress
                    ? null
                    : (e) {
                        final now = DateTime.now();
                        final difference = now.difference(last);
                        last = now;
                        if (difference < const Duration(milliseconds: 400)) {
                          setFullScreen();
                        }
                      },
                onPanUpdate: modifyVolumeOnScroll
                    ? (e) {
                        if (e.delta.dy > 0) {
                          final volume =
                              widget.videoController.value.volume - 5.0;
                          widget.videoController
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              widget.videoController.value.volume + 5.0;
                          widget.videoController
                              .setVolume(volume.clamp(0.0, 100.0));
                        }
                      }
                    : null,
                child: MouseRegion(
                  onHover: (_) => onHover(),
                  onEnter: (_) => onEnter(),
                  onExit: (_) => onExit(),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        curve: Curves.easeInOut,
                        opacity: visible ? 1.0 : 0.0,
                        duration: controlsTransitionDuration,
                        onEnd: () {
                          if (!visible) {
                            setState(() {
                              mount = false;
                            });
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            // Top gradient.

                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.0,
                                    0.2,
                                  ],
                                  colors: [
                                    Color(0x61000000),
                                    Color(0x00000000),
                                  ],
                                ),
                              ),
                            ),
                            // Bottom gradient.

                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [
                                    0.5,
                                    1.0,
                                  ],
                                  colors: [
                                    Color(0x00000000),
                                    Color(0x61000000),
                                  ],
                                ),
                              ),
                            ),
                            if (mount)
                              Padding(
                                padding: (widget.isFullScreen
                                    ? MediaQuery.of(context).padding
                                    : EdgeInsets.zero),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    widget.topButtonBarWidget,
                                    // Only display [primaryButtonBar] if [buffering] is false.
                                    Expanded(
                                      child: AnimatedOpacity(
                                          curve: Curves.easeInOut,
                                          opacity: buffering
                                              ? 0.0
                                              : !showSwipeDuration
                                                  ? 0.0
                                                  : 1.0,
                                          duration: controlsTransitionDuration,
                                          child: Center(
                                              child: seekIndicatorTextWidget(
                                                  Duration(
                                                      seconds: swipeDuration),
                                                  widget.videoController.value
                                                      .position))),
                                    ),
                                    widget.seekToWidget,
                                    Transform.translate(
                                      offset: Offset.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: CustomSeekBar(
                                          onSeekStart: (value) {
                                            setState(() {
                                              swipeDuration = value.inSeconds;
                                              showSwipeDuration = true;
                                              widget.tempDuration(widget
                                                      .videoController
                                                      .value
                                                      .position +
                                                  value);
                                            });
                                            _timer?.cancel();
                                          },
                                          onSeekEnd: (value) {
                                            _timer = Timer(
                                              controlsHoverDuration,
                                              () {
                                                if (mounted) {
                                                  setState(() {
                                                    visible = false;
                                                  });
                                                }
                                              },
                                            );
                                            setState(() {
                                              showSwipeDuration = false;
                                            });
                                            widget.tempDuration(null);
                                          },
                                          controller: widget.videoController,
                                        ),
                                      ),
                                    ),
                                    widget.bottomButtonBarWidget
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Buffering Indicator.
                      IgnorePointer(
                        child: Padding(
                          padding: (widget.isFullScreen
                              ? MediaQuery.of(context).padding
                              : EdgeInsets.zero),
                          child: Column(
                            children: [
                              Container(
                                height: buttonBarHeight,
                                margin: const EdgeInsets.all(0),
                              ),
                              Expanded(
                                child: Center(
                                  child: Center(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: buffering ? 1.0 : 0.0,
                                      ),
                                      duration: controlsTransitionDuration,
                                      builder: (context, value, child) {
                                        // Only mount the buffering indicator if the opacity is greater than 0.0.
                                        // This has been done to prevent redundant resource usage in [CircularProgressIndicator].
                                        if (value > 0.0) {
                                          return Opacity(
                                            opacity: value,
                                            child: child!,
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                      child: const CircularProgressIndicator(
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: buttonBarHeight,
                                margin: bottomButtonBarMargin,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BUTTON: PLAY/PAUSE

/// A material design play/pause button.
class CustomeMaterialDesktopPlayOrPauseButton extends StatefulWidget {
  final VideoPlayerController controller;

  const CustomeMaterialDesktopPlayOrPauseButton({
    super.key,
    required this.controller,
  });

  @override
  CustomeMaterialDesktopPlayOrPauseButtonState createState() =>
      CustomeMaterialDesktopPlayOrPauseButtonState();
}

class CustomeMaterialDesktopPlayOrPauseButtonState
    extends State<CustomeMaterialDesktopPlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: widget.controller.value.isPlaying ? 1 : 0,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(() {
      if (!mounted) return;
      final isPlaying = widget.controller.value.isPlaying;
      if (isPlaying) {
        animation.forward();
      } else {
        animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => widget.controller.value.isPlaying
          ? widget.controller.pause()
          : widget.controller.play(),
      iconSize: 25,
      color: Colors.white,
      icon: AnimatedIcon(
        progress: animation,
        icon: AnimatedIcons.play_pause,
        size: 25,
        color: Colors.white,
      ),
    );
  }
}

// BUTTON: VOLUME

/// MaterialDesktop design volume button & slider.
class CustomMaterialDesktopVolumeButton extends StatefulWidget {
  final VideoPlayerController controller;

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
  late double volume = widget.controller.value.volume;

  StreamSubscription<double>? subscription;

  bool hover = false;

  bool mute = false;
  double _volume = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    volume = widget.controller.value.volume;
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
              widget.controller.setVolume(volume + 0.1);
            }
            if (event.scrollDelta.dy > 0) {
              widget.controller.setVolume(volume - 0.1);
            }
          }
        },
        child: Row(
          children: [
            const SizedBox(width: 4.0),
            IconButton(
              onPressed: () async {
                if (mute) {
                  await widget.controller.setVolume(_volume);
                  mute = !mute;
                } else if (volume == 0.0) {
                  _volume = 1.0;
                  await widget.controller.setVolume(1.0);
                  mute = false;
                } else {
                  _volume = volume;
                  await widget.controller.setVolume(0.0);
                  mute = !mute;
                }

                setState(() {});
              },
              iconSize: 25,
              color: Colors.white,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: volume == 0.0
                    ? const Icon(
                        Icons.volume_off,
                        key: ValueKey(Icons.volume_off),
                      )
                    : volume < 0.5
                        ? const Icon(
                            Icons.volume_down,
                            key: ValueKey(Icons.volume_down),
                          )
                        : const Icon(
                            Icons.volume_up,
                            key: ValueKey(Icons.volume_up),
                          ),
              ),
            ),
            AnimatedOpacity(
              opacity: hover ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: AnimatedContainer(
                width: hover ? (12.0 + 52.0 + 18.0) : 12.0,
                duration: const Duration(milliseconds: 150),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 12.0),
                      SizedBox(
                        width: 52.0,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 1.2,
                            inactiveTrackColor: const Color(0x3DFFFFFF),
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12 / 2,
                              elevation: 0.0,
                              pressedElevation: 0.0,
                            ),
                            trackShape: _CustomTrackShape(),
                            overlayColor: const Color(0x00000000),
                          ),
                          child: Slider(
                            value: volume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (value) async {
                              await widget.controller.setVolume(value);
                              mute = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 18.0),
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

// POSITION INDICATOR

/// MaterialDesktop design position indicator.
class CustomMaterialDesktopPositionIndicator extends StatefulWidget {
  final VideoPlayerController controller;
  final Duration? delta;

  const CustomMaterialDesktopPositionIndicator(
      {super.key, required this.controller, this.delta});

  @override
  CustomMaterialDesktopPositionIndicatorState createState() =>
      CustomMaterialDesktopPositionIndicatorState();
}

class CustomMaterialDesktopPositionIndicatorState
    extends State<CustomMaterialDesktopPositionIndicator> {
  late Duration position = widget.controller.value.position;
  late Duration duration = widget.controller.value.duration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    position = widget.controller.value.position;
    duration = widget.controller.value.duration;
    return Text(
      '${(widget.delta ?? position).label(reference: duration)} / ${duration.label(reference: duration)}',
      style: const TextStyle(
        height: 1.0,
        fontSize: 12.0,
        color: Colors.white,
      ),
    );
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
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
    return Rect.fromLTWH(
      left,
      top,
      width,
      height,
    );
  }
}

class CustomMaterialDesktopFullscreenButton extends StatefulWidget {
  final VideoPlayerController controller;
  final Function(bool) isFullscreen;

  const CustomMaterialDesktopFullscreenButton({
    super.key,
    required this.controller,
    required this.isFullscreen,
  });

  @override
  State<CustomMaterialDesktopFullscreenButton> createState() =>
      _CustomMaterialDesktopFullscreenButtonState();
}

class _CustomMaterialDesktopFullscreenButtonState
    extends State<CustomMaterialDesktopFullscreenButton> {
  bool _isFullscreen = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final isFullScreen = await setFullScreen();
        setState(() {
          _isFullscreen = isFullScreen;
        });
        widget.isFullscreen(_isFullscreen);
      },
      icon: _isFullscreen
          ? const Icon(Icons.fullscreen_exit)
          : const Icon(Icons.fullscreen),
      iconSize: 25,
      color: Colors.white,
    );
  }
}

Future<bool> setFullScreen({bool? value}) async {
  if (value != null) {
    final isFullScreen = await windowManager.isFullScreen();
    if (value != isFullScreen) {
      await windowManager.setTitleBarStyle(
          value == false ? TitleBarStyle.normal : TitleBarStyle.hidden);
      await windowManager.setFullScreen(value);
      if (value == false) {
        await windowManager.center();
      }
      await windowManager.show();
    }
    return value;
  }
  final isFullScreen = await windowManager.isFullScreen();
  if (!isFullScreen) {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setFullScreen(true);
    await windowManager.show();
  } else {
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setFullScreen(false);
    await windowManager.center();
    await windowManager.show();
  }
  return isFullScreen;
}

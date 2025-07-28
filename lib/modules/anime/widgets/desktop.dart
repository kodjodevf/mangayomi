import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/anime_player_view.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/widgets/custom_seekbar.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:window_manager/window_manager.dart';

class DesktopControllerWidget extends ConsumerStatefulWidget {
  final Function(Duration?) tempDuration;
  final Function(bool?) doubleSpeed;
  final AnimeStreamController streamController;
  final VideoController videoController;
  final Widget topButtonBarWidget;
  final GlobalKey<VideoState> videoStatekey;
  final Widget bottomButtonBarWidget;
  final Widget seekToWidget;
  final int defaultSkipIntroLength;
  final void Function(bool) desktopFullScreenPlayer;
  final ValueNotifier<List<(String, int)>> chapterMarks;
  const DesktopControllerWidget({
    super.key,
    required this.videoController,
    required this.topButtonBarWidget,
    required this.bottomButtonBarWidget,
    required this.streamController,
    required this.videoStatekey,
    required this.seekToWidget,
    required this.tempDuration,
    required this.doubleSpeed,
    required this.defaultSkipIntroLength,
    required this.desktopFullScreenPlayer,
    required this.chapterMarks,
  });

  @override
  ConsumerState<DesktopControllerWidget> createState() =>
      _DesktopControllerWidgetState();
}

class _DesktopControllerWidgetState
    extends ConsumerState<DesktopControllerWidget> {
  bool mount = true;
  bool visible = true;
  bool cursorVisible = true;
  Duration controlsTransitionDuration = const Duration(milliseconds: 300);
  // Color backdropColor = const Color(0x66000000);
  Timer? _timer;

  int swipeDuration = 0; // Duration to seek in video
  bool showSwipeDuration = false; // Whether to show the seek duration overlay
  double previousPlaybackSpeed = -1;

  late bool buffering = widget.videoController.player.state.buffering;
  final controlsHoverDuration = const Duration(seconds: 3);
  double buttonBarHeight = 100;
  final bottomButtonBarMargin = const EdgeInsets.only(left: 16.0, right: 8.0);

  final List<StreamSubscription> subscriptions = [];
  DateTime last = DateTime.now();
  Timer? _tapTimer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        widget.videoController.player.stream.buffering.listen((event) {
          setState(() {
            buffering = event;
          });
        }),
      ]);

      _timer = Timer(controlsHoverDuration, () {
        if (mounted) {
          setState(() {
            visible = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    _timer?.cancel();
    _tapTimer?.cancel();
    super.dispose();
  }

  void onHover() {
    setState(() {
      mount = true;
      visible = true;
      cursorVisible = true;
    });

    _timer?.cancel();
    _timer = Timer(controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
          cursorVisible = false;
        });
      }
    });
  }

  void onEnter() {
    setState(() {
      mount = true;
      visible = true;
      cursorVisible = true;
    });

    _timer?.cancel();
    _timer = Timer(controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
          cursorVisible = false;
        });
      }
    });
  }

  void onExit() {
    setState(() {
      visible = false;
      cursorVisible = true;
    });

    _timer?.cancel();
  }

  final bool modifyVolumeOnScroll = true; // TODO. The variable is never changed
  final bool toggleFullscreenOnDoublePress = true; // TODO. variable not changed
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        // Default key-board shortcuts.
        // https://support.google.com/youtube/answer/7631406
        const SingleActivator(LogicalKeyboardKey.mediaPlay): () =>
            widget.videoController.player.play(),
        const SingleActivator(LogicalKeyboardKey.mediaPause): () =>
            widget.videoController.player.pause(),
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause): () =>
            widget.videoController.player.playOrPause(),
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext): () =>
            widget.videoController.player.next(),
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious): () =>
            widget.videoController.player.previous(),
        const SingleActivator(LogicalKeyboardKey.space): () =>
            widget.videoController.player.playOrPause(),
        const SingleActivator(LogicalKeyboardKey.keyJ): () {
          final rate =
              widget.videoController.player.state.position -
              const Duration(seconds: 10);
          widget.videoController.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.keyL): () {
          final rate =
              widget.videoController.player.state.position +
              const Duration(seconds: 10);
          widget.videoController.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.enter): () {
          final rate =
              widget.videoController.player.state.position +
              Duration(seconds: widget.defaultSkipIntroLength);
          widget.videoController.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          final rate =
              widget.videoController.player.state.position -
              const Duration(seconds: 5);
          widget.videoController.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          final rate =
              widget.videoController.player.state.position +
              const Duration(seconds: 5);
          widget.videoController.player.seek(rate);
        },
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          final volume = widget.videoController.player.state.volume + 5.0;
          widget.videoController.player.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          final volume = widget.videoController.player.state.volume - 5.0;
          widget.videoController.player.setVolume(volume.clamp(0.0, 100.0));
        },
        const SingleActivator(LogicalKeyboardKey.keyF): () async {
          await _changeFullScreen(ref, widget.desktopFullScreenPlayer);
        },
        const SingleActivator(LogicalKeyboardKey.escape): () async {
          final desktopFullScreenPlayer = widget.desktopFullScreenPlayer;
          await _changeFullScreen(ref, desktopFullScreenPlayer, value: false);
        },
        const SingleActivator(LogicalKeyboardKey.digit0, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "clear_anime",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_a",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_b",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_c",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit4, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_aa",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit5, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_bb",
          ]);
        },
        const SingleActivator(LogicalKeyboardKey.digit6, control: true): () {
          (widget.videoController.player.platform as NativePlayer).command([
            "script-message",
            "set_anime_ca",
          ]);
        },
      },
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, _) => ref.read(useLibassStateProvider)
                ? const SizedBox.shrink()
                : Positioned(
                    child: CustomSubtitleView(
                      controller: widget.videoController,
                      configuration: SubtitleViewConfiguration(
                        style: subtileTextStyle(ref),
                      ),
                    ),
                  ),
          ),
          Focus(
            autofocus: true,
            child: Listener(
              onPointerSignal: modifyVolumeOnScroll
                  ? (e) {
                      if (e is PointerScrollEvent) {
                        if (e.delta.dy > 0) {
                          final volume =
                              widget.videoController.player.state.volume - 5.0;
                          widget.videoController.player.setVolume(
                            volume.clamp(0.0, 100.0),
                          );
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              widget.videoController.player.state.volume + 5.0;
                          widget.videoController.player.setVolume(
                            volume.clamp(0.0, 100.0),
                          );
                        }
                      }
                    }
                  : null,
              child: GestureDetector(
                onTap: () {
                  // use own timer with onTapUp instead of onDoubleTap.
                  // onDoubleTap uses 300ms which feels laggy when pausing
                  // https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/gestures/constants.dart#L35
                  _tapTimer = Timer(const Duration(milliseconds: 100), () {
                    widget.videoController.player.playOrPause();
                  });
                },
                onLongPressStart: (e) {
                  previousPlaybackSpeed =
                      widget.videoController.player.state.rate;
                  widget.videoController.player.setRate(
                    previousPlaybackSpeed * 2,
                  );
                  widget.doubleSpeed(true);
                },
                onLongPressEnd: (e) {
                  if (previousPlaybackSpeed != -1) {
                    widget.videoController.player.setRate(
                      previousPlaybackSpeed,
                    );
                    previousPlaybackSpeed = -1;
                    widget.doubleSpeed(false);
                  }
                },
                onTapUp: !toggleFullscreenOnDoublePress
                    ? null
                    : (e) async {
                        final now = DateTime.now();
                        final difference = now.difference(last);
                        last = now;
                        if (difference < const Duration(milliseconds: 400)) {
                          _tapTimer?.cancel();
                          _tapTimer = null;
                          final fullScreen = widget.desktopFullScreenPlayer;
                          await _changeFullScreen(ref, fullScreen);
                        }
                      },
                onPanUpdate: modifyVolumeOnScroll
                    ? (e) {
                        if (e.delta.dy > 0) {
                          final volume =
                              widget.videoController.player.state.volume - 5.0;
                          widget.videoController.player.setVolume(
                            volume.clamp(0.0, 100.0),
                          );
                        }
                        if (e.delta.dy < 0) {
                          final volume =
                              widget.videoController.player.state.volume + 5.0;
                          widget.videoController.player.setVolume(
                            volume.clamp(0.0, 100.0),
                          );
                        }
                      }
                    : null,
                child: MouseRegion(
                  onHover: (_) => onHover(),
                  onEnter: (_) => onEnter(),
                  onExit: (_) => onExit(),
                  cursor: cursorVisible
                      ? SystemMouseCursors.basic
                      : SystemMouseCursors.none,
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
                                  stops: [0.0, 0.2],
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
                                  stops: [0.5, 1.0],
                                  colors: [
                                    Color(0x00000000),
                                    Color(0x61000000),
                                  ],
                                ),
                              ),
                            ),
                            if (mount)
                              Padding(
                                padding:
                                    (
                                    // Add padding in fullscreen!
                                    isFullscreen(context)
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
                                            Duration(seconds: swipeDuration),
                                            widget
                                                .videoController
                                                .player
                                                .state
                                                .position,
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.seekToWidget,
                                    Transform.translate(
                                      offset: Offset.zero,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: CustomSeekBar(
                                          onSeekStart: (value) {
                                            setState(() {
                                              swipeDuration = value.inSeconds;
                                              showSwipeDuration = true;
                                              widget.tempDuration(
                                                widget
                                                        .videoController
                                                        .player
                                                        .state
                                                        .position +
                                                    value,
                                              );
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
                                          player: widget.videoController.player,
                                          chapterMarks: widget.chapterMarks,
                                        ),
                                      ),
                                    ),
                                    widget.bottomButtonBarWidget,
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Buffering Indicator.
                      IgnorePointer(
                        child: Padding(
                          padding:
                              (
                              // Add padding in fullscreen!
                              isFullscreen(context)
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

Future<void> _changeFullScreen(
  WidgetRef ref,
  void Function(bool) setFullScreenCallback, {
  bool? value,
}) async {
  final isFullScreen = await setFullScreen(value: value);
  ref.read(fullscreenProvider.notifier).state = isFullScreen;
  setFullScreenCallback(isFullScreen);
}

// BUTTON: VOLUME

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
            const SizedBox(width: 4.0),
            IconButton(
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
              iconSize: 25,
              color: Colors.white,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: volume == 0.0
                    ? const Icon(
                        Icons.volume_off,
                        key: ValueKey(Icons.volume_off),
                      )
                    : volume < 50.0
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
  final VideoController controller;
  final Duration? delta;

  const CustomMaterialDesktopPositionIndicator({
    super.key,
    required this.controller,
    this.delta,
  });

  @override
  CustomMaterialDesktopPositionIndicatorState createState() =>
      CustomMaterialDesktopPositionIndicatorState();
}

class CustomMaterialDesktopPositionIndicatorState
    extends State<CustomMaterialDesktopPositionIndicator> {
  late Duration position = widget.controller.player.state.position;
  late Duration duration = widget.controller.player.state.duration;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        widget.controller.player.stream.position.listen((event) {
          setState(() {
            position = event;
          });
        }),
        widget.controller.player.stream.duration.listen((event) {
          setState(() {
            duration = event;
          });
        }),
      ]);
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedPosition = (widget.delta ?? position).clamp(
      Duration.zero,
      duration,
    );
    return Text(
      '${clampedPosition.label(reference: duration)} / ${duration.label(reference: duration)}',
      style: const TextStyle(height: 1.0, fontSize: 12.0, color: Colors.white),
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
    return Rect.fromLTWH(left, top, width, height);
  }
}

class CustomMaterialDesktopFullscreenButton extends ConsumerStatefulWidget {
  final VideoController controller;
  final void Function(bool) desktopFullScreenPlayer;

  const CustomMaterialDesktopFullscreenButton({
    super.key,
    required this.controller,
    required this.desktopFullScreenPlayer,
  });

  @override
  ConsumerState<CustomMaterialDesktopFullscreenButton> createState() =>
      _CustomMaterialDesktopFullscreenButtonState();
}

class _CustomMaterialDesktopFullscreenButtonState
    extends ConsumerState<CustomMaterialDesktopFullscreenButton> {
  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(fullscreenProvider);
    return IconButton(
      icon: isFullScreen
          ? const Icon(Icons.fullscreen_exit)
          : const Icon(Icons.fullscreen),
      iconSize: 25,
      color: Colors.white,
      onPressed: () async {
        await _changeFullScreen(ref, widget.desktopFullScreenPlayer);
      },
    );
  }
}

Future<bool> setFullScreen({bool? value}) async {
  if (value != null) {
    final isFullScreen = await windowManager.isFullScreen();
    if (value != isFullScreen) {
      await windowManager.setFullScreen(value);
    }
    return value;
  }
  final isFullScreen = await windowManager.isFullScreen();
  if (!isFullScreen) {
    await windowManager.setFullScreen(true);
  } else {
    await windowManager.setFullScreen(false);
  }
  return !isFullScreen;
}

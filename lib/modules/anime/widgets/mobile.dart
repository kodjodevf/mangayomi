// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/widgets/seek_indicator_text.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/modules/anime/widgets/custom_seekbar.dart';
import 'package:mangayomi/modules/anime/widgets/indicator_builder.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/anime/widgets/play_or_pause_button.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:mangayomi/modules/anime/widgets/temporary_playback_speed_selector.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_seek_indicator.dart';

class MobileControllerWidget extends ConsumerStatefulWidget {
  final AnimeStreamController streamController;
  final VideoController videoController;
  final Widget topButtonBarWidget;
  final GlobalKey<VideoState> videoStatekey;
  final Widget bottomButtonBarWidget;
  final ValueNotifier<List<(String, int)>> chapterMarks;
  // Bumped by the player on each d-pad key so the controls reveal on a TV remote.
  final ValueNotifier<int> revealControls;
  final ValueNotifier<bool>? isLocked;
  const MobileControllerWidget({
    super.key,
    required this.videoController,
    required this.topButtonBarWidget,
    required this.bottomButtonBarWidget,
    required this.streamController,
    required this.videoStatekey,
    required this.chapterMarks,
    required this.revealControls,
    this.isLocked,
  });

  @override
  ConsumerState<MobileControllerWidget> createState() =>
      _MobileControllerWidgetState();
}

class _MobileControllerWidgetState
    extends ConsumerState<MobileControllerWidget> {
  static const double _gestureInset = 16;

  bool mount = true;
  bool visible = true;
  // Wraps the control buttons; requestFocus()'d on reveal so the d-pad lands on
  // a real button (see _onRevealRequest).
  final FocusScopeNode _controlsScope = FocusScopeNode(
    debugLabel: 'playerControls',
  );
  // The center play/pause — focused first on reveal so the d-pad lands on the
  // main control rather than the top-bar back button.
  final FocusNode _playPauseFocus = FocusNode(debugLabel: 'playerPlayPause');
  Duration controlsTransitionDuration = const Duration(milliseconds: 300);
  Color backdropColor = const Color(0x66000000);
  Timer? _timer;
  late final skipDuration = ref.watch(
    defaultDoubleTapToSkipLengthStateProvider,
  );
  final ValueNotifier<double> _brightnessValue = ValueNotifier(0.0);
  final ValueNotifier<bool> _brightnessIndicator = ValueNotifier(false);
  StreamSubscription<double>? _brightnessSubscription;
  Timer? _brightnessTimer;

  final ValueNotifier<double> _volumeValue = ValueNotifier(0.0);
  final ValueNotifier<bool> _volumeIndicator = ValueNotifier(false);
  Timer? _volumeTimer;
  // The default event stream in package:volume_controller is buggy.
  bool _volumeInterceptEventStream = false;

  Offset _dragInitialDelta =
      Offset.zero; // Initial position for horizontal drag
  int swipeDuration = 0; // Duration to seek in video
  bool showSwipeDuration = false; // Whether to show the seek duration overlay
  double previousPlaybackSpeed = -1;
  double? _temporaryPlaybackSpeed;
  double? _temporaryInitialSpeed;
  double? _temporarySpeedOriginY;

  late bool buffering = widget.videoController.player.state.buffering;
  final controlsHoverDuration = const Duration(seconds: 3);
  bool _mountSeekBackwardButton = false;
  bool _mountSeekForwardButton = false;
  bool _hideSeekBackwardButton = false;
  bool _hideSeekForwardButton = false;
  double buttonBarHeight = 100;
  final bottomButtonBarMargin = const EdgeInsets.only(left: 16.0, right: 8.0);

  Duration? _seekBarDeltaValueNotifier;

  final List<StreamSubscription> subscriptions = [];
  Offset? _tapPosition;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _tapPosition = details.localPosition;
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final horizontalGestureSensitivity = 7500;
  final verticalGestureSensitivity = 500;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        widget.videoController.player.stream.buffering.listen((event) {
          setState(() {
            buffering = event;
            if (event) {
              _mountSeekBackwardButton = false;
              _mountSeekForwardButton = false;
              _hideSeekBackwardButton = false;
              _hideSeekForwardButton = false;
              _seekBarDeltaValueNotifier = null;
            }
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

  // Called by the player on each d-pad key: reveal the controls if hidden and
  // keep them on-screen while the user navigates the buttons with the remote.
  void _onRevealRequest() {
    if (!mounted) return;
    if (!visible) {
      setState(() {
        mount = true;
        visible = true;
      });
    }
    _restartHideTimer();
    // Move focus onto the controls only when it isn't already there. A
    // FocusScope delegates requestFocus to its first focusable descendant, so
    // this reliably lands the d-pad on a real button — unlike directional
    // traversal from the full-screen player Focus, which never landed anywhere.
    // Once focus is inside, subsequent keys navigate the buttons freely.
    if (!_controlsScope.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Prefer the center play/pause; fall back to the scope's first button.
        if (_playPauseFocus.canRequestFocus) {
          _playPauseFocus.requestFocus();
        } else {
          _controlsScope.requestFocus();
        }
      });
    }
  }

  void _onLockChanged() {
    if (!mounted) return;
    setState(() {});
    if (widget.isLocked?.value == true) {
      if (!visible) {
        setState(() {
          mount = true;
          visible = true;
        });
      }
      _restartHideTimer();
    }
  }

  @override
  void dispose() {
    _restorePlaybackSpeed(updateUi: false);
    widget.revealControls.removeListener(_onRevealRequest);
    widget.isLocked?.removeListener(_onLockChanged);
    _controlsScope.dispose();
    _playPauseFocus.dispose();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    _timer?.cancel();
    _volumeTimer?.cancel();
    _brightnessTimer?.cancel();
    _volumeValue.dispose();
    _volumeIndicator.dispose();
    _brightnessValue.dispose();
    _brightnessIndicator.dispose();
    _brightnessSubscription?.cancel();
    _volumeController.removeListener();

    // package:screen_brightness
    Future.microtask(() async {
      try {
        await ScreenBrightness.instance.resetApplicationScreenBrightness();
      } catch (_) {}
    });
    super.dispose();
  }

  void onTap() {
    if (!visible) {
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
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
        }
      });
    } else {
      setState(() {
        visible = false;
      });
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      _timer?.cancel();
    }
  }

  void _restartHideTimer() {
    _timer?.cancel();
    _timer = Timer(controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
        });
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    });
  }

  Duration _doubleTapSeekTarget(Duration offset, {required bool forward}) {
    final position = widget.videoController.player.state.position;
    final duration = widget.videoController.player.state.duration;
    final target = forward ? position + offset : position - offset;
    return target.clamp(Duration.zero, duration);
  }

  void _startDoubleTapSeek({required bool forward}) {
    _timer?.cancel();
    final offset = Duration(seconds: skipDuration);

    setState(() {
      mount = false;
      visible = false;
      _mountSeekForwardButton = forward;
      _mountSeekBackwardButton = !forward;
      _hideSeekForwardButton = false;
      _hideSeekBackwardButton = false;
      _seekBarDeltaValueNotifier = _doubleTapSeekTarget(
        offset,
        forward: forward,
      );
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void onDoubleTapSeekBackward() {
    _startDoubleTapSeek(forward: false);
  }

  void onDoubleTapSeekForward() {
    _startDoubleTapSeek(forward: true);
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_dragInitialDelta == Offset.zero) {
      _dragInitialDelta = details.localPosition;
      return;
    }

    final diff = _dragInitialDelta.dx - details.localPosition.dx;
    final duration = widget.videoController.player.state.duration.inSeconds;
    final position = widget.videoController.player.state.position.inSeconds;

    final seconds = -(diff * duration / horizontalGestureSensitivity).round();
    final relativePosition = position + seconds;

    if (relativePosition <= duration && relativePosition >= 0) {
      setState(() {
        swipeDuration = seconds;
        showSwipeDuration = true;
        _seekBarDeltaValueNotifier = Duration(
          seconds:
              widget.videoController.player.state.position.inSeconds + seconds,
        );
      });
    }
  }

  void onHorizontalDragEnd() {
    if (swipeDuration != 0) {
      Duration newPosition =
          widget.videoController.player.state.position +
          Duration(seconds: swipeDuration);
      newPosition = newPosition.clamp(
        Duration.zero,
        widget.videoController.player.state.duration,
      );
      widget.videoController.player.seek(newPosition);
    }

    setState(() {
      _dragInitialDelta = Offset.zero;
      showSwipeDuration = false;
      _seekBarDeltaValueNotifier = null;
    });
  }

  late final VolumeController _volumeController;
  @override
  void initState() {
    super.initState();
    widget.revealControls.addListener(_onRevealRequest);
    widget.isLocked?.addListener(_onLockChanged);
    _volumeController = VolumeController.instance;

    Future.microtask(() async {
      try {
        _volumeController.showSystemUI = false;
        _volumeValue.value = await _volumeController.getVolume();
        _volumeController.addListener((value) {
          if (mounted && !_volumeInterceptEventStream) {
            _volumeValue.value = value;
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _brightnessValue.value = await ScreenBrightness.instance.application;
        _brightnessSubscription = ScreenBrightness
            .instance
            .onApplicationScreenBrightnessChanged
            .listen((value) {
              if (mounted) {
                _brightnessValue.value = value;
              }
            });
      } catch (_) {}
    });
  }

  Future<void> setVolume(double value) async {
    try {
      _volumeController.setVolume(value);
    } catch (_) {}
    _volumeValue.value = value;
    _volumeIndicator.value = true;
    _volumeInterceptEventStream = true;
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _volumeIndicator.value = false;
        _volumeInterceptEventStream = false;
      }
    });
  }

  Future<void> setBrightness(double value) async {
    // package:screen_brightness
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(value);
    } catch (_) {}
    _brightnessIndicator.value = true;
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _brightnessIndicator.value = false;
      }
    });
  }

  void _startTemporaryPlaybackSpeed(LongPressStartDetails details) {
    if (widget.isLocked?.value == true || previousPlaybackSpeed != -1) return;

    previousPlaybackSpeed = widget.videoController.player.state.rate;
    final initialSpeed = initialTemporaryPlaybackSpeed();

    setState(() {
      _temporaryPlaybackSpeed = initialSpeed;
      _temporaryInitialSpeed = initialSpeed;
      _temporarySpeedOriginY = details.localPosition.dy;
    });
    HapticFeedback.mediumImpact();
    unawaited(widget.videoController.player.setRate(initialSpeed));
  }

  void _updateTemporaryPlaybackSpeed(LongPressMoveUpdateDetails details) {
    final initialSpeed = _temporaryInitialSpeed;
    final originY = _temporarySpeedOriginY;
    if (initialSpeed == null || originY == null) return;

    final speed = temporaryPlaybackSpeedForDrag(
      initialSpeed: initialSpeed,
      verticalDelta: details.localPosition.dy - originY,
    );
    final speedChanged = speed != _temporaryPlaybackSpeed;
    if (!speedChanged) return;

    setState(() {
      _temporaryPlaybackSpeed = speed;
    });

    HapticFeedback.selectionClick();
    unawaited(widget.videoController.player.setRate(speed));
  }

  void _restorePlaybackSpeed({bool updateUi = true}) {
    if (previousPlaybackSpeed == -1) return;

    final speedToRestore = previousPlaybackSpeed;
    previousPlaybackSpeed = -1;
    unawaited(widget.videoController.player.setRate(speedToRestore));

    void clearSelection() {
      _temporaryPlaybackSpeed = null;
      _temporaryInitialSpeed = null;
      _temporarySpeedOriginY = null;
    }

    if (updateUi && mounted) {
      setState(clearSelection);
    } else {
      clearSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final compactPortrait = usesCompactPortraitPlayerControls(
      orientation: MediaQuery.orientationOf(context),
      width: MediaQuery.sizeOf(context).width,
    );
    return Stack(
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
        FocusScope(
          node: _controlsScope,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // // Controls:
              AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: visible ? 1.0 : 0.0,
                duration: controlsTransitionDuration,
                onEnd: () {
                  setState(() {
                    if (!visible) {
                      mount = false;
                    }
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTap,
                        onLongPressStart: _startTemporaryPlaybackSpeed,
                        onLongPressMoveUpdate: _updateTemporaryPlaybackSpeed,
                        onLongPressEnd: (_) => _restorePlaybackSpeed(),
                        onLongPressCancel: _restorePlaybackSpeed,
                        child: Stack(
                          children: [
                            if (widget.isLocked?.value != true) ...[
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: compactPortrait ? 200 : 140,
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Theme.of(context).colorScheme.scrim
                                              .withValues(alpha: 0.75),
                                          Theme.of(context).colorScheme.scrim
                                              .withValues(alpha: 0.35),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.65, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 180,
                                child: IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Theme.of(context).colorScheme.scrim
                                              .withValues(alpha: 0.85),
                                          Theme.of(context).colorScheme.scrim
                                              .withValues(alpha: 0.40),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.70, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Positioned.fill(
                              child: Listener(
                                behavior: HitTestBehavior.translucent,
                                onPointerCancel: (_) => _restorePlaybackSpeed(),
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // We are adding 16.0 boundary around the actual controls (which contain the vertical drag gesture detectors).
                    // This will make the hit-test on edges (e.g. swiping to: show status-bar, show navigation-bar, go back in navigation) not activate the swipe gesture annoyingly.
                    Positioned.fill(
                      left: _gestureInset,
                      top: _gestureInset,
                      right: _gestureInset,
                      bottom: _gestureInset,
                      child: GestureDetector(
                        onTap: onTap,
                        onDoubleTapDown: _handleTapDown,
                        onDoubleTap: () {
                          if (widget.isLocked?.value == true) return;
                          if (_tapPosition != null &&
                              _tapPosition!.dx >
                                  (MediaQuery.sizeOf(context).width -
                                          (_gestureInset * 2)) /
                                      2) {
                            onDoubleTapSeekForward();
                          } else {
                            onDoubleTapSeekBackward();
                          }
                        },
                        // This detector is above the full-screen background
                        // detector in the Stack. It must own the long press as
                        // well as vertical drag so a completed hold wins the
                        // gesture arena before volume or brightness can start.
                        onLongPressStart: _startTemporaryPlaybackSpeed,
                        onLongPressMoveUpdate: _updateTemporaryPlaybackSpeed,
                        onLongPressEnd: (_) => _restorePlaybackSpeed(),
                        onLongPressCancel: _restorePlaybackSpeed,
                        onHorizontalDragUpdate: (details) {
                          if (widget.isLocked?.value == true) return;
                          onHorizontalDragUpdate(details);
                        },
                        onHorizontalDragEnd: (details) {
                          if (widget.isLocked?.value == true) return;
                          onHorizontalDragEnd();
                        },
                        onVerticalDragUpdate: (e) async {
                          if (widget.isLocked?.value == true) return;
                          final delta = e.delta.dy;
                          final Offset position = e.localPosition;

                          if (position.dx <=
                              MediaQuery.of(context).size.width / 2) {
                            // Left side of screen swiped

                            final brightness =
                                _brightnessValue.value -
                                delta / verticalGestureSensitivity;
                            final result = brightness.clamp(0.0, 1.0);
                            setBrightness(result);
                          } else {
                            // Right side of screen swiped

                            final volume =
                                _volumeValue.value -
                                delta / verticalGestureSensitivity;
                            final result = volume.clamp(0.0, 1.0);
                            setVolume(result);
                          }
                        },
                        child: Listener(
                          // A platform interruption can cancel the pointer
                          // after Flutter has accepted the long press.
                          behavior: HitTestBehavior.translucent,
                          onPointerCancel: (_) => _restorePlaybackSpeed(),
                          child: Container(color: const Color(0x00000000)),
                        ),
                      ),
                    ),
                    if (mount)
                      if (widget.isLocked?.value == true)
                        Positioned.fill(
                          child: MobilePlayerUnlockControl(
                            tooltip: context.l10n.unlock,
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              widget.isLocked?.value = false;
                              _restartHideTimer();
                            },
                          ),
                        )
                      else
                        MobilePlayerControlsOverlayLayout(
                          compactPortrait: compactPortrait,
                          safeInsets: MediaQuery.viewPaddingOf(context),
                          topControls: widget.topButtonBarWidget,
                          // Only display [primaryButtonBar] if [buffering] is false.
                          primaryControls: AnimatedOpacity(
                            curve: Curves.easeInOut,
                            opacity: buffering
                                ? 0.0
                                : showSwipeDuration
                                ? 0.0
                                : 1.0,
                            duration: controlsTransitionDuration,
                            child: Center(
                              // Brighter focus highlight on the main controls
                              // so the focused button stands out against the
                              // dark backdrop on a TV.
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  focusColor: Colors.white.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                                child: Row(
                                  children: mobilePrimaryButtonBar(
                                    context,
                                    widget.videoStatekey,
                                    widget.streamController,
                                    widget.videoController,
                                    playPauseFocus: _playPauseFocus,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          bottomControls: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CustomSeekBar(
                                  onSeekStart: (value) {
                                    setState(() {
                                      swipeDuration = value.inSeconds;
                                      showSwipeDuration = true;
                                    });
                                    _timer?.cancel();
                                  },
                                  onSeekEnd: (value) {
                                    _timer = Timer(controlsHoverDuration, () {
                                      if (mounted) {
                                        setState(() {
                                          visible = false;
                                        });
                                      }
                                    });
                                    setState(() {
                                      showSwipeDuration = false;
                                    });
                                  },
                                  player: widget.videoController.player,
                                  chapterMarks: widget.chapterMarks,
                                ),
                              ),
                              widget.bottomButtonBarWidget,
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              // // Double-Tap Seek Seek-Bar:
              if (!mount && widget.isLocked?.value != true)
                if (_mountSeekBackwardButton ||
                    _mountSeekForwardButton ||
                    showSwipeDuration)
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.viewPaddingOf(context).left,
                      right: MediaQuery.viewPaddingOf(context).right,
                      bottom: MediaQuery.viewPaddingOf(context).bottom,
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CustomSeekBar(
                                delta: _seekBarDeltaValueNotifier,
                                player: widget.videoController.player,
                                chapterMarks: widget.chapterMarks,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              if (_temporaryPlaybackSpeed != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: TemporaryPlaybackSpeedSelector(
                      speed: _temporaryPlaybackSpeed!,
                    ),
                  ),
                ),
              // // Buffering Indicator.
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
                                return Opacity(opacity: value, child: child!);
                              }
                              return const SizedBox.shrink();
                            },
                            child: const CircularProgressIndicator(
                              color: Color(0xFFFFFFFF),
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
              // // Volume Indicator.
              IgnorePointer(
                child: ValueListenableBuilder(
                  valueListenable: _volumeIndicator,
                  builder: (context, value, child) => AnimatedOpacity(
                    curve: Curves.easeInOut,
                    opacity: value ? 1.0 : 0.0,
                    duration: controlsTransitionDuration,
                    child: MediaIndicatorBuilder(
                      value: _volumeValue,
                      isVolumeIndicator: true,
                      adaptiveMobilePlacement: true,
                      showAtZero: true,
                    ),
                  ),
                ),
              ),
              // // Brightness Indicator.
              IgnorePointer(
                child: ValueListenableBuilder(
                  valueListenable: _brightnessIndicator,
                  builder: (context, value, child) => AnimatedOpacity(
                    curve: Curves.easeInOut,
                    opacity: value ? 1.0 : 0.0,
                    duration: controlsTransitionDuration,
                    child: MediaIndicatorBuilder(
                      value: _brightnessValue,
                      isVolumeIndicator: false,
                      adaptiveMobilePlacement: true,
                      showAtZero: true,
                    ),
                  ),
                ),
              ),
              // Seek Indicator.
              IgnorePointer(
                child: AnimatedOpacity(
                  duration: controlsTransitionDuration,
                  opacity: showSwipeDuration ? 1 : 0,
                  child: seekIndicatorTextWidget(
                    Duration(seconds: swipeDuration),
                    widget.videoController.player.state.position,
                  ),
                ),
              ),

              // Double-Tap Seek Button(s):
              if (_mountSeekBackwardButton || _mountSeekForwardButton)
                Positioned.fill(
                  child: Row(
                    children: [
                      Expanded(
                        child: _mountSeekBackwardButton
                            ? AbsorbPointer(
                                absorbing: _hideSeekBackwardButton,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: _hideSeekBackwardButton ? 0.0 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (context, value, child) =>
                                      Opacity(opacity: value, child: child),
                                  onEnd: () {
                                    if (_hideSeekBackwardButton) {
                                      setState(() {
                                        _hideSeekBackwardButton = false;
                                        _mountSeekBackwardButton = false;
                                        _seekBarDeltaValueNotifier = null;
                                      });
                                    }
                                  },
                                  child: MobileSeekIndicator(
                                    forward: false,
                                    compactPortrait: compactPortrait,
                                    onChanged: (value) {
                                      setState(() {
                                        _seekBarDeltaValueNotifier =
                                            _doubleTapSeekTarget(
                                              value,
                                              forward: false,
                                            );
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        _hideSeekBackwardButton = true;
                                      });
                                      widget.videoController.player.seek(
                                        _doubleTapSeekTarget(
                                          value,
                                          forward: false,
                                        ),
                                      );
                                    },
                                    skipDuration: skipDuration,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      Expanded(
                        child: _mountSeekForwardButton
                            ? AbsorbPointer(
                                absorbing: _hideSeekForwardButton,
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end: _hideSeekForwardButton ? 0.0 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 200),
                                  builder: (context, value, child) =>
                                      Opacity(opacity: value, child: child),
                                  onEnd: () {
                                    if (_hideSeekForwardButton) {
                                      setState(() {
                                        _hideSeekForwardButton = false;
                                        _mountSeekForwardButton = false;
                                        _seekBarDeltaValueNotifier = null;
                                      });
                                    }
                                  },
                                  child: MobileSeekIndicator(
                                    forward: true,
                                    compactPortrait: compactPortrait,
                                    onChanged: (value) {
                                      setState(() {
                                        _seekBarDeltaValueNotifier =
                                            _doubleTapSeekTarget(
                                              value,
                                              forward: true,
                                            );
                                      });
                                    },
                                    onSubmitted: (value) {
                                      setState(() {
                                        _hideSeekForwardButton = true;
                                      });
                                      widget.videoController.player.seek(
                                        _doubleTapSeekTarget(
                                          value,
                                          forward: true,
                                        ),
                                      );
                                    },
                                    skipDuration: skipDuration,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

List<Widget> mobilePrimaryButtonBar(
  BuildContext context,
  GlobalKey<VideoState> key,
  AnimeStreamController streamController,
  VideoController controller, {
  FocusNode? playPauseFocus,
}) {
  bool hasPrevEpisode =
      streamController.getEpisodeIndex().$1 + 1 !=
      streamController.getEpisodesLength(streamController.getEpisodeIndex().$2);
  bool hasNextEpisode = streamController.getEpisodeIndex().$1 != 0;
  final isFullScreen = isFullscreen(context);
  return [
    const Spacer(flex: 3),
    IconButton(
      style: mobilePlayerEpisodeNavigationButtonStyle(),
      onPressed: hasPrevEpisode
          ? () {
              if (isFullScreen) {
                key.currentState?.exitFullscreen();
              }
              pushReplacementMangaReaderView(
                context: context,
                chapter: streamController.getPrevEpisode(),
              );
            }
          : null,
      icon: const Icon(Icons.skip_previous, size: 28),
    ),
    const Spacer(),
    CustomPlayOrPauseButton(controller: controller, focusNode: playPauseFocus),
    const Spacer(),
    IconButton(
      style: mobilePlayerEpisodeNavigationButtonStyle(),
      onPressed: hasNextEpisode
          ? () {
              if (isFullScreen) {
                key.currentState?.exitFullscreen();
              }
              pushReplacementMangaReaderView(
                context: context,
                chapter: streamController.getNextEpisode(),
              );
            }
          : null,
      icon: const Icon(Icons.skip_next, size: 28),
    ),
    const Spacer(flex: 3),
  ];
}

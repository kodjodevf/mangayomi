// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/widgets/seek_indicator_text.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/temporary_playback_speed.dart';
import 'package:mangayomi/modules/anime/widgets/custom_seekbar.dart';
import 'package:mangayomi/modules/anime/widgets/indicator_builder.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_primary_button_bar.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:mangayomi/services/screen_brightness.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
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

  /// The opening and the ending AniSkip knows, marked on the timeline.
  final ValueListenable<List<(int, int)>>? skipRanges;

  /// A row just above the panel, on the left: the lock and the skip, as
  /// desktop's skip sits above its bar.
  final Widget? abovePanelWidget;
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
    this.skipRanges,
    this.abovePanelWidget,
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
  Duration controlsTransitionDuration = ShioriMotion.enter;
  Color backdropColor = ShioriScrim.shadow;
  Timer? _timer;
  // Read, not watched: a late final is read once, and a double tap can be
  // the first to read it, outside build, where watch is not allowed.
  late final skipDuration = ref.read(defaultDoubleTapToSkipLengthStateProvider);
  final ValueNotifier<double> _brightnessValue = ValueNotifier(0.0);
  final ValueNotifier<bool> _brightnessIndicator = ValueNotifier(false);
  Timer? _brightnessTimer;
  bool _brightnessChanged = false;

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
  final bottomButtonBarMargin = const EdgeInsets.only(
    left: ShioriSpace.s16,
    right: ShioriSpace.s8,
  );

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
    _rememberVolumeAndBrightness();
    _volumeValue.dispose();
    _volumeIndicator.dispose();
    _brightnessValue.dispose();
    _brightnessIndicator.dispose();
    _volumeController.removeListener();

    // Only if the brightness gesture set one; a reader's own brightness
    // is never left on.
    if (_brightnessChanged) unawaited(ScreenBrightness.reset());
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

  /// Read once the controls start: dispose() can no longer use ref.
  late final bool _rememberVolume;
  late final bool _rememberBrightness;
  @override
  void initState() {
    super.initState();
    _rememberVolume = ref.read(rememberPlayerVolumeStateProvider);
    _rememberBrightness = ref.read(rememberPlayerBrightnessStateProvider);
    widget.revealControls.addListener(_onRevealRequest);
    widget.isLocked?.addListener(_onLockChanged);
    _volumeController = VolumeController.instance;

    Future.microtask(() async {
      try {
        _volumeController.showSystemUI = false;
        final remembered = _rememberVolume
            ? settingsRepository.current.playerVolume
            : null;
        if (remembered != null) {
          _volumeController.setVolume(remembered.clamp(0.0, 1.0));
        }
        _volumeValue.value = await _volumeController.getVolume();
        _volumeController.addListener((value) {
          if (mounted && !_volumeInterceptEventStream) {
            _volumeValue.value = value;
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      final remembered = _rememberBrightness
          ? settingsRepository.current.playerBrightness
          : null;
      if (remembered != null) {
        _brightnessChanged = true;
        await ScreenBrightness.set(remembered.clamp(0.0, 1.0));
      }
      final current = await ScreenBrightness.current();
      if (mounted && current != null) _brightnessValue.value = current;
    });
  }

  /// Keeps the volume and brightness the episode ended with, for the next
  /// one, when asked to.
  void _rememberVolumeAndBrightness() {
    final volume = _rememberVolume ? _volumeValue.value : null;
    final brightness = _brightnessChanged && _rememberBrightness
        ? _brightnessValue.value
        : null;
    if (volume == null && brightness == null) return;
    settingsRepository.update((s) {
      if (volume != null) s.playerVolume = volume;
      if (brightness != null) s.playerBrightness = brightness;
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
    _brightnessChanged = true;
    _brightnessValue.value = value;
    unawaited(ScreenBrightness.set(value));
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
                          child: Container(color: Colors.transparent),
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
                          // The timeline and the settings in one panel
                          // floating over the foot of the picture, as the
                          // manga reader's: its own ground, so no gradient.
                          bottomControls: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ?widget.abovePanelWidget,
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  ShioriSpace.s8,
                                  0,
                                  ShioriSpace.s8,
                                  ShioriSpace.s8,
                                ),
                                child: ShioriOverlayPanel(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomSeekBar(
                                        onSeekStart: (value) {
                                          setState(() {
                                            swipeDuration = value.inSeconds;
                                            showSwipeDuration = true;
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
                                        },
                                        player: widget.videoController.player,
                                        chapterMarks: widget.chapterMarks,
                                        skipRanges: widget.skipRanges,
                                      ),
                                      widget.bottomButtonBarWidget,
                                    ],
                                  ),
                                ),
                              ),
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
                        // The timeline alone while a double tap or a swipe
                        // seeks, in the same panel as with the controls.
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            ShioriSpace.s8,
                            0,
                            ShioriSpace.s8,
                            ShioriSpace.s8,
                          ),
                          child: ShioriOverlayPanel(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ShioriSpace.s12,
                              vertical: ShioriSpace.s8,
                            ),
                            child: CustomSeekBar(
                              delta: _seekBarDeltaValueNotifier,
                              player: widget.videoController.player,
                              chapterMarks: widget.chapterMarks,
                              skipRanges: widget.skipRanges,
                            ),
                          ),
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
                            child: const PlayerBuffering(),
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
                                  duration: ShioriMotion.standard,
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
                                  duration: ShioriMotion.standard,
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

import 'dart:async';

import 'package:bot_toast/bot_toast.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/widgets/seek_indicator_text.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';
import 'package:mangayomi/modules/anime/utils/player_focus.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/anime/widgets/custom_seekbar.dart';
import 'package:mangayomi/modules/anime/widgets/indicator_builder.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
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

  /// The opening and the ending, in milliseconds, marked on the timeline.
  final ValueListenable<List<(int, int)>>? skipRanges;
  final int defaultSkipIntroLength;
  final void Function(bool) desktopFullScreenPlayer;
  final ValueNotifier<List<(String, int)>> chapterMarks;
  // Bumped by the player on each d-pad key so the desktop controls can reveal on
  // a TV remote — they otherwise only appear on mouse hover. Null off-TV.
  final ValueNotifier<int>? revealControls;
  const DesktopControllerWidget({
    super.key,
    required this.videoController,
    required this.topButtonBarWidget,
    required this.bottomButtonBarWidget,
    required this.streamController,
    required this.videoStatekey,
    required this.seekToWidget,
    this.skipRanges,
    required this.tempDuration,
    required this.doubleSpeed,
    required this.defaultSkipIntroLength,
    required this.desktopFullScreenPlayer,
    required this.chapterMarks,
    this.revealControls,
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
  Duration controlsTransitionDuration = ShioriMotion.enter;
  Timer? _timer;

  int swipeDuration = 0; // Duration to seek in video
  bool showSwipeDuration = false; // Whether to show the seek duration overlay
  double previousPlaybackSpeed = -1;

  late bool buffering = widget.videoController.player.state.buffering;
  final controlsHoverDuration = const Duration(seconds: 3);
  double buttonBarHeight = 100;
  final bottomButtonBarMargin = const EdgeInsets.only(
    left: ShioriSpace.s16,
    right: ShioriSpace.s8,
  );
  final FocusNode _playerFocusNode = FocusNode(
    debugLabel: 'desktopPlayerShortcuts',
  );

  final List<StreamSubscription> subscriptions = [];
  DateTime last = DateTime.now();
  Timer? _tapTimer;

  final ValueNotifier<double> _volumeValue = ValueNotifier(0.0);
  final ValueNotifier<bool> _volumeIndicator = ValueNotifier(false);
  Timer? _volumeTimer;
  double _lastNonZeroVolume = 100.0;

  // While the cursor sits on the seekbar (reading a scrub preview, say), the
  // bar must never auto-hide out from under it — only once it's no longer
  // over the track does the normal hover countdown resume.
  bool _hoveringSeekbar = false;

  void _onSeekbarHoverChanged(bool hovering) {
    if (_hoveringSeekbar == hovering) return;
    setState(() => _hoveringSeekbar = hovering);
    _timer?.cancel();
    if (!hovering) {
      _timer = Timer(controlsHoverDuration, () {
        if (mounted) {
          setState(() {
            visible = false;
            cursorVisible = false;
          });
        }
      });
    }
  }

  void _changeVolume(double delta) {
    final current = widget.videoController.player.state.volume;
    final newVolume = (current + delta).clamp(0.0, 100.0);
    widget.videoController.player.setVolume(newVolume);
    _showVolumeIndicator(newVolume);
  }

  void _toggleMute() {
    final current = widget.videoController.player.state.volume;
    if (current > 0.0) {
      _lastNonZeroVolume = current;
      widget.videoController.player.setVolume(0.0);
      _showVolumeIndicator(0.0);
    } else {
      final restore = _lastNonZeroVolume > 0 ? _lastNonZeroVolume : 100.0;
      widget.videoController.player.setVolume(restore);
      _showVolumeIndicator(restore);
    }
  }

  // Presses close together add up in one label ("+15 s"), as on YouTube.
  int _keySeekTotal = 0;
  Timer? _keySeekTimer;

  /// Seeks [seconds] from the keyboard, and says so over the video: the
  /// controls stay hidden, so the label is the only sign of it.
  void _seekByKey(int seconds) {
    final player = widget.videoController.player;
    final duration = player.state.duration;
    var target = player.state.position + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (duration > Duration.zero && target > duration) target = duration;
    player.seek(target);

    _keySeekTotal += seconds;
    _keySeekTimer?.cancel();
    _keySeekTimer = Timer(const Duration(seconds: 1), () => _keySeekTotal = 0);
    final total = _keySeekTotal;
    final label =
        '${total < 0 ? '−' : '+'}${context.l10n.seconds_short(total.abs())}'
        '  ·  ${target.label(reference: duration)}';
    BotToast.showCustomText(
      onlyOne: true,
      align: const Alignment(0, 0.6),
      duration: const Duration(seconds: 1),
      toastBuilder: (_) => ShioriOverlayLabel(label),
    );
  }

  /// One frame on or back; mpv pauses on it.
  void _frameStep({required bool forward}) {
    final platform = widget.videoController.player.platform;
    if (platform is! NativePlayer) return;
    platform.command([forward ? 'frame-step' : 'frame-back-step']);
  }

  void _showShortcuts() {
    showPlayerShortcuts(
      context,
      skipIntroSeconds: widget.defaultSkipIntroLength,
      shaders: ref.read(useMpvConfigStateProvider),
      bindings: ref.read(keyBindingsStateProvider),
    );
  }

  void _showVolumeIndicator(double volume) {
    _volumeValue.value = (volume / 100.0).clamp(0.0, 1.0);
    _volumeIndicator.value = true;
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _volumeIndicator.value = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Reveal on a d-pad key (TV remote) — the desktop controls otherwise only
    // appear on mouse hover, which a remote can't trigger.
    widget.revealControls?.addListener(_onRevealRequest);
  }

  void _onRevealRequest() {
    if (mounted) onEnter();
  }

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
    widget.revealControls?.removeListener(_onRevealRequest);
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    _timer?.cancel();
    _tapTimer?.cancel();
    _playerFocusNode.dispose();
    _volumeTimer?.cancel();
    _volumeValue.dispose();
    _volumeIndicator.dispose();
    _keySeekTimer?.cancel();
    super.dispose();
  }

  void _unmountHiddenControls() {
    if (visible) return;

    // A focused control is about to leave the tree. Move focus to the
    // persistent player node first; otherwise Flutter can fall back to the
    // root focus scope and CallbackShortcuts stops receiving hotkeys.
    restorePlayerFocusBeforeUnmount(_playerFocusNode);
    setState(() => mount = false);
  }

  void onHover() {
    if (!mount || !visible || !cursorVisible) {
      setState(() {
        mount = true;
        visible = true;
        cursorVisible = true;
      });
    }

    _timer?.cancel();
    // The seekbar's own hover callback owns the timer while the cursor is on
    // it — general movement over the rest of the bar (which this also fires
    // for, hover regions don't exclude each other) must not re-arm it out
    // from under that.
    if (_hoveringSeekbar) return;
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
    if (!mount || !visible || !cursorVisible) {
      setState(() {
        mount = true;
        visible = true;
        cursorVisible = true;
      });
    }

    _timer?.cancel();
    if (_hoveringSeekbar) return;
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
    if (visible || !cursorVisible) {
      setState(() {
        visible = false;
        cursorVisible = true;
      });
    }

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.videoController.player;
    void nextEpisode() {
      if (widget.streamController.hasNextEpisode) {
        pushReplacementMangaReaderView(
          context: context,
          chapter: widget.streamController.getNextEpisode(),
        );
      }
    }

    void previousEpisode() {
      if (widget.streamController.hasPreviousEpisode) {
        pushReplacementMangaReaderView(
          context: context,
          chapter: widget.streamController.getPrevEpisode(),
        );
      }
    }

    // The keyboard keys are the user's bindings; the media keys, the frame
    // steps, the list of shortcuts and the shader keys stay fixed.
    final actions = <PlayerShortcut, VoidCallback>{
      PlayerShortcut.playPause: player.playOrPause,
      PlayerShortcut.seekBackShort: () => _seekByKey(-playerShortSeekSeconds),
      PlayerShortcut.seekForwardShort: () => _seekByKey(playerShortSeekSeconds),
      PlayerShortcut.seekBackLong: () => _seekByKey(-playerLongSeekSeconds),
      PlayerShortcut.seekForwardLong: () => _seekByKey(playerLongSeekSeconds),
      PlayerShortcut.skipIntro: () => _seekByKey(widget.defaultSkipIntroLength),
      PlayerShortcut.volumeUp: () => _changeVolume(5.0),
      PlayerShortcut.volumeDown: () => _changeVolume(-5.0),
      PlayerShortcut.mute: _toggleMute,
      PlayerShortcut.previousEpisode: previousEpisode,
      PlayerShortcut.nextEpisode: nextEpisode,
      PlayerShortcut.fullScreen: () =>
          _changeFullScreen(ref, widget.desktopFullScreenPlayer),
      PlayerShortcut.exitFullScreen: () =>
          _changeFullScreen(ref, widget.desktopFullScreenPlayer, value: false),
    };
    final bindings = ref.watch(keyBindingsStateProvider);
    return CallbackShortcuts(
      bindings: {
        // Default key-board shortcuts.
        // https://support.google.com/youtube/answer/7631406
        const SingleActivator(LogicalKeyboardKey.mediaPlay): player.play,
        const SingleActivator(LogicalKeyboardKey.mediaPause): player.pause,
        const SingleActivator(LogicalKeyboardKey.mediaPlayPause):
            player.playOrPause,
        const SingleActivator(LogicalKeyboardKey.mediaTrackNext): nextEpisode,
        const SingleActivator(LogicalKeyboardKey.mediaTrackPrevious):
            previousEpisode,
        for (final MapEntry(key: shortcut, value: action) in actions.entries)
          for (final combo in bindings[shortcut]!) combo.activator: action,
        // By character rather than by key, so they hold on any layout (the
        // question mark is Shift+, on AZERTY).
        const CharacterActivator(','): () => _frameStep(forward: false),
        const CharacterActivator('.'): () => _frameStep(forward: true),
        const CharacterActivator('?'): _showShortcuts,
        const SingleActivator(LogicalKeyboardKey.f1): _showShortcuts,
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
            focusNode: _playerFocusNode,
            child: Listener(
              onPointerSignal: (e) {
                if (e is PointerScrollEvent) {
                  if (e.delta.dy > 0) {
                    _changeVolume(-5.0);
                  } else if (e.delta.dy < 0) {
                    _changeVolume(5.0);
                  }
                }
              },
              child: GestureDetector(
                onTap: () {
                  _tapTimer?.cancel();
                  _tapTimer = Timer(const Duration(milliseconds: 250), () {
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
                onTapUp: (e) async {
                  final now = DateTime.now();
                  final difference = now.difference(last);
                  last = now;
                  if (difference < const Duration(milliseconds: 350)) {
                    _tapTimer?.cancel();
                    _tapTimer = null;
                    final fullScreen = widget.desktopFullScreenPlayer;
                    await _changeFullScreen(ref, fullScreen);
                  }
                },
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
                          _unmountHiddenControls();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 140,
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
                                    // The timeline and the bar in one panel
                                    // floating over the foot, as on a phone.
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        ShioriSpace.s12,
                                        0,
                                        ShioriSpace.s12,
                                        ShioriSpace.s12,
                                      ),
                                      child: ShioriOverlayPanel(
                                        padding: const EdgeInsets.fromLTRB(
                                          ShioriSpace.s8,
                                          ShioriSpace.s8,
                                          ShioriSpace.s8,
                                          ShioriSpace.s4,
                                        ),
                                        maxWidth: double.infinity,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomSeekBar(
                                              onSeekStart: (value) {
                                                setState(() {
                                                  swipeDuration =
                                                      value.inSeconds;
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
                                              player:
                                                  widget.videoController.player,
                                              chapterMarks: widget.chapterMarks,
                                              onHoverChanged:
                                                  _onSeekbarHoverChanged,
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
                                      child: const PlayerBuffering(),
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
                      // Volume Indicator
                      IgnorePointer(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _volumeIndicator,
                          builder: (context, value, child) => AnimatedOpacity(
                            curve: Curves.easeInOut,
                            opacity: value ? 1.0 : 0.0,
                            duration: controlsTransitionDuration,
                            child: MediaIndicatorBuilder(
                              value: _volumeValue,
                              isVolumeIndicator: true,
                            ),
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
                            trackShape: _CustomTrackShape(),
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
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Colors.white,
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w600,
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
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(fullscreenProvider);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: ShioriMotion.fast,
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _hover
              ? Colors.white.withValues(alpha: Alphas.hairline)
              : Colors.transparent,
        ),
        child: IconButton(
          tooltip: isFullScreen
              ? context.l10n.exit_fullscreen
              : context.l10n.fullscreen,
          icon: isFullScreen
              ? const Icon(Symbols.fullscreen_exit_rounded)
              : const Icon(Symbols.fullscreen_rounded),
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: context.shiori.density.minTarget,
            minHeight: context.shiori.density.minTarget,
          ),
          color: Colors.white,
          onPressed: () async {
            await _changeFullScreen(ref, widget.desktopFullScreenPlayer);
          },
        ),
      ),
    );
  }
}

Future<bool> setFullScreen({bool? value}) async {
  if (value != null) {
    await windowManager.setFullScreen(value);
    return value;
  }
  final isFullScreen = await windowManager.isFullScreen();
  await windowManager.setFullScreen(!isFullScreen);
  return !isFullScreen;
}

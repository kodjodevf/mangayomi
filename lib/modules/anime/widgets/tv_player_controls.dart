import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/providers/auto_play_next_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_focusable.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_pills.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_seek_bar.dart';

/// A dedicated, Netflix-style controls overlay for the anime player on TV.
///
/// Only the essentials are on screen — play/pause, prev/next episode, a seek
/// bar with times, and audio/subtitle access — everything else lives behind the
/// gear. Built for the d-pad: theme-coloured focus highlight on every control,
/// the seek bar seeks a small fixed amount on Left/Right and lets Up/Down move
/// focus away, and the reveal/auto-hide is driven by [revealControls] (bumped by
/// the player on each key).
class TvPlayerControls extends StatefulWidget {
  const TvPlayerControls({
    super.key,
    required this.player,
    required this.revealControls,
    required this.title,
    required this.episodeLabel,
    required this.onBack,
    required this.onRestart,
    required this.onSettings,
    required this.hasNext,
    required this.onNext,
    required this.qualityListenable,
    required this.buildQualityOptions,
    required this.speedListenable,
    required this.onSetSpeed,
  });

  final Player player;
  final ValueNotifier<int> revealControls;
  final String title;
  final String episodeLabel;
  final VoidCallback onBack;
  final VoidCallback onRestart;
  final VoidCallback onSettings;
  final bool hasNext;
  final VoidCallback? onNext;
  // Quality = the source video list (e.g. "1080p Sub"/"1080p Dub") — the real
  // dub/sub control here. Rebuilt when [qualityListenable] fires.
  final Listenable qualityListenable;
  final List<TvTrackOption> Function() buildQualityOptions;
  // Playback speed: routed through the parent so its own speed notifier (used by
  // the hold-to-2x gesture) stays in sync rather than calling setRate directly.
  final ValueListenable<double> speedListenable;
  final ValueChanged<double> onSetSpeed;

  @override
  State<TvPlayerControls> createState() => _TvPlayerControlsState();
}

class _TvPlayerControlsState extends State<TvPlayerControls> {
  bool _visible = true;
  Timer? _hideTimer;
  final FocusScopeNode _scope = FocusScopeNode(debugLabel: 'tvPlayer');
  final FocusNode _playFocus = FocusNode(debugLabel: 'tvPlayerPlayPause');
  // Always in the tree, even while hidden (when the controls collapse to an
  // empty box and leave no focusable node). Focus parks here on hide so a key
  // press can still wake the panel — otherwise, on a keyboard, once it hides
  // there's nothing focused to receive the wake key.
  final FocusNode _rootFocus = FocusNode(debugLabel: 'tvPlayerRoot');
  static const _hideAfter = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    widget.revealControls.addListener(_reveal);
    // Re-arm the hide timer on every key event (see _onAnyKey): a control's own
    // handler consumes its key, so an ancestor Focus would never see it — a
    // hardware-keyboard handler is the only spot that catches *all* presses.
    HardwareKeyboard.instance.addHandler(_onAnyKey);
    _startHideTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _playFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onAnyKey);
    widget.revealControls.removeListener(_reveal);
    _hideTimer?.cancel();
    _scope.dispose();
    _playFocus.dispose();
    _rootFocus.dispose();
    super.dispose();
  }

  // Keep the panel alive while the user is actually pressing keys: any key (a
  // d-pad nudge, a held seek's repeats) restarts the hide countdown, so it never
  // vanishes mid-interaction or steals focus off the seek bar. Returns false so
  // the event still dispatches to whatever is focused. Skipped when a dialog is
  // on top (that case is handled by _onHideTimer re-arming).
  bool _onAnyKey(KeyEvent event) {
    if (mounted && _visible && _isTopRoute) _startHideTimer();
    return false;
  }

  // True while the player is the topmost route. When a dialog (speed / settings)
  // is open on top, the panel must not hide or touch focus — doing so steals
  // focus out of the dialog and back to the play button behind it.
  bool get _isTopRoute => ModalRoute.of(context)?.isCurrent ?? true;

  void _reveal() {
    if (!mounted) return;
    final wasHidden = !_visible;
    if (wasHidden) setState(() => _visible = true);
    // Always extend the hide timer (so a moving mouse keeps controls up), but
    // only grab focus on the hidden→visible edge — otherwise a stream of mouse
    // hover events would re-request focus every frame.
    _startHideTimer();
    if (wasHidden && !_scope.hasFocus && _isTopRoute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        (_playFocus.canRequestFocus ? _playFocus : _scope).requestFocus();
      });
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(_hideAfter, _onHideTimer);
  }

  void _onHideTimer() {
    if (!mounted) return;
    // A dialog is open on top — keep the panel and don't touch focus; re-arm so
    // it hides once the player is back on top.
    if (!_isTopRoute) {
      _startHideTimer();
      return;
    }
    _hideNow();
  }

  // Hide the control panel and park focus on the root node so a key press can
  // still wake it (Back also dismisses the panel before leaving the player).
  void _hideNow() {
    _hideTimer?.cancel();
    if (!mounted || !_visible) return;
    setState(() => _visible = false);
    _rootFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    // TV overscan-safe margins (~5% per side, Netflix-generous). Only the
    // interactive controls/title are inset — the scrim stays full-bleed, per
    // Android TV layout guidance.
    final size = MediaQuery.of(context).size;
    final safeH = size.width * 0.08;
    final safeV = size.height * 0.05;
    // Back dismisses the visible control panel before it leaves the player:
    // block the pop while the panel shows and hide it instead; a second Back
    // (panel already hidden) exits normally. The on-screen back arrow still
    // exits outright — it pops directly, bypassing this.
    return PopScope(
      canPop: !_visible,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _visible) _hideNow();
      },
      child: Focus(
        focusNode: _rootFocus,
        // While the panel is hidden this node holds focus; any d-pad / select
        // key wakes the panel (and is consumed so it doesn't also act). While
        // visible it defers to the focused control. Back is left alone so it
        // still exits.
        onKeyEvent: (node, event) {
          if (_visible) return KeyEventResult.ignored;
          if (event is KeyDownEvent || event is KeyRepeatEvent) {
            final k = event.logicalKey;
            // OK while hidden reveals the panel *and* toggles play/pause, so a
            // blind press does the obvious thing without a second keystroke.
            if (event is KeyDownEvent && isTvPlayerSelectKey(k)) {
              _reveal();
              widget.player.playOrPause();
              return KeyEventResult.handled;
            }
            final wake =
                k == LogicalKeyboardKey.arrowUp ||
                k == LogicalKeyboardKey.arrowDown ||
                k == LogicalKeyboardKey.arrowLeft ||
                k == LogicalKeyboardKey.arrowRight;
            if (wake) {
              _reveal();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: FocusScope(
          node: _scope,
          // Only build the controls (and their per-frame StreamBuilders) while
          // visible. Otherwise the seek/time streams rebuild ~4x/sec during
          // playback and jank the Fire TV — hidden means nothing to render.
          child: !_visible
              ? const SizedBox.expand()
              : Stack(
                  children: [
                    // Scrim so white controls read over any frame.
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.55),
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.65),
                            ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Top-left: back / restart / autoplay (gear lives by the pills).
                    Positioned(
                      top: safeV,
                      left: safeH,
                      child: Row(
                        children: [
                          TvFocusable(
                            accent: accent,
                            onPressed: widget.onBack,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TvFocusable(
                            accent: accent,
                            onPressed: widget.onRestart,
                            child: const Icon(
                              Icons.replay_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Autoplay-next — YouTube-style labelled switch.
                          Consumer(
                            builder: (context, ref, _) {
                              final on = ref.watch(autoPlayNextEpisodeProvider);
                              return TvAutoplayToggle(
                                accent: accent,
                                on: on,
                                onToggle: () => ref
                                    .read(autoPlayNextEpisodeProvider.notifier)
                                    .toggle(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // Top-right: title + episode.
                    Positioned(
                      top: safeV,
                      right: safeH,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (widget.title.isNotEmpty)
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (widget.episodeLabel.isNotEmpty)
                            Text(
                              widget.episodeLabel,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Bottom: controls + seek + tracks.
                    Positioned(
                      left: safeH,
                      right: safeH,
                      bottom: safeV,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Play/pause inline on the left of the seek line. Default
                          // focus + highlighted; OK on the seek bar also toggles it.
                          Row(
                            children: [
                              TvPlayPauseButton(
                                player: widget.player,
                                accent: accent,
                                focusNode: _playFocus,
                              ),
                              const SizedBox(width: 14),
                              TvPositionText(player: widget.player),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TvSeekBar(
                                  player: widget.player,
                                  accent: accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              TvRemainingText(player: widget.player),
                              // Manual skip to the next episode (autoplay still
                              // auto-advances at the end); shown only if there is one.
                              if (widget.hasNext) ...[
                                const SizedBox(width: 8),
                                TvFocusable(
                                  accent: accent,
                                  onPressed: widget.onNext,
                                  // Match the play/pause size (34) so the two
                                  // transport controls frame the seek bar evenly.
                                  child: const Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Quality | Subtitles | Speed | Settings pills.
                          TvPlayerPillBar(
                            player: widget.player,
                            accent: accent,
                            qualityListenable: widget.qualityListenable,
                            buildQualityOptions: widget.buildQualityOptions,
                            onSettings: widget.onSettings,
                            speedListenable: widget.speedListenable,
                            onSetSpeed: widget.onSetSpeed,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

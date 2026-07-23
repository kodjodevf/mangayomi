import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/providers/auto_play_next_provider.dart';
import 'package:media_kit/media_kit.dart';

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
            if (event is KeyDownEvent && _isSelect(k)) {
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
                          _TvFocusable(
                            accent: accent,
                            onPressed: widget.onBack,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _TvFocusable(
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
                              return _AutoplayToggle(
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
                              _PlayPauseButton(
                                player: widget.player,
                                accent: accent,
                                focusNode: _playFocus,
                              ),
                              const SizedBox(width: 14),
                              _PositionText(player: widget.player),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _TvSeekBar(
                                  player: widget.player,
                                  accent: accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _RemainingText(player: widget.player),
                              // Manual skip to the next episode (autoplay still
                              // auto-advances at the end); shown only if there is one.
                              if (widget.hasNext) ...[
                                const SizedBox(width: 8),
                                _TvFocusable(
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
                          _PillBar(
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

bool _isSelect(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;

/// A focusable control that shows a solid theme-accent background when focused
/// (clearly visible over the dark backdrop) and fires [onPressed] on select.
class _TvFocusable extends StatefulWidget {
  const _TvFocusable({
    required this.accent,
    required this.child,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  });

  final Color accent;
  final Widget child;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<_TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<_TvFocusable> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: enabled,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelect(event.logicalKey) && enabled) {
          widget.onPressed!();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused
                ? widget.accent
                : Colors.black.withValues(alpha: 0.35),
          ),
          child: Opacity(opacity: enabled ? 1.0 : 0.4, child: widget.child),
        ),
      ),
    );
  }
}

/// Focusable play/pause button — highlighted when focused, and the default
/// focus on reveal. OK on the seek bar also toggles it (Netflix convenience).
class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({
    required this.player,
    required this.accent,
    required this.focusNode,
  });

  final Player player;
  final Color accent;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: player.stream.playing,
      initialData: player.state.playing,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
        return _TvFocusable(
          accent: accent,
          focusNode: focusNode,
          autofocus: true,
          onPressed: player.playOrPause,
          child: Icon(
            playing ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 34,
          ),
        );
      },
    );
  }
}

/// A selectable option for the Quality group (source-provided video list).
class TvTrackOption {
  const TvTrackOption({
    required this.label,
    required this.selected,
    required this.onSelect,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelect;
}

/// The bottom pill bar: `Quality | Subtitles | Audio`, centered, current option
/// in each group checked. Quality is the real dub/sub control here (it re-opens
/// the stream at the chosen source video), so it comes first.
class _PillBar extends StatelessWidget {
  const _PillBar({
    required this.player,
    required this.accent,
    required this.qualityListenable,
    required this.buildQualityOptions,
    required this.onSettings,
    required this.speedListenable,
    required this.onSetSpeed,
  });

  final Player player;
  final Color accent;
  final Listenable qualityListenable;
  final List<TvTrackOption> Function() buildQualityOptions;
  final VoidCallback onSettings;
  final ValueListenable<double> speedListenable;
  final ValueChanged<double> onSetSpeed;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: qualityListenable,
      builder: (context, _) {
        final quality = buildQualityOptions();
        return StreamBuilder<Tracks>(
          stream: player.stream.tracks,
          initialData: player.state.tracks,
          builder: (context, tracksSnap) {
            final tracks = tracksSnap.data ?? player.state.tracks;
            return StreamBuilder<Track>(
              stream: player.stream.track,
              initialData: player.state.track,
              builder: (context, trackSnap) {
                final current = trackSnap.data ?? player.state.track;
                // Real subtitle tracks only (no "auto"/"no" placeholders).
                final subs = tracks.subtitle
                    .where((t) => t.id != 'auto' && t.id != 'no')
                    .toList();
                // A "sub" quality already bakes subtitles into the stream, so
                // hide the subtitle group when one is selected.
                final subQualitySelected = quality.any(
                  (q) => q.selected && q.label.toLowerCase().contains('sub'),
                );

                final groups = <List<Widget>>[];

                // Quality group — the real dub/sub control.
                if (quality.isNotEmpty) {
                  groups.add([
                    for (final q in quality)
                      _TrackPill(
                        accent: accent,
                        icon: Icons.high_quality_outlined,
                        label: q.label,
                        selected: q.selected,
                        onTap: q.onSelect,
                      ),
                  ]);
                }

                // Subtitle group — real tracks only, toggleable (re-clicking the
                // selected one turns subtitles off). No separate "off" pill, and
                // hidden entirely for sub-quality streams.
                if (!subQualitySelected && subs.isNotEmpty) {
                  groups.add([
                    for (final s in subs)
                      _TrackPill(
                        accent: accent,
                        icon: Icons.subtitles_outlined,
                        label: _trackLabel(s.title, s.language, s.id),
                        selected: s.id == current.subtitle.id,
                        onTap: () => player.setSubtitleTrack(
                          s.id == current.subtitle.id ? SubtitleTrack.no() : s,
                        ),
                      ),
                  ]);
                }

                // Join groups with a "|" divider.
                final children = <Widget>[];
                for (var i = 0; i < groups.length; i++) {
                  if (i > 0) children.add(const _PillDivider());
                  children.addAll(groups[i]);
                }
                // Speed group, then the gear, both sized to match the track
                // pills.
                if (children.isNotEmpty) children.add(const _PillDivider());
                children.add(
                  _SpeedPill(
                    accent: accent,
                    speedListenable: speedListenable,
                    onSetSpeed: onSetSpeed,
                  ),
                );
                children.add(const _PillDivider());
                children.add(
                  _TrackPill(
                    accent: accent,
                    icon: Icons.settings,
                    label: 'Settings',
                    selected: false,
                    onTap: onSettings,
                  ),
                );
                return Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: children,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Playback-speed pill: shows the current rate, opens a d-pad-focusable list of
/// presets. Highlighted (like a selected track) whenever it isn't 1×.
class _SpeedPill extends StatelessWidget {
  const _SpeedPill({
    required this.accent,
    required this.speedListenable,
    required this.onSetSpeed,
  });

  final Color accent;
  final ValueListenable<double> speedListenable;
  final ValueChanged<double> onSetSpeed;

  static const _presets = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  static String _fmt(double r) {
    final s = r == r.roundToDouble() ? r.toStringAsFixed(0) : r.toString();
    return '$s×';
  }

  void _showMenu(BuildContext context, double current) {
    showDialog<void>(
      context: context,
      builder: (ctx) => _SpeedMenu(
        accent: accent,
        presets: _presets,
        current: current,
        onPick: onSetSpeed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: speedListenable,
      builder: (context, rate, _) => _TrackPill(
        accent: accent,
        icon: Icons.speed,
        label: _fmt(rate),
        selected: (rate - 1.0).abs() > 0.001,
        onTap: () => _showMenu(context, rate),
      ),
    );
  }
}

/// The playback-speed picker. Owns its focus containment: Up/Down move within
/// the list and are *always* consumed (clamped at the ends), so d-pad focus
/// can't escape past the edges to the controls behind the still-open dialog —
/// which was letting the speed pill re-open a second dialog on top of this one.
class _SpeedMenu extends StatefulWidget {
  const _SpeedMenu({
    required this.accent,
    required this.presets,
    required this.current,
    required this.onPick,
  });

  final Color accent;
  final List<double> presets;
  final double current;
  final ValueChanged<double> onPick;

  @override
  State<_SpeedMenu> createState() => _SpeedMenuState();
}

class _SpeedMenuState extends State<_SpeedMenu> {
  late final List<FocusNode> _nodes = List.generate(
    widget.presets.length,
    (_) => FocusNode(),
  );
  late int _index;

  @override
  void initState() {
    super.initState();
    final sel = widget.presets.indexWhere(
      (s) => (s - widget.current).abs() < 0.001,
    );
    _index = sel >= 0 ? sel : widget.presets.length ~/ 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodes[_index].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _move(int delta) {
    final next = (_index + delta).clamp(0, _nodes.length - 1);
    if (next != _index) {
      setState(() => _index = next);
      _nodes[next].requestFocus();
    }
  }

  void _pick(int i) {
    widget.onPick(widget.presets[i]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Playback speed'),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: 300,
        child: FocusTraversalGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.presets.length; i++)
                Focus(
                  focusNode: _nodes[i],
                  onKeyEvent: (node, event) {
                    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
                      return KeyEventResult.ignored;
                    }
                    final k = event.logicalKey;
                    if (k == LogicalKeyboardKey.arrowDown) {
                      _move(1);
                      return KeyEventResult.handled;
                    }
                    if (k == LogicalKeyboardKey.arrowUp) {
                      _move(-1);
                      return KeyEventResult.handled;
                    }
                    // Swallow Left/Right too, so neither can escape sideways.
                    if (k == LogicalKeyboardKey.arrowLeft ||
                        k == LogicalKeyboardKey.arrowRight) {
                      return KeyEventResult.handled;
                    }
                    if (event is KeyDownEvent && _isSelect(k)) {
                      _pick(i);
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Padding(
                    // Inset so the highlight is a rounded pill inside the
                    // dialog — a full-bleed square looked broken on the last
                    // row against the dialog's rounded corner.
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: InkWell(
                      onTap: () => _pick(i),
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: i == _index
                              ? widget.accent.withValues(alpha: 0.18)
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_SpeedPill._fmt(widget.presets[i])),
                            ),
                            if ((widget.presets[i] - widget.current).abs() <
                                0.001)
                              Icon(Icons.check, color: widget.accent),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A thin vertical "|" separator between pill groups.
class _PillDivider extends StatelessWidget {
  const _PillDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white.withValues(alpha: 0.3),
    );
  }
}

/// A compact YouTube-style "Autoplay" labelled switch, focusable for the d-pad.
class _AutoplayToggle extends StatefulWidget {
  const _AutoplayToggle({
    required this.accent,
    required this.on,
    required this.onToggle,
  });

  final Color accent;
  final bool on;
  final VoidCallback onToggle;

  @override
  State<_AutoplayToggle> createState() => _AutoplayToggleState();
}

class _AutoplayToggleState extends State<_AutoplayToggle> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
          widget.onToggle();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Theme tint on focus (like the settings toggles), not an outline.
            color: _focused
                ? widget.accent.withValues(alpha: 0.25)
                : Colors.transparent,
          ),
          child: AutoplaySwitch(on: widget.on, accent: widget.accent),
        ),
      ),
    );
  }
}

/// A drawn play/pause autoplay toggle (no asset): a pill track with a circular
/// black knob that slides right + shows ▶ when on, left + shows ⏸ when off —
/// matching the reference toggle style.
class AutoplaySwitch extends StatelessWidget {
  const AutoplaySwitch({super.key, required this.on, required this.accent});

  final bool on;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    const w = 52.0;
    const h = 28.0;
    const trackH = 22.0;
    const knob = 28.0;
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: w - 4,
            height: trackH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(trackH / 2),
              color: on
                  ? accent.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.22),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: knob,
              height: knob,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                on ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _trackLabel(String? title, String? language, String id) {
  final t = (title ?? '').trim();
  if (t.isNotEmpty) return t;
  final l = (language ?? '').trim();
  if (l.isNotEmpty) return l;
  return id;
}

/// A small focusable track pill: accent when focused, faded accent when it's the
/// current track (with a check), else a translucent fill.
class _TrackPill extends StatefulWidget {
  const _TrackPill({
    required this.accent,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color accent;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TrackPill> createState() => _TrackPillState();
}

class _TrackPillState extends State<_TrackPill> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final bg = _focused
        ? widget.accent
        : widget.selected
        ? widget.accent.withValues(alpha: 0.4)
        : Colors.white.withValues(alpha: 0.15);
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.selected ? Icons.check : widget.icon,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A focusable seek bar: Left/Right seek a small fixed amount; Up/Down escape.
class _TvSeekBar extends StatefulWidget {
  const _TvSeekBar({required this.player, required this.accent});

  final Player player;
  final Color accent;

  @override
  State<_TvSeekBar> createState() => _TvSeekBarState();
}

class _TvSeekBarState extends State<_TvSeekBar> {
  bool _focused = false;

  // Own a node when the parent doesn't supply one, so a mouse click can focus
  // the bar (and hand keyboard seeking over to it) on desktop.
  FocusNode? _ownNode;
  FocusNode get _node => _ownNode ??= FocusNode();

  @override
  void dispose() {
    _ownNode?.dispose();
    super.dispose();
  }

  // Hold-to-accelerate: a held arrow fires key repeats, and each consecutive
  // repeat in the same direction grows the seek step, so a long hold covers
  // ground fast while a single tap still nudges ±10s. Reset on release or when
  // the direction flips.
  static const _baseStep = 10; // seconds
  static const _maxStep = 90;
  int _holdCount = 0;
  LogicalKeyboardKey? _holdDir;

  Duration _stepFor(LogicalKeyboardKey dir) {
    if (_holdDir != dir) {
      _holdDir = dir;
      _holdCount = 0;
    } else {
      _holdCount++;
    }
    // +10s per 3 repeats held: 10 → 20 → 30 … capped.
    final secs = (_baseStep + (_holdCount ~/ 3) * 10).clamp(
      _baseStep,
      _maxStep,
    );
    return Duration(seconds: secs);
  }

  void _endHold() {
    _holdDir = null;
    _holdCount = 0;
  }

  void _seek(Duration delta) {
    var target = widget.player.state.position + delta;
    if (target < Duration.zero) target = Duration.zero;
    final dur = widget.player.state.duration;
    if (dur > Duration.zero && target > dur) target = dur;
    widget.player.seek(target);
  }

  // Mouse tap / drag on the bar seeks to that fraction of the duration.
  void _seekToFraction(double frac) {
    final dur = widget.player.state.duration;
    if (dur <= Duration.zero) return;
    if (!_node.hasFocus) _node.requestFocus();
    widget.player.seek(dur * frac.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _node,
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (!f) _endHold();
      },
      onKeyEvent: (node, event) {
        final k = event.logicalKey;
        final isLeft = k == LogicalKeyboardKey.arrowLeft;
        final isRight = k == LogicalKeyboardKey.arrowRight;
        // Releasing an arrow ends the hold ramp.
        if (event is KeyUpEvent) {
          if (isLeft || isRight) {
            _endHold();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        }
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (isLeft) {
            _seek(-_stepFor(k));
            return KeyEventResult.handled;
          }
          if (isRight) {
            _seek(_stepFor(k));
            return KeyEventResult.handled;
          }
          // OK/Select toggles play/pause (Netflix model — no separate button).
          if (event is KeyDownEvent && _isSelect(k)) {
            widget.player.playOrPause();
            return KeyEventResult.handled;
          }
          // Up / Down fall through so focus can leave the bar.
        }
        return KeyEventResult.ignored;
      },
      child: StreamBuilder<Duration>(
        stream: widget.player.stream.position,
        initialData: widget.player.state.position,
        builder: (context, snapshot) {
          final pos = snapshot.data ?? Duration.zero;
          final dur = widget.player.state.duration;
          final frac = dur.inMilliseconds > 0
              ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
              : 0.0;
          final barH = _focused ? 6.0 : 4.0;
          const knob = 16.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: SizedBox(
              height: 16,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) => _seekToFraction(d.localPosition.dx / w),
                    onHorizontalDragStart: (d) =>
                        _seekToFraction(d.localPosition.dx / w),
                    onHorizontalDragUpdate: (d) =>
                        _seekToFraction(d.localPosition.dx / w),
                    child: Stack(
                      children: [
                        // Track + progress, vertically centred.
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(barH / 2),
                            child: SizedBox(
                              height: barH,
                              width: w,
                              child: LinearProgressIndicator(
                                value: frac,
                                backgroundColor: Colors.white24,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.accent,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Scrubber handle at the current position when focused —
                        // the focus affordance instead of an outline.
                        if (_focused)
                          Positioned(
                            left: (frac * (w - knob)).clamp(0.0, w - knob),
                            top: (16 - knob) / 2,
                            child: Container(
                              width: knob,
                              height: knob,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

String _fmt(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
}

// Monospace + tabular figures so the timestamps read cleanly and don't jitter
// as the digits change.
TextStyle _timeStyle(Color color) => TextStyle(
  color: color,
  fontSize: 15,
  fontFamily: 'monospace',
  fontWeight: FontWeight.w600,
  letterSpacing: 0.3,
  fontFeatures: const [FontFeature.tabularFigures()],
);

class _PositionText extends StatelessWidget {
  const _PositionText({required this.player});
  final Player player;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      initialData: player.state.position,
      builder: (context, snapshot) => Text(
        _fmt(snapshot.data ?? Duration.zero),
        style: _timeStyle(Colors.white),
      ),
    );
  }
}

/// Right-side timestamp counts DOWN — time remaining (e.g. "-45:32"), like
/// Netflix.
class _RemainingText extends StatelessWidget {
  const _RemainingText({required this.player});
  final Player player;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: player.stream.position,
      initialData: player.state.position,
      builder: (context, snapshot) {
        final pos = snapshot.data ?? Duration.zero;
        final dur = player.state.duration;
        var remaining = dur - pos;
        if (remaining < Duration.zero) remaining = Duration.zero;
        return Text('-${_fmt(remaining)}', style: _timeStyle(Colors.white70));
      },
    );
  }
}

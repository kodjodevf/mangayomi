import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_focusable.dart';

/// A focusable seek bar: Left/Right seek a small fixed amount; Up/Down escape.
class TvSeekBar extends StatefulWidget {
  const TvSeekBar({super.key, required this.player, required this.accent});

  final Player player;
  final Color accent;

  @override
  State<TvSeekBar> createState() => _TvSeekBarState();
}

class _TvSeekBarState extends State<TvSeekBar> {
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
          if (event is KeyDownEvent && isTvPlayerSelectKey(k)) {
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

class TvPositionText extends StatelessWidget {
  const TvPositionText({super.key, required this.player});
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
class TvRemainingText extends StatelessWidget {
  const TvRemainingText({super.key, required this.player});
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

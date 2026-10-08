import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_focusable.dart';

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
class TvPlayerPillBar extends StatelessWidget {
  const TvPlayerPillBar({
    super.key,
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
                    label: context.l10n.settings,
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

  static String _formatRate(double r) {
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
        label: _formatRate(rate),
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
      title: Text(context.l10n.playback_speed),
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
                    if (event is KeyDownEvent && isTvPlayerSelectKey(k)) {
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
                              child: Text(
                                _SpeedPill._formatRate(widget.presets[i]),
                              ),
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
class TvAutoplayToggle extends StatefulWidget {
  const TvAutoplayToggle({
    super.key,
    required this.accent,
    required this.on,
    required this.onToggle,
  });

  final Color accent;
  final bool on;
  final VoidCallback onToggle;

  @override
  State<TvAutoplayToggle> createState() => _AutoplayToggleState();
}

class _AutoplayToggleState extends State<TvAutoplayToggle> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && isTvPlayerSelectKey(event.logicalKey)) {
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
        if (event is KeyDownEvent && isTvPlayerSelectKey(event.logicalKey)) {
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// The YouTube-style settings panel that docks on the right of the TV player.
/// A navigable drill-down: a category list, and selecting one replaces it with
/// that category's page (Back returns). Surfaces the player's existing quality /
/// subtitle / audio widgets plus speed, shaders, decoder and mpv stats — all
/// d-pad-focusable.
/// One selectable option in a track/quality list: its label, whether it's the
/// current selection, and the action to switch to it (no route pop — the panel
/// stays open).
typedef TvTrackOptionData = ({String label, bool selected, VoidCallback onTap});

class TvPlayerSettingsPanel extends ConsumerStatefulWidget {
  const TvPlayerSettingsPanel({
    super.key,
    required this.player,
    required this.speedListenable,
    required this.onSetSpeed,
    required this.selectedShaderListenable,
    required this.qualityOptions,
    required this.subtitleOptions,
    required this.audioOptions,
    required this.headerFocusNode,
    required this.onExitLeft,
    required this.onClose,
  });

  final Player player;
  final ValueListenable<double> speedListenable;
  final ValueChanged<double> onSetSpeed;
  final ValueListenable<String> selectedShaderListenable;
  final List<TvTrackOptionData> Function() qualityOptions;
  final List<TvTrackOptionData> Function() subtitleOptions;
  final List<TvTrackOptionData> Function() audioOptions;
  // The header's focus node is owned by the player so it can be re-focused every
  // time the panel opens (autofocus only fires once per scope).
  final FocusNode headerFocusNode;
  // Left out of the panel goes to the video — an explicit hand-off, because
  // geometric directional focus across the split was losing focus entirely.
  final VoidCallback onExitLeft;
  final VoidCallback onClose;

  @override
  ConsumerState<TvPlayerSettingsPanel> createState() =>
      _TvPlayerSettingsPanelState();
}

class _TvPlayerSettingsPanelState extends ConsumerState<TvPlayerSettingsPanel> {
  static const _speeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  static const _shaders = [
    ('Anime4K: Mode A (Fast)', 'set_anime_a'),
    ('Anime4K: Mode B (Fast)', 'set_anime_b'),
    ('Anime4K: Mode C (Fast)', 'set_anime_c'),
    ('Anime4K: Mode A (HQ)', 'set_anime_hq_a'),
    ('Anime4K: Mode B (HQ)', 'set_anime_hq_b'),
    ('Anime4K: Mode C (HQ)', 'set_anime_hq_c'),
    ('AMD FSR', 'set_fsr'),
    ('Luma Upscaling', 'set_luma'),
    ('Qualcomm Snapdragon GSR', 'set_snapdragon'),
    ('NVIDIA Image Scaling', 'set_nvidia'),
    ('Off (clear shaders)', 'clear_anime'),
  ];
  static const _decoders = [
    ('auto', 'Auto (hardware)'),
    ('auto-copy', 'Auto-copy'),
    ('mediacodec', 'MediaCodec — HW (Android)'),
    ('mediacodec-copy', 'MediaCodec — HW+ (Android)'),
    ('videotoolbox', 'VideoToolbox (Apple)'),
    ('videotoolbox-copy', 'VideoToolbox-copy (Apple)'),
    ('d3d11va', 'D3D11VA (Windows)'),
    ('nvdec', 'NVDEC (CUDA)'),
    ('no', 'Software (no hardware)'),
  ];
  static const _stats = [
    ('Toggle overlay', 'stats/display-stats-toggle'),
    ('General', 'stats/display-page-1'),
    ('Frame timings', 'stats/display-page-2'),
    ('Input cache', 'stats/display-page-3'),
    ('Active filters', 'stats/display-page-4'),
    ('Log', 'stats/display-page-5'),
  ];

  // null = the category list; otherwise the open category's key.
  String? _open;

  NativePlayer get _native => widget.player.platform as NativePlayer;

  void _drill(String key) => setState(() => _open = key);

  bool _handleBack() {
    if (_open != null) {
      setState(() => _open = null);
      return true;
    }
    widget.onClose();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final size = MediaQuery.of(context).size;
    final width = (size.width * 0.26).clamp(300.0, 380.0);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      // Intercept Left before the default directional traversal (onKeyEvent
      // runs ahead of Shortcuts/Actions) and hand focus to the video explicitly.
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
              event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            widget.onExitLeft();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: FocusTraversalGroup(
          child: Container(
            width: width,
            color: Theme.of(context).colorScheme.surface,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const Divider(height: 1),
                  Expanded(
                    child: _open == null
                        ? _categoryList(context, accent)
                        : _page(context, accent, _open!),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final title = _open == null ? 'Settings' : _titleFor(_open!);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            focusNode: widget.headerFocusNode,
            onPressed: _handleBack,
            icon: Icon(_open == null ? Icons.close : Icons.arrow_back),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _titleFor(String key) => switch (key) {
    'playback' => 'Playback speed',
    'quality' => 'Quality',
    'subtitles' => 'Subtitles',
    'audio' => 'Audio',
    'shaders' => 'Shaders',
    'decoder' => 'Decoder',
    'stats' => 'Stats for nerds',
    _ => 'Settings',
  };

  Widget _categoryList(BuildContext context, Color accent) {
    final entries = <(String, IconData, String)>[
      ('playback', Icons.speed, 'Playback speed'),
      ('quality', Icons.high_quality_outlined, 'Quality'),
      ('subtitles', Icons.subtitles_outlined, 'Subtitles'),
      ('audio', Icons.audiotrack_outlined, 'Audio'),
      ('shaders', Icons.auto_awesome_outlined, 'Shaders'),
      ('decoder', Icons.memory_outlined, 'Decoder'),
      ('stats', Icons.insights_outlined, 'Stats for nerds'),
    ];
    return ListView(
      children: [
        for (final e in entries)
          _NavRow(
            accent: accent,
            icon: e.$2,
            label: e.$3,
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () => _drill(e.$1),
          ),
      ],
    );
  }

  Widget _page(BuildContext context, Color accent, String key) {
    switch (key) {
      case 'playback':
        return ValueListenableBuilder<double>(
          valueListenable: widget.speedListenable,
          builder: (context, rate, _) => ListView(
            children: [
              for (final (i, s) in _speeds.indexed)
                _OptionRow(
                  accent: accent,
                  autofocus: i == 0,
                  label: _fmtSpeed(s),
                  selected: (s - rate).abs() < 0.001,
                  onTap: () => widget.onSetSpeed(s),
                ),
            ],
          ),
        );
      case 'quality':
        return _trackList(
          accent,
          widget.qualityOptions,
          'No other quality',
        );
      case 'subtitles':
        return _trackList(accent, widget.subtitleOptions, 'No subtitles');
      case 'audio':
        return _trackList(accent, widget.audioOptions, 'No audio tracks');
      case 'shaders':
        return ValueListenableBuilder<String>(
          valueListenable: widget.selectedShaderListenable,
          builder: (context, current, _) => ListView(
            children: [
              for (final (i, sh) in _shaders.indexed)
                _OptionRow(
                  accent: accent,
                  autofocus: i == 0,
                  label: sh.$1,
                  selected: current == sh.$1,
                  onTap: () =>
                      _native.command(['script-message', sh.$2]),
                ),
            ],
          ),
        );
      case 'decoder':
        final currentHwdec = ref.watch(hwdecModeStateProvider());
        return ListView(
          children: [
            for (final (i, d) in _decoders.indexed)
              _OptionRow(
                accent: accent,
                autofocus: i == 0,
                label: d.$2,
                selected: currentHwdec == d.$1,
                onTap: () {
                  ref.read(hwdecModeStateProvider().notifier).set(d.$1);
                  // Live-switch mpv too, so it takes effect without a restart.
                  _native.setProperty('hwdec', d.$1);
                },
              ),
          ],
        );
      case 'stats':
        return ListView(
          children: [
            for (final (i, st) in _stats.indexed)
              _NavRow(
                accent: accent,
                autofocus: i == 0,
                icon: Icons.insights_outlined,
                label: st.$1,
                onTap: () => _native.command(['script-binding', st.$2]),
              ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _trackList(
    Color accent,
    List<TvTrackOptionData> Function() optionsBuilder,
    String empty,
  ) {
    // Recompute from player state on every track change so the check mark
    // follows the real selection: switching a track updates player state
    // asynchronously, and without this the list stayed frozen on the option
    // that was selected when the page opened.
    return StreamBuilder<Track>(
      stream: widget.player.stream.track,
      builder: (context, _) {
        final options = optionsBuilder();
        if (options.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                empty,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          );
        }
        return ListView(
          children: [
            for (final (i, o) in options.indexed)
              _OptionRow(
                accent: accent,
                autofocus: i == 0,
                label: o.label,
                selected: o.selected,
                onTap: o.onTap,
              ),
          ],
        );
      },
    );
  }

  static String _fmtSpeed(double r) {
    final s = r == r.roundToDouble() ? r.toStringAsFixed(0) : r.toString();
    return '$s×';
  }
}

/// A focusable navigation row (drills in or fires an action).
class _NavRow extends StatefulWidget {
  const _NavRow({
    required this.accent,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.autofocus = false,
  });
  final Color accent;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool autofocus;

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: _focused ? widget.accent.withValues(alpha: 0.18) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: widget.accent),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

/// A focusable selectable option (a check marks the current one).
class _OptionRow extends StatefulWidget {
  const _OptionRow({
    required this.accent,
    required this.label,
    required this.selected,
    required this.onTap,
    this.autofocus = false,
  });
  final Color accent;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool autofocus;

  @override
  State<_OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<_OptionRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _focused ? widget.accent.withValues(alpha: 0.18) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: widget.selected
                        ? FontWeight.w700
                        : FontWeight.normal,
                    color: widget.selected ? widget.accent : null,
                  ),
                ),
              ),
              if (widget.selected)
                Icon(Icons.check, size: 20, color: widget.accent),
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

/// Wraps the docked video as a single focusable unit: a rounded accent ring
/// when focused (reached by pressing Left out of the panel), and Select toggles
/// play/pause. When focused it shows the current play/pause state in the centre
/// so it's clear what Select will do (and that it changed).
class TvVideoFocusFrame extends StatefulWidget {
  const TvVideoFocusFrame({
    super.key,
    required this.accent,
    required this.player,
    required this.focusNode,
    required this.onSelect,
    required this.onExitRight,
    required this.child,
  });
  final Color accent;
  final Player player;
  final FocusNode focusNode;
  final VoidCallback onSelect;
  // Right off the video hands focus back into the settings panel.
  final VoidCallback onExitRight;
  final Widget child;

  @override
  State<TvVideoFocusFrame> createState() => _TvVideoFocusFrameState();
}

class _TvVideoFocusFrameState extends State<TvVideoFocusFrame> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            widget.onExitRight();
            return KeyEventResult.handled;
          }
        }
        if (event is KeyDownEvent && _isSelect(event.logicalKey)) {
          widget.onSelect();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focused ? widget.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              if (_focused)
                Center(
                  child: StreamBuilder<bool>(
                    stream: widget.player.stream.playing,
                    initialData: widget.player.state.playing,
                    builder: (context, snap) {
                      final playing = snap.data ?? true;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Icon(
                            playing ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

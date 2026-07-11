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
class TvPlayerSettingsPanel extends ConsumerStatefulWidget {
  const TvPlayerSettingsPanel({
    super.key,
    required this.player,
    required this.speedListenable,
    required this.onSetSpeed,
    required this.selectedShaderListenable,
    required this.qualityWidget,
    required this.subtitleWidget,
    required this.audioWidget,
    required this.onClose,
  });

  final Player player;
  final ValueListenable<double> speedListenable;
  final ValueChanged<double> onSetSpeed;
  final ValueListenable<String> selectedShaderListenable;
  final Widget qualityWidget;
  final Widget subtitleWidget;
  final Widget audioWidget;
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
    final width = (size.width * 0.34).clamp(340.0, 460.0);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
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
    );
  }

  Widget _header(BuildContext context) {
    final title = _open == null ? 'Settings' : _titleFor(_open!);
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            autofocus: true,
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
              for (final s in _speeds)
                _OptionRow(
                  accent: accent,
                  label: _fmtSpeed(s),
                  selected: (s - rate).abs() < 0.001,
                  onTap: () => widget.onSetSpeed(s),
                ),
            ],
          ),
        );
      case 'quality':
        return SingleChildScrollView(child: widget.qualityWidget);
      case 'subtitles':
        return SingleChildScrollView(child: widget.subtitleWidget);
      case 'audio':
        return SingleChildScrollView(child: widget.audioWidget);
      case 'shaders':
        return ValueListenableBuilder<String>(
          valueListenable: widget.selectedShaderListenable,
          builder: (context, current, _) => ListView(
            children: [
              for (final sh in _shaders)
                _OptionRow(
                  accent: accent,
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
            for (final d in _decoders)
              _OptionRow(
                accent: accent,
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
            for (final st in _stats)
              _NavRow(
                accent: accent,
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
  });
  final Color accent;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  State<_NavRow> createState() => _NavRowState();
}

class _NavRowState extends State<_NavRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          color: _focused
              ? widget.accent.withValues(alpha: 0.18)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
  });
  final Color accent;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_OptionRow> createState() => _OptionRowState();
}

class _OptionRowState extends State<_OptionRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          color: _focused
              ? widget.accent.withValues(alpha: 0.18)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
/// play/pause so the video can be paused without leaving settings.
class TvVideoFocusFrame extends StatefulWidget {
  const TvVideoFocusFrame({
    super.key,
    required this.accent,
    required this.onSelect,
    required this.child,
  });
  final Color accent;
  final VoidCallback onSelect;
  final Widget child;

  @override
  State<TvVideoFocusFrame> createState() => _TvVideoFocusFrameState();
}

class _TvVideoFocusFrameState extends State<TvVideoFocusFrame> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
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
          child: widget.child,
        ),
      ),
    );
  }
}

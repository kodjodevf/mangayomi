import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/widgets/subtitle_view.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

extension on PlayerSubtitleSettings {
  PlayerSubtitleSettings copyWith({
    int? fontSize,
    bool? useBold,
    bool? useItalic,
    int? textColorA,
    int? textColorR,
    int? textColorG,
    int? textColorB,
    int? borderColorA,
    int? borderColorR,
    int? borderColorG,
    int? borderColorB,
    int? backgroundColorA,
    int? backgroundColorR,
    int? backgroundColorG,
    int? backgroundColorB,
    bool? overrideAssSubtitles,
  }) {
    return PlayerSubtitleSettings(
      fontSize: fontSize ?? this.fontSize,
      useBold: useBold ?? this.useBold,
      useItalic: useItalic ?? this.useItalic,
      textColorA: textColorA ?? this.textColorA,
      textColorR: textColorR ?? this.textColorR,
      textColorG: textColorG ?? this.textColorG,
      textColorB: textColorB ?? this.textColorB,
      borderColorA: borderColorA ?? this.borderColorA,
      borderColorR: borderColorR ?? this.borderColorR,
      borderColorG: borderColorG ?? this.borderColorG,
      borderColorB: borderColorB ?? this.borderColorB,
      backgroundColorA: backgroundColorA ?? this.backgroundColorA,
      backgroundColorR: backgroundColorR ?? this.backgroundColorR,
      backgroundColorG: backgroundColorG ?? this.backgroundColorG,
      backgroundColorB: backgroundColorB ?? this.backgroundColorB,
      overrideAssSubtitles: overrideAssSubtitles ?? this.overrideAssSubtitles,
    );
  }
}

/// Unified Material 3 subtitle appearance settings widget.
/// Eliminates the layout overflow bug, unifies typography and color controls,
/// and includes a live video subtitle preview box.
class SubtitleAppearanceWidget extends ConsumerStatefulWidget {
  final bool hasSubtitleTrack;
  const SubtitleAppearanceWidget({super.key, required this.hasSubtitleTrack});

  @override
  ConsumerState<SubtitleAppearanceWidget> createState() =>
      _SubtitleAppearanceWidgetState();
}

class _SubtitleAppearanceWidgetState
    extends ConsumerState<SubtitleAppearanceWidget> {
  String _colorTarget = 'text'; // 'text', 'border', 'background'
  late TextEditingController _fontSizeController;
  final FocusNode _fontSizeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(subtitleSettingsStateProvider);
    _fontSizeController = TextEditingController(
      text: '${settings.fontSize ?? 45}',
    );
  }

  @override
  void dispose() {
    _fontSizeController.dispose();
    _fontSizeFocusNode.dispose();
    super.dispose();
  }

  int _clampColor(int? v, int def) => (v ?? def).clamp(0, 255);

  void _updateFontSize(int value) {
    final clamped = value.clamp(10, 120);
    final current = ref.read(subtitleSettingsStateProvider);
    ref
        .read(subtitleSettingsStateProvider.notifier)
        .set(current.copyWith(fontSize: clamped), true);
    _fontSizeController.text = '$clamped';
  }

  void _updateColorChannel(String channel, int value, bool end) {
    final current = ref.read(subtitleSettingsStateProvider);
    final clamped = value.clamp(0, 255);
    final updated = switch (_colorTarget) {
      'text' => switch (channel) {
        'r' => current.copyWith(textColorR: clamped),
        'g' => current.copyWith(textColorG: clamped),
        'b' => current.copyWith(textColorB: clamped),
        _ => current.copyWith(textColorA: clamped),
      },
      'border' => switch (channel) {
        'r' => current.copyWith(borderColorR: clamped),
        'g' => current.copyWith(borderColorG: clamped),
        'b' => current.copyWith(borderColorB: clamped),
        _ => current.copyWith(borderColorA: clamped),
      },
      _ => switch (channel) {
        'r' => current.copyWith(backgroundColorR: clamped),
        'g' => current.copyWith(backgroundColorG: clamped),
        'b' => current.copyWith(backgroundColorB: clamped),
        _ => current.copyWith(backgroundColorA: clamped),
      },
    };
    ref.read(subtitleSettingsStateProvider.notifier).set(updated, end);
  }

  void _applyPresetColor(int r, int g, int b) {
    final current = ref.read(subtitleSettingsStateProvider);
    final updated = switch (_colorTarget) {
      'text' => current.copyWith(
        textColorR: r,
        textColorG: g,
        textColorB: b,
        textColorA: 255,
      ),
      'border' => current.copyWith(
        borderColorR: r,
        borderColorG: g,
        borderColorB: b,
        borderColorA: 255,
      ),
      _ => current.copyWith(
        backgroundColorR: r,
        backgroundColorG: g,
        backgroundColorB: b,
        backgroundColorA: 180,
      ),
    };
    ref.read(subtitleSettingsStateProvider.notifier).set(updated, true);
  }

  @override
  Widget build(BuildContext context) {
    final subSets = ref.watch(subtitleSettingsStateProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Synchronize controller text when not focused
    if (!_fontSizeFocusNode.hasFocus) {
      final currentSize = '${subSets.fontSize ?? 45}';
      if (_fontSizeController.text != currentSize) {
        _fontSizeController.text = currentSize;
      }
    }

    final textA = _clampColor(subSets.textColorA, 255);
    final textR = _clampColor(subSets.textColorR, 255);
    final textG = _clampColor(subSets.textColorG, 255);
    final textB = _clampColor(subSets.textColorB, 255);

    final borderA = _clampColor(subSets.borderColorA, 255);
    final borderR = _clampColor(subSets.borderColorR, 0);
    final borderG = _clampColor(subSets.borderColorG, 0);
    final borderB = _clampColor(subSets.borderColorB, 0);

    final bgA = _clampColor(subSets.backgroundColorA, 0);
    final bgR = _clampColor(subSets.backgroundColorR, 0);
    final bgG = _clampColor(subSets.backgroundColorG, 0);
    final bgB = _clampColor(subSets.backgroundColorB, 0);

    final textColor = Color.fromARGB(textA, textR, textG, textB);
    final borderColor = Color.fromARGB(borderA, borderR, borderG, borderB);
    final backgroundColor = Color.fromARGB(bgA, bgR, bgG, bgB);

    final (activeA, activeR, activeG, activeB) = switch (_colorTarget) {
      'text' => (textA, textR, textG, textB),
      'border' => (borderA, borderR, borderG, borderB),
      _ => (bgA, bgR, bgG, bgB),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subtitle track warning banner
          if (!widget.hasSubtitleTrack)
            Container(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.no_subtite_warning_message,
                      style: (textTheme.bodySmall ?? const TextStyle())
                          .copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ],
              ),
            ),

          // Live Subtitle Preview Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Center(
              child: Text(
                "Lorem ipsum dolor sit amet",
                style: subtileTextStyle(ref).copyWith(
                  fontSize: ((subSets.fontSize ?? 45) * 0.45).clamp(14.0, 24.0),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Typography section
          SettingsSectionLabel(context.l10n.font),
          SettingsStepperRow(
            label: context.l10n.font_size,
            controller: _fontSizeController,
            suffix: ' pt',
            keyboardType: TextInputType.number,
            onDecrement: () {
              final current = subSets.fontSize ?? 45;
              _updateFontSize(current - 1);
            },
            onIncrement: () {
              final current = subSets.fontSize ?? 45;
              _updateFontSize(current + 1);
            },
            onSubmitted: (text) {
              final val = int.tryParse(text);
              if (val != null) {
                _updateFontSize(val);
              } else {
                _fontSizeController.text = '${subSets.fontSize ?? 45}';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Style",
                    style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'bold',
                      icon: Icon(Icons.format_bold, size: 18),
                      tooltip: 'Bold',
                    ),
                    ButtonSegment(
                      value: 'italic',
                      icon: Icon(Icons.format_italic, size: 18),
                      tooltip: 'Italic',
                    ),
                  ],
                  selected: {
                    if (subSets.useBold ?? true) 'bold',
                    if (subSets.useItalic ?? false) 'italic',
                  },
                  emptySelectionAllowed: true,
                  multiSelectionEnabled: true,
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onSelectionChanged: (selection) {
                    final current = ref.read(subtitleSettingsStateProvider);
                    ref
                        .read(subtitleSettingsStateProvider.notifier)
                        .set(
                          current.copyWith(
                            useBold: selection.contains('bold'),
                            useItalic: selection.contains('italic'),
                          ),
                          true,
                        );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.20),
          ),

          // Color section
          SettingsSectionLabel(context.l10n.color),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.50,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Row(
                children: [
                  Expanded(
                    child: _ColorTab(
                      label: context.l10n.text,
                      color: textColor,
                      selected: _colorTarget == 'text',
                      onTap: () => setState(() => _colorTarget = 'text'),
                    ),
                  ),
                  Expanded(
                    child: _ColorTab(
                      label: context.l10n.border,
                      color: borderColor,
                      selected: _colorTarget == 'border',
                      onTap: () => setState(() => _colorTarget = 'border'),
                    ),
                  ),
                  Expanded(
                    child: _ColorTab(
                      label: context.l10n.background,
                      color: backgroundColor,
                      selected: _colorTarget == 'background',
                      onTap: () => setState(() => _colorTarget = 'background'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Preset Color Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PresetChip(
                  color: const Color(0xFFFFFFFF),
                  tooltip: 'White',
                  onTap: () => _applyPresetColor(255, 255, 255),
                ),
                _PresetChip(
                  color: const Color(0xFFFFEB3B),
                  tooltip: 'Yellow',
                  onTap: () => _applyPresetColor(255, 235, 59),
                ),
                _PresetChip(
                  color: const Color(0xFF00E5FF),
                  tooltip: 'Cyan',
                  onTap: () => _applyPresetColor(0, 229, 255),
                ),
                _PresetChip(
                  color: const Color(0xFF69F0AE),
                  tooltip: 'Green',
                  onTap: () => _applyPresetColor(105, 240, 174),
                ),
                _PresetChip(
                  color: const Color(0xFFFFAB40),
                  tooltip: 'Orange',
                  onTap: () => _applyPresetColor(255, 171, 64),
                ),
                _PresetChip(
                  color: const Color(0xFF000000),
                  tooltip: 'Black',
                  onTap: () => _applyPresetColor(0, 0, 0),
                ),
              ],
            ),
          ),

          // RGBA Channel Sliders
          _ColorChannelSlider(
            label: 'R',
            value: activeR,
            channelColor: Colors.redAccent,
            onChanged: (v) => _updateColorChannel('r', v, true),
          ),
          _ColorChannelSlider(
            label: 'G',
            value: activeG,
            channelColor: Colors.greenAccent,
            onChanged: (v) => _updateColorChannel('g', v, true),
          ),
          _ColorChannelSlider(
            label: 'B',
            value: activeB,
            channelColor: Colors.lightBlueAccent,
            onChanged: (v) => _updateColorChannel('b', v, true),
          ),
          _ColorChannelSlider(
            label: 'A',
            value: activeA,
            channelColor: Colors.grey.shade400,
            onChanged: (v) => _updateColorChannel('a', v, true),
          ),

          // Reset button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  ref.read(subtitleSettingsStateProvider.notifier).reset();
                  _fontSizeController.text = '45';
                  setState(() {
                    _colorTarget = 'text';
                  });
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(context.l10n.reset),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorTab extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorTab({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Material(
      color: selected
          ? colorScheme.surfaceContainerHighest
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _PresetChip({
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorChannelSlider extends StatelessWidget {
  final String label;
  final int value;
  final Color channelColor;
  final ValueChanged<int> onChanged;

  const _ColorChannelSlider({
    required this.label,
    required this.value,
    required this.channelColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              label,
              style: (textTheme.labelLarge ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.bold,
                color: channelColor,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor: channelColor,
                thumbColor: channelColor,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: value.toDouble().clamp(0, 255),
                min: 0,
                max: 255,
                divisions: 255,
                onChanged: (v) => onChanged(v.round().clamp(0, 255)),
              ),
            ),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.end,
              style: (textTheme.labelMedium ?? const TextStyle()).copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias for [SubtitleAppearanceWidget].
class FontSettingWidget extends StatelessWidget {
  final bool hasSubtitleTrack;
  const FontSettingWidget({super.key, required this.hasSubtitleTrack});

  @override
  Widget build(BuildContext context) {
    return SubtitleAppearanceWidget(hasSubtitleTrack: hasSubtitleTrack);
  }
}

/// Backward compatibility alias.
class ColorSettingWidget extends StatelessWidget {
  final bool hasSubtitleTrack;
  const ColorSettingWidget({super.key, required this.hasSubtitleTrack});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

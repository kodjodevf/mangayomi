import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../alphas.dart';
import '../tokens.dart';
import 'choice.dart';
import 'section_header.dart';

/// A group of settings under a quiet label, with an optional note under the
/// rows: "Reading", "Downloads". A long settings screen is a column of
/// these, so its parts can be found by eye.
class ShioriSettingsGroup extends StatelessWidget {
  const ShioriSettingsGroup({
    super.key,
    this.title,
    required this.children,
    this.footer,
  });

  final String? title;
  final List<Widget> children;

  /// What the group's rows have in common that none of them says: a caveat,
  /// a consequence.
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Padding(
      padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ShioriSpace.s16,
                ShioriSpace.s16,
                ShioriSpace.s16,
                ShioriSpace.s4,
              ),
              child: ShioriGroupLabel(title!, maxLines: 2),
            ),
          ...children,
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                ShioriSpace.s16,
                ShioriSpace.s4,
                ShioriSpace.s16,
                0,
              ),
              child: Text(
                footer!,
                style: tokens.text.meta.copyWith(color: tokens.color.fgMuted),
              ),
            ),
        ],
      ),
    );
  }
}

/// A setting that opens something: a screen, a sheet, an action.
///
/// Built on [ListTile], so focus, keyboard and D-pad activation and semantics
/// come from Material; Shiori sets the icon, the type and the spacing.
class ShioriSettingRow extends StatelessWidget {
  const ShioriSettingRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.destructive = false,
    this.autofocus = false,
  });

  final String title;

  /// One or two muted lines: what the setting does, or its current value.
  final String? subtitle;

  /// A leading `Symbols.*_rounded` glyph.
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  /// For an action that deletes or resets: the title in the error colour.
  final bool destructive;

  /// Takes focus when the screen opens: the first row of a TV screen.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final error = Theme.of(context).colorScheme.error;
    return _Surface(
      ListTile(
        autofocus: autofocus,
        enabled: enabled,
        leading: _leading(icon, destructive ? error : null),
        title: Text(title, style: destructive ? TextStyle(color: error) : null),
        subtitle: subtitle == null || subtitle!.isEmpty
            ? null
            : Text(subtitle!, maxLines: 3, overflow: TextOverflow.ellipsis),
        trailing: trailing,
        minTileHeight: tokens.density.rowHeight,
        onTap: onTap,
      ),
    );
  }
}

/// A setting that is on or off. The whole row toggles it.
class ShioriSwitchRow extends StatelessWidget {
  const ShioriSwitchRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    required this.onChanged,
    this.autofocus = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool value;
  final bool autofocus;

  /// Null disables the row.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final subtitleText = subtitle == null || subtitle!.isEmpty
        ? null
        : Text(subtitle!, maxLines: 3, overflow: TextOverflow.ellipsis);
    if (tokens.density == ShioriDensity.tv) {
      // Material's switch keeps its phone size beside text a third larger,
      // too small to read across a room. On TV the row draws it scaled, and
      // stays the one thing the remote lands on: the switch itself takes no
      // focus and no taps, the row toggles it.
      return _Surface(
        MergeSemantics(
          child: Semantics(
            toggled: value,
            child: ListTile(
              autofocus: autofocus,
              enabled: onChanged != null,
              leading: _leading(icon),
              title: Text(title),
              subtitle: subtitleText,
              minTileHeight: tokens.density.rowHeight,
              onTap: onChanged == null ? null : () => onChanged!(!value),
              trailing: ExcludeFocus(
                child: IgnorePointer(
                  // The scale is painted around the centre; the padding
                  // gives back the room it takes, so the switch stays on
                  // the row's margin.
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 52 * (tokens.density.typeScale - 1) / 2,
                    ),
                    child: Transform.scale(
                      scale: tokens.density.typeScale,
                      child: Switch(value: value, onChanged: onChanged),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return _Surface(
      SwitchListTile(
        autofocus: autofocus,
        secondary: _leading(icon),
        title: Text(title),
        subtitle: subtitleText,
        value: value,
        onChanged: onChanged,
        minTileHeight: tokens.density.rowHeight,
      ),
    );
  }
}

/// A setting with one value out of several. The row shows the current value
/// under its title; a tap opens [showShioriChoice] with every option, the
/// current one checked, and picking one closes it.
///
/// The value is in the row so that nobody has to open it to know what it is
/// set to.
class ShioriValueRow<T> extends StatelessWidget {
  const ShioriValueRow({
    super.key,
    required this.title,
    this.icon,
    required this.value,
    required this.options,
    required this.onChanged,
    this.description,
    this.autofocus = false,
    this.searchHint,
  });

  final String title;
  final IconData? icon;
  final T value;
  final List<ShioriChoice<T>> options;

  /// Null disables the row.
  final ValueChanged<T>? onChanged;

  /// What the setting does, under the value, when its title doesn't say.
  final String? description;
  final bool autofocus;

  /// A search field over the options, for a long list (languages).
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    final current = options.where((o) => o.value == value).firstOrNull;
    final label = current?.label ?? '$value';
    return ShioriSettingRow(
      autofocus: autofocus,
      title: title,
      icon: icon,
      enabled: onChanged != null,
      subtitle: description == null ? label : '$label\n$description',
      onTap: onChanged == null
          ? null
          : () async {
              final picked = await showShioriChoice<T>(
                context,
                title: title,
                options: options,
                selected: value,
                searchHint: searchHint,
              );
              if (picked != null && picked != value) onChanged!(picked);
            },
    );
  }
}

/// A setting on a continuous or stepped scale: the title and the value on
/// one line, the slider under them. [onReset] adds a way back to the
/// default, shown only while the value differs from it.
class ShioriSliderRow extends StatelessWidget {
  const ShioriSliderRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.onChangeEnd,
    this.valueLabel,
    this.defaultValue,
    this.onReset,
    this.resetTooltip,
    this.stepTooltips,
  });

  final String title;

  /// What the setting does, under the title.
  final String? subtitle;
  final IconData? icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;

  /// Null disables the row.
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;

  /// How the value reads: "1.5×", "120 %". Defaults to the number; an
  /// empty label shows none, for a title that already says the value.
  final String Function(double value)? valueLabel;
  final double? defaultValue;
  final VoidCallback? onReset;

  /// Names the reset button; required with [onReset].
  final String? resetTooltip;

  /// Adds − and + buttons on either side of the slider, one step each, for
  /// a value that is set precisely (a font size); the pair names them.
  final (String decrease, String increase)? stepTooltips;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final enabled = onChanged != null;
    final label =
        valueLabel?.call(value) ??
        (value == value.roundToDouble()
            ? value.toInt().toString()
            : value.toStringAsFixed(1));
    final showReset =
        onReset != null && defaultValue != null && value != defaultValue;
    final fg = enabled ? c.fg : c.fg.withValues(alpha: Alphas.disabled);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s8,
        ShioriSpace.s8,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: ShioriSpace.s16,
            children: [
              if (icon != null)
                Icon(icon, color: c.fgMuted, size: tokens.scaled(24)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      title,
                      style: tokens.text.body.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.text.meta.copyWith(color: c.fgMuted),
                      ),
                  ],
                ),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: tokens.text.row.copyWith(
                    color: enabled ? c.accentInk : fg,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              if (showReset)
                IconButton(
                  tooltip: resetTooltip,
                  onPressed: enabled ? onReset : null,
                  icon: const Icon(Symbols.restart_alt_rounded),
                )
              else
                const SizedBox(width: ShioriSpace.s8),
            ],
          ),
          _withSteps(
            context,
            _DpadSlider(
              enabled: enabled && tokens.density == ShioriDensity.tv,
              step: _step,
              value: value,
              min: min,
              max: max,
              onChanged: (v) {
                onChanged?.call(v);
                onChangeEnd?.call(v);
              },
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                label: label.isEmpty ? null : label,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _step => (max - min) / (divisions ?? 20);

  void _stepBy(int direction) {
    final next = (value + direction * _step).clamp(min, max);
    if (next == value) return;
    onChanged?.call(next);
    onChangeEnd?.call(next);
  }

  Widget _withSteps(BuildContext context, Widget slider) {
    final tooltips = stepTooltips;
    if (tooltips == null) return slider;
    final enabled = onChanged != null;
    return Row(
      children: [
        IconButton(
          tooltip: tooltips.$1,
          onPressed: enabled && value > min ? () => _stepBy(-1) : null,
          icon: const Icon(Symbols.remove_rounded),
        ),
        Expanded(child: slider),
        IconButton(
          tooltip: tooltips.$2,
          onPressed: enabled && value < max ? () => _stepBy(1) : null,
          icon: const Icon(Symbols.add_rounded),
        ),
      ],
    );
  }
}

/// A Material [Slider] takes all four arrow keys, so a TV remote can reach
/// it but never leave. On TV this owns the focus instead: Left and Right
/// step the value, Up, Down and Select move on, and the slider underneath
/// is out of the focus order. It draws its own focus ring, since the
/// slider no longer can.
class _DpadSlider extends StatefulWidget {
  const _DpadSlider({
    required this.enabled,
    required this.step,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.child,
  });

  final bool enabled;
  final double step;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Widget child;

  @override
  State<_DpadSlider> createState() => _DpadSliderState();
}

class _DpadSliderState extends State<_DpadSlider> {
  bool _focused = false;

  /// The last value sent, until the row rebuilds with it: a held key
  /// repeats faster than frames, and each step must start from the last.
  double? _sent;

  @override
  void didUpdateWidget(_DpadSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sent = null;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final direction = switch (event.logicalKey) {
      LogicalKeyboardKey.arrowLeft => -1,
      LogicalKeyboardKey.arrowRight => 1,
      _ => 0,
    };
    if (direction == 0) return KeyEventResult.ignored;
    final current = _sent ?? widget.value;
    final next = (current + direction * widget.step).clamp(
      widget.min,
      widget.max,
    );
    if (next != current) widget.onChanged(_sent = next);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final accent = context.shiori.color.accent;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: _onKey,
      child: AnimatedContainer(
        duration: ShioriMotion.fast,
        // The border is always there, transparent at rest, so focusing
        // never moves the slider.
        decoration: BoxDecoration(
          color: _focused
              ? accent.withValues(alpha: Alphas.focus)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ShioriShape.card),
          border: Border.all(
            color: _focused ? accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ExcludeFocus(child: widget.child),
      ),
    );
  }
}

/// Rows paint their ink on their own surface, so a row set on a card or a
/// coloured panel still shows its press and focus.
class _Surface extends StatelessWidget {
  const _Surface(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Material(type: MaterialType.transparency, child: child);
}

/// A row's leading glyph, at the density's scale like the text beside it:
/// a TV row's title is a third larger, and so is its icon.
Widget? _leading(IconData? icon, [Color? color]) =>
    icon == null ? null : _LeadingIcon(icon, color);

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon(this.icon, this.color);

  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      Icon(icon, color: color, size: context.shiori.scaled(24));
}

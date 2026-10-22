import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// One selectable row inside a settings section: a label, an
/// optional trailing hint (codec, keyboard shortcut...) and a filled
/// checkmark when selected.
class SettingsOptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final String? hint;
  final VoidCallback onTap;

  const SettingsOptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: tokens.density.rowHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
            child: Row(
              spacing: ShioriSpace.s12,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: tokens.text.row.copyWith(
                      color: tokens.color.fg,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hint != null)
                  Text(
                    hint!,
                    style: tokens.caption.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                SizedBox.square(
                  dimension: 24,
                  child: selected
                      ? Icon(
                          Symbols.check_rounded,
                          color: tokens.color.accentInk,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A non-selectable action row — same density as [SettingsOptionRow], but a
/// leading icon and a chevron instead of a checkmark.
class SettingsActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsActionRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.shiori.density.rowHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: context.shiori.scaled(24),
                  color: context.shiori.color.fgMuted,
                ),
                const SizedBox(width: ShioriSpace.s16),
                Expanded(
                  child: Text(
                    label,
                    style: context.shiori.text.row.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                ),
                Icon(
                  Symbols.chevron_right_rounded,
                  fill: 1,
                  size: 18,
                  color: context.shiori.color.fgMuted.withValues(alpha: 0.70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A group label inside a section body.
class SettingsSectionLabel extends StatelessWidget {
  final String text;
  const SettingsSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        ShioriSpace.s12,
        ShioriSpace.s16,
        ShioriSpace.s8,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: ShioriGroupLabel(text),
      ),
    );
  }
}

/// A "-"/"+" stepper row supporting optional manual text editing.
class SettingsStepperRow extends StatelessWidget {
  final String label;
  final String? value;
  final TextEditingController? controller;
  final String? suffix;
  final TextInputType? keyboardType;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const SettingsStepperRow({
    super.key,
    required this.label,
    this.value,
    this.controller,
    this.suffix,
    this.keyboardType,
    required this.onDecrement,
    required this.onIncrement,
    this.onChanged,
    this.onSubmitted,
  }) : assert(
         value != null || controller != null,
         'Must provide value or controller',
       );

  @override
  Widget build(BuildContext context) {
    final onSurface = context.shiori.color.fg;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: context.shiori.text.row.copyWith(
                color: context.shiori.color.fgMuted,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.shiori.color.ink3.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(ShioriShape.cover),
              border: Border.all(
                color: context.shiori.color.hairline.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Symbols.remove_rounded,
                  onTap: onDecrement,
                ),
                if (controller != null)
                  SizedBox(
                    width: 78,
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      textAlign: TextAlign.center,
                      cursorHeight: 14,
                      style: context.shiori.text.meta.copyWith(
                        color: onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: ShioriSpace.s8,
                          horizontal: ShioriSpace.s4,
                        ),
                        border: InputBorder.none,
                        suffixText: suffix,
                        suffixStyle: context.shiori.text.badge.copyWith(
                          color: context.shiori.color.fgMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  )
                else
                  SizedBox(
                    width: 64,
                    child: Text(
                      value ?? '',
                      textAlign: TextAlign.center,
                      style: context.shiori.text.meta.copyWith(
                        color: onSurface,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                _StepperButton(icon: Symbols.add_rounded, onTap: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 16, color: context.shiori.color.fg),
        ),
      ),
    );
  }
}

/// A small persistent pill for a bottom rail (e.g. current speed, fit mode)
/// so the value stays glanceable without opening a menu.
class PlayerPillButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final GestureLongPressCallback? onLongPress;
  final String? tooltip;
  final bool active;
  final bool isCompact;
  final bool showLabel;

  const PlayerPillButton({
    super.key,
    required this.onTap,
    this.onLongPress,
    this.icon,
    this.label,
    this.tooltip,
    this.active = false,
    this.isCompact = false,
    this.showLabel = true,
  }) : assert(
         icon != null || (showLabel && label != null),
         'Must provide a visible icon or label',
       );

  @override
  Widget build(BuildContext context) {
    final visibleLabel = showLabel ? label : null;
    return ShioriOverlayPill(
      icon: icon,
      label: visibleLabel,
      tooltip: tooltip ?? (visibleLabel == null ? label : null),
      semanticsValue: visibleLabel == null && tooltip != null ? label : null,
      emphasized: active,
      compact: isCompact,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

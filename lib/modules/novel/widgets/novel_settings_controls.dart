import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// A labelled part of the novel reader's settings: the label where a
/// Shiori settings group puts it, the controls under it. [inset] lines a
/// hand-built control up with the label; rows (sliders, switches) bring
/// their own margins and leave it off.
class NovelSettingSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool inset;

  const NovelSettingSection({
    super.key,
    required this.title,
    required this.child,
    this.inset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            ShioriSpace.s16,
            ShioriSpace.s16,
            ShioriSpace.s8,
          ),
          child: ShioriGroupLabel(title, maxLines: 2),
        ),
        if (inset)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
            child: child,
          )
        else
          child,
      ],
    );
  }
}

/// A switch in the novel reader's settings.
class NovelSwitchSetting extends StatelessWidget {
  final String title;
  final bool value;
  final IconData? icon;
  final ValueChanged<bool> onChanged;

  const NovelSwitchSetting({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => ShioriSwitchRow(
    icon: icon,
    title: title,
    value: value,
    onChanged: onChanged,
  );
}

class NovelThemeButton extends StatelessWidget {
  final String backgroundColor;
  final String textColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NovelThemeButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  Color _parseColor(String hex) {
    final hexColor = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.shiori.color.accent;
    final bg = _parseColor(backgroundColor);
    final txt = _parseColor(textColor);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        child: AnimatedContainer(
          duration: ShioriMotion.standard,
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(ShioriShape.card),
            border: Border.all(
              color: isSelected ? primaryColor : context.shiori.color.hairline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Aa',
                      style: TextStyle(
                        color: txt,
                        fontSize: context.shiori.text.body.fontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: txt.withValues(alpha: 0.9),
                          fontSize: context.shiori.text.badge.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.check_rounded,
                      fill: 1,
                      size: 9,
                      color: Colors.white,
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

class NovelColorPicker extends StatelessWidget {
  final String label;
  final String color;
  final ValueChanged<String> onColorChanged;

  const NovelColorPicker({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  Color _parseColor(String hex) {
    final hexColor = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showColorPickerDialog(BuildContext context) {
    Color selectedColor = _parseColor(color);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShioriDialog(
          title: context.l10n.select_label_color(label),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _colorOption(
                      context,
                      Colors.white,
                      selectedColor,
                      context.l10n.page_color_white,
                    ),
                    _colorOption(
                      context,
                      Colors.black,
                      selectedColor,
                      context.l10n.page_color_black,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      const Color(0xFF292832),
                      selectedColor,
                      context.l10n.page_color_night,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      const Color(0xFFF5E6D3),
                      selectedColor,
                      context.l10n.page_color_sepia,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      const Color(0xFF5F4B32),
                      selectedColor,
                      context.l10n.page_color_coffee,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      const Color(0xFFCCCCCC),
                      selectedColor,
                      context.l10n.page_color_silver,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.grey[800]!,
                      selectedColor,
                      context.l10n.page_color_graphite,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.grey[300]!,
                      selectedColor,
                      context.l10n.page_color_mist,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.brown[100]!,
                      selectedColor,
                      context.l10n.page_color_paper,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.blue[100]!,
                      selectedColor,
                      context.l10n.page_color_sky,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.green[100]!,
                      selectedColor,
                      context.l10n.page_color_mint,
                    ),
                    _colorOption(
                      context,
                      // shiori: a page colour the reader picks; it styles the book, not the interface
                      Colors.amber[100]!,
                      selectedColor,
                      context.l10n.page_color_honey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ShioriButton.quiet(
              label: context.l10n.cancel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _colorOption(
    BuildContext context,
    Color optionColor,
    Color selectedColor,
    String name,
  ) {
    final isSelected = optionColor.toARGB32() == selectedColor.toARGB32();
    // A swatch alone says nothing to a screen reader, and little to anyone
    // choosing between two greys.
    return Tooltip(
      message: name,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: name,
        child: _swatch(context, optionColor, isSelected),
      ),
    );
  }

  Widget _swatch(BuildContext context, Color optionColor, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onColorChanged(_colorToHex(optionColor));
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        child: AnimatedContainer(
          duration: ShioriMotion.standard,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: optionColor,
            borderRadius: BorderRadius.circular(ShioriShape.cover),
            border: Border.all(
              color: isSelected
                  ? context.shiori.color.accentInk
                  : context.shiori.color.fgMuted,
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: isSelected
              ? Icon(
                  Symbols.check_circle_rounded,
                  fill: 1,
                  size: 22,
                  color: ShioriColors.onFill(optionColor),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showColorPickerDialog(context),
        borderRadius: BorderRadius.circular(ShioriShape.card),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ShioriSpace.s12,
            vertical: ShioriSpace.s8,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: context.shiori.color.hairline, width: 1),
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  borderRadius: BorderRadius.circular(ShioriShape.cover),
                  border: Border.all(
                    color: context.shiori.color.hairline,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: ShioriSpace.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.shiori.text.badge.fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      color,
                      style: TextStyle(
                        fontSize: context.shiori.text.badge.fontSize,
                        color: context.shiori.color.fgMuted,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Symbols.palette_rounded,
                color: context.shiori.color.accent.withValues(
                  alpha: Alphas.accentTint,
                ),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NovelAlignButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NovelAlignButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ShioriShape.cover),
        child: AnimatedContainer(
          duration: ShioriMotion.standard,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected
                ? context.shiori.color.accent.withValues(
                    alpha: Alphas.accentTint,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ShioriShape.cover),
            border: Border.all(
              color: isSelected
                  ? context.shiori.color.accent
                  : context.shiori.color.hairline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected
                ? context.shiori.color.accent
                : context.shiori.color.fg,
          ),
        ),
      ),
    );
  }
}

class NovelModeChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NovelModeChipButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.shiori.color.accent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ShioriShape.card),
        child: AnimatedContainer(
          duration: ShioriMotion.standard,
          padding: const EdgeInsets.symmetric(
            horizontal: ShioriSpace.s8,
            vertical: ShioriSpace.s8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: Alphas.accentTint)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ShioriShape.card),
            border: Border.all(
              color: isSelected ? primaryColor : context.shiori.color.hairline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected ? primaryColor : context.shiori.color.fg,
              ),
              const SizedBox(width: ShioriSpace.s8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.shiori.text.meta.fontSize,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? primaryColor : context.shiori.color.fg,
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

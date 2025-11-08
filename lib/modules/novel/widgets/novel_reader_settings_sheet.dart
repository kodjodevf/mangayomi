import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class ReaderSettingsTab extends ConsumerWidget {
  const ReaderSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ref.watch(novelReaderPaddingStateProvider);
    final lineHeight = ref.watch(novelReaderLineHeightStateProvider);
    final textAlign = ref.watch(novelTextAlignStateProvider);
    final backgroundColor = ref.watch(novelReaderThemeStateProvider);
    final textColor = ref.watch(novelReaderTextColorStateProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SettingSection(
            title: 'Theme',
            child: Column(
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ThemeButton(
                      backgroundColor: '#292832',
                      textColor: '#CCCCCC',
                      label: 'Dark',
                      isSelected: backgroundColor == '#292832',
                      onTap: () {
                        ref
                            .read(novelReaderThemeStateProvider.notifier)
                            .set('#292832');
                        ref
                            .read(novelReaderTextColorStateProvider.notifier)
                            .set('#CCCCCC');
                      },
                    ),
                    _ThemeButton(
                      backgroundColor: '#FFFFFF',
                      textColor: '#000000',
                      label: 'Light',
                      isSelected: backgroundColor == '#FFFFFF',
                      onTap: () {
                        ref
                            .read(novelReaderThemeStateProvider.notifier)
                            .set('#FFFFFF');
                        ref
                            .read(novelReaderTextColorStateProvider.notifier)
                            .set('#000000');
                      },
                    ),
                    _ThemeButton(
                      backgroundColor: '#000000',
                      textColor: '#FFFFFF',
                      label: 'Black',
                      isSelected: backgroundColor == '#000000',
                      onTap: () {
                        ref
                            .read(novelReaderThemeStateProvider.notifier)
                            .set('#000000');
                        ref
                            .read(novelReaderTextColorStateProvider.notifier)
                            .set('#FFFFFF');
                      },
                    ),
                    _ThemeButton(
                      backgroundColor: '#F5E6D3',
                      textColor: '#5F4B32',
                      label: 'Sepia',
                      isSelected: backgroundColor == '#F5E6D3',
                      onTap: () {
                        ref
                            .read(novelReaderThemeStateProvider.notifier)
                            .set('#F5E6D3');
                        ref
                            .read(novelReaderTextColorStateProvider.notifier)
                            .set('#5F4B32');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ColorPicker(
                        label: 'Background',
                        color: backgroundColor,
                        onColorChanged: (color) {
                          ref
                              .read(novelReaderThemeStateProvider.notifier)
                              .set(color);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ColorPicker(
                        label: 'Text',
                        color: textColor,
                        onColorChanged: (color) {
                          ref
                              .read(novelReaderTextColorStateProvider.notifier)
                              .set(color);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          _SettingSection(
            title: 'Text Align',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AlignButton(
                  icon: Icons.format_align_left,
                  isSelected: textAlign == NovelTextAlign.left,
                  onTap: () {
                    ref
                        .read(novelTextAlignStateProvider.notifier)
                        .set(NovelTextAlign.left);
                  },
                ),
                _AlignButton(
                  icon: Icons.format_align_center,
                  isSelected: textAlign == NovelTextAlign.center,
                  onTap: () {
                    ref
                        .read(novelTextAlignStateProvider.notifier)
                        .set(NovelTextAlign.center);
                  },
                ),
                _AlignButton(
                  icon: Icons.format_align_right,
                  isSelected: textAlign == NovelTextAlign.right,
                  onTap: () {
                    ref
                        .read(novelTextAlignStateProvider.notifier)
                        .set(NovelTextAlign.right);
                  },
                ),
                _AlignButton(
                  icon: Icons.format_align_justify,
                  isSelected: textAlign == NovelTextAlign.block,
                  onTap: () {
                    ref
                        .read(novelTextAlignStateProvider.notifier)
                        .set(NovelTextAlign.block);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SettingSection(
            title: 'Padding',
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.space_bar, size: 20),
                    Expanded(
                      child: Slider(
                        value: padding.toDouble(),
                        min: 0,
                        max: 50,
                        divisions: 50,
                        label: '$padding px',
                        onChanged: (value) {
                          ref
                              .read(novelReaderPaddingStateProvider.notifier)
                              .set(value.toInt());
                        },
                      ),
                    ),
                    Text('${padding}px'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _SettingSection(
            title: 'Line Height',
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.height, size: 20),
                    Expanded(
                      child: Slider(
                        value: lineHeight,
                        min: 1.0,
                        max: 3.0,
                        divisions: 20,
                        label: lineHeight.toStringAsFixed(1),
                        onChanged: (value) {
                          ref
                              .read(novelReaderLineHeightStateProvider.notifier)
                              .set(value);
                        },
                      ),
                    ),
                    Text(lineHeight.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralSettingsTab extends ConsumerWidget {
  final ValueNotifier<bool> autoScrollPage;
  final ValueNotifier<bool> autoScroll;
  final NovelReaderController readerController;
  final ValueNotifier<double> pageOffset;
  const GeneralSettingsTab({
    required this.autoScrollPage,
    required this.autoScroll,
    required this.readerController,
    required this.pageOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SwitchListTileSetting(
            title: 'Show Scroll Percentage',
            value: ref.watch(novelShowScrollPercentageStateProvider),
            onChanged: (value) {
              ref
                  .read(novelShowScrollPercentageStateProvider.notifier)
                  .set(value);
            },
          ),
          ValueListenableBuilder(
            valueListenable: autoScrollPage,
            builder: (context, valueT, child) {
              return Column(
                children: [
                  _SwitchListTileSetting(
                    secondary: Icon(
                      valueT ? Icons.timer : Icons.timer_outlined,
                    ),
                    value: valueT,
                    title: context.l10n.auto_scroll,
                    onChanged: (val) {
                      readerController.setAutoScroll(val, pageOffset.value);
                      autoScrollPage.value = val;
                      autoScroll.value = val;
                    },
                  ),
                  if (valueT)
                    ValueListenableBuilder(
                      valueListenable: pageOffset,
                      builder: (context, value, child) => Slider(
                        min: 2.0,
                        max: 30.0,
                        divisions: max(28, 3),
                        value: value,
                        onChanged: (val) {
                          pageOffset.value = val;
                        },
                        onChangeEnd: (val) {
                          readerController.setAutoScroll(valueT, val);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
          _SwitchListTileSetting(
            title: 'Remove Extra Paragraph Spacing',
            value: ref.watch(novelRemoveExtraParagraphSpacingStateProvider),
            onChanged: (value) {
              ref
                  .read(novelRemoveExtraParagraphSpacingStateProvider.notifier)
                  .set(value);
            },
          ),

          // _SwitchListTileSetting(
          //   title: 'Tap to Scroll',
          //   subtitle: 'Tap screen to scroll up/down',
          //   value: ref.watch(novelTapToScrollStateProvider),
          //   onChanged: (value) {
          //     ref.read(novelTapToScrollStateProvider.notifier).set(value);
          //   },
          // ),
        ],
      ),
    );
  }
}

class _SettingSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _SwitchListTileSetting extends StatelessWidget {
  final String title;
  final bool value;
  final Widget? secondary;
  final ValueChanged<bool> onChanged;

  const _SwitchListTileSetting({
    required this.title,
    required this.value,
    required this.onChanged,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: secondary,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(
            context,
          ).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
          fontSize: 14,
        ),
      ),

      value: value,
      onChanged: onChanged,
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String backgroundColor;
  final String textColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeButton({
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 60,
        decoration: BoxDecoration(
          color: _parseColor(backgroundColor),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aa',
              style: TextStyle(
                color: _parseColor(textColor),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: _parseColor(textColor), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final String color;
  final ValueChanged<String> onColorChanged;

  const _ColorPicker({
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
        return AlertDialog(
          title: Text('Select $label Color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _colorOption(context, Colors.white, selectedColor),
                    _colorOption(context, Colors.black, selectedColor),
                    _colorOption(
                      context,
                      const Color(0xFF292832),
                      selectedColor,
                    ),
                    _colorOption(
                      context,
                      const Color(0xFFF5E6D3),
                      selectedColor,
                    ),
                    _colorOption(
                      context,
                      const Color(0xFF5F4B32),
                      selectedColor,
                    ),
                    _colorOption(
                      context,
                      const Color(0xFFCCCCCC),
                      selectedColor,
                    ),
                    _colorOption(context, Colors.grey[800]!, selectedColor),
                    _colorOption(context, Colors.grey[300]!, selectedColor),
                    _colorOption(context, Colors.brown[100]!, selectedColor),
                    _colorOption(context, Colors.blue[100]!, selectedColor),
                    _colorOption(context, Colors.green[100]!, selectedColor),
                    _colorOption(context, Colors.amber[100]!, selectedColor),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
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
  ) {
    final isSelected = optionColor.toARGB32() == selectedColor.toARGB32();
    return GestureDetector(
      onTap: () {
        onColorChanged(_colorToHex(optionColor));
        Navigator.of(context).pop();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: optionColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: optionColor.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showColorPickerDialog(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: _parseColor(color),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12)),
                  Text(
                    color,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class _AlignButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AlignButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/novel/widgets/novel_settings_controls.dart';

class ReaderSettingsTab extends ConsumerStatefulWidget {
  final NovelReaderController? readerController;
  final ReaderMode? currentReaderMode;
  final ValueChanged<ReaderMode>? onReaderModeChanged;
  final PageMode? currentPageMode;
  final ValueChanged<PageMode>? onPageModeChanged;

  const ReaderSettingsTab({
    super.key,
    this.readerController,
    this.currentReaderMode,
    this.onReaderModeChanged,
    this.currentPageMode,
    this.onPageModeChanged,
  });

  @override
  ConsumerState<ReaderSettingsTab> createState() => _ReaderSettingsTabState();
}

class _ReaderSettingsTabState extends ConsumerState<ReaderSettingsTab> {
  late ReaderMode? _readerMode;
  late PageMode? _pageMode;

  @override
  void initState() {
    super.initState();
    _readerMode = widget.currentReaderMode;
    _pageMode = widget.currentPageMode;
  }

  @override
  void didUpdateWidget(covariant ReaderSettingsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentReaderMode != oldWidget.currentReaderMode) {
      _readerMode = widget.currentReaderMode;
    }
    if (widget.currentPageMode != oldWidget.currentPageMode) {
      _pageMode = widget.currentPageMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = ref.watch(novelReaderPaddingStateProvider);
    final lineHeight = ref.watch(novelReaderLineHeightStateProvider);
    final textAlign = ref.watch(novelTextAlignStateProvider);
    final backgroundColor = ref.watch(novelReaderThemeStateProvider);
    final textColor = ref.watch(novelReaderTextColorStateProvider);
    final fontFamilyKey = ref.watch(novelFontFamilyStateProvider);
    final fontSize = ref.watch(novelFontSizeStateProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          NovelSettingSection(
            title: context.l10n.theme,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: NovelThemeButton(
                        backgroundColor: '#292832',
                        textColor: '#CCCCCC',
                        label: context.l10n.theme_dark,
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NovelThemeButton(
                        backgroundColor: '#FFFFFF',
                        textColor: '#000000',
                        label: context.l10n.theme_light,
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NovelThemeButton(
                        backgroundColor: '#000000',
                        textColor: '#FFFFFF',
                        label: context.l10n.theme_black,
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NovelThemeButton(
                        backgroundColor: '#F5E6D3',
                        textColor: '#5F4B32',
                        label: context.l10n.theme_sepia,
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: NovelColorPicker(
                        label: context.l10n.background,
                        color: backgroundColor,
                        onColorChanged: (color) {
                          ref
                              .read(novelReaderThemeStateProvider.notifier)
                              .set(color);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NovelColorPicker(
                        label: context.l10n.text,
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

          const SizedBox(height: 10),
          NovelSettingSection(
            title: context.l10n.text_align,
            child: Row(
              children: [
                Expanded(
                  child: NovelAlignButton(
                    icon: Icons.format_align_left,
                    isSelected: textAlign == NovelTextAlign.left,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.left);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: NovelAlignButton(
                    icon: Icons.format_align_center,
                    isSelected: textAlign == NovelTextAlign.center,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.center);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: NovelAlignButton(
                    icon: Icons.format_align_right,
                    isSelected: textAlign == NovelTextAlign.right,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.right);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: NovelAlignButton(
                    icon: Icons.format_align_justify,
                    isSelected: textAlign == NovelTextAlign.block,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.block);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          NovelSettingSection(
            title: context.l10n.font_size,
            child: Row(
              children: [
                Icon(
                  Icons.format_size_rounded,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 4),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: fontSize > 8
                      ? () {
                          ref
                              .read(novelFontSizeStateProvider.notifier)
                              .set(fontSize - 1);
                        }
                      : null,
                  icon: const Icon(Icons.remove_rounded, size: 18),
                  tooltip: context.l10n.decrease,
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                      thumbColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: fontSize.toDouble().clamp(8.0, 40.0),
                      min: 8,
                      max: 40,
                      divisions: 32,
                      label: '$fontSize px',
                      onChanged: (value) {
                        ref
                            .read(novelFontSizeStateProvider.notifier)
                            .set(value.toInt());
                      },
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: fontSize < 40
                      ? () {
                          ref
                              .read(novelFontSizeStateProvider.notifier)
                              .set(fontSize + 1);
                        }
                      : null,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  tooltip: context.l10n.increase,
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${fontSize}px',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          NovelSettingSection(
            title: context.l10n.padding,
            child: Row(
              children: [
                Icon(
                  Icons.space_bar_rounded,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                      thumbColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${padding}px',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          NovelSettingSection(
            title: context.l10n.line_height,
            child: Row(
              children: [
                Icon(
                  Icons.height_rounded,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                      thumbColor: Theme.of(context).primaryColor,
                      overlayColor: Theme.of(context).primaryColor
                          .withValues(alpha: 0.2),
                    ),
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
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lineHeight.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          NovelSettingSection(
            title: context.l10n.font,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in novelReaderFontOptions)
                  ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    labelStyle: const TextStyle(fontSize: 11),
                    label: Text(
                      option.key == null ? context.l10n.default0 : option.label,
                    ),
                    selected: fontFamilyKey == option.key,
                    onSelected: (_) {
                      ref
                          .read(novelFontFamilyStateProvider.notifier)
                          .set(option.key);
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          if (_readerMode != null) ...[
            NovelSettingSection(
              title: context.l10n.reading_mode,
              child: Row(
                children: [
                  Expanded(
                    child: NovelModeChipButton(
                      icon: Icons.swap_vert_rounded,
                      label: context.l10n.reading_mode_vertical_continuous,
                      isSelected: _readerMode!.isContinuous,
                      onTap: () {
                        setState(() {
                          _readerMode = ReaderMode.verticalContinuous;
                        });
                        widget.readerController?.setReaderMode(
                          ReaderMode.verticalContinuous,
                        );
                        widget.onReaderModeChanged?.call(
                          ReaderMode.verticalContinuous,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: NovelModeChipButton(
                      icon: Icons.auto_stories_rounded,
                      label: context.l10n.reading_mode_left_to_right,
                      isSelected: !_readerMode!.isContinuous,
                      onTap: () {
                        setState(() {
                          _readerMode = ReaderMode.ltr;
                        });
                        widget.readerController?.setReaderMode(ReaderMode.ltr);
                        widget.onReaderModeChanged?.call(ReaderMode.ltr);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          if (_readerMode == null || !_readerMode!.isContinuous) ...[
            Builder(
              builder: (context) {
                final doublePageAuto = ref.watch(doublePageAutoStateProvider);
                final orientation = MediaQuery.orientationOf(context);
                final effectivePageMode = doublePageAuto
                    ? (orientation == Orientation.landscape
                          ? PageMode.doublePage
                          : PageMode.onePage)
                    : (_pageMode ?? PageMode.onePage);

                return NovelSettingSection(
                  title: context.l10n.page_mode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: NovelModeChipButton(
                                icon: Icons.article_outlined,
                                label: context.l10n.single_page,
                                isSelected:
                                    effectivePageMode == PageMode.onePage,
                                onTap: () {
                                  setState(() {
                                    _pageMode = PageMode.onePage;
                                  });
                                  ref
                                      .read(
                                        doublePageAutoStateProvider.notifier,
                                      )
                                      .set(false);
                                  widget.readerController?.setPageMode(
                                    PageMode.onePage,
                                  );
                                  widget.onPageModeChanged?.call(
                                    PageMode.onePage,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: NovelModeChipButton(
                                icon: Icons.auto_stories_outlined,
                                label: context.l10n.double_page,
                                isSelected:
                                    effectivePageMode == PageMode.doublePage,
                                onTap: () {
                                  setState(() {
                                    _pageMode = PageMode.doublePage;
                                  });
                                  ref
                                      .read(
                                        doublePageAutoStateProvider.notifier,
                                      )
                                      .set(false);
                                  widget.readerController?.setPageMode(
                                    PageMode.doublePage,
                                  );
                                  widget.onPageModeChanged?.call(
                                    PageMode.doublePage,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      NovelSwitchSetting(
                        title: context.l10n.double_page_auto,
                        secondary: const Icon(
                          Icons.screen_rotation_outlined,
                          size: 20,
                        ),
                        value: doublePageAuto,
                        onChanged: (value) {
                          ref
                              .read(doublePageAutoStateProvider.notifier)
                              .set(value);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

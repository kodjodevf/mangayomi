import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
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
      padding: const EdgeInsets.only(bottom: ShioriSpace.s16),
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
                    const SizedBox(width: ShioriSpace.s8),
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
                    const SizedBox(width: ShioriSpace.s8),
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
                    const SizedBox(width: ShioriSpace.s8),
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
                const SizedBox(height: ShioriSpace.s12),
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
                    const SizedBox(width: ShioriSpace.s8),
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
          NovelSettingSection(
            title: context.l10n.text_align,
            child: Row(
              children: [
                Expanded(
                  child: NovelAlignButton(
                    icon: Symbols.format_align_left_rounded,
                    isSelected: textAlign == NovelTextAlign.left,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.left);
                    },
                  ),
                ),
                const SizedBox(width: ShioriSpace.s8),
                Expanded(
                  child: NovelAlignButton(
                    icon: Symbols.format_align_center_rounded,
                    isSelected: textAlign == NovelTextAlign.center,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.center);
                    },
                  ),
                ),
                const SizedBox(width: ShioriSpace.s8),
                Expanded(
                  child: NovelAlignButton(
                    icon: Symbols.format_align_right_rounded,
                    isSelected: textAlign == NovelTextAlign.right,
                    onTap: () {
                      ref
                          .read(novelTextAlignStateProvider.notifier)
                          .set(NovelTextAlign.right);
                    },
                  ),
                ),
                const SizedBox(width: ShioriSpace.s8),
                Expanded(
                  child: NovelAlignButton(
                    icon: Symbols.format_align_justify_rounded,
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
          // Size, margins and spacing of the text.
          NovelSettingSection(
            title: context.l10n.display,
            inset: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShioriSliderRow(
                  icon: Symbols.format_size_rounded,
                  title: context.l10n.font_size,
                  value: fontSize.toDouble().clamp(8, 40),
                  min: 8,
                  max: 40,
                  divisions: 32,
                  valueLabel: (v) => '${v.round()} px',
                  stepTooltips: (context.l10n.decrease, context.l10n.increase),
                  defaultValue: 14,
                  onReset: () =>
                      ref.read(novelFontSizeStateProvider.notifier).set(14),
                  resetTooltip: context.l10n.reset,
                  onChanged: (v) => ref
                      .read(novelFontSizeStateProvider.notifier)
                      .set(v.round()),
                ),
                ShioriSliderRow(
                  icon: Symbols.space_bar_rounded,
                  title: context.l10n.padding,
                  value: padding.toDouble(),
                  min: 0,
                  max: 50,
                  divisions: 50,
                  valueLabel: (v) => '${v.round()} px',
                  defaultValue: 16,
                  onReset: () => ref
                      .read(novelReaderPaddingStateProvider.notifier)
                      .set(16),
                  resetTooltip: context.l10n.reset,
                  onChanged: (v) => ref
                      .read(novelReaderPaddingStateProvider.notifier)
                      .set(v.round()),
                ),
                ShioriSliderRow(
                  icon: Symbols.height_rounded,
                  title: context.l10n.line_height,
                  value: lineHeight,
                  min: 1,
                  max: 3,
                  divisions: 20,
                  valueLabel: (v) => v.toStringAsFixed(1),
                  defaultValue: 1.5,
                  onReset: () => ref
                      .read(novelReaderLineHeightStateProvider.notifier)
                      .set(1.5),
                  resetTooltip: context.l10n.reset,
                  onChanged: (v) => ref
                      .read(novelReaderLineHeightStateProvider.notifier)
                      .set(v),
                ),
              ],
            ),
          ),
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
                      horizontal: ShioriSpace.s8,
                      vertical: 2,
                    ),
                    labelStyle: context.shiori.text.meta,
                    label: Text(
                      option.label,
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
          if (_readerMode != null) ...[
            NovelSettingSection(
              title: context.l10n.reading_mode,
              child: Row(
                children: [
                  Expanded(
                    child: NovelModeChipButton(
                      icon: Symbols.swap_vert_rounded,
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
                  const SizedBox(width: ShioriSpace.s8),
                  Expanded(
                    child: NovelModeChipButton(
                      icon: Symbols.auto_stories_rounded,
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
                  inset: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          ShioriSpace.s16,
                          0,
                          ShioriSpace.s16,
                          ShioriSpace.s8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: NovelModeChipButton(
                                icon: Symbols.article_rounded,
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
                            const SizedBox(width: ShioriSpace.s8),
                            Expanded(
                              child: NovelModeChipButton(
                                icon: Symbols.auto_stories_rounded,
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
                        icon: Symbols.screen_rotation_rounded,
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

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
          _SettingSection(
            title: context.l10n.theme,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ThemeButton(
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
                      child: _ThemeButton(
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
                      child: _ThemeButton(
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
                      child: _ThemeButton(
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
                      child: _ColorPicker(
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
                      child: _ColorPicker(
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
          _SettingSection(
            title: context.l10n.text_align,
            child: Row(
              children: [
                Expanded(
                  child: _AlignButton(
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
                  child: _AlignButton(
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
                  child: _AlignButton(
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
                  child: _AlignButton(
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

          _SettingSection(
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
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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

          _SettingSection(
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

          _SettingSection(
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
                            .read(
                              novelReaderLineHeightStateProvider.notifier,
                            )
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

          _SettingSection(
            title: context.l10n.font,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in novelReaderFontOptions)
                  ChoiceChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    labelStyle: const TextStyle(fontSize: 11),
                    label: Text(
                      option.key == null
                          ? context.l10n.default0
                          : option.label,
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
            _SettingSection(
              title: context.l10n.reading_mode,
              child: Row(
                children: [
                  Expanded(
                    child: _ModeChipButton(
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
                    child: _ModeChipButton(
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

                return _SettingSection(
                  title: context.l10n.page_mode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: _ModeChipButton(
                                icon: Icons.article_outlined,
                                label: context.l10n.single_page,
                                isSelected: effectivePageMode == PageMode.onePage,
                                onTap: () {
                                  setState(() {
                                    _pageMode = PageMode.onePage;
                                  });
                                  ref
                                      .read(doublePageAutoStateProvider.notifier)
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
                              child: _ModeChipButton(
                                icon: Icons.auto_stories_outlined,
                                label: context.l10n.double_page,
                                isSelected:
                                    effectivePageMode == PageMode.doublePage,
                                onTap: () {
                                  setState(() {
                                    _pageMode = PageMode.doublePage;
                                  });
                                  ref
                                      .read(doublePageAutoStateProvider.notifier)
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
                      _SwitchListTileSetting(
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

class GeneralSettingsTab extends ConsumerWidget {
  final ValueNotifier<bool>? autoScrollPage;
  final ValueNotifier<bool>? autoScroll;
  final NovelReaderController? readerController;
  final ValueNotifier<double>? pageOffset;
  const GeneralSettingsTab({
    this.autoScrollPage,
    this.autoScroll,
    this.readerController,
    this.pageOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoScrollPageNotifier = autoScrollPage;
    final autoScrollNotifier = autoScroll;
    final controller = readerController;
    final offsetNotifier = pageOffset;
    final hasActiveSession = autoScrollPageNotifier != null &&
        autoScrollNotifier != null &&
        controller != null &&
        offsetNotifier != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          _SwitchListTileSetting(
            title: context.l10n.keep_screen_on,
            value: ref.watch(keepScreenOnReaderStateProvider),
            onChanged: (value) {
              ref.read(keepScreenOnReaderStateProvider.notifier).set(value);
            },
          ),
          _SwitchListTileSetting(
            title: context.l10n.show_scroll_percentage,
            value: ref.watch(novelShowScrollPercentageStateProvider),
            onChanged: (value) {
              ref
                  .read(novelShowScrollPercentageStateProvider.notifier)
                  .set(value);
            },
          ),
          if (hasActiveSession)
            ValueListenableBuilder(
              valueListenable: autoScrollPageNotifier,
              builder: (context, valueT, child) {
                return Column(
                  children: [
                    _SwitchListTileSetting(
                      secondary: Icon(
                        valueT ? Icons.timer : Icons.timer_outlined,
                        size: 20,
                      ),
                      value: valueT,
                      title: context.l10n.auto_scroll,
                      onChanged: (val) {
                        controller.setAutoScroll(val, offsetNotifier.value);
                        autoScrollPageNotifier.value = val;
                        autoScrollNotifier.value = val;
                      },
                    ),
                    if (valueT)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor
                                .withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Theme.of(context).primaryColor
                                  .withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.speed_rounded,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        context.l10n.speed,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ValueListenableBuilder<double>(
                                    valueListenable: offsetNotifier,
                                    builder: (context, val, _) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${val.toStringAsFixed(1)}x',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              ValueListenableBuilder<double>(
                                valueListenable: offsetNotifier,
                                builder: (context, value, child) => Row(
                                  children: [
                                    Icon(
                                      Icons.directions_walk_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.5),
                                    ),
                                    Expanded(
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 3,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                            enabledThumbRadius: 6,
                                          ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                            overlayRadius: 12,
                                          ),
                                        ),
                                        child: Slider(
                                          min: 2.0,
                                          max: 30.0,
                                          divisions: max(28, 3),
                                          value: value.clamp(2.0, 30.0),
                                          onChanged: (val) {
                                            offsetNotifier.value = val;
                                          },
                                          onChangeEnd: (val) {
                                            controller.setAutoScroll(
                                              valueT,
                                              val,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.directions_run_rounded,
                                      size: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          _SwitchListTileSetting(
            title: context.l10n.remove_extra_paragraph_spacing,
            value: ref.watch(novelRemoveExtraParagraphSpacingStateProvider),
            onChanged: (value) {
              ref
                  .read(novelRemoveExtraParagraphSpacingStateProvider.notifier)
                  .set(value);
            },
          ),

          _SwitchListTileSetting(
            title: context.l10n.use_page_tap_zones,
            value: ref.watch(novelTapToScrollStateProvider),
            onChanged: (value) {
              ref.read(novelTapToScrollStateProvider.notifier).set(value);
            },
          ),
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
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.04),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      secondary: secondary,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color!
              .withValues(alpha: 0.9),
          fontSize: 13,
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
    final primaryColor = Theme.of(context).primaryColor;
    final bg = _parseColor(backgroundColor);
    final txt = _parseColor(textColor);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.withValues(alpha: 0.25),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
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
                        fontSize: 15,
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
                          fontSize: 10,
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
                      Icons.check,
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
          title: Text(context.l10n.select_label_color(label)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
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
              child: Text(context.l10n.cancel),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onColorChanged(_colorToHex(optionColor));
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: optionColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor
                          .withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isSelected
              ? Icon(
                  Icons.check_circle_rounded,
                  size: 22,
                  color: optionColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
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
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.25),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.03),
                Colors.transparent,
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      color,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.palette_outlined,
                color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                size: 16,
              ),
            ],
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 36,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withValues(alpha: 0.2),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}

class _ModeChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChipButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : Colors.grey.withValues(alpha: 0.25),
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
                color: isSelected
                    ? primaryColor
                    : Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context).textTheme.bodyMedium?.color,
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

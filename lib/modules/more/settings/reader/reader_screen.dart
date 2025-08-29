import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultReadingMode = ref.watch(defaultReadingModeStateProvider);
    final animatePageTransitions = ref.watch(
      animatePageTransitionsStateProvider,
    );
    final doubleTapAnimationSpeed = ref.watch(
      doubleTapAnimationSpeedStateProvider,
    );
    final pagePreloadAmount = ref.watch(pagePreloadAmountStateProvider);
    final scaleType = ref.watch(scaleTypeStateProvider);
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final usePageTapZones = ref.watch(usePageTapZonesStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);

    final cropBorders = ref.watch(cropBordersStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.reader)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.default_reading_mode),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: defaultReadingMode,
                          onChanged: (value) {
                            ref
                                .read(defaultReadingModeStateProvider.notifier)
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: ReaderMode.values.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: ReaderMode.values[index],
                                title: Row(
                                  children: [
                                    Text(
                                      getReaderModeName(
                                        ReaderMode.values[index],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.default_reading_mode),
              subtitle: Text(
                getReaderModeName(defaultReadingMode, context),
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.double_tap_animation_speed),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: doubleTapAnimationSpeed,
                          onChanged: (value) {
                            ref
                                .read(
                                  doubleTapAnimationSpeedStateProvider.notifier,
                                )
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: index,
                                title: Row(
                                  children: [
                                    Text(getAnimationSpeedName(index, context)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.double_tap_animation_speed),
              subtitle: Text(
                getAnimationSpeedName(doubleTapAnimationSpeed, context),
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.background_color),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: backgroundColor,
                          onChanged: (value) {
                            ref
                                .read(backgroundColorStateProvider.notifier)
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: BackgroundColor.values.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: BackgroundColor.values[index],
                                title: Row(
                                  children: [
                                    Text(
                                      getBackgroundColorName(
                                        BackgroundColor.values[index],
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.background_color),
              subtitle: Text(
                getBackgroundColorName(backgroundColor, context),
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    int tempAmount = pagePreloadAmount;
                    return AlertDialog(
                      title: Text(context.l10n.page_preload_amount),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tempAmount.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Slider(
                                  value: tempAmount.toDouble(),
                                  min: 1,
                                  max: 20,
                                  // divisions: 19, // makes the slider a bit sluggish
                                  // label: tempAmount.toString(), // value indicator balloon. Redundant because of the Text widget above
                                  onChanged: (double newVal) {
                                    setState(() {
                                      tempAmount = newVal.round();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            context.l10n.cancel,
                            style: TextStyle(color: context.primaryColor),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(pagePreloadAmountStateProvider.notifier)
                                .set(tempAmount);
                            Navigator.pop(context);
                          },
                          child: Text(
                            context.l10n.ok,
                            style: TextStyle(color: context.primaryColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.page_preload_amount),
              subtitle: Text(
                context.l10n.page_preload_amount_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.scale_type),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: scaleType.index,
                          onChanged: (value) {
                            ref
                                .read(scaleTypeStateProvider.notifier)
                                .set(ScaleType.values[value!]);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: getScaleTypeNames(context).length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                // dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: index,
                                title: Row(
                                  children: [
                                    Text(
                                      getScaleTypeNames(
                                        context,
                                      )[index].toString(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text(
                                context.l10n.cancel,
                                style: TextStyle(color: context.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              title: Text(context.l10n.scale_type),
              subtitle: Text(
                getScaleTypeNames(context)[scaleType.index],
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            SwitchListTile(
              value: fullScreenReader,
              title: Text(context.l10n.fullscreen),
              onChanged: (value) {
                ref.read(fullScreenReaderStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: animatePageTransitions,
              title: Text(context.l10n.animate_page_transitions),
              onChanged: (value) {
                ref
                    .read(animatePageTransitionsStateProvider.notifier)
                    .set(value);
              },
            ),
            SwitchListTile(
              value: cropBorders,
              title: Text(context.l10n.crop_borders),
              onChanged: (value) {
                ref.read(cropBordersStateProvider.notifier).set(value);
              },
            ),
            SwitchListTile(
              value: usePageTapZones,
              title: Text(context.l10n.use_page_tap_zones),
              onChanged: (value) {
                ref.read(usePageTapZonesStateProvider.notifier).set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

String getReaderModeName(ReaderMode readerMode, BuildContext context) {
  return switch (readerMode) {
    ReaderMode.vertical => context.l10n.reading_mode_vertical,
    ReaderMode.verticalContinuous =>
      context.l10n.reading_mode_vertical_continuous,
    ReaderMode.ltr => context.l10n.reading_mode_left_to_right,
    ReaderMode.rtl => context.l10n.reading_mode_right_to_left,
    ReaderMode.horizontalContinuous => context.l10n.horizontal_continious,
    _ => context.l10n.reading_mode_webtoon,
  };
}

String getBackgroundColorName(
  BackgroundColor backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    BackgroundColor.white => context.l10n.white,
    BackgroundColor.grey => context.l10n.grey,
    BackgroundColor.black => context.l10n.black,
    _ => context.l10n.automaic,
  };
}

Color? getBackgroundColor(BackgroundColor backgroundColor) {
  return switch (backgroundColor) {
    BackgroundColor.white => Colors.white,
    BackgroundColor.grey => Colors.grey,
    BackgroundColor.black => Colors.black,
    _ => null,
  };
}

String getColorFilterBlendModeName(
  ColorFilterBlendMode backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    ColorFilterBlendMode.none => context.l10n.blend_mode_default,
    ColorFilterBlendMode.multiply => context.l10n.blend_mode_multiply,
    ColorFilterBlendMode.screen => context.l10n.blend_mode_screen,
    ColorFilterBlendMode.overlay => context.l10n.blend_mode_overlay,
    ColorFilterBlendMode.colorDodge => context.l10n.blend_mode_colorDodge,
    ColorFilterBlendMode.lighten => context.l10n.blend_mode_lighten,
    ColorFilterBlendMode.colorBurn => context.l10n.blend_mode_colorBurn,
    ColorFilterBlendMode.difference => context.l10n.blend_mode_difference,
    ColorFilterBlendMode.saturation => context.l10n.blend_mode_saturation,
    ColorFilterBlendMode.softLight => context.l10n.blend_mode_softLight,
    ColorFilterBlendMode.plus => context.l10n.blend_mode_plus,
    ColorFilterBlendMode.exclusion => context.l10n.blend_mode_exclusion,
    _ => context.l10n.blend_mode_darken,
  };
}

BlendMode? getColorFilterBlendMode(
  ColorFilterBlendMode backgroundColor,
  BuildContext context,
) {
  return switch (backgroundColor) {
    ColorFilterBlendMode.none => null,
    ColorFilterBlendMode.multiply => BlendMode.multiply,
    ColorFilterBlendMode.screen => BlendMode.screen,
    ColorFilterBlendMode.overlay => BlendMode.overlay,
    ColorFilterBlendMode.colorDodge => BlendMode.colorDodge,
    ColorFilterBlendMode.lighten => BlendMode.lighten,
    ColorFilterBlendMode.colorBurn => BlendMode.colorBurn,
    ColorFilterBlendMode.difference => BlendMode.difference,
    ColorFilterBlendMode.saturation => BlendMode.saturation,
    ColorFilterBlendMode.softLight => BlendMode.softLight,
    ColorFilterBlendMode.plus => BlendMode.plus,
    ColorFilterBlendMode.exclusion => BlendMode.exclusion,
    _ => BlendMode.darken,
  };
}

String getAnimationSpeedName(int type, BuildContext context) {
  return switch (type) {
    0 => context.l10n.no_animation,
    1 => context.l10n.normal,
    _ => context.l10n.fast,
  };
}

List<String> getScaleTypeNames(BuildContext context) {
  return [
    context.l10n.scale_type_fit_screen,
    context.l10n.scale_type_stretch,
    context.l10n.scale_type_fit_width,
    context.l10n.scale_type_fit_height,
    // l10n.scale_type_original_size,
    // l10n.scale_type_smart_fit,
  ];
}

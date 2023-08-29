import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final defaultReadingMode = ref.watch(defaultReadingModeStateProvider);
    final animatePageTransitions =
        ref.watch(animatePageTransitionsStateProvider);
    final cropBorders = ref.watch(cropBordersStateProvider);
    final doubleTapAnimationSpeed =
        ref.watch(doubleTapAnimationSpeedStateProvider);
    final pagePreloadAmount = ref.watch(pagePreloadAmountStateProvider);
    final scaleType = ref.watch(scaleTypeStateProvider);
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.reader),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.default_reading_mode),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: ReaderMode.values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: ReaderMode.values[index],
                                  groupValue: defaultReadingMode,
                                  onChanged: (value) {
                                    ref
                                        .read(defaultReadingModeStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [
                                      Text(getReaderModeName(
                                          ReaderMode.values[index], context))
                                    ],
                                  ),
                                );
                              },
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.default_reading_mode),
              subtitle: Text(
                getReaderModeName(defaultReadingMode, context),
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          l10n.double_tap_animation_speed,
                        ),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  groupValue: doubleTapAnimationSpeed,
                                  onChanged: (value) {
                                    ref
                                        .read(
                                            doubleTapAnimationSpeedStateProvider
                                                .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [
                                      Text(
                                          getAnimationSpeedName(index, context))
                                    ],
                                  ),
                                );
                              },
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.double_tap_animation_speed),
              subtitle: Text(
                getAnimationSpeedName(doubleTapAnimationSpeed, context),
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.reading_mode),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: BackgroundColor.values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: BackgroundColor.values[index],
                                  groupValue: backgroundColor,
                                  onChanged: (value) {
                                    ref
                                        .read(backgroundColorStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [
                                      Text(getBackgroundColorName(
                                          BackgroundColor.values[index],
                                          context))
                                    ],
                                  ),
                                );
                              },
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.reading_mode),
              subtitle: Text(
                getBackgroundColorName(backgroundColor, context),
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            ListTile(
              onTap: () {
                List<int> numbers = [4, 6, 8, 10, 12, 14, 16, 18, 20];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          l10n.page_preload_amount,
                        ),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: numbers.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: numbers[index],
                                  groupValue: pagePreloadAmount,
                                  onChanged: (value) {
                                    ref
                                        .read(pagePreloadAmountStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text(numbers[index].toString())],
                                  ),
                                );
                              },
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.page_preload_amount),
              subtitle: Text(
                l10n.page_preload_amount_subtitle,
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          l10n.scale_type,
                        ),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: getScaleTypeNames(context).length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  // dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: index,
                                  groupValue: scaleType.index,
                                  onChanged: (value) {
                                    ref
                                        .read(scaleTypeStateProvider.notifier)
                                        .set(ScaleType.values[value!]);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [
                                      Text(getScaleTypeNames(context)[index]
                                          .toString())
                                    ],
                                  ),
                                );
                              },
                            )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(l10n.scale_type),
              subtitle: Text(
                getScaleTypeNames(context)[scaleType.index],
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            SwitchListTile(
                value: animatePageTransitions,
                title: Text(l10n.animate_page_transitions),
                onChanged: (value) {
                  ref
                      .read(animatePageTransitionsStateProvider.notifier)
                      .set(value);
                }),
            SwitchListTile(
                value: cropBorders,
                title: Text(l10n.crop_borders),
                onChanged: (value) {
                  ref.read(cropBordersStateProvider.notifier).set(value);
                }),
          ],
        ),
      ),
    );
  }
}

String getReaderModeName(ReaderMode readerMode, BuildContext context) {
  final l10n = l10nLocalizations(context);
  return switch (readerMode) {
    ReaderMode.vertical => l10n!.reading_mode_vertical,
    ReaderMode.verticalContinuous => l10n!.reading_mode_vertical_continuous,
    ReaderMode.ltr => l10n!.reading_mode_left_to_right,
    ReaderMode.rtl => l10n!.reading_mode_right_to_left,
    _ => l10n!.reading_mode_webtoon
  };
}

String getBackgroundColorName(
    BackgroundColor backgroundColor, BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return switch (backgroundColor) {
    BackgroundColor.white => l10n.white,
    BackgroundColor.grey => l10n.grey,
    BackgroundColor.black => l10n.black,
    _ => l10n.automaic,
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

String getAnimationSpeedName(int type, BuildContext context) {
  final l10n = l10nLocalizations(context);
  return switch (type) {
    0 => l10n!.no_animation,
    1 => l10n!.normal,
    _ => l10n!.fast,
  };
}

List<String> getScaleTypeNames(BuildContext context) {
  final l10n = l10nLocalizations(context)!;
  return [
    l10n.scale_type_fit_screen,
    l10n.scale_type_stretch,
    l10n.scale_type_fit_width,
    l10n.scale_type_fit_height,
    // l10n.scale_type_original_size,
    // l10n.scale_type_smart_fit,
  ];
}

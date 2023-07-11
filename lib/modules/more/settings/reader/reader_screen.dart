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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.reader),
      ),
      body: Column(
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
                                      .read(doubleTapAnimationSpeedStateProvider
                                          .notifier)
                                      .set(value!);
                                  Navigator.pop(context);
                                },
                                title: Row(
                                  children: [
                                    Text(getAnimationSpeedName(index, context))
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
    );
  }
}

String getReaderModeName(ReaderMode readerMode, BuildContext context) {
  final l10n = l10nLocalizations(context);
  return readerMode == ReaderMode.vertical
      ? l10n!.reading_mode_vertical
      : readerMode == ReaderMode.verticalContinuous
          ? l10n!.reading_mode_vertical_continuous
          : readerMode == ReaderMode.ltr
              ? l10n!.reading_mode_left_to_right
              : readerMode == ReaderMode.rtl
                  ? l10n!.reading_mode_right_to_left
                  : l10n!.reading_mode_webtoon;
}

String getAnimationSpeedName(int type, BuildContext context) {
  final l10n = l10nLocalizations(context);
  return type == 0
      ? l10n!.no_animation
      : type == 1
          ? l10n!.normal
          : l10n!.fast;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/more/settings/reader/providers/reader_state_provider.dart';

class ReaderScreen extends ConsumerWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultReadingMode = ref.watch(defaultReadingModeStateProvider);
    final animatePageTransitions =
        ref.watch(animatePageTransitionsStateProvider);
    final doubleTapAnimationSpeed =
        ref.watch(doubleTapAnimationSpeedStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reader"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Default reading mode",
                      ),
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
                                        ReaderMode.values[index]))
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
                                  "Cancel",
                                  style:
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: const Text(
              "Default reading mode",
              style: TextStyle(),
            ),
            subtitle: Text(
              getReaderModeName(defaultReadingMode),
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Double tap animation speed",
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
                                    Text(getAnimationSpeedName(index))
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
                                  "Cancel",
                                  style:
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: const Text(
              "Double tap animation speed",
              style: TextStyle(),
            ),
            subtitle: Text(
              getAnimationSpeedName(doubleTapAnimationSpeed),
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          SwitchListTile(
              value: animatePageTransitions,
              title: const Text("Animate page transitions"),
              onChanged: (value) {
                ref
                    .read(animatePageTransitionsStateProvider.notifier)
                    .set(value);
              }),
        ],
      ),
    );
  }
}

String getReaderModeName(ReaderMode readerMode) {
  return readerMode == ReaderMode.vertical
      ? 'Vertical'
      : readerMode == ReaderMode.verticalContinuous
          ? 'Verical continuous'
          : readerMode == ReaderMode.ltr
              ? 'Left to Right'
              : readerMode == ReaderMode.rtl
                  ? 'Right to Left'
                  : 'Webtoon';
}

String getAnimationSpeedName(int type) {
  return type == 0
      ? 'No animation'
      : type == 1
          ? 'Normal'
          : "Fast";
}

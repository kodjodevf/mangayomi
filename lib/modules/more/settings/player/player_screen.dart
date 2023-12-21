import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:numberpicker/numberpicker.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markEpisodeAsSeenType = ref.watch(markEpisodeAsSeenTypeStateProvider);
    final defaultSkipIntroLength =
        ref.watch(defaultSkipIntroLengthStateProvider);

    // final defaultDoubleTapToSkipLength =
    //     ref.watch(defaultDoubleTapToSkipLengthStateProvider);
    final defaultPlayBackSpeed = ref.watch(defaultPlayBackSpeedStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.player),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                final values = [100, 95, 90, 85, 80, 75, 70];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.markEpisodeAsSeenSetting),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: values[index],
                                  groupValue: markEpisodeAsSeenType,
                                  onChanged: (value) {
                                    ref
                                        .read(markEpisodeAsSeenTypeStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text("${values[index]}%")],
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
                                    context.l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(context.l10n.markEpisodeAsSeenSetting),
              subtitle: Text(
                "$markEpisodeAsSeenType%",
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            ListTile(
              onTap: () {
                int currentIntValue = defaultSkipIntroLength;
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.default_skip_intro_length),
                        content: StatefulBuilder(
                          builder: (context, setState) => SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NumberPicker(
                                  value: currentIntValue,
                                  minValue: 1,
                                  maxValue: 255,
                                  step: 1,
                                  haptics: true,
                                  textMapper: (numberText) => "${numberText}s",
                                  onChanged: (value) =>
                                      setState(() => currentIntValue = value),
                                ),
                              ],
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
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    ref
                                        .read(
                                            defaultSkipIntroLengthStateProvider
                                                .notifier)
                                        .set(currentIntValue);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    context.l10n.ok,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(context.l10n.default_skip_intro_length),
              subtitle: Text(
                "${defaultSkipIntroLength}s",
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
            // ListTile(
            //   onTap: () {
            //     final values = [30, 20, 10, 5, 3, 0];
            //     showDialog(
            //         context: context,
            //         builder: (context) {
            //           return AlertDialog(
            //             title: Text("Default Double tap to skip length"),
            //             content: SizedBox(
            //                 width: mediaWidth(context, 0.8),
            //                 child: ListView.builder(
            //                   shrinkWrap: true,
            //                   itemCount: values.length,
            //                   itemBuilder: (context, index) {
            //                     return RadioListTile(
            //                       dense: true,
            //                       contentPadding: const EdgeInsets.all(0),
            //                       value: values[index],
            //                       groupValue: defaultDoubleTapToSkipLength,
            //                       onChanged: (value) {
            //                         ref
            //                             .read(
            //                                 defaultDoubleTapToSkipLengthStateProvider
            //                                     .notifier)
            //                             .set(value!);
            //                         Navigator.pop(context);
            //                       },
            //                       title: Row(
            //                         children: [Text("${values[index]}s")],
            //                       ),
            //                     );
            //                   },
            //                 )),
            //             actions: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: [
            //                   TextButton(
            //                       onPressed: () async {
            //                         Navigator.pop(context);
            //                       },
            //                       child: Text(
            //                         context.l10n.cancel,
            //                         style:
            //                             TextStyle(color: primaryColor(context)),
            //                       )),
            //                 ],
            //               )
            //             ],
            //           );
            //         });
            //   },
            //   title: Text("Default Double tap to skip length"),
            //   subtitle: Text(
            //     "${defaultDoubleTapToSkipLength}s",
            //     style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            //   ),
            // ),
            ListTile(
              onTap: () {
                final values = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.default_playback_speed_length),
                        content: SizedBox(
                            width: mediaWidth(context, 0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: values[index],
                                  groupValue: defaultPlayBackSpeed,
                                  onChanged: (value) {
                                    ref
                                        .read(defaultPlayBackSpeedStateProvider
                                            .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text("x${values[index]}")],
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
                                    context.l10n.cancel,
                                    style:
                                        TextStyle(color: primaryColor(context)),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(context.l10n.default_playback_speed_length),
              subtitle: Text(
                "x$defaultPlayBackSpeed",
                style: TextStyle(fontSize: 11, color: secondaryColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

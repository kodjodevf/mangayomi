import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:numberpicker/numberpicker.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final markEpisodeAsSeenType = ref.watch(markEpisodeAsSeenTypeStateProvider);
    final defaultSkipIntroLength =
        ref.watch(defaultSkipIntroLengthStateProvider);
    final defaultDoubleTapToSkipLength =
        ref.watch(defaultDoubleTapToSkipLengthStateProvider);
    final defaultPlayBackSpeed = ref.watch(defaultPlayBackSpeedStateProvider);
    final enableAniSkip = ref.watch(enableAniSkipStateProvider);
    final enableAutoSkip = ref.watch(enableAutoSkipStateProvider);
    final aniSkipTimeoutLength = ref.watch(aniSkipTimeoutLengthStateProvider);
    final useLibass = ref.watch(useLibassStateProvider);
    final hideAnime = ref.watch(hideAnimeStateProvider);
    final fullScreenPlayer = ref.watch(fullScreenPlayerStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.player),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
                value: hideAnime,
                title: Text(context.l10n.hide_anime),
                onChanged: (value) {
                  ref.read(hideAnimeStateProvider.notifier).set(value);
                }),
            ListTile(
              onTap: () {
                final values = [100, 95, 90, 85, 80, 75, 70];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.markEpisodeAsSeenSetting),
                        content: SizedBox(
                            width: context.width(0.8),
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
                                        TextStyle(color: context.primaryColor),
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
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
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
                                        TextStyle(color: context.primaryColor),
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
                                        TextStyle(color: context.primaryColor),
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
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                final values = [30, 20, 10, 5, 3, 1];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text(context.l10n.default_skip_forward_skip_length),
                        content: SizedBox(
                            width: context.width(0.8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: values[index],
                                  groupValue: defaultDoubleTapToSkipLength,
                                  onChanged: (value) {
                                    ref
                                        .read(
                                            defaultDoubleTapToSkipLengthStateProvider
                                                .notifier)
                                        .set(value!);
                                    Navigator.pop(context);
                                  },
                                  title: Row(
                                    children: [Text("${values[index]}s")],
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
                                        TextStyle(color: context.primaryColor),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              },
              title: Text(context.l10n.default_skip_forward_skip_length),
              subtitle: Text(
                "${defaultDoubleTapToSkipLength}s",
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              onTap: () {
                final values = [0.25, 0.5, 0.75, 1.0, 1.25, 1.50, 1.75, 2.0];
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(context.l10n.default_playback_speed_length),
                        content: SizedBox(
                            width: context.width(0.8),
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
                                        TextStyle(color: context.primaryColor),
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
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.secondaryColor,
                    ),
                  ],
                ),
              ),
              subtitle: Text(context.l10n.aniskip_requires_info,
                  style:
                      TextStyle(fontSize: 11, color: context.secondaryColor)),
            ),
            SwitchListTile(
                value: useLibass,
                title: Text(context.l10n.use_libass),
                subtitle: Text(context.l10n.use_libass_info,
                    style:
                        TextStyle(fontSize: 11, color: context.secondaryColor)),
                onChanged: (value) {
                  ref.read(useLibassStateProvider.notifier).set(value);
                }),
            ExpansionTile(
              title: Text(context.l10n.enable_aniskip),
              initiallyExpanded: enableAniSkip,
              trailing: IgnorePointer(
                child: Switch(
                  value: enableAniSkip,
                  onChanged: (_) {},
                ),
              ),
              onExpansionChanged: (value) =>
                  ref.read(enableAniSkipStateProvider.notifier).set(value),
              children: [
                SwitchListTile(
                    value: enableAutoSkip,
                    title: Text(context.l10n.enable_auto_skip),
                    onChanged: (value) {
                      ref.read(enableAutoSkipStateProvider.notifier).set(value);
                    }),
                ListTile(
                  onTap: () {
                    final values = [5, 6, 7, 8, 9, 10];
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                context.l10n.default_playback_speed_length),
                            content: SizedBox(
                                width: context.width(0.8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: values.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: values[index],
                                      groupValue: aniSkipTimeoutLength,
                                      onChanged: (value) {
                                        ref
                                            .read(
                                                aniSkipTimeoutLengthStateProvider
                                                    .notifier)
                                            .set(value!);
                                        Navigator.pop(context);
                                      },
                                      title: Row(
                                        children: [Text("${values[index]}s")],
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
                                        style: TextStyle(
                                            color: context.primaryColor),
                                      )),
                                ],
                              )
                            ],
                          );
                        });
                  },
                  title: Text(context.l10n.aniskip_button_timeout),
                  subtitle: Text(
                    "${aniSkipTimeoutLength}s",
                    style:
                        TextStyle(fontSize: 11, color: context.secondaryColor),
                  ),
                ),
              ],
            ),
            SwitchListTile(
                value: fullScreenPlayer,
                title: Text(context.l10n.full_screen_player),
                subtitle: Text(context.l10n.full_screen_player_info,
                    style:
                        TextStyle(fontSize: 11, color: context.secondaryColor)),
                onChanged: (value) {
                  ref.read(fullScreenPlayerStateProvider.notifier).set(value);
                }),
          ],
        ),
      ),
    );
  }
}

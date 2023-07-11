import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/blend_level_slider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/dark_mode_button.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/theme_selector.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final dateFormatState = ref.watch(dateFormatStateProvider);
    final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
    final pureBlackDarkMode = ref.watch(pureBlackDarkModeStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.appearance),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(l10n.theme,
                          style: TextStyle(
                              fontSize: 13, color: primaryColor(context))),
                    ],
                  ),
                ),
                const DarkModeButton(),
                const ThemeSelector(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SwitchListTile(
                      title: Text(l10n.pure_black_dark_mode),
                      value: pureBlackDarkMode,
                      onChanged: (value) {
                        ref
                            .read(pureBlackDarkModeStateProvider.notifier)
                            .set(value);
                      }),
                ),
                if (!pureBlackDarkMode) const BlendLevelSlider()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(l10n.timestamp,
                          style: TextStyle(
                              fontSize: 13, color: primaryColor(context))),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              l10n.relative_timestamp,
                            ),
                            content: SizedBox(
                                width: mediaWidth(context, 0.8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      relativeTimestampsList(context).length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: index,
                                      groupValue: relativeTimestamps,
                                      onChanged: (value) {
                                        ref
                                            .read(
                                                relativeTimesTampsStateProvider
                                                    .notifier)
                                            .set(value!);
                                        Navigator.pop(context);
                                      },
                                      title: Row(
                                        children: [
                                          Text(relativeTimestampsList(
                                              context)[index])
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
                                        style: TextStyle(
                                            color: primaryColor(context)),
                                      )),
                                ],
                              )
                            ],
                          );
                        });
                  },
                  title: Text(l10n.relative_timestamp),
                  subtitle: Text(
                    relativeTimestampsList(context)[relativeTimestamps],
                    style:
                        TextStyle(fontSize: 11, color: secondaryColor(context)),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              l10n.date_format,
                            ),
                            content: SizedBox(
                                width: mediaWidth(context, 0.8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dateFormatsList.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      dense: true,
                                      contentPadding: const EdgeInsets.all(0),
                                      value: dateFormatsList[index],
                                      groupValue: dateFormatState,
                                      onChanged: (value) {
                                        ref
                                            .read(dateFormatStateProvider
                                                .notifier)
                                            .set(value!);
                                        Navigator.pop(context);
                                      },
                                      title: Row(
                                        children: [
                                          Text(
                                              "${dateFormatsList[index]} (${dateFormat(context: context, DateTime.now().millisecondsSinceEpoch.toString(), useRelativeTimesTamps: false, dateFormat: dateFormatsList[index], ref: ref)})")
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
                                        style: TextStyle(
                                            color: primaryColor(context)),
                                      )),
                                ],
                              )
                            ],
                          );
                        });
                  },
                  title: Text(l10n.date_format),
                  subtitle: Text(
                    "$dateFormatState (${dateFormat(context: context, DateTime.now().millisecondsSinceEpoch.toString(), useRelativeTimesTamps: false, dateFormat: dateFormatState, ref: ref)})",
                    style:
                        TextStyle(fontSize: 11, color: secondaryColor(context)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/blend_level_slider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/dark_mode_button.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/theme_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final dateFormatState = ref.watch(dateFormatStateProvider);
    final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
    final pureBlackDarkMode = ref.watch(pureBlackDarkModeStateProvider);
    final isDarkTheme = ref.watch(themeModeStateProvider);
    final l10nLocale = ref.watch(l10nLocaleStateProvider);
    final appFontFamily = ref.watch(appFontFamilyProvider);
    final appFontFamilySub = appFontFamily == null
        ? context.l10n.default0
        : GoogleFonts.asMap()
            .entries
            .toList()
            .firstWhere(
                (element) => element.value().fontFamily! == appFontFamily)
            .key;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.appearance),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(l10n.theme,
                            style: TextStyle(
                                fontSize: 13, color: context.primaryColor)),
                      ],
                    ),
                  ),
                  const DarkModeButton(),
                  const ThemeSelector(),
                  if (isDarkTheme)
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
                  if (!pureBlackDarkMode || !isDarkTheme)
                    const BlendLevelSlider()
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
                        Text(l10n.appearance,
                            style: TextStyle(
                                fontSize: 13, color: context.primaryColor)),
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
                                l10n.app_language,
                              ),
                              content: SizedBox(
                                  width: context.width(0.8),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: AppLocalizations
                                        .supportedLocales.length,
                                    itemBuilder: (context, index) {
                                      final locale = AppLocalizations
                                          .supportedLocales[index];
                                      return RadioListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: locale,
                                        groupValue: l10nLocale,
                                        onChanged: (value) {
                                          ref
                                              .read(l10nLocaleStateProvider
                                                  .notifier)
                                              .setLocale(locale);
                                          Navigator.pop(context);
                                        },
                                        title: Text(completeLanguageName(
                                            locale.toLanguageTag())),
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
                                              color: context.primaryColor),
                                        )),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: Text(l10n.app_language),
                    subtitle: Text(
                      completeLanguageName(l10nLocale.toLanguageTag()),
                      style: TextStyle(
                          fontSize: 11, color: context.secondaryColor),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      String textValue = "";
                      final controller = ScrollController();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(context.l10n.font),
                              content:
                                  StatefulBuilder(builder: (context, setState) {
                                return SizedBox(
                                    width: context.width(0.8),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 8),
                                          child: TextField(
                                              onChanged: (v) {
                                                setState(() {
                                                  textValue = v;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  isDense: true,
                                                  filled: false,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: context
                                                            .secondaryColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: context
                                                            .primaryColor),
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide()),
                                                  hintText: l10n.search)),
                                        ),
                                        Builder(builder: (context) {
                                          List values = GoogleFonts.asMap()
                                              .entries
                                              .toList();
                                          values = values
                                              .where((values) => values.key
                                                  .toLowerCase()
                                                  .contains(
                                                      textValue.toLowerCase()))
                                              .toList();
                                          return Flexible(
                                            child: Scrollbar(
                                              interactive: true,
                                              thickness: 12,
                                              radius: const Radius.circular(10),
                                              controller: controller,
                                              child: CustomScrollView(
                                                controller: controller,
                                                slivers: [
                                                  SliverPadding(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    sliver:
                                                        SuperSliverList.builder(
                                                      itemCount: values.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final value =
                                                            values[index];
                                                        return RadioListTile(
                                                          dense: true,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          value: value
                                                              .value()
                                                              .fontFamily,
                                                          groupValue:
                                                              appFontFamily,
                                                          onChanged: (value) {
                                                            ref
                                                                .read(appFontFamilyProvider
                                                                    .notifier)
                                                                .set(value);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          title:
                                                              Text(value.key),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ));
                              }),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          ref
                                              .read(appFontFamilyProvider
                                                  .notifier)
                                              .set(null);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          l10n.default0,
                                          style: TextStyle(
                                              color: context.primaryColor),
                                        )),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          l10n.cancel,
                                          style: TextStyle(
                                              color: context.primaryColor),
                                        )),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: Text(context.l10n.font),
                    subtitle: Text(
                      appFontFamilySub,
                      style: TextStyle(
                          fontSize: 11, color: context.secondaryColor),
                    ),
                  ),
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
                                fontSize: 13, color: context.primaryColor)),
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
                                  width: context.width(0.8),
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
                                              color: context.primaryColor),
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
                      style: TextStyle(
                          fontSize: 11, color: context.secondaryColor),
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
                                  width: context.width(0.8),
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
                                              color: context.primaryColor),
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
                      style: TextStyle(
                          fontSize: 11, color: context.secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

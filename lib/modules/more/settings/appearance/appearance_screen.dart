import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_font_family.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/follow_system_theme_button.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/blend_level_slider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/dark_mode_button.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/theme_selector.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

final navigationItems = {
  "/MangaLibrary": "Manga",
  "/AnimeLibrary": "Anime",
  "/NovelLibrary": "Novel",
  "/updates": "Updates",
  "/history": "History",
  "/browse": "Browse",
  "/more": "More",
  "/trackerLibrary": "Tracking",
};

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              title,
              style: TextStyle(fontSize: 13, color: context.primaryColor),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    final pureBlackDarkMode = ref.watch(pureBlackDarkModeStateProvider);
    final isDarkTheme = ref.watch(themeModeStateProvider);
    bool followSystemTheme = ref.watch(followSystemThemeStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.appearance)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsSection(
              title: l10n.theme,
              children: [
                const FollowSystemThemeButton(),
                if (!followSystemTheme) const DarkModeButton(),
                const ThemeSelector(),
                if (isDarkTheme)
                  SwitchListTile(
                    title: Text(l10n.pure_black_dark_mode),
                    value: pureBlackDarkMode,
                    onChanged: (value) {
                      ref
                          .read(pureBlackDarkModeStateProvider.notifier)
                          .set(value);
                    },
                  ),
                if (!pureBlackDarkMode || !isDarkTheme)
                  const BlendLevelSlider(),
              ],
            ),
            SettingsSection(
              title: l10n.appearance,
              children: [
                _buildLanguageTile(context, ref, l10n),
                _buildFontTile(context, ref, l10n),
                ListTile(
                  title: Text(l10n.reorder_navigation),
                  subtitle: Text(
                    l10n.reorder_navigation_description,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  onTap: () {
                    context.push("/customNavigationSettings");
                  },
                ),
              ],
            ),
            SettingsSection(
              title: l10n.timestamp,
              children: [
                _buildRelativeTimestampTile(context, ref, l10n),
                _buildDateFormatTile(context, ref, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final l10nLocale = ref.watch(l10nLocaleStateProvider);
    return ListTile(
      title: Text(l10n.app_language),
      subtitle: Text(
        completeLanguageName(l10nLocale.toLanguageTag()),
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.app_language),
              content: SizedBox(
                width: context.width(0.8),
                child: RadioGroup(
                  groupValue: l10nLocale,
                  onChanged: (value) {
                    ref
                        .read(l10nLocaleStateProvider.notifier)
                        .setLocale(value!);
                    Navigator.pop(context);
                  },
                  child: SuperListView.builder(
                    shrinkWrap: true,
                    itemCount: AppLocalizations.supportedLocales.length,
                    itemBuilder: (context, index) {
                      final locale = AppLocalizations.supportedLocales[index];
                      return RadioListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        value: locale,
                        title: Text(
                          completeLanguageName(locale.toLanguageTag()),
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
                        l10n.cancel,
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
    );
  }

  Widget _buildFontTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final appFontFamily = ref.watch(appFontFamilyProvider);
    final appFontFamilySub = appFontFamily == null
        ? context.l10n.default0
        : GoogleFonts.asMap().entries
              .toList()
              .firstWhere(
                (element) => element.value().fontFamily! == appFontFamily,
              )
              .key;
    return ListTile(
      title: Text(context.l10n.font),
      subtitle: Text(
        appFontFamilySub,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () {
        String textValue = "";
        final controller = ScrollController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(context.l10n.font),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: context.width(0.8),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: TextField(
                            onChanged: (v) {
                              setState(() {
                                textValue = v;
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              filled: false,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.secondaryColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.primaryColor,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              hintText: l10n.search,
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            List values = GoogleFonts.asMap().entries.toList();
                            values = values
                                .where(
                                  (values) => values.key.toLowerCase().contains(
                                    textValue.toLowerCase(),
                                  ),
                                )
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
                                      padding: const EdgeInsets.all(0),
                                      sliver: RadioGroup(
                                        groupValue: appFontFamily,
                                        onChanged: (value) {
                                          ref
                                              .read(
                                                appFontFamilyProvider.notifier,
                                              )
                                              .set(value);
                                          Navigator.pop(context);
                                        },
                                        child: SuperSliverList.builder(
                                          itemCount: values.length,
                                          itemBuilder: (context, index) {
                                            final value = values[index];
                                            return RadioListTile(
                                              dense: true,
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              value: value.value().fontFamily,
                                              title: Text(value.key),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        ref.read(appFontFamilyProvider.notifier).set(null);
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.default0,
                        style: TextStyle(color: context.primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.cancel,
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
    );
  }

  Widget _buildRelativeTimestampTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
    return ListTile(
      title: Text(l10n.relative_timestamp),
      subtitle: Text(
        relativeTimestampsList(context)[relativeTimestamps],
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.relative_timestamp),
              content: SizedBox(
                width: context.width(0.8),
                child: RadioGroup(
                  groupValue: relativeTimestamps,
                  onChanged: (value) {
                    ref
                        .read(relativeTimesTampsStateProvider.notifier)
                        .set(value!);
                    Navigator.pop(context);
                  },
                  child: SuperListView.builder(
                    shrinkWrap: true,
                    itemCount: relativeTimestampsList(context).length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        value: index,
                        title: Row(
                          children: [
                            Text(relativeTimestampsList(context)[index]),
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
                        l10n.cancel,
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
    );
  }

  Widget _buildDateFormatTile(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final dateFormatState = ref.watch(dateFormatStateProvider);
    return ListTile(
      title: Text(l10n.date_format),
      subtitle: Text(
        "$dateFormatState (${dateFormat(context: context, DateTime.now().millisecondsSinceEpoch.toString(), useRelativeTimesTamps: false, dateFormat: dateFormatState, ref: ref)})",
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.date_format),
              content: SizedBox(
                width: context.width(0.8),
                child: RadioGroup(
                  groupValue: dateFormatState,
                  onChanged: (value) {
                    ref.read(dateFormatStateProvider.notifier).set(value!);
                    Navigator.pop(context);
                  },
                  child: SuperListView.builder(
                    shrinkWrap: true,
                    itemCount: dateFormatsList.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        value: dateFormatsList[index],
                        title: Row(
                          children: [
                            Text(
                              "${dateFormatsList[index]} (${dateFormat(context: context, DateTime.now().millisecondsSinceEpoch.toString(), useRelativeTimesTamps: false, dateFormat: dateFormatsList[index], ref: ref)})",
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
                        l10n.cancel,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/floating_navigation_bar_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/tint_surfaces_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/follow_system_theme_button.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/date_format_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/blend_level_slider.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/dark_mode_button.dart';
import 'package:mangayomi/modules/more/settings/appearance/widgets/theme_selector.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/app_ui_scale_state_provider.dart';

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

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pureBlackDarkMode = ref.watch(pureBlackDarkModeStateProvider);
    final isDarkTheme = ref.watch(themeModeStateProvider);
    final followSystemTheme = ref.watch(followSystemThemeStateProvider);
    final tintSurfaces = ref.watch(tintSurfacesStateProvider);
    final scale = ref.watch(appUiScaleStateProvider).clamp(0.85, 1.25);
    final locale = ref.watch(l10nLocaleStateProvider);
    final relativeTimestamps = ref.watch(relativeTimesTampsStateProvider);
    final dateFormatState = ref.watch(dateFormatStateProvider);
    String sampleDate(String format) => dateFormat(
      context: context,
      DateTime.now().millisecondsSinceEpoch.toString(),
      useRelativeTimesTamps: false,
      dateFormat: format,
      ref: ref,
    );
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearance)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            title: l10n.theme,
            children: [
              const FollowSystemThemeButton(),
              if (!followSystemTheme) const DarkModeButton(),
              const ThemeSelector(),
              if (isDarkTheme)
                ShioriSwitchRow(
                  title: l10n.pure_black_dark_mode,
                  value: pureBlackDarkMode,
                  onChanged: (v) =>
                      ref.read(pureBlackDarkModeStateProvider.notifier).set(v),
                ),
              ShioriSwitchRow(
                title: l10n.tint_surfaces_with_palette,
                subtitle: l10n.tint_surfaces_with_palette_subtitle,
                value: tintSurfaces,
                onChanged: (v) =>
                    ref.read(tintSurfacesStateProvider.notifier).set(v),
              ),
              // The blend only mixes the palette into the surfaces, so it
              // has nothing to do while they are neutral, or pure black.
              if (tintSurfaces && (!pureBlackDarkMode || !isDarkTheme))
                const BlendLevelSlider(),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_interface,
            children: [
              ShioriSliderRow(
                icon: Symbols.aspect_ratio_rounded,
                title: l10n.app_ui_scale,
                subtitle: l10n.app_ui_scale_subtitle,
                value: scale.toDouble(),
                min: 0.85,
                max: 1.25,
                divisions: 8,
                valueLabel: (v) => '${(v * 100).round()} %',
                defaultValue: 1,
                onReset: () => ref
                    .read(appUiScaleStateProvider.notifier)
                    .set(1, end: true),
                resetTooltip: l10n.reset,
                onChanged: (v) =>
                    ref.read(appUiScaleStateProvider.notifier).set(v),
                onChangeEnd: (v) => ref
                    .read(appUiScaleStateProvider.notifier)
                    .set(v, end: true),
              ),
              ShioriValueRow<Locale>(
                icon: Symbols.translate_rounded,
                title: l10n.app_language,
                searchHint: l10n.search,
                value: locale,
                options: [
                  for (final locale in AppLocalizations.supportedLocales)
                    ShioriChoice(
                      locale,
                      languageName(context, locale.toLanguageTag()),
                    ),
                ],
                onChanged: (v) =>
                    ref.read(l10nLocaleStateProvider.notifier).setLocale(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_navigation,
            children: [
              if (supportsFloatingNav)
                ShioriSwitchRow(
                  icon: Symbols.call_to_action_rounded,
                  title: l10n.floating_navigation_bar,
                  subtitle: l10n.floating_navigation_bar_description,
                  value: ref.watch(floatingNavigationBarStateProvider),
                  onChanged: (v) => ref
                      .read(floatingNavigationBarStateProvider.notifier)
                      .set(v),
                ),
              ShioriSettingRow(
                icon: Symbols.reorder_rounded,
                title: l10n.reorder_navigation,
                subtitle: l10n.reorder_navigation_description,
                trailing: const Icon(Symbols.chevron_forward_rounded),
                onTap: () => context.push("/customNavigationSettings"),
              ),
              if (isTv)
                ShioriSwitchRow(
                  icon: Symbols.grid_view_rounded,
                  title: l10n.tv_home_beta,
                  subtitle: l10n.tv_home_beta_subtitle,
                  value: ref.watch(tvHomeStyleProvider),
                  onChanged: (v) =>
                      ref.read(tvHomeStyleProvider.notifier).set(v),
                ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.timestamp,
            children: [
              ShioriValueRow<int>(
                title: l10n.relative_timestamp,
                value: relativeTimestamps,
                options: [
                  for (final (i, name) in relativeTimestampsList(
                    context,
                  ).indexed)
                    ShioriChoice(i, name),
                ],
                onChanged: (v) =>
                    ref.read(relativeTimesTampsStateProvider.notifier).set(v),
              ),
              ShioriValueRow<String>(
                title: l10n.date_format,
                value: dateFormatState,
                options: [
                  for (final format in dateFormatsList)
                    ShioriChoice(format, format, subtitle: sampleDate(format)),
                ],
                onChanged: (v) =>
                    ref.read(dateFormatStateProvider.notifier).set(v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

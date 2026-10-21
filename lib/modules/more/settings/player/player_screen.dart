import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final defaultSubtitleLang = ref.watch(defaultSubtitleLangStateProvider);
    final markEpisodeAsSeenType = ref.watch(markEpisodeAsSeenTypeStateProvider);
    final defaultSkipIntroLength = ref.watch(
      defaultSkipIntroLengthStateProvider,
    );
    final defaultDoubleTapToSkipLength = ref.watch(
      defaultDoubleTapToSkipLengthStateProvider,
    );
    final defaultPlayBackSpeed = ref.watch(defaultPlayBackSpeedStateProvider);
    final enableAniSkip = ref.watch(enableAniSkipStateProvider);
    final enableAutoSkip = ref.watch(enableAutoSkipStateProvider);
    final aniSkipTimeoutLength = ref.watch(aniSkipTimeoutLengthStateProvider);
    final useLibass = ref.watch(useLibassStateProvider);

    final fullScreenPlayer = ref.watch(fullScreenPlayerStateProvider);
    final forceLandscapePlayer = ref.watch(forceLandscapePlayerStateProvider);
    final l10n = context.l10n;
    List<ShioriChoice<T>> choices<T>(List<T> values, String Function(T) name) =>
        [for (final v in values) ShioriChoice(v, name(v))];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.internal_player)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            title: l10n.group_playback,
            children: [
              ShioriValueRow<double>(
                autofocus: isTv,
                title: l10n.default_playback_speed_length,
                value: defaultPlayBackSpeed,
                options: choices([
                  0.25,
                  0.5,
                  0.75,
                  1.0,
                  1.25,
                  1.5,
                  1.75,
                  2.0,
                ], l10n.playback_speed_multiplier),
                onChanged: (v) =>
                    ref.read(defaultPlayBackSpeedStateProvider.notifier).set(v),
              ),
              ShioriValueRow<int>(
                title: l10n.default_skip_forward_skip_length,
                value: defaultDoubleTapToSkipLength,
                options: choices([1, 3, 5, 10, 20, 30], l10n.seconds_short),
                onChanged: (v) => ref
                    .read(defaultDoubleTapToSkipLengthStateProvider.notifier)
                    .set(v),
              ),
              ShioriSliderRow(
                title: l10n.default_skip_intro_length,
                value: defaultSkipIntroLength.toDouble(),
                min: 1,
                max: 255,
                divisions: 254,
                valueLabel: (v) => l10n.seconds_short(v.round()),
                defaultValue: 85,
                onReset: () => ref
                    .read(defaultSkipIntroLengthStateProvider.notifier)
                    .set(85),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(defaultSkipIntroLengthStateProvider.notifier)
                    .set(v.round()),
              ),
              ShioriValueRow<int>(
                title: l10n.markEpisodeAsSeenSetting,
                value: markEpisodeAsSeenType,
                options: choices([70, 75, 80, 85, 90, 95, 100], (v) => '$v %'),
                onChanged: (v) => ref
                    .read(markEpisodeAsSeenTypeStateProvider.notifier)
                    .set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_subtitles,
            children: [
              ShioriValueRow<Locale>(
                title: l10n.default_subtitle_language,
                searchHint: l10n.search,
                value: defaultSubtitleLang,
                options: choices(
                  AppLocalizations.supportedLocales,
                  (locale) => languageName(context, locale.toLanguageTag()),
                ),
                onChanged: (v) => ref
                    .read(defaultSubtitleLangStateProvider.notifier)
                    .setLocale(v),
              ),
              ShioriSwitchRow(
                title: l10n.use_libass,
                subtitle: l10n.use_libass_info,
                value: useLibass,
                onChanged: (v) =>
                    ref.read(useLibassStateProvider.notifier).set(v),
              ),
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.aniskip,
            footer: l10n.aniskip_requires_info,
            children: [
              ShioriSwitchRow(
                title: l10n.enable_aniskip,
                value: enableAniSkip,
                onChanged: (v) =>
                    ref.read(enableAniSkipStateProvider.notifier).set(v),
              ),
              if (enableAniSkip) ...[
                ShioriSwitchRow(
                  title: l10n.enable_auto_skip,
                  value: enableAutoSkip,
                  onChanged: (v) =>
                      ref.read(enableAutoSkipStateProvider.notifier).set(v),
                ),
                ShioriValueRow<int>(
                  title: l10n.aniskip_button_timeout,
                  value: aniSkipTimeoutLength,
                  options: choices([5, 6, 7, 8, 9, 10], l10n.seconds_short),
                  onChanged: (v) => ref
                      .read(aniSkipTimeoutLengthStateProvider.notifier)
                      .set(v),
                ),
              ],
            ],
          ),
          ShioriSettingsGroup(
            title: l10n.group_screen,
            children: [
              ShioriSwitchRow(
                title: l10n.full_screen_player,
                subtitle: l10n.full_screen_player_info,
                value: fullScreenPlayer,
                onChanged: (v) =>
                    ref.read(fullScreenPlayerStateProvider.notifier).set(v),
              ),
              ShioriSwitchRow(
                title: l10n.forceLandscapeMode,
                subtitle: l10n.forceLandscapeModeSubtitle,
                value: forceLandscapePlayer,
                onChanged: (v) =>
                    ref.read(forceLandscapePlayerStateProvider.notifier).set(v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

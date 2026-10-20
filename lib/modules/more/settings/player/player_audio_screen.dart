import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class PlayerAudioScreen extends ConsumerStatefulWidget {
  const PlayerAudioScreen({super.key});

  @override
  ConsumerState<PlayerAudioScreen> createState() => _PlayerAudioScreenState();
}

class _PlayerAudioScreenState extends ConsumerState<PlayerAudioScreen> {
  @override
  Widget build(BuildContext context) {
    final audioPreferredLang = ref.watch(audioPreferredLangStateProvider);
    final enableAudioPitchCorrection = ref.watch(
      enableAudioPitchCorrectionStateProvider,
    );
    final audioChannel = ref.watch(audioChannelStateProvider);
    final volumeBoostCap = ref.watch(volumeBoostCapStateProvider);

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.video_audio)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            children: [
              ShioriSettingRow(
                autofocus: isTv,
                title: l10n.audio_preferred_languages,
                subtitle: audioPreferredLang,
                onTap: _editPreferredLanguages,
              ),
              ShioriSwitchRow(
                title: l10n.enable_audio_pitch_correction,
                subtitle: l10n.enable_audio_pitch_correction_info,
                value: enableAudioPitchCorrection,
                onChanged: (v) => ref
                    .read(enableAudioPitchCorrectionStateProvider.notifier)
                    .set(v),
              ),
              ShioriValueRow<AudioChannel>(
                title: l10n.audio_channels,
                value: audioChannel,
                options: const [
                  ShioriChoice(AudioChannel.auto, 'Auto'),
                  ShioriChoice(AudioChannel.autoSafe, 'Auto-safe'),
                  ShioriChoice(AudioChannel.mono, 'Mono'),
                  ShioriChoice(AudioChannel.stereo, 'Stereo'),
                  ShioriChoice(AudioChannel.reverseStereo, 'Reverse stereo'),
                ],
                onChanged: (v) =>
                    ref.read(audioChannelStateProvider.notifier).set(v),
              ),
              ShioriSliderRow(
                title: l10n.volume_boost_cap,
                value: volumeBoostCap.toDouble(),
                min: 0,
                max: 200,
                divisions: 40,
                defaultValue: 30,
                onReset: () =>
                    ref.read(volumeBoostCapStateProvider.notifier).set(30),
                resetTooltip: l10n.reset,
                onChanged: (v) => ref
                    .read(volumeBoostCapStateProvider.notifier)
                    .set(v.round()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Comma-separated language codes; each must be one the app knows.
  Future<void> _editPreferredLanguages() async {
    final l10n = context.l10n;
    final known = AppLocalizations.supportedLocales
        .map((e) => e.languageCode)
        .toSet();
    final codes = await showShioriPrompt(
      context,
      title: l10n.audio_preferred_languages,
      message: l10n.audio_preferred_languages_info,
      confirmLabel: l10n.ok,
      initialValue: ref.read(audioPreferredLangStateProvider),
      hint: 'en, ja',
      allowEmpty: true,
      validator: (text) {
        final unknown = text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty && !known.contains(e));
        return unknown.isEmpty
            ? null
            : l10n.unknown_language_codes(unknown.join(', '));
      },
    );
    if (codes == null) return;
    final cleaned = codes
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(',');
    ref.read(audioPreferredLangStateProvider.notifier).set(cleaned);
  }
}

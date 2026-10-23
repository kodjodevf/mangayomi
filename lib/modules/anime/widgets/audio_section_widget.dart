import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:media_kit/media_kit.dart';

/// The player settings sheet's "audio" section: the audio delay, then one row
/// per available audio track (from the player and from the source's own
/// audio list).
class AudioSectionWidget extends StatelessWidget {
  final List<VideoPrefs> audioOptions;
  final AudioTrack? effectiveAudioTrack;
  final bool Function(AudioTrack? candidate, AudioTrack? effective)
  isTrackSelected;
  final void Function(AudioTrack track) onSelect;
  final VoidCallback onDone;

  /// The audio delay in milliseconds, as text.
  final TextEditingController audioDelayController;

  const AudioSectionWidget({
    super.key,
    required this.audioOptions,
    required this.effectiveAudioTrack,
    required this.isTrackSelected,
    required this.onSelect,
    required this.onDone,
    required this.audioDelayController,
  });

  void _stepDelay(int by) {
    final text = '${(int.tryParse(audioDelayController.text) ?? 0) + by}';
    audioDelayController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
      child: Column(
        children: [
          SettingsStepperRow(
            label: context.l10n.audio_delay,
            controller: audioDelayController,
            suffix: ' ms',
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            onDecrement: () => _stepDelay(-50),
            onIncrement: () => _stepDelay(50),
          ),
          ...audioOptions.map((aud) {
            final isNone = aud.audio?.id == "no";
            final title = isNone
                ? context.l10n.off
                : (aud.title ?? audioTrackLabel(aud.audio));
            final selected = isNone
                ? (effectiveAudioTrack == null ||
                      effectiveAudioTrack!.id == "no")
                : isTrackSelected(aud.audio, effectiveAudioTrack);
            return SettingsOptionRow(
              label: title,
              selected: selected,
              onTap: () {
                onDone();
                try {
                  onSelect(aud.audio!);
                } catch (_) {}
              },
            );
          }),
        ],
      ),
    );
  }
}

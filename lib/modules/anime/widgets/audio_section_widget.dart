import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/video_prefs.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:media_kit/media_kit.dart';

/// The player settings sheet's "audio" section: one row per available audio
/// track (from the player and from the source's own audio list).
class AudioSectionWidget extends StatelessWidget {
  final List<VideoPrefs> audioOptions;
  final AudioTrack? effectiveAudioTrack;
  final bool Function(AudioTrack? candidate, AudioTrack? effective)
  isTrackSelected;
  final void Function(AudioTrack track) onSelect;
  final VoidCallback onDone;

  const AudioSectionWidget({
    super.key,
    required this.audioOptions,
    required this.effectiveAudioTrack,
    required this.isTrackSelected,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: audioOptions.map((aud) {
          final isNone = aud.audio?.id == "no";
          final title = isNone
              ? context.l10n.off
              : (aud.title ?? audioTrackLabel(aud.audio));
          final selected = isNone
              ? (effectiveAudioTrack == null || effectiveAudioTrack!.id == "no")
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
        }).toList(),
      ),
    );
  }
}

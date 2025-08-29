import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/player/custom_button_screen.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_audio_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.video_audio)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () => _showEditController(),
              title: Text(context.l10n.audio_preferred_languages),
              subtitle: Text(
                audioPreferredLang,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            SwitchListTile(
              value: enableAudioPitchCorrection,
              title: Text(context.l10n.enable_audio_pitch_correction),
              subtitle: Text(
                context.l10n.enable_audio_pitch_correction_info,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onChanged: (value) {
                ref
                    .read(enableAudioPitchCorrectionStateProvider.notifier)
                    .set(value);
              },
            ),
            ListTile(
              onTap: () {
                final values = [
                  (AudioChannel.auto, "Auto"),
                  (AudioChannel.autoSafe, "Auto-safe"),
                  (AudioChannel.mono, "Mono"),
                  (AudioChannel.stereo, "Stereo"),
                  (AudioChannel.reverseStereo, "Reverse stereo"),
                ];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.audio_channels),
                      content: SizedBox(
                        width: context.width(0.8),
                        child: RadioGroup(
                          groupValue: audioChannel,
                          onChanged: (value) {
                            ref
                                .read(audioChannelStateProvider.notifier)
                                .set(value!);
                            Navigator.pop(context);
                          },
                          child: SuperListView.builder(
                            shrinkWrap: true,
                            itemCount: values.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.all(0),
                                value: values[index].$1,
                                title: Row(children: [Text(values[index].$2)]),
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
                                context.l10n.cancel,
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
              title: Text(context.l10n.audio_channels),
              subtitle: Text(
                audioChannel.name,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.volume_boost_cap),
                  Text(
                    "$volumeBoostCap",
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 5.0,
                      ),
                    ),
                    child: Slider.adaptive(
                      min: 0,
                      max: 200,
                      value: volumeBoostCap.toDouble(),
                      onChanged: (value) {
                        HapticFeedback.vibrate();
                        ref
                            .read(volumeBoostCapStateProvider.notifier)
                            .set(value.toInt());
                      },
                      onChangeEnd: (value) {
                        ref
                            .read(volumeBoostCapStateProvider.notifier)
                            .set(value.toInt());
                      },
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

  void _showEditController() {
    final audioPreferredLang = ref.read(audioPreferredLangStateProvider);
    final langCodes = AppLocalizations.supportedLocales
        .map((e) => e.languageCode)
        .toList();
    bool isLangCodeError = false;
    final textController = TextEditingController(text: audioPreferredLang);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  Text(context.l10n.audio_preferred_languages),
                  Text(
                    context.l10n.audio_preferred_languages_info,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.secondaryColor,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: context.width(0.8),
                child: CustomTextFormField(
                  controller: textController,
                  context: context,
                  isMissing: isLangCodeError,
                  val: (text) => setState(() {
                    isLangCodeError = text
                        .split(",")
                        .any((e) => !langCodes.contains(e));
                  }),
                  missing: (_) {},
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.l10n.cancel,
                        style: TextStyle(color: context.primaryColor),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(audioPreferredLangStateProvider.notifier)
                            .set(textController.text);
                        Navigator.pop(context);
                      },
                      child: Text(
                        context.l10n.ok,
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

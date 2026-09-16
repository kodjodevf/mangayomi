import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart' as vid;
import 'package:mangayomi/modules/anime/utils/audio_track_label.dart';
import 'package:mangayomi/modules/anime/utils/track_list_builder.dart';
import 'package:mangayomi/modules/anime/widgets/search_subtitles.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_subtitles.dart';
import 'package:media_kit/media_kit.dart';

/// The player settings sheet's "subtitle" section: delay/speed steppers plus
/// one row per available subtitle track (from the player and from the
/// source's own subtitle list), and actions to load a local file or search
/// online. Its own StatefulWidget (rather than the nested StatefulBuilder
/// this used to be) since the delay/speed steppers' displayed value is
/// local, UI-only state - the actual committed mpv property is driven by the
/// text controllers' listeners, owned by the caller.
class SubtitleSectionWidget extends StatefulWidget {
  final Player player;
  final List<vid.Video> videos;
  final bool isLocal;
  final Chapter episode;
  final SubtitleTrack? effectiveSubtitleTrack;
  final bool Function(SubtitleTrack? candidate, SubtitleTrack? effective)
  isTrackSelected;
  final Future<void> Function(SubtitleTrack track) onSetSubtitleTrack;
  final TextEditingController subDelayController;
  final TextEditingController subSpeedController;
  final VoidCallback onDone;

  const SubtitleSectionWidget({
    super.key,
    required this.player,
    required this.videos,
    required this.isLocal,
    required this.episode,
    required this.effectiveSubtitleTrack,
    required this.isTrackSelected,
    required this.onSetSubtitleTrack,
    required this.subDelayController,
    required this.subSpeedController,
    required this.onDone,
  });

  @override
  State<SubtitleSectionWidget> createState() => _SubtitleSectionWidgetState();
}

class _SubtitleSectionWidgetState extends State<SubtitleSectionWidget> {
  late int _subDelay = int.tryParse(widget.subDelayController.text) ?? 0;
  late double _subSpeed = double.tryParse(widget.subSpeedController.text) ?? 1;

  @override
  Widget build(BuildContext context) {
    final uniqueSubtitle = buildUniqueSubtitleOptions(
      player: widget.player,
      videos: widget.videos,
      isLocal: widget.isLocal,
    );
    final effective = widget.effectiveSubtitleTrack;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.subtitle_delay_text,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _subDelay = 0;
                    widget.subDelayController.value = const TextEditingValue(
                      text: "0",
                      selection: TextSelection.collapsed(offset: 1),
                    );
                    _subSpeed = 1;
                    widget.subSpeedController.value = const TextEditingValue(
                      text: "1.00",
                      selection: TextSelection.collapsed(offset: 4),
                    );
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ],
          ),
          SettingsStepperRow(
            label: context.l10n.subtitle_delay,
            controller: widget.subDelayController,
            suffix: ' ms',
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            onDecrement: () => setState(() {
              _subDelay -= 50;
              final text = "$_subDelay";
              widget.subDelayController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
            onIncrement: () => setState(() {
              _subDelay += 50;
              final text = "$_subDelay";
              widget.subDelayController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
            onSubmitted: (text) {
              final val = int.tryParse(text);
              if (val != null) {
                setState(() {
                  _subDelay = val;
                  final str = "$val";
                  widget.subDelayController.value = TextEditingValue(
                    text: str,
                    selection: TextSelection.collapsed(offset: str.length),
                  );
                });
              } else {
                final str = "$_subDelay";
                widget.subDelayController.value = TextEditingValue(
                  text: str,
                  selection: TextSelection.collapsed(offset: str.length),
                );
              }
            },
          ),
          SettingsStepperRow(
            label: context.l10n.subtitle_speed,
            controller: widget.subSpeedController,
            suffix: 'x',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onDecrement: () => setState(() {
              _subSpeed = (_subSpeed - 0.01).clamp(0.1, 10.0);
              final text = _subSpeed.toStringAsFixed(2);
              widget.subSpeedController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
            onIncrement: () => setState(() {
              _subSpeed = (_subSpeed + 0.01).clamp(0.1, 10.0);
              final text = _subSpeed.toStringAsFixed(2);
              widget.subSpeedController.value = TextEditingValue(
                text: text,
                selection: TextSelection.collapsed(offset: text.length),
              );
            }),
            onSubmitted: (text) {
              final val = double.tryParse(text);
              if (val != null) {
                setState(() {
                  _subSpeed = val.clamp(0.1, 10.0);
                  final str = _subSpeed.toStringAsFixed(2);
                  widget.subSpeedController.value = TextEditingValue(
                    text: str,
                    selection: TextSelection.collapsed(offset: str.length),
                  );
                });
              } else {
                final str = _subSpeed.toStringAsFixed(2);
                widget.subSpeedController.value = TextEditingValue(
                  text: str,
                  selection: TextSelection.collapsed(offset: str.length),
                );
              }
            },
          ),
          SettingsSectionLabel(context.l10n.tracks),
          ...uniqueSubtitle.map((sub) {
            final isNone = sub.subtitle?.id == "no";
            final title = isNone
                ? context.l10n.off
                : (sub.title ?? subtitleTrackLabel(sub.subtitle));
            final selected = isNone
                ? (effective == null || effective.id == "no")
                : widget.isTrackSelected(sub.subtitle, effective);
            return SettingsOptionRow(
              label: title,
              selected: selected,
              onTap: () {
                widget.onDone();
                try {
                  unawaited(widget.onSetSubtitleTrack(sub.subtitle!));
                } catch (_) {}
              },
            );
          }),
          SettingsActionRow(
            label: context.l10n.load_own_subtitles,
            icon: Icons.file_open_outlined,
            onTap: () async {
              try {
                final file = await FilePicker.pickFile(
                  linuxOptions: const LinuxOptions(lockParentWindow: true),
                );

                if (file != null && context.mounted) {
                  final track = SubtitleTrack.uri(file.path!);
                  unawaited(widget.onSetSubtitleTrack(track));
                }
                if (!context.mounted) return;
                widget.onDone();
              } catch (e) {
                botToast(context.l10n.error_with_message(e));
                widget.onDone();
              }
            },
          ),
          SettingsActionRow(
            label: context.l10n.search_subtitles,
            icon: Icons.search,
            onTap: () async {
              try {
                final subtitle = await subtitlesSearchraggableMenu(
                  context,
                  chapter: widget.episode,
                  isLocal: widget.isLocal,
                ) as ImdbSubtitle?;
                if (subtitle != null && context.mounted) {
                  final track = SubtitleTrack.uri(
                    subtitle.url!,
                    title: subtitle.language,
                    language: subtitle.language,
                  );
                  unawaited(widget.onSetSubtitleTrack(track));
                }
                if (!context.mounted) return;
                widget.onDone();
              } catch (_) {
                botToast(context.l10n.error);
                widget.onDone();
              }
            },
          ),
        ],
      ),
    );
  }
}

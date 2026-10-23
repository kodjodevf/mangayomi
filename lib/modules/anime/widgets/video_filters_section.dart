import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/utils/video_filters.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// The player settings sheet's picture adjustments: one slider per
/// [VideoFilter], applied to the video as it moves through [onApply] and
/// kept for the next episodes.
class VideoFiltersSection extends ConsumerWidget {
  const VideoFiltersSection({super.key, required this.onApply});

  final void Function(VideoFilter filter, int value) onApply;

  static String label(AppLocalizations l10n, VideoFilter filter) =>
      switch (filter) {
        VideoFilter.brightness => l10n.brightness,
        VideoFilter.contrast => l10n.video_filter_contrast,
        VideoFilter.saturation => l10n.video_filter_saturation,
        VideoFilter.gamma => l10n.video_filter_gamma,
        VideoFilter.hue => l10n.video_filter_hue,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final filters = ref.watch(videoFiltersStateProvider);
    final notifier = ref.read(videoFiltersStateProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final filter in VideoFilter.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(
                      label(l10n, filter),
                      style: tokens.text.row.copyWith(
                        color: tokens.color.fgMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: filters[filter]!.toDouble(),
                      min: VideoFilter.min.toDouble(),
                      max: VideoFilter.max.toDouble(),
                      divisions: VideoFilter.max - VideoFilter.min,
                      onChanged: (v) {
                        notifier.set(filter, v.round());
                        onApply(filter, v.round());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${filters[filter]}',
                      textAlign: TextAlign.end,
                      style: tokens.caption.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
              child: TextButton(
                onPressed: filters.values.every((v) => v == 0)
                    ? null
                    : () {
                        notifier.reset();
                        for (final filter in VideoFilter.values) {
                          onApply(filter, 0);
                        }
                      },
                child: Text(l10n.reset),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

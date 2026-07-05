import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/widgets/tv_escapable_slider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class BlendLevelSlider extends ConsumerWidget {
  const BlendLevelSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blendLevel = ref.watch(blendLevelStateProvider);
    final l10n = l10nLocalizations(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            l10n!.color_blend_level,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TvEscapableSlider(
          enabled: isTv,
          onDecrease: () => ref
              .read(blendLevelStateProvider.notifier)
              .setBlendLevel((blendLevel - 1).clamp(0.0, 40.0), end: true),
          onIncrease: () => ref
              .read(blendLevelStateProvider.notifier)
              .setBlendLevel((blendLevel + 1).clamp(0.0, 40.0), end: true),
          child: Slider(
            min: 0.0,
            max: 40.0,
            divisions: max(39, 1),
            value: blendLevel,
            onChanged: (value) =>
                ref.read(blendLevelStateProvider.notifier).setBlendLevel(value),
            onChangeEnd: (value) => ref
                .read(blendLevelStateProvider.notifier)
                .setBlendLevel(value, end: true),
          ),
        ),
      ],
    );
  }
}

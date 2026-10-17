import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class BlendLevelSlider extends ConsumerWidget {
  const BlendLevelSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blendLevel = ref.watch(blendLevelStateProvider);
    final l10n = l10nLocalizations(context);
    return ShioriSliderRow(
      title: l10n!.color_blend_level,
      value: blendLevel,
      min: 0,
      max: 40,
      divisions: 40,
      onChanged: (value) =>
          ref.read(blendLevelStateProvider.notifier).setBlendLevel(value),
      onChangeEnd: (value) => ref
          .read(blendLevelStateProvider.notifier)
          .setBlendLevel(value, end: true),
    );
  }
}

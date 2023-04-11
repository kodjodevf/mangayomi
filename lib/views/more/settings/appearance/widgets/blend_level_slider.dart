import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/views/more/settings/appearance/providers/blend_level_state_provider.dart';

class BlendLevelSlider extends ConsumerWidget {
  const BlendLevelSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blendLevel = ref.watch(blendLevelStateProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22),
          child: Text(
            'Color blend Level',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Slider(
            min: 0.0,
            max: 40.0,
            divisions: max(40 - 1, 1),
            value: blendLevel,
            onChanged: (value) {
              ref.read(blendLevelStateProvider.notifier).setBlendLevel(value);
            }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';

class ColorFilterWidget extends ConsumerWidget {
  final Widget child;
  const ColorFilterWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColorFilter = ref.watch(customColorFilterStateProvider);
    final colorFilterBlendMode = ref.watch(colorFilterBlendModeStateProvider);
    return Container(
      foregroundDecoration: BoxDecoration(
        backgroundBlendMode:
            getColorFilterBlendMode(colorFilterBlendMode, context),
        color: customColorFilter == null
            ? Colors.transparent
            : Color.fromARGB(customColorFilter.a ?? 0, customColorFilter.r ?? 0,
                customColorFilter.g ?? 0, customColorFilter.b ?? 0),
      ),
      child: child,
    );
  }
}

Widget customColorFilterListTile(bool isDesktop, String label, int value,
    void Function(double)? onChanged, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 50,
          child: Column(
            children: [
              Text(label.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold)),
              Text("$value"),
            ],
          ),
        ),
        Expanded(
          child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: isDesktop ? null : 3,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 5.0)),
              child: Slider(
                  min: 0.0,
                  max: 255,
                  value: value.toDouble(),
                  onChanged: onChanged)),
        ),
      ],
    ),
  );
}

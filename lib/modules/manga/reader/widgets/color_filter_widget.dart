import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

(BlendMode?, Color?) chapterColorFIlterValues(
    BuildContext context, WidgetRef ref) {
  final customColorFilter = ref.watch(customColorFilterStateProvider);
  final colorFilterBlendMode = ref.watch(colorFilterBlendModeStateProvider);
  return (
    getColorFilterBlendMode(colorFilterBlendMode, context),
    customColorFilter == null
        ? Colors.transparent
        : Color.fromARGB(customColorFilter.a ?? 0, customColorFilter.r ?? 0,
            customColorFilter.g ?? 0, customColorFilter.b ?? 0)
  );
}

Widget customColorFilterListTile(String label, int value,
    void Function((double, bool, String))? onChanged, BuildContext context) {
  final color = switch (label) {
    "a" => Color.fromARGB(value, 255, 255, 255),
    "r" => Color.fromARGB(255, value, 0, 0),
    "g" => Color.fromARGB(255, 0, value, 0),
    _ => Color.fromARGB(255, 0, 0, value),
  };

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold)),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: color,
                      border: Border.all(
                          width: 2, color: context.dynamicWhiteBlackColor)),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  trackHeight: context.isDesktop ? null : 3,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 5.0)),
              child: Slider(
                min: 0.0,
                max: 255,
                divisions: max(244, 1),
                onChangeEnd: (value) => onChanged!.call((value, true, label)),
                value: value.toDouble(),
                onChanged: (value) => onChanged!.call((value, false, label)),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text("$value"),
        ),
      ],
    ),
  );
}

Widget rgbaFilterWidget(int a, int r, int g, int b,
    void Function((double, bool, String))? onChanged, BuildContext context) {
  return Column(children: [
    customColorFilterListTile("r", r, onChanged, context),
    customColorFilterListTile("g", g, onChanged, context),
    customColorFilterListTile("b", b, onChanged, context),
    customColorFilterListTile("a", a, onChanged, context),
  ]);
}

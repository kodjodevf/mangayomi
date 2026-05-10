import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

// ── Color matrix utilities (5×4 row-major, 20 elements) ──

List<double> _identityMatrix() => <double>[
  1, 0, 0, 0, 0, //
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0,
];

List<double> _invertMatrix() => <double>[
  -1, 0, 0, 0, 255, //
  0, -1, 0, 0, 255,
  0, 0, -1, 0, 255,
  0, 0, 0, 1, 0,
];

List<double> _grayscaleMatrix() {
  const double lr = 0.2126, lg = 0.7152, lb = 0.0722;
  return <double>[
    lr, lg, lb, 0, 0, //
    lr, lg, lb, 0, 0,
    lr, lg, lb, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

/// [b] in range -1.0 .. 1.0  (0 = no change)
List<double> _brightnessMatrix(double b) {
  final double t = b * 255;
  return <double>[
    1, 0, 0, 0, t, //
    0, 1, 0, 0, t,
    0, 0, 1, 0, t,
    0, 0, 0, 1, 0,
  ];
}

/// [c] in range 0.0 .. 2.0  (1 = no change)
List<double> _contrastMatrix(double c) {
  final double t = 128 * (1 - c);
  return <double>[
    c, 0, 0, 0, t, //
    0, c, 0, 0, t,
    0, 0, c, 0, t,
    0, 0, 0, 1, 0,
  ];
}

/// [s] in range 0.0 .. 2.0  (1 = no change)
List<double> _saturationMatrix(double s) {
  const double lr = 0.2126, lg = 0.7152, lb = 0.0722;
  return <double>[
    lr * (1 - s) + s, lg * (1 - s), lb * (1 - s), 0, 0, //
    lr * (1 - s), lg * (1 - s) + s, lb * (1 - s), 0, 0,
    lr * (1 - s), lg * (1 - s), lb * (1 - s) + s, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

/// Multiply two 5×4 colour matrices (with an implicit 5th row [0,0,0,0,1]).
List<double> _multiplyColorMatrices(List<double> a, List<double> b) {
  final result = List<double>.filled(20, 0);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 5; j++) {
      double sum = 0;
      for (int k = 0; k < 4; k++) {
        sum += a[i * 5 + k] * b[k * 5 + j];
      }
      if (j == 4) sum += a[i * 5 + 4];
      result[i * 5 + j] = sum;
    }
  }
  return result;
}

/// Builds a single composed [ColorFilter.matrix] from the reader enhancement
/// settings (invert, grayscale, brightness, contrast, saturation).
/// Returns `null` when every value is at its default (== identity).
ColorFilter? buildReaderColorFilter(WidgetRef ref) {
  final invert = ref.watch(invertColorsStateProvider);
  final grayscale = ref.watch(grayscaleStateProvider);
  final brightness = ref.watch(readerBrightnessStateProvider);
  final contrast = ref.watch(readerContrastStateProvider);
  final saturation = ref.watch(readerSaturationStateProvider);

  if (!invert &&
      !grayscale &&
      brightness == 0.0 &&
      contrast == 1.0 &&
      saturation == 1.0) {
    return null;
  }

  List<double> m = _identityMatrix();
  if (saturation != 1.0) {
    m = _multiplyColorMatrices(_saturationMatrix(saturation), m);
  }
  if (contrast != 1.0) {
    m = _multiplyColorMatrices(_contrastMatrix(contrast), m);
  }
  if (brightness != 0.0) {
    m = _multiplyColorMatrices(_brightnessMatrix(brightness), m);
  }
  if (grayscale) {
    m = _multiplyColorMatrices(_grayscaleMatrix(), m);
  }
  if (invert) {
    m = _multiplyColorMatrices(_invertMatrix(), m);
  }

  return ColorFilter.matrix(m);
}

/// Convenience wrapper: wraps [child] with a [ColorFiltered] if any reader
/// enhancement filter is active; otherwise returns [child] unchanged.
Widget applyReaderColorFilter(Widget child, WidgetRef ref) {
  final filter = buildReaderColorFilter(ref);
  if (filter == null) return child;
  return ColorFiltered(colorFilter: filter, child: child);
}

(BlendMode?, Color?) chapterColorFIlterValues(
  BuildContext context,
  WidgetRef ref,
) {
  final customColorFilter = ref.watch(customColorFilterStateProvider);
  final colorFilterBlendMode = ref.watch(colorFilterBlendModeStateProvider);
  return (
    getColorFilterBlendMode(colorFilterBlendMode, context),
    customColorFilter == null
        ? null
        : Color.fromARGB(
            customColorFilter.a ?? 0,
            customColorFilter.r ?? 0,
            customColorFilter.g ?? 0,
            customColorFilter.b ?? 0,
          ),
  );
}

Widget customColorFilterListTile(
  String label,
  int value,
  void Function((double, bool, String))? onChanged,
  BuildContext context,
) {
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
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: color,
                    border: Border.all(
                      width: 2,
                      color: context.dynamicWhiteBlackColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: isDesktop ? null : 3,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
            ),
            child: Slider(
              min: 0.0,
              max: 255,
              divisions: max(244, 1),
              onChangeEnd: (value) => onChanged!.call((value, true, label)),
              value: value.toDouble(),
              onChanged: (value) => onChanged!.call((value, false, label)),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(2), child: Text("$value")),
      ],
    ),
  );
}

Widget rgbaFilterWidget(
  int a,
  int r,
  int g,
  int b,
  void Function((double, bool, String))? onChanged,
  BuildContext context,
) {
  return Column(
    children: [
      customColorFilterListTile("r", r, onChanged, context),
      customColorFilterListTile("g", g, onChanged, context),
      customColorFilterListTile("b", b, onChanged, context),
      customColorFilterListTile("a", a, onChanged, context),
    ],
  );
}

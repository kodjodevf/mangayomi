import 'dart:math' as math;

/// The picture adjustments the player offers, each an mpv property from
/// -100 to 100, 0 leaving the picture as it is.
enum VideoFilter {
  brightness('brightness'),
  contrast('contrast'),
  saturation('saturation'),
  gamma('gamma'),
  hue('hue');

  const VideoFilter(this.mpvProperty);

  final String mpvProperty;

  static const int min = -100;
  static const int max = 100;
}

/// [saved], the filter values as stored, one per [VideoFilter] in order, as a
/// map; anything missing or out of range reads as 0.
Map<VideoFilter, int> videoFiltersFrom(List<int>? saved) => {
  for (final filter in VideoFilter.values)
    filter: (saved?.elementAtOrNull(filter.index) ?? 0).clamp(
      VideoFilter.min,
      VideoFilter.max,
    ),
};

/// The mpv options that start the player with [filters] applied.
Map<String, String> videoFilterOptions(Map<VideoFilter, int> filters) => {
  for (final MapEntry(key: filter, :value) in filters.entries)
    if (value != 0) filter.mpvProperty: '$value',
};

/// Whether the video reaches the screen through mpv's software renderer,
/// which leaves out every one of the mpv properties above.
bool isSoftwareVideoOutput({
  required bool isAndroid,
  required bool hardwareAcceleration,
}) => !isAndroid && !hardwareAcceleration;

/// The adjustments that can reach the picture: software output is corrected
/// by [softwareVideoFilterMatrix], and gamma is not a matrix.
List<VideoFilter> availableVideoFilters({required bool softwareOutput}) => [
  for (final filter in VideoFilter.values)
    if (!softwareOutput || filter != VideoFilter.gamma) filter,
];

/// [filters] as a 5x4 colour matrix, computed as mpv computes them, so the
/// picture looks the same either way: hue and saturation turn and scale the
/// BT.709 chroma, contrast is a gain over black and brightness an offset.
/// Null when it would change nothing.
List<double>? softwareVideoFilterMatrix(Map<VideoFilter, int> filters) {
  int value(VideoFilter filter) => filters[filter] ?? 0;
  final brightness = value(VideoFilter.brightness);
  final contrast = value(VideoFilter.contrast);
  final saturation = value(VideoFilter.saturation);
  final hue = value(VideoFilter.hue);
  if (brightness == 0 && contrast == 0 && saturation == 0 && hue == 0) {
    return null;
  }
  const kr = 0.2126, kg = 0.7152, kb = 0.0722;
  final gain = (contrast + 100) / 100;
  final chroma = (saturation + 100) / 100;
  final hueCos = chroma * math.cos(hue / 100 * math.pi);
  final hueSin = chroma * math.sin(hue / 100 * math.pi);
  // What one unit of each input channel gives, the matrix's columns.
  List<double> column(double r, double g, double b) {
    final y = kr * r + kg * g + kb * b;
    final u = (b - y) / (2 * (1 - kb));
    final v = (r - y) / (2 * (1 - kr));
    final newR = y + 2 * (1 - kr) * (hueSin * u + hueCos * v);
    final newB = y + 2 * (1 - kb) * (hueCos * u - hueSin * v);
    final newG = (y - kr * newR - kb * newB) / kg;
    return [gain * newR, gain * newG, gain * newB];
  }

  final red = column(1, 0, 0);
  final green = column(0, 1, 0);
  final blue = column(0, 0, 1);
  // The matrix's offsets are on the 0-255 scale.
  final offset = brightness / 100 * 255;
  return [
    for (var channel = 0; channel < 3; channel++) ...[
      red[channel],
      green[channel],
      blue[channel],
      0,
      offset,
    ],
    0,
    0,
    0,
    1,
    0,
  ];
}

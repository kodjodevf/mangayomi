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

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/video_filters.dart';

void main() {
  test('nothing saved is no adjustment', () {
    expect(videoFiltersFrom(null).values, everyElement(0));
    expect(videoFilterOptions(videoFiltersFrom(null)), isEmpty);
  });

  test('saved values are read in order and kept in range', () {
    final filters = videoFiltersFrom([10, -20, 300]);
    expect(filters[VideoFilter.brightness], 10);
    expect(filters[VideoFilter.contrast], -20);
    expect(filters[VideoFilter.saturation], 100);
    expect(filters[VideoFilter.hue], 0);
  });

  test('only the adjusted filters become mpv options', () {
    expect(videoFilterOptions(videoFiltersFrom([0, 15, 0, -5])), {
      'contrast': '15',
      'gamma': '-5',
    });
  });
}

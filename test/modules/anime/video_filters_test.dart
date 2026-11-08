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

  group('software output', () {
    Map<VideoFilter, int> set(VideoFilter filter, int value) => {
      ...videoFiltersFrom(null),
      filter: value,
    };

    /// [matrix] on an rgb colour in 0-255.
    List<double> apply(List<double> matrix, List<double> rgb) => [
      for (var row = 0; row < 3; row++)
        matrix[row * 5] * rgb[0] +
            matrix[row * 5 + 1] * rgb[1] +
            matrix[row * 5 + 2] * rgb[2] +
            matrix[row * 5 + 4],
    ];

    void expectColour(List<double> actual, List<double> expected) {
      for (var i = 0; i < 3; i++) {
        expect(actual[i], closeTo(expected[i], 0.01));
      }
    }

    test('only Android always has mpv\'s renderer', () {
      expect(
        isSoftwareVideoOutput(isAndroid: true, hardwareAcceleration: false),
        isFalse,
      );
      expect(
        isSoftwareVideoOutput(isAndroid: false, hardwareAcceleration: false),
        isTrue,
      );
      expect(
        isSoftwareVideoOutput(isAndroid: false, hardwareAcceleration: true),
        isFalse,
      );
    });

    test('gamma is left out of it, and only of it', () {
      expect(
        availableVideoFilters(softwareOutput: true),
        VideoFilter.values.where((filter) => filter != VideoFilter.gamma),
      );
      expect(availableVideoFilters(softwareOutput: false), VideoFilter.values);
    });

    test('nothing to do without an adjustment it can make', () {
      expect(softwareVideoFilterMatrix(videoFiltersFrom(null)), isNull);
      expect(softwareVideoFilterMatrix(set(VideoFilter.gamma, 50)), isNull);
    });

    test('brightness is an offset', () {
      final matrix = softwareVideoFilterMatrix(
        set(VideoFilter.brightness, 50),
      )!;
      expectColour(apply(matrix, [100, 50, 0]), [227.5, 177.5, 127.5]);
    });

    test('contrast is a gain over black', () {
      final matrix = softwareVideoFilterMatrix(set(VideoFilter.contrast, 100))!;
      expectColour(apply(matrix, [100, 50, 0]), [200, 100, 0]);
      expectColour(apply(matrix, [0, 0, 0]), [0, 0, 0]);
    });

    test('no saturation leaves the colour\'s luma in every channel', () {
      final matrix = softwareVideoFilterMatrix(
        set(VideoFilter.saturation, -100),
      )!;
      final luma = 0.2126 * 200 + 0.7152 * 100 + 0.0722 * 50;
      expectColour(apply(matrix, [200, 100, 50]), [luma, luma, luma]);
    });

    test('hue turns colours and leaves grey alone', () {
      final matrix = softwareVideoFilterMatrix(set(VideoFilter.hue, 100))!;
      expectColour(apply(matrix, [128, 128, 128]), [128, 128, 128]);
      final red = apply(matrix, [200, 0, 0]);
      expect(red[0], lessThan(red[1]));
    });

    test('alpha is left as it is', () {
      final matrix = softwareVideoFilterMatrix(set(VideoFilter.contrast, 50))!;
      expect(matrix.sublist(15), [0, 0, 0, 1, 0]);
    });
  });
}

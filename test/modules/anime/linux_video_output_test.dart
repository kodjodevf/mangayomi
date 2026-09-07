import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/linux_video_output.dart';

void main() {
  test('video output follows the physical viewport', () {
    expect(
      linuxVideoOutputSize(
        logicalWidth: 853,
        logicalHeight: 480,
        devicePixelRatio: 1.25,
      ),
      (width: 1068, height: 600),
    );
  });

  test('video output rounds both dimensions to even pixels', () {
    expect(
      linuxVideoOutputSize(
        logicalWidth: 100,
        logicalHeight: 99,
        devicePixelRatio: 1,
      ),
      (width: 100, height: 100),
    );
  });

  test('video output rejects invalid or unbounded viewports', () {
    expect(
      linuxVideoOutputSize(
        logicalWidth: double.infinity,
        logicalHeight: 480,
        devicePixelRatio: 1,
      ),
      isNull,
    );
    expect(
      linuxVideoOutputSize(
        logicalWidth: 0,
        logicalHeight: 480,
        devicePixelRatio: 1,
      ),
      isNull,
    );
  });
}

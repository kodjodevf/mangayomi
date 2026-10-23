import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/download_manager/download_gate.dart';

void main() {
  test('scheduled downloads notify as they come and go', () {
    final seen = <Set<int>>[];
    void listener() => seen.add(scheduledDownloads.value);
    scheduledDownloads.addListener(listener);
    addTearDown(() => scheduledDownloads.removeListener(listener));

    expect(scheduleDownload(901), isTrue);
    expect(scheduleDownload(901), isFalse);
    expect(scheduleDownload(902), isTrue);
    unscheduleDownload(901);
    unscheduleDownload(901);
    unscheduleDownload(902);

    expect(seen, [
      {901},
      {901, 902},
      {902},
      <int>{},
    ]);
  });
}

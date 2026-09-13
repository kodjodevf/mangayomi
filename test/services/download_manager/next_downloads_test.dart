import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';

void main() {
  List<Chapter> episodes({int watched = 0}) => List.generate(
    25,
    (index) => Chapter(
      id: index + 1,
      mangaId: 1,
      name: 'Episode ${index + 1}',
      isRead: index < watched,
    ),
  );

  Download queued(int id, {bool completed = false, bool failed = false}) =>
      Download(
        id: id,
        succeeded: 0,
        failed: failed ? 1 : 0,
        total: 100,
        isDownload: completed,
        isStartDownload: !failed,
      );

  test('next downloads skip watched entries wherever they appear', () {
    final chapters = List.generate(20, (index) {
      final number = 316 + index;
      return Chapter(
        id: number,
        mangaId: 1,
        name: 'Episode $number',
        isRead: number <= 320 || (number >= 326 && number <= 331),
      );
    });
    expect(
      selectNextDownloads(chapters, count: 10, downloads: []).map((c) => c.id),
      [321, 322, 323, 324, 325, 332, 333, 334, 335],
    );
  });

  test('repeated batches advance past queued and completed entries', () {
    expect(
      selectNextDownloads(
        episodes(watched: 5),
        count: 5,
        downloads: [
          for (var id = 6; id <= 10; id++) queued(id),
          queued(11, completed: true),
        ],
      ).map((chapter) => chapter.id),
      [12, 13, 14, 15, 16],
    );
  });

  test('failed entries can be retried and the series end is bounded', () {
    expect(
      selectNextDownloads(
        episodes(watched: 23),
        count: 25,
        downloads: [queued(24, failed: true)],
      ).map((chapter) => chapter.id),
      [24, 25],
    );
  });
}

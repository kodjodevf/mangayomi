import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/download_manager/next_downloads.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';

/// Starts downloading the chapters after [chapter], as many as the Download
/// ahead setting asks, for a series in the library whose chapter being read
/// is itself downloaded.
void downloadAhead(WidgetRef ref, Chapter chapter) {
  final count = settingsRepository.current.downloadAheadWhileReading ?? 0;
  final manga = chapter.manga.value;
  if (count <= 0 ||
      manga == null ||
      manga.favorite != true ||
      (manga.isLocalArchive ?? false)) {
    return;
  }
  final chapters = selectDownloadAhead(
    manga.getChapterListForReading(),
    chapter,
    count: count,
    downloads: downloadRepository.getAll(),
  );
  for (final next in chapters) {
    final provider = downloadChapterProvider(chapter: next);
    ref.invalidate(provider);
    ref.read(provider);
  }
}

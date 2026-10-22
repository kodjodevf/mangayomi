import 'package:archive/archive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/kotatsu_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore_invalidation.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/restore_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';

/// Service responsible for restoring backups created by Kotatsu.
class KotatsuRestoreService {
  const KotatsuRestoreService._();

  static Future<void> restore(Ref ref, Archive archive) async {
    try {
      final backup = parseKotatsuBackup(archive);
      await restoreRepository.run(() {
        categoryRepository.clearSync();
        mangaRepository.clearSync();

        final categoryIdMap = <int, int>{};
        for (final category in backup.categories) {
          final restoredId = categoryRepository.putSync(
            Category(
              name: category.name,
              forItemType: ItemType.manga,
              pos: category.position,
              hide: category.hidden,
            ),
          );
          final sourceId = category.sourceId;
          if (sourceId != null) categoryIdMap[sourceId] = restoredId;
        }

        for (final favourite in backup.mangas) {
          final tempManga = favourite.manga;
          final manga = Manga(
            source: tempManga["source"],
            author: tempManga["author"],
            artist: null,
            genre:
                (tempManga["tags"] as List?)
                    ?.map((t) => t["title"] as String)
                    .toList() ??
                [],
            imageUrl: tempManga["large_cover_url"],
            lang: 'en',
            link: tempManga["url"],
            name: tempManga["title"],
            status: Status.values.firstWhere(
              (s) =>
                  s.name.toLowerCase() ==
                  (tempManga["state"] as String?)?.toLowerCase(),
              orElse: () => Status.unknown,
            ),
            description: null,
            categories: remapKotatsuCategoryIds(favourite, categoryIdMap),
            itemType: ItemType.manga,
            favorite: true,
            sourceId: null,
          );
          mangaRepository.putSync(manga);
        }
      });
      await restoreRepository.run(() {
        chapterRepository.clearSync();
        downloadRepository.clearSync();
        historyRepository.clearSync();
        updateRepository.clearSync();
        trackRepository.clearSync();
        trackRepository.clearPreferencesSync();
      });
      invalidateCommonRestoreState(ref);
    } catch (e) {
      rethrow;
    }
  }
}

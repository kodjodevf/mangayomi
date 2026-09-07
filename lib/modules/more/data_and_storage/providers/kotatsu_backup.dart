import 'dart:convert';

import 'package:archive/archive.dart';

class KotatsuCategoryRecord {
  const KotatsuCategoryRecord({
    required this.sourceId,
    required this.name,
    required this.position,
    required this.hidden,
  });

  final int? sourceId;
  final String? name;
  final int position;
  final bool hidden;
}

class KotatsuMangaRecord {
  KotatsuMangaRecord({required this.manga});

  final Map<String, dynamic> manga;
  final Set<int> categoryIds = <int>{};
}

class KotatsuBackupData {
  const KotatsuBackupData({required this.categories, required this.mangas});

  final List<KotatsuCategoryRecord> categories;
  final List<KotatsuMangaRecord> mangas;
}

/// Decodes the two Kotatsu sections needed by Mangayomi's library restore.
///
/// Kotatsu stores one favourite row per manga-category relationship. Grouping
/// those rows here prevents a multi-category manga from being imported more
/// than once while retaining every category assignment.
KotatsuBackupData parseKotatsuBackup(Archive archive) {
  final categoryJson = _decodeSection(archive, 'categories');
  final categories = <KotatsuCategoryRecord>[];
  for (var index = 0; index < categoryJson.length; index++) {
    final value = categoryJson[index];
    if (value is! Map) continue;
    final category = Map<String, dynamic>.from(value);
    categories.add(
      KotatsuCategoryRecord(
        // Current Kotatsu backups use category_id. Keep id as a fallback for
        // backups created before that field was made explicit.
        sourceId: _readInt(category['category_id'] ?? category['id']),
        name: category['title'] as String?,
        position: _readInt(category['sort_key']) ?? index,
        hidden: !(category['show_in_lib'] as bool? ?? true),
      ),
    );
  }

  final mangasByKey = <String, KotatsuMangaRecord>{};
  for (final value in _decodeSection(archive, 'favourites')) {
    if (value is! Map) continue;
    final favourite = Map<String, dynamic>.from(value);
    final mangaValue = favourite['manga'];
    if (mangaValue is! Map) continue;
    final manga = Map<String, dynamic>.from(mangaValue);
    final mangaId = _readInt(favourite['manga_id'] ?? manga['id']);
    final key = mangaId != null
        ? 'id:$mangaId'
        : 'source:${manga['source']}\u0000url:${manga['url']}';
    final record = mangasByKey.putIfAbsent(
      key,
      () => KotatsuMangaRecord(manga: manga),
    );
    final categoryId = _readInt(favourite['category_id']);
    if (categoryId != null) record.categoryIds.add(categoryId);
  }

  return KotatsuBackupData(
    categories: categories,
    mangas: mangasByKey.values.toList(),
  );
}

List<int> remapKotatsuCategoryIds(
  KotatsuMangaRecord manga,
  Map<int, int> categoryIdMap,
) => manga.categoryIds.map((id) => categoryIdMap[id]).whereType<int>().toList();

List<dynamic> _decodeSection(Archive archive, String name) {
  for (final file in archive.files) {
    if (file.name != name) continue;
    final decoded = jsonDecode(utf8.decode(file.content as List<int>));
    return decoded is List ? decoded : const [];
  }
  return const [];
}

int? _readInt(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

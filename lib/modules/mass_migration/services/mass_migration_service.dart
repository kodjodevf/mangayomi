import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/services/search.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

Future<void> migrateLibraryItem({
  required WidgetRef ref,
  required Manga oldManga,
  required MManga selectedManga,
  required MManga preview,
  required Source destinationSource,
}) async {
  final migrationSnapshot = _captureMigrationSnapshot(
    ref: ref,
    oldManga: oldManga,
  );
  _rewriteMigratedItemMetadata(
    oldManga: oldManga,
    selectedManga: selectedManga,
    preview: preview,
    destinationSource: destinationSource,
  );
  _syncMigratedMangaFromPreview(
    oldManga: oldManga,
    preview: preview,
    destinationSource: destinationSource,
  );
  _restoreMigrationProgress(oldManga: oldManga, snapshot: migrationSnapshot);
  ref.invalidate(getMangaDetailStreamProvider(mangaId: oldManga.id!));
}

class _MigrationSnapshot {
  const _MigrationSnapshot({
    required this.chaptersProgress,
    this.historyChapter,
    this.historyDate,
  });

  final List<Chapter> chaptersProgress;
  final String? historyChapter;
  final String? historyDate;
}

_MigrationSnapshot _captureMigrationSnapshot({
  required WidgetRef ref,
  required Manga oldManga,
}) {
  String? historyChapter;
  String? historyDate;
  final chaptersProgress = <Chapter>[];

  isar.writeTxnSync(() {
    final histories = isar.historys
        .filter()
        .mangaIdEqualTo(oldManga.id)
        .sortByDate()
        .findAllSync();
    historyChapter = extractMigrationChapterNumber(
      histories.lastOrNull?.chapter.value?.name ?? '',
    );
    historyDate = histories.lastOrNull?.date;
    for (final history in histories) {
      isar.historys.deleteSync(history.id!);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(ActionType.removeHistory, history.id, '{}', false);
    }
    for (final chapter in oldManga.chapters) {
      chaptersProgress.add(chapter);
      isar.updates
          .filter()
          .mangaIdEqualTo(chapter.mangaId)
          .chapterNameEqualTo(chapter.name)
          .deleteAllSync();
      isar.chapters.deleteSync(chapter.id!);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(ActionType.removeChapter, chapter.id, '{}', false);
    }
  });

  return _MigrationSnapshot(
    chaptersProgress: chaptersProgress,
    historyChapter: historyChapter,
    historyDate: historyDate,
  );
}

void _rewriteMigratedItemMetadata({
  required Manga oldManga,
  required MManga selectedManga,
  required MManga preview,
  required Source destinationSource,
}) {
  isar.writeTxnSync(() {
    oldManga.name = selectedManga.name;
    oldManga.link = selectedManga.link;
    oldManga.imageUrl = selectedManga.imageUrl;
    oldManga.lang = destinationSource.lang;
    oldManga.source = destinationSource.name;
    oldManga.sourceId = destinationSource.id;
    oldManga.artist = preview.artist;
    oldManga.author = preview.author;
    oldManga.status = preview.status ?? oldManga.status;
    oldManga.description = preview.description;
    oldManga.genre = preview.genre;
    oldManga.updatedAt = DateTime.now().millisecondsSinceEpoch;
    isar.mangas.putSync(oldManga);
  });
}

void _syncMigratedMangaFromPreview({
  required Manga oldManga,
  required MManga preview,
  required Source destinationSource,
}) {
  final genre =
      preview.genre
          ?.map((entry) => entry.toString().trim())
          .where((entry) => entry.isNotEmpty)
          .toSet()
          .toList() ??
      [];

  final previewImageUrl = _trimmedOrDefault(
    preview.imageUrl,
    oldManga.imageUrl,
  );
  oldManga
    ..imageUrl = previewImageUrl == null
        ? null
        : previewImageUrl.startsWith('http')
        ? previewImageUrl
        : '${destinationSource.baseUrl ?? ''}/${previewImageUrl.getUrlWithoutDomain}'
    ..name = _trimmedOrDefault(preview.name, oldManga.name)
    ..genre = genre.isEmpty ? oldManga.genre ?? [] : genre
    ..author = _trimmedOrDefault(preview.author, oldManga.author) ?? ''
    ..artist = _trimmedOrDefault(preview.artist, oldManga.artist) ?? ''
    ..status = preview.status == Status.unknown
        ? oldManga.status
        : preview.status ?? Status.unknown
    ..description =
        _trimmedOrDefault(preview.description, oldManga.description) ?? ''
    ..link = _trimmedOrDefault(preview.link, oldManga.link)
    ..source = destinationSource.name
    ..lang = destinationSource.lang
    ..itemType = destinationSource.itemType
    ..lastUpdate = DateTime.now().millisecondsSinceEpoch
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;

  isar.writeTxnSync(() {
    final mangaId = isar.mangas.putSync(oldManga);
    final previewChapters = preview.chapters ?? const [];
    final chapters = previewChapters
        .map(
          (previewChapter) => Chapter(
            name: previewChapter.name ?? '',
            url: previewChapter.url?.trim() ?? '',
            dateUpload: previewChapter.dateUpload == null
                ? DateTime.now().millisecondsSinceEpoch.toString()
                : previewChapter.dateUpload.toString(),
            scanlator: previewChapter.scanlator ?? '',
            mangaId: mangaId,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            isFiller: previewChapter.isFiller,
            thumbnailUrl: previewChapter.thumbnailUrl,
            description: previewChapter.description,
            downloadSize: previewChapter.downloadSize,
            duration: previewChapter.duration,
          )..manga.value = oldManga,
        )
        .toList();
    for (final chapter in chapters.reversed) {
      isar.chapters.putSync(chapter);
      chapter.manga.saveSync();
    }
  });
}

void _restoreMigrationProgress({
  required Manga oldManga,
  required _MigrationSnapshot snapshot,
}) {
  isar.writeTxnSync(() {
    for (final oldChapter in snapshot.chaptersProgress) {
      final chapter = isar.chapters
          .filter()
          .mangaIdEqualTo(oldManga.id)
          .nameContains(
            extractMigrationChapterNumber(oldChapter.name ?? '') ?? '.....',
            caseSensitive: false,
          )
          .findFirstSync();
      if (chapter != null) {
        chapter.isBookmarked = oldChapter.isBookmarked;
        chapter.lastPageRead = oldChapter.lastPageRead;
        chapter.isRead = oldChapter.isRead;
        isar.chapters.putSync(chapter);
      }
    }

    final historyChapter = isar.chapters
        .filter()
        .mangaIdEqualTo(oldManga.id)
        .nameContains(snapshot.historyChapter ?? '.....', caseSensitive: false)
        .findFirstSync();
    if (historyChapter != null) {
      isar.historys.putSync(
        History(
          mangaId: oldManga.id,
          date:
              snapshot.historyDate ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          itemType: oldManga.itemType,
          chapterId: historyChapter.id,
        )..chapter.value = historyChapter,
      );
    }
  });
}

Future<MassMigrationSearchResult> findBestMassMigrationMatch({
  required WidgetRef ref,
  required Manga manga,
  required Source destinationSource,
}) async {
  final queries = buildMassMigrationQueries(manga);

  for (final query in queries) {
    final pages = await ref.read(
      searchProvider(
        source: destinationSource,
        page: 1,
        query: query,
        filterList: const [],
      ).future,
    );
    final candidates = pages?.list ?? const <MManga>[];
    if (candidates.isEmpty) continue;
    return MassMigrationSearchResult(
      queries: queries,
      usedQuery: query,
      candidates: candidates,
      selected: _selectBestCandidate(
        manga: manga,
        queries: queries,
        candidates: candidates,
      ),
    );
  }

  return MassMigrationSearchResult(queries: queries, candidates: const []);
}

Future<MassMigrationResolvedItem> resolveMassMigrationItem({
  required WidgetRef ref,
  required Manga manga,
  required Source destinationSource,
}) async {
  try {
    final searchResult = await _resolveSearchResult(
      ref: ref,
      manga: manga,
      destinationSource: destinationSource,
    );
    return await _resolveMatchedPreview(
      ref: ref,
      manga: manga,
      destinationSource: destinationSource,
      searchResult: searchResult,
    );
  } catch (error) {
    return _buildErroredResolvedItem(
      sourceItem: manga,
      errorMessage: error.toString(),
    );
  }
}

Future<MassMigrationSearchResult> _resolveSearchResult({
  required WidgetRef ref,
  required Manga manga,
  required Source destinationSource,
}) {
  return findBestMassMigrationMatch(
    ref: ref,
    manga: manga,
    destinationSource: destinationSource,
  );
}

Future<MassMigrationResolvedItem> _resolveMatchedPreview({
  required WidgetRef ref,
  required Manga manga,
  required Source destinationSource,
  required MassMigrationSearchResult searchResult,
}) async {
  final selectedCandidate = searchResult.selected;
  if (selectedCandidate == null) {
    return MassMigrationResolvedItem(
      sourceItem: manga,
      searchResult: searchResult,
    );
  }

  try {
    final preview = await ref.read(
      getDetailProvider(
        url: selectedCandidate.link!,
        source: destinationSource,
      ).future,
    );
    return MassMigrationResolvedItem(
      sourceItem: manga,
      searchResult: searchResult,
      selectedCandidate: selectedCandidate,
      destinationPreview: preview,
      shouldMigrate: true,
    );
  } catch (error) {
    return MassMigrationResolvedItem(
      sourceItem: manga,
      searchResult: searchResult,
      selectedCandidate: selectedCandidate,
      errorMessage: error.toString(),
    );
  }
}

MassMigrationResolvedItem _buildErroredResolvedItem({
  required Manga sourceItem,
  required String errorMessage,
}) {
  return MassMigrationResolvedItem(
    sourceItem: sourceItem,
    searchResult: MassMigrationSearchResult(
      queries: buildMassMigrationQueries(sourceItem),
      candidates: const [],
    ),
    errorMessage: errorMessage,
  );
}

List<String> buildMassMigrationQueries(Manga manga) {
  final queries = <String>{};

  void addQuery(String? value) {
    final cleaned = value?.trim();
    if (cleaned == null || cleaned.isEmpty) return;
    queries.add(cleaned);
  }

  addQuery(manga.name);
  for (final track
      in isar.tracks.filter().mangaIdEqualTo(manga.id).findAllSync()) {
    addQuery(track.title);
  }

  final name = manga.name?.trim();
  if (name != null && name.isNotEmpty) {
    addQuery(name.split(RegExp(r'\s*[:\-|/]\s*')).first);
    final beforeParenthesis = name.split('(').first.trim();
    if (beforeParenthesis.isNotEmpty && beforeParenthesis != name) {
      addQuery(beforeParenthesis);
    }
    final matches = RegExp(r'\(([^)]+)\)').allMatches(name);
    for (final match in matches) {
      addQuery(match.group(1));
    }
  }

  return queries.toList();
}

String? extractMigrationChapterNumber(String chapterName) {
  return RegExp(
        r'\s*(\d+\.\d+)\s*',
        multiLine: true,
      ).firstMatch(chapterName)?.group(0) ??
      RegExp(r'\s*(\d+)\s*', multiLine: true).firstMatch(chapterName)?.group(0);
}

MManga _selectBestCandidate({
  required Manga manga,
  required List<String> queries,
  required List<MManga> candidates,
}) {
  candidates.sort((left, right) {
    final leftScore = _scoreCandidate(
      manga: manga,
      queries: queries,
      candidate: left,
    );
    final rightScore = _scoreCandidate(
      manga: manga,
      queries: queries,
      candidate: right,
    );
    return rightScore.compareTo(leftScore);
  });
  return candidates.first;
}

double _scoreCandidate({
  required Manga manga,
  required List<String> queries,
  required MManga candidate,
}) {
  final candidateName = _normalizeTitle(candidate.name);
  if (candidateName.isEmpty) return 0;

  var score = 0.0;
  for (final query in queries) {
    final normalizedQuery = _normalizeTitle(query);
    if (normalizedQuery.isEmpty) continue;
    if (normalizedQuery == candidateName) {
      score = score < 100 ? 100 : score;
      continue;
    }
    if (candidateName.contains(normalizedQuery) ||
        normalizedQuery.contains(candidateName)) {
      final ratio = normalizedQuery.length < candidateName.length
          ? normalizedQuery.length / candidateName.length
          : candidateName.length / normalizedQuery.length;
      score = score < (80 * ratio) ? 80 * ratio : score;
    }
    final tokenScore = _tokenOverlapScore(normalizedQuery, candidateName);
    score = score < tokenScore ? tokenScore : score;
  }

  final sourceAuthor = _normalizeTitle(manga.author);
  final sourceArtist = _normalizeTitle(manga.artist);
  final candidateAuthor = _normalizeTitle(candidate.author);
  final candidateArtist = _normalizeTitle(candidate.artist);
  if (sourceAuthor.isNotEmpty &&
      (sourceAuthor == candidateAuthor || sourceAuthor == candidateArtist)) {
    score += 15;
  }
  if (sourceArtist.isNotEmpty &&
      (sourceArtist == candidateArtist || sourceArtist == candidateAuthor)) {
    score += 10;
  }

  return score;
}

double _tokenOverlapScore(String left, String right) {
  final leftTokens = left.split(' ').where((token) => token.isNotEmpty).toSet();
  final rightTokens = right
      .split(' ')
      .where((token) => token.isNotEmpty)
      .toSet();
  if (leftTokens.isEmpty || rightTokens.isEmpty) return 0;
  final overlap = leftTokens.intersection(rightTokens).length;
  return (overlap / leftTokens.union(rightTokens).length) * 70;
}

String _normalizeTitle(String? value) {
  return value
          ?.toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
          .replaceAll(RegExp(r'\b(the|a|an)\b'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim() ??
      '';
}

String? _trimmedOrDefault(String? value, String? defaultValue) {
  if (value?.trim().isNotEmpty ?? false) {
    return value!.trim();
  }
  return defaultValue;
}

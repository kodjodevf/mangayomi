import 'dart:convert';
import 'dart:io';

import 'package:mangayomi/eval/aidoku/aidoku_ext_dart.dart' as aidoku;
import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/eval/model/filter.dart' as m_filter;
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

class AidokuExtensionService implements ExtensionService {
  @override
  late Source source;

  aidoku.Source? _aidokuSource;
  List<aidoku.Filter>? _cachedFilters;
  bool _isInitialized = false;

  AidokuExtensionService(this.source);

  Future<aidoku.Source> _ensureInitialized() async {
    if (_isInitialized && _aidokuSource != null) {
      return _aidokuSource!;
    }

    final code = source.sourceCode ?? '';
    if (code.isNotEmpty) {
      // Check if sourceCode is a file path
      final file = File(code);
      if (file.existsSync()) {
        _aidokuSource = await aidoku.Source.loadFromAix(file);
      } else {
        try {
          // Assume base64 encoded .aix archive bytes
          final bytes = base64Decode(code);
          _aidokuSource = await aidoku.Source.loadFromAixBytes(bytes);
        } catch (_) {
          // If not base64, try to read as utf8 path or string
          _aidokuSource = await aidoku.Source.loadFromAix(File(code));
        }
      }
    } else if (source.sourceCodeUrl != null &&
        source.sourceCodeUrl!.isNotEmpty) {
      final file = File(source.sourceCodeUrl!);
      if (file.existsSync()) {
        _aidokuSource = await aidoku.Source.loadFromAix(file);
      }
    }

    if (_aidokuSource == null) {
      throw StateError(
        'Failed to initialize Aidoku source "${source.name}": No valid .aix binary payload found.',
      );
    }

    _isInitialized = true;
    try {
      _cachedFilters = await _aidokuSource!.getSearchFilters();
    } catch (_) {}
    return _aidokuSource!;
  }

  Future<m_filter.FilterList> fetchFilterList() async {
    await _ensureInitialized();
    return getFilterList();
  }

  @override
  String get sourceBaseUrl =>
      _aidokuSource?.urls.firstOrNull ?? source.baseUrl ?? '';

  @override
  bool get supportsLatest => _aidokuSource?.features.providesListings ?? true;

  @override
  void dispose() {
    _aidokuSource?.dispose();
    _aidokuSource = null;
    _cachedFilters = null;
    _isInitialized = false;
  }

  @override
  Map<String, String> getHeaders() {
    return {
      'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    };
  }

  @override
  Future<MPages> getPopular(int page) async {
    final s = await _ensureInitialized();
    final listings = await s.getListings();
    final popularListing = listings.firstWhere(
      (l) =>
          l.id == 'popular' ||
          l.name.toLowerCase().contains('popular') ||
          l.name.toLowerCase().contains('trending'),
      orElse: () => listings.isNotEmpty
          ? listings.first
          : aidoku.Listing(id: 'popular', name: 'Popular'),
    );

    final res = await s.getMangaList(popularListing, page);
    return _mapMangaPageResult(res);
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final s = await _ensureInitialized();
    final listings = await s.getListings();
    final latestListing = listings.firstWhere(
      (l) =>
          l.id == 'latest' ||
          l.name.toLowerCase().contains('latest') ||
          l.name.toLowerCase().contains('update'),
      orElse: () => listings.isNotEmpty
          ? listings.last
          : aidoku.Listing(id: 'latest', name: 'Latest'),
    );

    final res = await s.getMangaList(latestListing, page);
    return _mapMangaPageResult(res);
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final s = await _ensureInitialized();
    final filterValues = _mapMangayomiFiltersToAidoku(filters);
    final res = await s.getSearchMangaList(query, page, filterValues);
    return _mapMangaPageResult(res);
  }

  @override
  Future<MManga> getDetail(String url) async {
    final s = await _ensureInitialized();
    final manga = aidoku.Manga(
      key: _extractMangaKey(url),
      title: '',
      url: _extractMangaUrl(url),
    );

    final updated = await s.getMangaUpdate(
      manga,
      needsDetails: true,
      needsChapters: true,
    );

    return _mapMangaToMManga(updated, url);
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    final s = await _ensureInitialized();
    final manga = aidoku.Manga(
      key: _extractMangaKey(url),
      title: '',
      url: _extractMangaUrl(url),
    );
    final chapter = aidoku.Chapter(
      key: _extractChapterKey(url),
      url: _extractChapterUrl(url),
    );

    final pages = await s.getPageList(manga, chapter);
    final pageUrls = <PageUrl>[];

    for (final p in pages) {
      final content = p.content;
      if (content is aidoku.PageContentUrl) {
        pageUrls.add(PageUrl(content.url, headers: content.context));
      }
    }

    return pageUrls;
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    return [];
  }

  @override
  Future<String> getHtmlContent(String name, String url) async {
    final s = await _ensureInitialized();
    final manga = aidoku.Manga(
      key: _extractMangaKey(url),
      title: '',
      url: _extractMangaUrl(url),
    );
    final chapter = aidoku.Chapter(
      key: _extractChapterKey(url),
      title: name,
      url: _extractChapterUrl(url),
    );

    final pages = await s.getPageList(manga, chapter);
    final buffer = StringBuffer();

    for (final p in pages) {
      final content = p.content;
      if (content is aidoku.PageContentText) {
        final text = content.text;
        if (text.contains('<p>') ||
            text.contains('<div>') ||
            text.contains('<article>')) {
          buffer.writeln(text);
        } else {
          final lines = text.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              buffer.writeln('<p>$trimmed</p>');
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    return html;
  }

  @override
  m_filter.FilterList getFilterList() {
    List<aidoku.Filter> filters =
        _cachedFilters ?? _aidokuSource?.getSearchFiltersSync() ?? [];
    if (filters.isEmpty &&
        source.filterList != null &&
        source.filterList!.isNotEmpty) {
      try {
        return m_filter.FilterList.fromJson(jsonDecode(source.filterList!));
      } catch (_) {}
    }
    final list = <dynamic>[];

    for (final f in filters) {
      final config = f.config;
      if (config is aidoku.FilterTypeSelect) {
        final defIndex = config.filter.defaultValue is int
            ? config.filter.defaultValue as int
            : int.tryParse(config.filter.defaultValue?.toString() ?? '0') ?? 0;
        list.add(
          m_filter.SelectFilter(
            'SelectFilter',
            f.title ?? f.id,
            defIndex,
            config.filter.options
                .map(
                  (opt) =>
                      m_filter.SelectFilterOption(opt, opt, 'SelectOption'),
                )
                .toList(),
            'SelectFilter',
          ),
        );
      } else if (config is aidoku.FilterTypeCheck) {
        list.add(
          m_filter.CheckBoxFilter(
            'CheckBoxFilter',
            f.title ?? f.id,
            f.id,
            'CheckBoxFilter',
            state: config.defaultValue ?? false,
          ),
        );
      } else if (config is aidoku.FilterTypeSort) {
        list.add(
          m_filter.SortFilter(
            'SortFilter',
            f.title ?? f.id,
            m_filter.SortState(
              config.defaultValue?.index ?? 0,
              config.defaultValue?.ascending ?? false,
              'SortState',
            ),
            config.options
                .map(
                  (opt) =>
                      m_filter.SelectFilterOption(opt, opt, 'SelectOption'),
                )
                .toList(),
            'SortFilter',
          ),
        );
      } else if (config is aidoku.FilterTypeText) {
        list.add(
          m_filter.TextFilter(
            'TextFilter',
            f.title ?? f.id,
            'TextFilter',
            state: '',
          ),
        );
      } else if (config is aidoku.FilterTypeNote) {
        list.add(m_filter.HeaderFilter(config.text, 'HeaderFilter'));
      }
    }

    return m_filter.FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    return [];
  }

  // --- Private Mapping Helpers ---

  MPages _mapMangaPageResult(aidoku.MangaPageResult res) {
    final list = res.entries.map((m) {
      return MManga(
        name: m.title,
        link: '${m.url ?? ''}|${m.key}',
        imageUrl: m.cover,
        author: m.authors?.join(', '),
        artist: m.artists?.join(', '),
        description: m.description,
        genre: m.tags,
        status: _mapStatus(m.status),
      );
    }).toList();

    return MPages(list: list, hasNextPage: res.hasNextPage);
  }

  MManga _mapMangaToMManga(aidoku.Manga m, String fallbackUrl) {
    final mangaKey = m.key.isNotEmpty ? m.key : _extractMangaKey(fallbackUrl);
    final mangaUrl = m.url ?? _extractMangaUrl(fallbackUrl);

    final chapters = m.chapters?.map((c) {
      return MChapter(
        name:
            c.title ??
            (c.chapterNumber != null
                ? 'Chapter ${c.chapterNumber}'
                : 'Chapter'),
        url: '${c.url ?? ''}|${c.key}|$mangaKey|$mangaUrl',
        dateUpload: c.dateUploaded != null
            ? '${c.dateUploaded!.millisecondsSinceEpoch}'
            : null,
        scanlator: c.scanlators?.join(', '),
        thumbnailUrl: c.thumbnail,
      );
    }).toList();

    return MManga(
      name: m.title,
      link: '$mangaUrl|$mangaKey',
      imageUrl: m.cover,
      author: m.authors?.join(', '),
      artist: m.artists?.join(', '),
      description: m.description,
      genre: m.tags,
      status: _mapStatus(m.status),
      chapters: chapters,
    );
  }

  Status _mapStatus(aidoku.PublishingStatus status) {
    return switch (status) {
      aidoku.PublishingStatus.ongoing => Status.ongoing,
      aidoku.PublishingStatus.completed => Status.completed,
      aidoku.PublishingStatus.hiatus => Status.onHiatus,
      aidoku.PublishingStatus.cancelled => Status.canceled,
      _ => Status.unknown,
    };
  }

  List<aidoku.FilterValue> _mapMangayomiFiltersToAidoku(List<dynamic> filters) {
    final result = <aidoku.FilterValue>[];
    for (final f in filters) {
      if (f is m_filter.SelectFilter) {
        final val = f.state >= 0 && f.state < f.values.length
            ? (f.values[f.state] is m_filter.SelectFilterOption
                  ? (f.values[f.state] as m_filter.SelectFilterOption).value
                  : f.values[f.state].toString())
            : f.state.toString();
        result.add(aidoku.FilterValueSelect(id: f.name, value: val));
      } else if (f is m_filter.CheckBoxFilter) {
        result.add(aidoku.FilterValueCheck(id: f.name, value: f.state ? 1 : 0));
      } else if (f is m_filter.SortFilter) {
        result.add(
          aidoku.FilterValueSort(
            aidoku.SortFilterValue(
              id: f.name,
              index: f.state.index,
              ascending: f.state.ascending,
            ),
          ),
        );
      } else if (f is m_filter.TextFilter) {
        result.add(aidoku.FilterValueText(id: f.name, value: f.state));
      }
    }
    return result;
  }

  String _extractMangaKey(String url) {
    if (url.contains('|')) {
      final parts = url.split('|');
      if (parts.length >= 3 && parts[2].isNotEmpty) return parts[2];
      if (parts.length >= 2 && parts[1].isNotEmpty) return parts[1];
    }
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    return url;
  }

  String _extractMangaUrl(String url) {
    if (url.contains('|')) {
      final parts = url.split('|');
      if (parts.length >= 4 && parts[3].startsWith('http')) return parts[3];
      if (parts.isNotEmpty && parts[0].startsWith('http')) return parts[0];
    }
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return '${uri.scheme}://${uri.host}/${uri.pathSegments.first}';
    }
    return url;
  }

  String _extractChapterKey(String url) {
    if (url.contains('|')) {
      final parts = url.split('|');
      if (parts.length >= 2 && parts[1].isNotEmpty) return parts[1];
    }
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.length > 1) {
      return uri.pathSegments.last;
    }
    return url;
  }

  String _extractChapterUrl(String url) {
    if (url.contains('|')) {
      final parts = url.split('|');
      if (parts.isNotEmpty && parts[0].startsWith('http')) return parts[0];
    }
    return url;
  }
}

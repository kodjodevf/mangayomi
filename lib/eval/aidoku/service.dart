import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
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
import 'package:mangayomi/repositories/source_preference_repository.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/src/rust/api/aidoku_wasm.dart' as rust;

class AidokuExtensionService implements ExtensionService {
  @override
  late Source source;

  aidoku.Source? _aidokuSource;
  List<aidoku.Filter>? _cachedFilters;
  bool _isInitialized = false;

  AidokuExtensionService(this.source);

  Future<rust.AidokuNetResponse> _handleRustHttpRequest(
    rust.AidokuNetRequest req,
  ) async {
    try {
      aidoku.AidokuLogger.log(
        'AidokuService:HTTP',
        'Request: ${req.method} ${req.url} (headers: ${req.headers.length}, body: ${req.body?.length})',
      );
      http.Client client;
      try {
        client = MClient.init(source: source.toMSource());
      } catch (_) {
        client = http.Client();
      }
      final uri = Uri.parse(req.url);
      final request = http.Request(req.method.toUpperCase(), uri);
      for (final (k, v) in req.headers) {
        request.headers[k] = v;
      }
      if (req.body != null && req.body!.isNotEmpty) {
        request.bodyBytes = req.body!;
      }
      final timeout = req.timeoutMs > BigInt.zero
          ? Duration(milliseconds: req.timeoutMs.toInt())
          : const Duration(seconds: 60);
      final streamed = await client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      aidoku.AidokuLogger.log(
        'AidokuService:HTTP',
        'Response: ${response.statusCode} (${response.bodyBytes.length} bytes) for ${req.url}',
      );
      final headers = response.headers.entries
          .map((e) => (e.key, e.value))
          .toList();
      return rust.AidokuNetResponse(
        statusCode: response.statusCode,
        headers: headers,
        body: response.bodyBytes,
        error: null,
      );
    } catch (e, st) {
      aidoku.AidokuLogger.error(
        'AidokuService:HTTP',
        'Error fetching ${req.url}: $e',
        e,
        st,
      );
      return rust.AidokuNetResponse(
        statusCode: 0,
        headers: const [],
        body: Uint8List(0),
        error: e.toString(),
      );
    }
  }

  Future<aidoku.AidokuRunner> _runnerFactory(
    Uint8List wasmBytes,
    String sourceKey,
  ) async {
    return await aidoku.AidokuRustRunner.create(
      bytes: wasmBytes,
      sourceKey: sourceKey,
      requestHandler: _handleRustHttpRequest,
    );
  }

  Future<aidoku.Source> _ensureInitialized() async {
    if (_isInitialized && _aidokuSource != null) {
      return _aidokuSource!;
    }

    final code = source.sourceCode ?? '';
    if (code.isNotEmpty) {
      // Check if sourceCode is a file path
      final file = File(code);
      if (file.existsSync()) {
        _aidokuSource = await aidoku.Source.loadFromAix(
          file,
          runnerFactory: _runnerFactory,
          defaultLanguage: source.lang,
        );
      } else {
        try {
          // Assume base64 encoded .aix archive bytes
          final bytes = base64Decode(code);
          _aidokuSource = await aidoku.Source.loadFromAixBytes(
            bytes,
            runnerFactory: _runnerFactory,
            defaultLanguage: source.lang,
          );
        } catch (_) {
          // If not base64, try to read as utf8 path or string
          _aidokuSource = await aidoku.Source.loadFromAix(
            File(code),
            runnerFactory: _runnerFactory,
            defaultLanguage: source.lang,
          );
        }
      }
    } else if (source.sourceCodeUrl != null &&
        source.sourceCodeUrl!.isNotEmpty) {
      final file = File(source.sourceCodeUrl!);
      if (file.existsSync()) {
        _aidokuSource = await aidoku.Source.loadFromAix(
          file,
          runnerFactory: _runnerFactory,
          defaultLanguage: source.lang,
        );
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

    // Restore any user-saved preferences from database into SettingsStore and Rust engine
    try {
      final savedPrefs = sourcePreferenceRepository.getAllForSource(source.id);
      for (final pref in savedPrefs) {
        if (pref.key == null || pref.key!.isEmpty) continue;
        final key = pref.key!;
        dynamic val;
        if (pref.listPreference != null) {
          final p = pref.listPreference!;
          val =
              (p.entryValues != null &&
                  p.valueIndex != null &&
                  p.valueIndex! < p.entryValues!.length)
              ? p.entryValues![p.valueIndex!]
              : p.valueIndex;
        } else if (pref.checkBoxPreference != null) {
          val = pref.checkBoxPreference!.value;
        } else if (pref.switchPreferenceCompat != null) {
          val = pref.switchPreferenceCompat!.value;
        } else if (pref.multiSelectListPreference != null) {
          val = pref.multiSelectListPreference!.values;
        } else if (pref.editTextPreference != null) {
          val = pref.editTextPreference!.value;
        }
        if (val != null) {
          aidoku.SettingsStore.shared.setValue(
            '${_aidokuSource!.key}.$key',
            val,
          );
          aidoku.SettingsStore.shared.setValue(key, val);
        }
      }
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
    final headers = <String, String>{};

    final key = _aidokuSource?.key;
    final activeUrl = key != null
        ? (aidoku.SettingsStore.shared.object('$key.url') ??
                aidoku.SettingsStore.shared.object('url'))
            ?.toString()
        : aidoku.SettingsStore.shared.object('url')?.toString();
    final baseUrl = (activeUrl != null && activeUrl.isNotEmpty)
        ? activeUrl
        : (sourceBaseUrl.isNotEmpty ? sourceBaseUrl : (source.baseUrl ?? ''));

    if (baseUrl.isNotEmpty) {
      headers['Referer'] = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
      try {
        final uri = Uri.parse(baseUrl);
        if (uri.hasScheme && uri.hasAuthority) {
          headers['Origin'] = '${uri.scheme}://${uri.host}';
        }
      } catch (_) {}
    }

    headers['User-Agent'] =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
    headers['Accept'] =
        'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8';

    if (source.headers != null && source.headers!.isNotEmpty) {
      try {
        final decoded = jsonDecode(source.headers!);
        if (decoded is Map) {
          decoded.forEach((k, v) {
            if (k != null && v != null) {
              headers[k.toString()] = v.toString();
            }
          });
        }
      } catch (_) {}
    }

    return headers;
  }

  @override
  Future<MPages> getPopular(int page) async {
    final s = await _ensureInitialized();
    final listings = await s.getListings();
    if (s.features.providesListings && listings.isNotEmpty) {
      final popularListing = listings.firstWhere(
        (l) =>
            l.id == 'popular' ||
            l.name.toLowerCase().contains('popular') ||
            l.name.toLowerCase().contains('trending'),
        orElse: () => listings.first,
      );
      final res = await s.getMangaList(popularListing, page);
      return _mapMangaPageResult(res);
    } else {
      final res = await s.getSearchMangaList(null, page, []);
      return _mapMangaPageResult(res);
    }
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final s = await _ensureInitialized();
    final listings = await s.getListings();
    if (s.features.providesListings && listings.isNotEmpty) {
      final latestListing = listings.firstWhere(
        (l) =>
            l.id == 'latest' ||
            l.name.toLowerCase().contains('latest') ||
            l.name.toLowerCase().contains('update'),
        orElse: () => listings.last,
      );
      final res = await s.getMangaList(latestListing, page);
      return _mapMangaPageResult(res);
    } else {
      final res = await s.getSearchMangaList(null, page, []);
      return _mapMangaPageResult(res);
    }
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
    final defaultHeaders = getHeaders();

    final pageUrls = await Future.wait(
      pages.map((p) async {
        final content = p.content;
        if (content is aidoku.PageContentUrl) {
          String finalUrl = content.url;
          final pageHeaders = Map<String, String>.from(defaultHeaders);
          if (content.context != null) {
            pageHeaders.addAll(content.context!);
          }
          if (s.features.providesImageRequests) {
            try {
              final imgReq = await s.getImageRequest(
                content.url,
                context: content.context,
              );
              if (imgReq != null) {
                if (imgReq.url.isNotEmpty) finalUrl = imgReq.url;
                pageHeaders.addAll(imgReq.headers);
              }
            } catch (_) {}
          }
          return PageUrl(finalUrl, headers: pageHeaders);
        }
        return null;
      }),
    );

    return pageUrls.whereType<PageUrl>().toList();
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
    if (filters.isEmpty) {
      final code = source.sourceCode ?? '';
      if (code.isNotEmpty) {
        try {
          List<int>? bytes;
          final file = File(code);
          if (file.existsSync()) {
            bytes = file.readAsBytesSync();
          } else {
            bytes = base64Decode(code);
          }
          final archive = ZipDecoder().decodeBytes(bytes);
          for (final f in archive.files) {
            if (f.name == 'filters.json' || f.name.endsWith('/filters.json')) {
              final content = utf8.decode(f.content as List<int>);
              final parsed = jsonDecode(content);
              if (parsed is List) {
                filters = parsed
                    .map(
                      (e) => aidoku.Filter.fromJson(e as Map<String, dynamic>),
                    )
                    .toList();
                _cachedFilters = filters;
                break;
              }
            }
          }
        } catch (_) {}
      }
    }
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
      final filterId = f.id;
      final filterTitle = f.title?.isNotEmpty == true ? f.title! : filterId;

      if (config is aidoku.FilterTypeSelect) {
        final options = config.filter.options;
        final ids = config.filter.ids;
        final defVal = config.filter.defaultValue;
        int defIndex = 0;
        if (defVal != null) {
          if (ids != null && ids.contains(defVal)) {
            defIndex = ids.indexOf(defVal);
          } else if (options.contains(defVal)) {
            defIndex = options.indexOf(defVal);
          } else if (int.tryParse(defVal) != null) {
            defIndex = int.parse(defVal);
          }
        }
        final optionItems = <m_filter.SelectFilterOption>[];
        for (int i = 0; i < options.length; i++) {
          final optName = options[i];
          final optVal = (ids != null && i < ids.length) ? ids[i] : optName;
          optionItems.add(
            m_filter.SelectFilterOption(optName, optVal, 'SelectOption'),
          );
        }
        list.add(
          m_filter.SelectFilter(
            filterId,
            filterTitle,
            defIndex.clamp(
              0,
              optionItems.isNotEmpty ? optionItems.length - 1 : 0,
            ),
            optionItems,
            'SelectFilter',
          ),
        );
      } else if (config is aidoku.FilterTypeMultiSelect) {
        final options = config.filter.options;
        final ids = config.filter.ids;
        final defaultIncluded = config.filter.defaultIncluded ?? [];
        final defaultExcluded = config.filter.defaultExcluded ?? [];
        final canExclude = config.filter.canExclude;

        final groupItems = <dynamic>[];
        for (int i = 0; i < options.length; i++) {
          final optName = options[i];
          final optVal = (ids != null && i < ids.length) ? ids[i] : optName;
          if (canExclude) {
            int state = 0;
            if (defaultIncluded.contains(optVal) ||
                defaultIncluded.contains(optName)) {
              state = 1;
            } else if (defaultExcluded.contains(optVal) ||
                defaultExcluded.contains(optName)) {
              state = 2;
            }
            groupItems.add(
              m_filter.TriStateFilter(
                filterId,
                optName,
                optVal,
                'TriState',
                state: state,
              ),
            );
          } else {
            final isChecked =
                defaultIncluded.contains(optVal) ||
                defaultIncluded.contains(optName);
            groupItems.add(
              m_filter.CheckBoxFilter(
                filterId,
                optName,
                optVal,
                'CheckBox',
                state: isChecked,
              ),
            );
          }
        }
        list.add(
          m_filter.GroupFilter(
            filterId,
            filterTitle,
            groupItems,
            'GroupFilter',
          ),
        );
      } else if (config is aidoku.FilterTypeCheck) {
        final canExclude = config.canExclude;
        if (canExclude) {
          list.add(
            m_filter.TriStateFilter(
              filterId,
              filterTitle,
              filterId,
              'TriState',
              state: config.defaultValue == true ? 1 : 0,
            ),
          );
        } else {
          list.add(
            m_filter.CheckBoxFilter(
              filterId,
              filterTitle,
              filterId,
              'CheckBoxFilter',
              state: config.defaultValue ?? false,
            ),
          );
        }
      } else if (config is aidoku.FilterTypeSort) {
        final options = config.options;
        final optionItems = options
            .map((opt) => m_filter.SelectFilterOption(opt, opt, 'SelectOption'))
            .toList();
        list.add(
          m_filter.SortFilter(
            filterId,
            filterTitle,
            m_filter.SortState(
              config.defaultValue?.index ?? 0,
              config.defaultValue?.ascending ?? false,
              'SortState',
            ),
            optionItems,
            'SortFilter',
          ),
        );
      } else if (config is aidoku.FilterTypeText) {
        list.add(
          m_filter.TextFilter(filterId, filterTitle, 'TextFilter', state: ''),
        );
      } else if (config is aidoku.FilterTypeNote) {
        list.add(
          m_filter.HeaderFilter(config.text, 'HeaderFilter', type: filterId),
        );
      }
    }

    return m_filter.FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    var s = _aidokuSource;
    List<aidoku.Setting> settings = s?.getSettingsSync() ?? [];
    String sourceKey = s?.key ?? '';

    if (settings.isEmpty) {
      final code = source.sourceCode ?? '';
      if (code.isNotEmpty) {
        try {
          List<int>? bytes;
          final file = File(code);
          if (file.existsSync()) {
            bytes = file.readAsBytesSync();
          } else {
            bytes = base64Decode(code);
          }
          final archive = ZipDecoder().decodeBytes(bytes);
          ArchiveFile? findFile(String name) {
            for (final f in archive.files) {
              if (f.name == name || f.name.endsWith('/$name')) return f;
            }
            return null;
          }

          aidoku.SourceInfo? sourceInfo;
          List<aidoku.Setting> staticSettings = [];
          final sourceJsonFile = findFile('source.json');
          if (sourceJsonFile != null) {
            final content = utf8.decode(sourceJsonFile.content as List<int>);
            sourceInfo = aidoku.SourceInfo.fromJson(
              jsonDecode(content) as Map<String, dynamic>,
            );
          }
          final settingsFile = findFile('settings.json');
          if (settingsFile != null) {
            final content = utf8.decode(settingsFile.content as List<int>);
            final parsed = jsonDecode(content);
            if (parsed is List) {
              staticSettings = parsed
                  .map(
                    (e) => aidoku.Setting.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
            }
          }
          if (sourceInfo != null) {
            sourceKey = sourceInfo.info.id;
            final allUrls = <String>[];
            if (sourceInfo.info.url != null) allUrls.add(sourceInfo.info.url!);
            if (sourceInfo.info.urls != null) {
              allUrls.addAll(sourceInfo.info.urls!);
            }
            settings = aidoku.Source.initSettings(
              sourceInfo.config,
              sourceInfo.info.languages,
              allUrls,
              staticSettings,
              sourceKey,
              defaultLanguage: source.lang,
            );
          }
        } catch (_) {}
      }
    }

    if (settings.isEmpty) {
      return [];
    }

    final preferences = <SourcePreference>[];

    void processSetting(aidoku.Setting setting, {String? groupTitle}) {
      final key = setting.key;
      final title = setting.title.isNotEmpty ? setting.title : key;
      final val = setting.value;

      if (val is aidoku.GroupSetting) {
        for (final item in val.items) {
          processSetting(
            item,
            groupTitle: setting.title.isNotEmpty ? setting.title : groupTitle,
          );
        }
        return;
      }

      if (val is aidoku.PageSetting) {
        for (final item in val.items) {
          processSetting(
            item,
            groupTitle: setting.title.isNotEmpty ? setting.title : groupTitle,
          );
        }
        return;
      }

      if (key.isEmpty) return;

      final currentVal =
          aidoku.SettingsStore.shared.object('$sourceKey.$key') ??
          aidoku.SettingsStore.shared.object(key);

      if (val is aidoku.ToggleSetting) {
        final bool isChecked = currentVal is bool
            ? currentVal
            : (currentVal?.toString().toLowerCase() == 'true' ||
                  val.defaultValue);
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            switchPreferenceCompat: SwitchPreferenceCompat(
              title: title,
              summary: val.subtitle ?? groupTitle,
              value: isChecked,
            ),
          ),
        );
      } else if (val is aidoku.SelectSetting) {
        final entries = val.titles ?? val.values;
        final entryValues = val.values;
        final selectedVal =
            currentVal?.toString() ??
            val.defaultValue ??
            (entryValues.isNotEmpty ? entryValues.first : '');
        var idx = entryValues.indexOf(selectedVal);
        if (idx < 0) idx = 0;
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            listPreference: ListPreference(
              title: title,
              summary: groupTitle,
              entries: entries,
              entryValues: entryValues,
              valueIndex: idx,
            ),
          ),
        );
      } else if (val is aidoku.MultiSelectSetting) {
        final entries = val.titles ?? val.values;
        final entryValues = val.values;
        List<String> selectedValues;
        if (currentVal is List) {
          selectedValues = currentVal.map((e) => e.toString()).toList();
        } else if (currentVal is String && currentVal.isNotEmpty) {
          selectedValues = currentVal
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        } else {
          selectedValues = val.defaultValue ?? entryValues;
        }
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            multiSelectListPreference: MultiSelectListPreference(
              title: title,
              summary: groupTitle,
              entries: entries,
              entryValues: entryValues,
              values: selectedValues,
            ),
          ),
        );
      } else if (val is aidoku.SegmentSetting) {
        final entries = val.options;
        final entryValues = List.generate(entries.length, (i) => i.toString());
        final selectedIdx = currentVal is int
            ? currentVal
            : (int.tryParse(currentVal?.toString() ?? '') ??
                  val.defaultValue ??
                  0);
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            listPreference: ListPreference(
              title: title,
              summary: groupTitle,
              entries: entries,
              entryValues: entryValues,
              valueIndex: selectedIdx.clamp(
                0,
                entries.isNotEmpty ? entries.length - 1 : 0,
              ),
            ),
          ),
        );
      } else if (val is aidoku.TextSetting) {
        final textVal = currentVal?.toString() ?? val.defaultValue ?? '';
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            editTextPreference: EditTextPreference(
              title: title,
              summary: val.placeholder ?? groupTitle,
              value: textVal,
              dialogTitle: title,
            ),
          ),
        );
      } else if (val is aidoku.EditableListSetting) {
        List<String> currentList;
        if (currentVal is List) {
          currentList = currentVal.map((e) => e.toString()).toList();
        } else if (currentVal is String && currentVal.isNotEmpty) {
          currentList = currentVal
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        } else {
          currentList = val.defaultValue ?? [];
        }
        preferences.add(
          SourcePreference(
            key: key,
            sourceId: source.id,
            multiSelectListPreference: MultiSelectListPreference(
              title: title,
              summary: val.placeholder ?? groupTitle,
              entries: currentList,
              entryValues: currentList,
              values: currentList,
            ),
          ),
        );
      }
    }

    for (final setting in settings) {
      processSetting(setting);
    }

    return preferences;
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

  String _resolveFilterId(dynamic f) {
    final type = f.type as String?;
    final name = (f.name as String?) ?? '';
    const ignoredTypes = {
      'TextFilter',
      'SelectFilter',
      'GroupFilter',
      'CheckBox',
      'CheckBoxFilter',
      'TriState',
      'SortFilter',
      'HeaderFilter',
      'SeparatorFilter',
      'SelectOption',
    };
    if (type != null && type.isNotEmpty && !ignoredTypes.contains(type)) {
      return type;
    }
    final cached = _cachedFilters ?? _aidokuSource?.getSearchFiltersSync();
    if (cached != null) {
      for (final cf in cached) {
        if (cf.title == name ||
            cf.id == name ||
            cf.title?.toLowerCase() == name.toLowerCase() ||
            cf.id.toLowerCase() == name.toLowerCase()) {
          return cf.id;
        }
      }
    }
    final lower = name.toLowerCase();
    if (lower == 'author/artist' || lower == 'author') return 'author';
    if (lower == 'artist') return 'artist';
    if (lower == 'sort') return 'sort';
    return lower;
  }

  List<aidoku.FilterValue> _mapMangayomiFiltersToAidoku(List<dynamic> filters) {
    final result = <aidoku.FilterValue>[];
    for (final f in filters) {
      if (f is m_filter.SelectFilter) {
        final filterId = _resolveFilterId(f);
        String val = '';
        if (f.state >= 0 && f.state < f.values.length) {
          final opt = f.values[f.state];
          if (opt is m_filter.SelectFilterOption) {
            val = opt.value;
          } else if (opt is Map) {
            val = opt['value']?.toString() ?? opt['name']?.toString() ?? '';
          } else {
            val = opt.toString();
          }
        }
        if (val.isNotEmpty) {
          result.add(aidoku.FilterValueSelect(id: filterId, value: val));
        }
      } else if (f is m_filter.GroupFilter) {
        final filterId = _resolveFilterId(f);
        final included = <String>[];
        final excluded = <String>[];
        for (final item in f.state) {
          if (item is m_filter.TriStateFilter) {
            if (item.state == 1) {
              included.add(item.value);
            } else if (item.state == 2) {
              excluded.add(item.value);
            }
          } else if (item is m_filter.CheckBoxFilter) {
            if (item.state == true) {
              included.add(item.value);
            }
          } else if (item is Map) {
            final typeName = item['type_name'];
            final state = item['state'];
            final value = item['value']?.toString() ?? '';
            if (typeName == 'TriState') {
              if (state == 1) included.add(value);
              if (state == 2) excluded.add(value);
            } else if (typeName == 'CheckBox' && state == true) {
              included.add(value);
            }
          }
        }
        if (included.isNotEmpty || excluded.isNotEmpty) {
          result.add(
            aidoku.FilterValueMultiSelect(
              id: filterId,
              included: included,
              excluded: excluded,
            ),
          );
        }
      } else if (f is m_filter.CheckBoxFilter) {
        final filterId = _resolveFilterId(f);
        result.add(
          aidoku.FilterValueCheck(id: filterId, value: f.state ? 1 : 0),
        );
      } else if (f is m_filter.TriStateFilter) {
        final filterId = _resolveFilterId(f);
        if (f.state != 0) {
          result.add(
            aidoku.FilterValueCheck(id: filterId, value: f.state == 1 ? 1 : -1),
          );
        }
      } else if (f is m_filter.SortFilter) {
        final filterId = _resolveFilterId(f);
        result.add(
          aidoku.FilterValueSort(
            aidoku.SortFilterValue(
              id: filterId,
              index: f.state.index,
              ascending: f.state.ascending,
            ),
          ),
        );
      } else if (f is m_filter.TextFilter) {
        final filterId = _resolveFilterId(f);
        if (f.state.trim().isNotEmpty) {
          result.add(
            aidoku.FilterValueText(id: filterId, value: f.state.trim()),
          );
        }
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
      final titleIdx = uri.pathSegments.indexOf('title');
      if (titleIdx != -1 && titleIdx + 1 < uri.pathSegments.length) {
        return uri.pathSegments[titleIdx + 1];
      }
      final mangaIdx = uri.pathSegments.indexOf('manga');
      if (mangaIdx != -1 && mangaIdx + 1 < uri.pathSegments.length) {
        return uri.pathSegments[mangaIdx + 1];
      }
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
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final chapterIdx = uri.pathSegments.indexOf('chapter');
      if (chapterIdx != -1 && chapterIdx + 1 < uri.pathSegments.length) {
        return uri.pathSegments[chapterIdx + 1];
      }
      final segments = uri.pathSegments
          .where((s) => s.isNotEmpty && s != 'index.html')
          .toList();
      if (segments.isNotEmpty) {
        if (segments.length > 1 && int.tryParse(segments.last) != null) {
          return segments[segments.length - 2];
        }
        return segments.last;
      }
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

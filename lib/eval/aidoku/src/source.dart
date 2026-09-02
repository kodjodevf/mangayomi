import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'interpreter/runner.dart';
import 'models/chapter.dart';
import 'models/deep_link.dart';
import 'models/filter.dart';
import 'models/filter_value.dart';
import 'models/home.dart';
import 'models/listing.dart';
import 'models/manga.dart';
import 'models/page.dart';
import 'models/response.dart';
import 'models/setting.dart';
import 'models/source_features.dart';
import 'models/source_info.dart';
import 'store/settings_store.dart';
import 'util/logger.dart';

/// High-level representation of an Aidoku source extension.
class Source {
  Source({
    required this.key,
    required this.name,
    required this.version,
    this.languages = const [],
    this.urls = const [],
    this.contentRating = SourceContentRating.safe,
    this.config,
    this.staticListings = const [],
    this.staticFilters = const [],
    List<Setting> staticSettings = const [],
    String? defaultLanguage,
    required this.runner,
  }) : staticSettings = initSettings(
         config,
         languages,
         urls,
         staticSettings,
         key,
         defaultLanguage: defaultLanguage,
       );

  final String key;
  final String name;
  final int version;
  final List<String> languages;
  final List<String> urls;
  final SourceContentRating contentRating;
  final SourceConfiguration? config;
  final List<Listing> staticListings;
  final List<Filter> staticFilters;
  final List<Setting> staticSettings;
  AidokuRunner runner;

  String get id => key;
  String get apiVersion => '0.7';
  SourceFeatures get features => runner.features;

  /// Loads a source directly from an `.aix` file.
  static Future<Source> loadFromAix(
    File aixFile, {
    required Future<AidokuRunner> Function(
      Uint8List wasmBytes,
      String sourceKey,
    )
    runnerFactory,
    String? defaultLanguage,
  }) async {
    AidokuLogger.log(
      'Source',
      'loadFromAix: reading file ${aixFile.path} (exists: ${aixFile.existsSync()})',
    );
    final bytes = await aixFile.readAsBytes();
    AidokuLogger.debug(
      'Source',
      'loadFromAix: read ${bytes.length} bytes from ${aixFile.path}',
    );
    return await loadFromAixBytes(
      bytes,
      runnerFactory: runnerFactory,
      defaultLanguage: defaultLanguage,
    );
  }

  /// Loads a source from raw `.aix` (zip) bytes in memory.
  static Future<Source> loadFromAixBytes(
    Uint8List aixBytes, {
    required Future<AidokuRunner> Function(
      Uint8List wasmBytes,
      String sourceKey,
    )
    runnerFactory,
    String? defaultLanguage,
  }) async {
    AidokuLogger.log(
      'Source',
      'loadFromAixBytes: decoding archive (${aixBytes.length} bytes)...',
    );
    final archive = ZipDecoder().decodeBytes(aixBytes);
    AidokuLogger.debug(
      'Source',
      'loadFromAixBytes: archive contains ${archive.files.length} files',
    );

    ArchiveFile? findFile(String name) {
      for (final file in archive.files) {
        final filename = file.name.replaceAll('\\', '/');
        if (filename == name ||
            filename == 'Payload/$name' ||
            filename.endsWith('/$name')) {
          return file;
        }
      }
      return null;
    }

    final sourceJsonFile = findFile('source.json');
    if (sourceJsonFile == null) {
      AidokuLogger.error(
        'Source',
        'loadFromAixBytes: source.json not found in archive',
      );
      throw const FormatException(
        'Invalid .aix archive: source.json not found',
      );
    }
    final sourceJsonStr = utf8.decode(sourceJsonFile.content as List<int>);
    final sourceJson = jsonDecode(sourceJsonStr) as Map<String, dynamic>;
    final sourceInfo = SourceInfo.fromJson(sourceJson);
    AidokuLogger.log(
      'Source',
      'loadFromAixBytes: loaded metadata for "${sourceInfo.info.name}" (id: ${sourceInfo.info.id}, v${sourceInfo.info.version})',
    );

    final wasmFile = findFile('main.wasm');
    if (wasmFile == null) {
      AidokuLogger.error(
        'Source',
        'loadFromAixBytes: main.wasm not found in archive',
      );
      throw const FormatException('Invalid .aix archive: main.wasm not found');
    }
    final wasmBytes = Uint8List.fromList(wasmFile.content as List<int>);
    AidokuLogger.debug(
      'Source',
      'loadFromAixBytes: found main.wasm (${wasmBytes.length} bytes)',
    );

    final runner = await runnerFactory(wasmBytes, sourceInfo.info.id);

    // Load static filters
    final filtersFile = findFile('filters.json');
    List<Filter> staticFilters = [];
    if (filtersFile != null) {
      try {
        final filtersJsonStr = utf8.decode(filtersFile.content as List<int>);
        final filtersJson = jsonDecode(filtersJsonStr);
        if (filtersJson is List) {
          staticFilters = filtersJson
              .map((e) => Filter.fromJson(e as Map<String, dynamic>))
              .toList();
          AidokuLogger.debug(
            'Source',
            'loadFromAixBytes: loaded ${staticFilters.length} static filters from filters.json',
          );
        }
      } catch (e, st) {
        AidokuLogger.error(
          'Source',
          'loadFromAixBytes: error decoding filters.json',
          e,
          st,
        );
      }
    }

    // Load static settings
    final settingsFile = findFile('settings.json');
    List<Setting> staticSettings = [];
    if (settingsFile != null) {
      try {
        final settingsJsonStr = utf8.decode(settingsFile.content as List<int>);
        final settingsJson = jsonDecode(settingsJsonStr);
        if (settingsJson is List) {
          staticSettings = settingsJson
              .map((e) => Setting.fromJson(e as Map<String, dynamic>))
              .toList();
          AidokuLogger.debug(
            'Source',
            'loadFromAixBytes: loaded ${staticSettings.length} static settings from settings.json',
          );
        }
      } catch (e, st) {
        AidokuLogger.error(
          'Source',
          'loadFromAixBytes: error decoding settings.json',
          e,
          st,
        );
      }
    }

    final allUrls = <String>[];
    if (sourceInfo.info.url != null) allUrls.add(sourceInfo.info.url!);
    if (sourceInfo.info.urls != null) allUrls.addAll(sourceInfo.info.urls!);

    AidokuLogger.log(
      'Source',
      'loadFromAixBytes: completed loading source "${sourceInfo.info.name}" (${sourceInfo.info.id})',
    );
    return Source(
      key: sourceInfo.info.id,
      name: sourceInfo.info.name,
      version: sourceInfo.info.version,
      languages: sourceInfo.info.languages,
      urls: allUrls,
      contentRating: sourceInfo.info.contentRating ?? SourceContentRating.safe,
      config: sourceInfo.config,
      staticListings: sourceInfo.listings ?? [],
      staticFilters: staticFilters,
      staticSettings: staticSettings,
      defaultLanguage: defaultLanguage,
      runner: runner,
    );
  }

  /// Loads a source from an extension folder containing `source.json` and `main.wasm`.
  static Future<Source> loadFromDirectory(
    Directory directory, {
    required Future<AidokuRunner> Function(
      Uint8List wasmBytes,
      String sourceKey,
    )
    runnerFactory,
    String? defaultLanguage,
  }) async {
    AidokuLogger.log(
      'Source',
      'loadFromDirectory: loading from ${directory.path}',
    );
    final sourceJsonFile = File('${directory.path}/source.json');
    if (!sourceJsonFile.existsSync()) {
      AidokuLogger.error(
        'Source',
        'loadFromDirectory: source.json missing at ${sourceJsonFile.path}',
      );
      throw const PathNotFoundException('', OSError('source.json missing'));
    }

    final sourceJson =
        jsonDecode(await sourceJsonFile.readAsString()) as Map<String, dynamic>;
    final sourceInfo = SourceInfo.fromJson(sourceJson);
    AidokuLogger.log(
      'Source',
      'loadFromDirectory: parsed source.json for "${sourceInfo.info.name}" (${sourceInfo.info.id})',
    );

    final wasmFile = File('${directory.path}/main.wasm');
    if (!wasmFile.existsSync()) {
      AidokuLogger.error(
        'Source',
        'loadFromDirectory: main.wasm missing at ${wasmFile.path}',
      );
      throw const PathNotFoundException('', OSError('main.wasm missing'));
    }
    final bytes = await wasmFile.readAsBytes();

    final runner = await runnerFactory(bytes, sourceInfo.info.id);

    // Static filters
    final filtersFile = File('${directory.path}/filters.json');
    List<Filter> staticFilters = [];
    if (filtersFile.existsSync()) {
      try {
        final filtersJson = jsonDecode(await filtersFile.readAsString());
        if (filtersJson is List) {
          staticFilters = filtersJson
              .map((e) => Filter.fromJson(e as Map<String, dynamic>))
              .toList();
          AidokuLogger.debug(
            'Source',
            'loadFromDirectory: loaded ${staticFilters.length} static filters',
          );
        }
      } catch (e, st) {
        AidokuLogger.error(
          'Source',
          'loadFromDirectory: error decoding filters.json',
          e,
          st,
        );
      }
    }

    // Static settings
    final settingsFile = File('${directory.path}/settings.json');
    List<Setting> staticSettings = [];
    if (settingsFile.existsSync()) {
      try {
        final settingsJson = jsonDecode(await settingsFile.readAsString());
        if (settingsJson is List) {
          staticSettings = settingsJson
              .map((e) => Setting.fromJson(e as Map<String, dynamic>))
              .toList();
          AidokuLogger.debug(
            'Source',
            'loadFromDirectory: loaded ${staticSettings.length} static settings',
          );
        }
      } catch (e, st) {
        AidokuLogger.error(
          'Source',
          'loadFromDirectory: error decoding settings.json',
          e,
          st,
        );
      }
    }

    final allUrls = <String>[];
    if (sourceInfo.info.url != null) allUrls.add(sourceInfo.info.url!);
    if (sourceInfo.info.urls != null) allUrls.addAll(sourceInfo.info.urls!);

    return Source(
      key: sourceInfo.info.id,
      name: sourceInfo.info.name,
      version: sourceInfo.info.version,
      languages: sourceInfo.info.languages,
      urls: allUrls,
      contentRating: sourceInfo.info.contentRating ?? SourceContentRating.safe,
      config: sourceInfo.config,
      staticListings: sourceInfo.listings ?? [],
      staticFilters: staticFilters,
      staticSettings: staticSettings,
      defaultLanguage: defaultLanguage,
      runner: runner,
    );
  }

  static List<Setting> initSettings(
    SourceConfiguration? config,
    List<String> languages,
    List<String> urls,
    List<Setting> baseSettings,
    String key, {
    String? defaultLanguage,
  }) {
    AidokuLogger.debug(
      'Source',
      'initSettings: initializing settings for source "$key" (languages: ${languages.length}, urls: ${urls.length}, baseSettings: ${baseSettings.length}, defaultLanguage: $defaultLanguage)',
    );
    final extra = <Setting>[];
    if (languages.length > 1) {
      final isSingle = config?.languageSelectType == LanguageSelectType.single;

      List<String> defaultLanguages;
      String defaultSingleLang = languages.first;

      if (defaultLanguage != null &&
          defaultLanguage.isNotEmpty &&
          defaultLanguage.toLowerCase() != 'all' &&
          defaultLanguage.toLowerCase() != 'multi') {
        final exact = languages
            .where((l) => l.toLowerCase() == defaultLanguage.toLowerCase())
            .toList();
        if (exact.isNotEmpty) {
          defaultLanguages = [exact.first];
          defaultSingleLang = exact.first;
        } else {
          final prefix = languages
              .where(
                (l) => l.toLowerCase().startsWith(
                  defaultLanguage.toLowerCase(),
                ),
              )
              .toList();
          if (prefix.isNotEmpty) {
            defaultLanguages = prefix;
            defaultSingleLang = prefix.first;
          } else {
            defaultLanguages = languages;
          }
        }
      } else {
        defaultLanguages = languages;
      }

      final setting = Setting(
        key: isSingle ? 'language' : 'languages',
        title: isSingle ? 'LANGUAGE' : 'LANGUAGES',
        value: isSingle
            ? SelectSetting(values: languages, defaultValue: defaultSingleLang)
            : MultiSelectSetting(
                values: languages,
                defaultValue: defaultLanguages,
              ),
      );
      extra.add(
        Setting(
          title: setting.title,
          value: GroupSetting(items: [setting]),
        ),
      );
    }

    if (config?.allowsBaseUrlSelect == true && urls.length > 1) {
      final setting = Setting(
        key: 'url',
        title: 'BASE_URL',
        value: SelectSetting(values: urls, defaultValue: urls.first),
      );
      extra.add(
        Setting(
          title: setting.title,
          value: GroupSetting(items: [setting]),
        ),
      );
    }

    final all = [...extra, ...baseSettings];
    _loadDefaults(all, key);
    return all;
  }

  static void _loadDefaults(List<Setting> settings, String sourceKey) {
    void setIfNull(String? key, Object? val) {
      if (key == null || key.isEmpty || val == null) return;
      if (SettingsStore.shared.object('$sourceKey.$key') == null &&
          SettingsStore.shared.object(key) == null) {
        SettingsStore.shared.setValue('$sourceKey.$key', val);
        SettingsStore.shared.setValue(key, val);
      }
    }

    for (final s in settings) {
      final key = s.key;
      final v = s.value;
      if (v is GroupSetting) {
        _loadDefaults(v.items, sourceKey);
      } else if (v is PageSetting) {
        _loadDefaults(v.items, sourceKey);
      } else if (v is SelectSetting) {
        final def =
            v.defaultValue ?? (v.values.isNotEmpty ? v.values.first : null);
        if (def != null) {
          AidokuLogger.debug(
            'Source',
            '_loadDefaults: registered SelectSetting "$key" = "$def"',
          );
          setIfNull(key, def);
        }
      } else if (v is MultiSelectSetting) {
        final def = v.defaultValue;
        if (def != null) {
          AidokuLogger.debug(
            'Source',
            '_loadDefaults: registered MultiSelectSetting "$key" = "$def"',
          );
          setIfNull(key, def);
        }
      } else if (v is ToggleSetting) {
        AidokuLogger.debug(
          'Source',
          '_loadDefaults: registered ToggleSetting "$key" = "${v.defaultValue}"',
        );
        setIfNull(key, v.defaultValue);
      } else if (v is StepperSetting) {
        final def = v.defaultValue ?? v.minimumValue;
        AidokuLogger.debug(
          'Source',
          '_loadDefaults: registered StepperSetting "$key" = "$def"',
        );
        setIfNull(key, def);
      } else if (v is SegmentSetting) {
        final def = v.defaultValue ?? 0;
        AidokuLogger.debug(
          'Source',
          '_loadDefaults: registered SegmentSetting "$key" = "$def"',
        );
        setIfNull(key, def);
      } else if (v is TextSetting) {
        if (v.defaultValue != null) {
          AidokuLogger.debug(
            'Source',
            '_loadDefaults: registered TextSetting "$key" = "${v.defaultValue}"',
          );
          setIfNull(key, v.defaultValue);
        }
      } else if (v is EditableListSetting) {
        if (v.defaultValue != null) {
          AidokuLogger.debug(
            'Source',
            '_loadDefaults: registered EditableListSetting "$key" = "${v.defaultValue}"',
          );
          setIfNull(key, v.defaultValue);
        }
      } else if (v is PickerSetting) {
        final def =
            v.defaultValue ?? (v.values.isNotEmpty ? v.values.first : null);
        if (def != null) {
          AidokuLogger.debug(
            'Source',
            '_loadDefaults: registered PickerSetting "$key" = "$def"',
          );
          setIfNull(key, def);
        }
      }
    }
  }

  Future<void> restart({Uint8List? wasmBytes}) async {
    AidokuLogger.log('Source', 'restart: restarting source "$key"');
  }

  Future<MangaPageResult> getSearchMangaList(
    String? query,
    int page,
    List<FilterValue> filters,
  ) async {
    AidokuLogger.log(
      'Source',
      'getSearchMangaList: query="$query", page=$page, filters=${filters.length} for source "$key"',
    );
    final activeFilters =
        (query != null &&
            query.isNotEmpty &&
            (config?.hidesFiltersWhileSearching ?? false))
        ? <FilterValue>[]
        : filters;
    final result = await runner.getSearchMangaList(query, page, activeFilters);
    AidokuLogger.debug(
      'Source',
      'getSearchMangaList: returned ${result.entries.length} items (hasNext: ${result.hasNextPage})',
    );
    return result;
  }

  Future<Manga> getMangaUpdate(
    Manga manga, {
    bool needsDetails = false,
    bool needsChapters = false,
  }) async {
    AidokuLogger.log(
      'Source',
      'getMangaUpdate: manga="${manga.title}" (key: ${manga.key}), needsDetails=$needsDetails, needsChapters=$needsChapters for source "$key"',
    );
    final updated = await runner.getMangaUpdate(
      manga,
      needsDetails: needsDetails,
      needsChapters: needsChapters,
    );
    updated.sourceKey = key;
    AidokuLogger.debug(
      'Source',
      'getMangaUpdate: updated manga "${updated.title}", chapters=${updated.chapters?.length ?? 0}',
    );
    return updated;
  }

  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    AidokuLogger.log(
      'Source',
      'getPageList: manga="${manga.title}", chapter="${chapter.title}" (${chapter.chapterNumber}) for source "$key"',
    );
    final pages = await runner.getPageList(manga, chapter);
    AidokuLogger.debug('Source', 'getPageList: returned ${pages.length} pages');
    return pages;
  }

  Future<MangaPageResult> getMangaList(Listing listing, int page) async {
    AidokuLogger.log(
      'Source',
      'getMangaList: listing="${listing.name}" (id: ${listing.id}), page=$page for source "$key"',
    );
    final result = await runner.getMangaList(listing, page);
    AidokuLogger.debug(
      'Source',
      'getMangaList: returned ${result.entries.length} items (hasNext: ${result.hasNextPage})',
    );
    return result;
  }

  Future<Home> getHome() async {
    AidokuLogger.log('Source', 'getHome: requested for "$key"');
    final home = await runner.getHome();
    AidokuLogger.debug(
      'Source',
      'getHome: returned ${home.components.length} components',
    );
    return home;
  }

  Future<Uint8List?> processPageImage(
    Response response, {
    PageContext? context,
  }) async {
    AidokuLogger.log(
      'Source',
      'processPageImage: processing response for context: $context',
    );
    final processed = await runner.processPageImage(response, context: context);
    AidokuLogger.debug(
      'Source',
      'processPageImage: returned ${processed?.length ?? 0} bytes',
    );
    return processed;
  }

  Future<List<Listing>> getListings() async {
    AidokuLogger.log(
      'Source',
      'getListings: fetching listings (features.dynamicListings: ${features.dynamicListings})',
    );
    if (features.dynamicListings) {
      final dynamicListings = await runner.getListings();
      final all = [...staticListings, ...dynamicListings];
      AidokuLogger.debug(
        'Source',
        'getListings: returned ${all.length} total listings (${staticListings.length} static + ${dynamicListings.length} dynamic)',
      );
      return all;
    }
    return staticListings;
  }

  Future<List<Filter>> getSearchFilters() async {
    AidokuLogger.log(
      'Source',
      'getSearchFilters: fetching search filters (features.dynamicFilters: ${features.dynamicFilters})',
    );
    if (features.dynamicFilters) {
      final dynamicFilters = await runner.getSearchFilters();
      final all = [...staticFilters, ...dynamicFilters];
      AidokuLogger.debug(
        'Source',
        'getSearchFilters: returned ${all.length} total filters (${staticFilters.length} static + ${dynamicFilters.length} dynamic)',
      );
      return all;
    }
    return staticFilters;
  }

  Future<List<Setting>> getSettings() async {
    AidokuLogger.log(
      'Source',
      'getSettings: fetching settings (features.dynamicSettings: ${features.dynamicSettings})',
    );
    if (features.dynamicSettings) {
      final dynamicSettings = await runner.getSettings();
      _loadDefaults(dynamicSettings, key);
      final all = [...staticSettings, ...dynamicSettings];
      AidokuLogger.debug(
        'Source',
        'getSettings: returned ${all.length} total settings',
      );
      return all;
    }
    return staticSettings;
  }

  List<Setting> getSettingsSync() {
    AidokuLogger.debug(
      'Source',
      'getSettingsSync: returning ${staticSettings.length} static settings',
    );
    return staticSettings;
  }

  List<Filter> getSearchFiltersSync() {
    AidokuLogger.debug(
      'Source',
      'getSearchFiltersSync: returning ${staticFilters.length} static filters',
    );
    return staticFilters;
  }

  Future<String?> getBaseUrl() async {
    AidokuLogger.log('Source', 'getBaseUrl: resolving dynamic base URL');
    final baseUrl = await runner.getBaseUrl();
    AidokuLogger.debug('Source', 'getBaseUrl: resolved base URL -> "$baseUrl"');
    return baseUrl;
  }

  Future<DeepLinkResult?> handleDeepLink(String url) async {
    AidokuLogger.log('Source', 'handleDeepLink: handling deep link url="$url"');
    final result = await runner.handleDeepLink(url);
    AidokuLogger.debug('Source', 'handleDeepLink: returned result -> $result');
    return result;
  }

  Future<ImageRequestResult?> getImageRequest(
    String url, {
    PageContext? context,
  }) async {
    AidokuLogger.log(
      'Source',
      'getImageRequest: resolving image request url="$url"',
    );
    final result = await runner.getImageRequest(url, context: context);
    AidokuLogger.debug('Source', 'getImageRequest: returned result -> $result');
    return result;
  }

  void dispose() {
    AidokuLogger.log('Source', 'dispose: disposing source "$key"');
    runner.dispose();
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'interpreter/aidoku_interpreter.dart';
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
    required this.runner,
  }) : staticSettings = _initSettings(config, languages, urls, staticSettings, key);

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
    InterpreterConfiguration interpreterConfig = const InterpreterConfiguration(),
  }) async {
    final bytes = await aixFile.readAsBytes();
    return await loadFromAixBytes(bytes, interpreterConfig: interpreterConfig);
  }

  /// Loads a source from raw `.aix` (zip) bytes in memory.
  static Future<Source> loadFromAixBytes(
    Uint8List aixBytes, {
    InterpreterConfiguration interpreterConfig = const InterpreterConfiguration(),
  }) async {
    final archive = ZipDecoder().decodeBytes(aixBytes);

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
      throw const FormatException('Invalid .aix archive: source.json not found');
    }
    final sourceJsonStr = utf8.decode(sourceJsonFile.content as List<int>);
    final sourceJson = jsonDecode(sourceJsonStr) as Map<String, dynamic>;
    final sourceInfo = SourceInfo.fromJson(sourceJson);

    final wasmFile = findFile('main.wasm');
    if (wasmFile == null) {
      throw const FormatException('Invalid .aix archive: main.wasm not found');
    }
    final wasmBytes = Uint8List.fromList(wasmFile.content as List<int>);

    final runner = await AidokuInterpreter.create(
      bytes: wasmBytes,
      sourceKey: sourceInfo.info.id,
      config: interpreterConfig,
    );

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
        }
      } catch (_) {}
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
        }
      } catch (_) {}
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
      runner: runner,
    );
  }

  /// Loads a source from an extension folder containing `source.json` and `main.wasm`.
  static Future<Source> loadFromDirectory(
    Directory directory, {
    InterpreterConfiguration interpreterConfig = const InterpreterConfiguration(),
  }) async {
    final sourceJsonFile = File('${directory.path}/source.json');
    if (!sourceJsonFile.existsSync()) {
      throw const PathNotFoundException('', OSError('source.json missing'));
    }

    final sourceJson = jsonDecode(await sourceJsonFile.readAsString()) as Map<String, dynamic>;
    final sourceInfo = SourceInfo.fromJson(sourceJson);

    final wasmFile = File('${directory.path}/main.wasm');
    if (!wasmFile.existsSync()) {
      throw const PathNotFoundException('', OSError('main.wasm missing'));
    }
    final bytes = await wasmFile.readAsBytes();

    final runner = await AidokuInterpreter.create(
      bytes: bytes,
      sourceKey: sourceInfo.info.id,
      config: interpreterConfig,
    );

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
        }
      } catch (_) {}
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
        }
      } catch (_) {}
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
      runner: runner,
    );
  }

  static List<Setting> _initSettings(
    SourceConfiguration? config,
    List<String> languages,
    List<String> urls,
    List<Setting> baseSettings,
    String key,
  ) {
    final extra = <Setting>[];
    if (languages.length > 1) {
      final isSingle = config?.languageSelectType == LanguageSelectType.single;
      final setting = Setting(
        key: isSingle ? 'language' : 'languages',
        title: isSingle ? 'LANGUAGE' : 'LANGUAGES',
        value: isSingle
            ? SelectSetting(values: languages, defaultValue: languages.first)
            : MultiSelectSetting(values: languages, defaultValue: languages),
      );
      extra.add(Setting(title: setting.title, value: GroupSetting(items: [setting])));
    }

    final all = [...extra, ...baseSettings];
    _loadDefaults(all, key);
    return all;
  }

  static void _loadDefaults(List<Setting> settings, String sourceKey) {
    for (final s in settings) {
      final key = s.key;
      final v = s.value;
      if (v is SelectSetting) {
        final def = v.defaultValue ?? (v.values.isNotEmpty ? v.values.first : null);
        if (def != null) {
          SettingsStore.shared.setValue('$sourceKey.$key', def);
          SettingsStore.shared.setValue(key, def);
        }
      } else if (v is MultiSelectSetting) {
        final def = v.defaultValue;
        if (def != null) {
          SettingsStore.shared.setValue('$sourceKey.$key', def);
          SettingsStore.shared.setValue(key, def);
        }
      } else if (v is ToggleSetting) {
        SettingsStore.shared.setValue('$sourceKey.$key', v.defaultValue);
        SettingsStore.shared.setValue(key, v.defaultValue);
      } else if (v is StepperSetting && v.defaultValue != null) {
        SettingsStore.shared.setValue('$sourceKey.$key', v.defaultValue);
        SettingsStore.shared.setValue(key, v.defaultValue);
      } else if (v is SegmentSetting && v.defaultValue != null) {
        SettingsStore.shared.setValue('$sourceKey.$key', v.defaultValue);
        SettingsStore.shared.setValue(key, v.defaultValue);
      } else if (v is TextSetting && v.defaultValue != null) {
        SettingsStore.shared.setValue('$sourceKey.$key', v.defaultValue);
        SettingsStore.shared.setValue(key, v.defaultValue);
      } else if (v is EditableListSetting && v.defaultValue != null) {
        SettingsStore.shared.setValue('$sourceKey.$key', v.defaultValue);
        SettingsStore.shared.setValue(key, v.defaultValue);
      } else if (v is PickerSetting) {
        final def = v.defaultValue ?? (v.values.isNotEmpty ? v.values.first : null);
        if (def != null) {
          SettingsStore.shared.setValue('$sourceKey.$key', def);
          SettingsStore.shared.setValue(key, def);
        }
      } else if (v is GroupSetting) {
        _loadDefaults(v.items, sourceKey);
      } else if (v is PageSetting) {
        _loadDefaults(v.items, sourceKey);
      }
    }
  }

  Future<void> restart({Uint8List? wasmBytes}) async {
    if (runner is AidokuInterpreter) {
      final cur = runner as AidokuInterpreter;
      runner = await AidokuInterpreter.create(
        bytes: wasmBytes ?? cur.bytes,
        sourceKey: key,
        config: cur.config,
      );
    }
  }

  Future<MangaPageResult> getSearchMangaList(
    String? query,
    int page,
    List<FilterValue> filters,
  ) async {
    final activeFilters = (query != null && query.isNotEmpty && (config?.hidesFiltersWhileSearching ?? false))
        ? <FilterValue>[]
        : filters;
    return await runner.getSearchMangaList(query, page, activeFilters);
  }

  Future<Manga> getMangaUpdate(
    Manga manga, {
    bool needsDetails = false,
    bool needsChapters = false,
  }) async {
    final updated = await runner.getMangaUpdate(
      manga,
      needsDetails: needsDetails,
      needsChapters: needsChapters,
    );
    updated.sourceKey = key;
    return updated;
  }

  Future<List<Page>> getPageList(Manga manga, Chapter chapter) async {
    return await runner.getPageList(manga, chapter);
  }

  Future<MangaPageResult> getMangaList(Listing listing, int page) async {
    return await runner.getMangaList(listing, page);
  }

  Future<Home> getHome() async {
    return await runner.getHome();
  }

  Future<Uint8List?> processPageImage(Response response, {PageContext? context}) async {
    return await runner.processPageImage(response, context: context);
  }

  Future<List<Listing>> getListings() async {
    if (features.dynamicListings) {
      return [...staticListings, ...await runner.getListings()];
    }
    return staticListings;
  }

  Future<List<Filter>> getSearchFilters() async {
    if (features.dynamicFilters) {
      return [...staticFilters, ...await runner.getSearchFilters()];
    }
    return staticFilters;
  }

  Future<List<Setting>> getSettings() async {
    if (features.dynamicSettings) {
      final dynamicSettings = await runner.getSettings();
      _loadDefaults(dynamicSettings, key);
      return [...staticSettings, ...dynamicSettings];
    }
    return staticSettings;
  }

  List<Filter> getSearchFiltersSync() {
    return staticFilters;
  }

  Future<String?> getBaseUrl() async {
    return await runner.getBaseUrl();
  }

  Future<DeepLinkResult?> handleDeepLink(String url) async {
    return await runner.handleDeepLink(url);
  }

  void dispose() {
    runner.dispose();
  }
}

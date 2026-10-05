import 'dart:convert';

import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/lnreader/http.dart';
import 'package:mangayomi/eval/lnreader/m_plugin.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/repositories/source_preference_repository.dart';

import '../interface.dart';
import 'js_cheerio.dart';
import 'js_htmlparser.dart';
import 'js_libs.dart';
import 'js_polyfills.dart';

JavascriptRuntime getJavascriptRuntime({
  Map<String, dynamic>? extraArgs = const {},
}) {
  JavascriptRuntime runtime;
  runtime = QuickJsRuntime2(stackSize: 1024 * 1024 * 4);
  runtime.enableHandlePromises();
  return runtime;
}

class LNReaderExtensionService implements ExtensionService {
  late JavascriptRuntime runtime;
  @override
  late Source source;
  bool _isInitialized = false;
  late JsCheerio _jsCheerio;

  LNReaderExtensionService(this.source);

  void _init() {
    if (_isInitialized) return;
    runtime = getJavascriptRuntime();
    runtime.evaluate('''
module={},exports=Function("return this")(),Object.defineProperties(module,{namespace:{set:function(a){exports=a}},exports:{set:function(a){for(var b in a)a.hasOwnProperty(b)&&(exports[b]=a[b])},get:function(){return exports}}});
''');
    JsPolyfills(runtime).init();
    JsHttpClient(runtime).init();
    JsLibs(runtime).init();
    JsHtmlParser(runtime).init();
    _jsCheerio = JsCheerio(runtime)..init();
    runtime.onMessage('ln_storage_get', (dynamic args) {
      final key = args[0]?.toString();
      if (key == null) return null;
      return _getStoredPreference(key);
    });
    runtime.onMessage('ln_storage_set', (dynamic args) {
      final key = args[0]?.toString();
      if (key == null) return null;
      _setStoredPreference(key, args[1]);
      return null;
    });
    runtime.onMessage('ln_storage_delete', (dynamic args) {
      final key = args[0]?.toString();
      if (key == null) return null;
      _deleteStoredPreference(key);
      return null;
    });
    runtime.evaluate('''
const require = (package) => {
  switch (package) {
    case "htmlparser2":
        return {Parser: Parser};
    case "cheerio":
        return {load: load};
    case "dayjs":
        return module.exports.dayjs;
    case "urlencode":
        return {encode: urlencode, decode: urldecode};
    case "@libs/fetch":
        return {fetchApi: fetchApi, fetchText: fetchText};
    case "@libs/novelStatus":
        return {NovelStatus: NovelStatus};
    case "@libs/isAbsoluteUrl":
        return {isUrlAbsolute: isUrlAbsolute};
    case "@libs/filterInputs":
        return {
          FilterTypes: FilterTypes,
          isPickerValue: isPickerValue,
          isCheckboxValue: isCheckboxValue,
          isSwitchValue: isSwitchValue,
          isTextValue: isTextValue,
          isXCheckboxValue: isXCheckboxValue
        };
    case "@libs/defaultCover":
        return {defaultCover: 'https://raw.githubusercontent.com/LNReader/lnreader-plugins/refs/heads/master/public/static/coverNotAvailable.webp'};
    case "@libs/storage":
        if (!globalThis._lnStorage) globalThis._lnStorage = {};
        const pId = "${source.id ?? source.name ?? 'default'}";
        const getStoreKey = (k) => pId + "_DB_" + k;
        return {
          storage: {
            get: (key, raw) => {
              const fullKey = getStoreKey(key);
              const item = globalThis._lnStorage[fullKey];
              if (item !== undefined) {
                if (item.expires && Date.now() > item.expires) {
                  delete globalThis._lnStorage[fullKey];
                  return undefined;
                }
                return raw ? item : item.value;
              }
              try {
                const fromDart = sendMessage("ln_storage_get", JSON.stringify([key]));
                if (fromDart !== undefined && fromDart !== null) {
                  return raw ? { created: new Date(), value: fromDart } : fromDart;
                }
              } catch (_) {}
              if (typeof extension !== "undefined" && extension && extension.pluginSettings && extension.pluginSettings[key]) {
                const defVal = extension.pluginSettings[key].value;
                if (defVal !== undefined) {
                  return raw ? { created: new Date(), value: defVal } : defVal;
                }
              }
              return undefined;
            },
            set: (key, value, expires) => {
              const fullKey = getStoreKey(key);
              let exp = expires;
              if (exp instanceof Date) exp = exp.getTime();
              globalThis._lnStorage[fullKey] = {
                created: new Date(),
                value: value,
                expires: exp
              };
              try {
                sendMessage("ln_storage_set", JSON.stringify([key, value]));
              } catch (_) {}
            },
            delete: (key) => {
              delete globalThis._lnStorage[getStoreKey(key)];
              try {
                sendMessage("ln_storage_delete", JSON.stringify([key]));
              } catch (_) {}
            },
            clearAll: () => {
              const prefix = pId + "_DB_";
              Object.keys(globalThis._lnStorage).forEach(k => {
                if (k.startsWith(prefix)) delete globalThis._lnStorage[k];
              });
            },
            getAllKeys: () => {
              const prefix = pId + "_DB_";
              return Object.keys(globalThis._lnStorage)
                .filter(k => k.startsWith(prefix))
                .map(k => k.replace(prefix, ''));
            }
          },
          localStorage: {
            get: () => {
              const data = globalThis._lnStorage[pId + "_LocalStorage"];
              return data !== undefined ? data : undefined;
            }
          },
          sessionStorage: {
            get: () => {
              const data = globalThis._lnStorage[pId + "_SessionStorage"];
              return data !== undefined ? data : undefined;
            }
          }
        };
    default:
        return {};
  }
};
''');
    runtime.evaluate('''
${source.sourceCode}
const extension = exports.default;
''');
    _isInitialized = true;
  }

  @override
  void dispose() {
    if (!_isInitialized) return;
    _jsCheerio.dispose();
    _isInitialized = false;
  }

  @override
  Map<String, String> getHeaders() {
    _init();
    try {
      final res = runtime.evaluate(
        'JSON.stringify((extension.imageRequestInit && extension.imageRequestInit.headers) ? extension.imageRequestInit.headers : (extension.headers || null))',
      );
      final decoded = jsonDecode(res.stringResult) as Map?;
      if (decoded != null) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return {};
  }

  @override
  bool get supportsLatest {
    return true;
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  Future<MPages> getPopular(int page) async {
    final items =
        ((await _extensionCallAsync(
              'popularNovels($page, {showLatestNovels: false, filters: extension.filters})',
              [],
            )))
            .map((e) => NovelItem.fromJson(e))
            .map(
              (e) => MManga(
                name: e.name,
                imageUrl: e.cover,
                link: e.path,
                chapters: [],
              ),
            )
            .toList();
    return MPages(list: items, hasNextPage: true);
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final items =
        ((await _extensionCallAsync(
              'popularNovels($page, {showLatestNovels: true, filters: extension.filters})',
              [],
            )))
            .map((e) => NovelItem.fromJson(e))
            .map(
              (e) => MManga(
                name: e.name,
                imageUrl: e.cover,
                link: e.path,
                chapters: [],
              ),
            )
            .toList();
    return MPages(list: items, hasNextPage: true);
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final items =
        ((await _extensionCallAsync(
              'searchNovels(${jsonEncode(query)},$page)',
              [],
            )))
            .map((e) => NovelItem.fromJson(e))
            .map(
              (e) => MManga(
                name: e.name,
                imageUrl: e.cover,
                link: e.path,
                chapters: [],
              ),
            )
            .toList();
    return MPages(list: items, hasNextPage: true);
  }

  @override
  Future<MManga> getDetail(String url) async {
    List<ChapterItem>? chapters = [];
    final item = SourceNovel.fromJson(
      await _extensionCallAsync('parseNovel(${jsonEncode(url)})', {}),
    );
    chapters = item.chapters ?? [];
    if (chapters.isEmpty || (item.totalPages != null && item.totalPages! > 1)) {
      final paginatedChapters = <ChapterItem>[...chapters];
      int pageNum = paginatedChapters.isEmpty ? 1 : 2;
      final maxPages = item.totalPages ?? 50;
      while (pageNum <= maxPages) {
        try {
          final raw = await _extensionCallAsync<Map<String, dynamic>>(
            'parsePage(${jsonEncode(item.path)}, ${jsonEncode(pageNum.toString())})',
            <String, dynamic>{},
          );
          final sourcePage = SourcePage.fromJson(raw);
          if (sourcePage.chapters.isEmpty) break;
          paginatedChapters.addAll(sourcePage.chapters);
          if (item.totalPages == null &&
              (sourcePage.chapters.length < 5 || pageNum >= 50)) {
            break;
          }
          pageNum++;
        } catch (_) {
          break;
        }
      }
      if (paginatedChapters.isNotEmpty) {
        chapters = paginatedChapters;
      }
    }

    final chaps = chapters
        .map(
          (e) => MChapter(
            name: e.name,
            url: e.path,
            scanlator: e.scanlator,
            dateUpload: e.releaseTime != null
                ? DateTime.tryParse(e.releaseTime!)?.millisecondsSinceEpoch
                          .toString() ??
                      int.tryParse(e.releaseTime!)?.toString() ??
                      DateTime.now().millisecondsSinceEpoch.toString()
                : DateTime.now().millisecondsSinceEpoch.toString(),
          ),
        )
        .toList();
    return MManga(
      name: item.name,
      imageUrl: item.cover,
      link: item.path,
      artist: item.artist,
      author: item.author,
      description: item.summary,
      status: switch (item.status) {
        "Ongoing" => Status.ongoing,
        "Completed" || "Publishing Finished" => Status.completed,
        "On Hiatus" => Status.onHiatus,
        "Cancelled" => Status.canceled,
        _ => Status.unknown,
      },
      genre: item.genres?.split(","),
      chapters: chaps.reversed.toList(),
    );
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    return [];
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    return [];
  }

  @override
  Future<String> getHtmlContent(String name, String url) async {
    _init();
    final res = (await runtime.handlePromise(
      await runtime.evaluateAsync(
        'jsonStringify(() => extension.parseChapter(${jsonEncode(url)}))',
      ),
    )).stringResult;
    return res;
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    return html;
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;

    try {
      list = fromJsonFilterValuesToList(_extensionCall('filters', []));
    } catch (_) {
      list = [];
    }

    return FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    _init();
    try {
      final res = runtime.evaluate('JSON.stringify(extension.pluginSettings)');
      final decoded = jsonDecode(res.stringResult);
      if (decoded == null) return [];

      final list = <SourcePreference>[];

      if (decoded is Map<String, dynamic>) {
        decoded.forEach((key, val) {
          if (val is! Map<String, dynamic>) return;
          final pref = _mapPluginSettingToSourcePreference(key, val);
          if (pref != null) {
            list.add(pref);
          }
        });
      } else if (decoded is List) {
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            final key = item['key']?.toString();
            if (key != null &&
                (item['switchPreferenceCompat'] != null ||
                    item['checkBoxPreference'] != null ||
                    item['listPreference'] != null ||
                    item['multiSelectListPreference'] != null ||
                    item['editTextPreference'] != null)) {
              list.add(SourcePreference.fromJson(item)..sourceId = source.id);
            } else if (key != null) {
              final pref = _mapPluginSettingToSourcePreference(key, item);
              if (pref != null) list.add(pref);
            }
          }
        }
      }

      return list;
    } catch (_) {
      return [];
    }
  }

  SourcePreference? _mapPluginSettingToSourcePreference(
    String key,
    Map<String, dynamic> setting,
  ) {
    final label = setting['label']?.toString() ?? key;
    final type = setting['type']?.toString();
    final defaultValue = setting['value'];

    SourcePreference? savedPref;
    if (source.id != null) {
      try {
        savedPref = sourcePreferenceRepository.findByKey(source.id, key);
      } catch (_) {}
    }

    // Switch
    if (type == 'Switch' || (type == null && defaultValue is bool)) {
      final currentVal =
          savedPref?.switchPreferenceCompat?.value ??
          savedPref?.checkBoxPreference?.value ??
          (defaultValue is bool ? defaultValue : false);
      return SourcePreference(
        key: key,
        sourceId: source.id,
        switchPreferenceCompat: SwitchPreferenceCompat(
          title: label,
          summary: '',
          value: currentVal,
        ),
      );
    }

    // Select
    if (type == 'Select') {
      final rawOptions = setting['options'];
      final options = rawOptions is List ? rawOptions : [];
      final entries = <String>[];
      final entryValues = <String>[];
      for (final opt in options) {
        if (opt is Map) {
          entries.add(opt['label']?.toString() ?? '');
          entryValues.add(opt['value']?.toString() ?? '');
        }
      }
      final curVal =
          savedPref?.listPreference?.entryValues != null &&
              savedPref!.listPreference!.valueIndex != null &&
              savedPref.listPreference!.valueIndex! >= 0 &&
              savedPref.listPreference!.valueIndex! <
                  savedPref.listPreference!.entryValues!.length
          ? savedPref.listPreference!.entryValues![savedPref
                .listPreference!
                .valueIndex!]
          : (defaultValue?.toString() ?? '');
      final idx = entryValues.indexOf(curVal);
      return SourcePreference(
        key: key,
        sourceId: source.id,
        listPreference: ListPreference(
          title: label,
          summary: '',
          entries: entries,
          entryValues: entryValues,
          valueIndex: idx >= 0 && idx < entries.length ? idx : 0,
        ),
      );
    }

    // CheckboxGroup
    if (type == 'CheckboxGroup') {
      final rawOptions = setting['options'];
      final options = rawOptions is List ? rawOptions : [];
      final entries = <String>[];
      final entryValues = <String>[];
      for (final opt in options) {
        if (opt is Map) {
          entries.add(opt['label']?.toString() ?? '');
          entryValues.add(opt['value']?.toString() ?? '');
        }
      }
      final curVals =
          savedPref?.multiSelectListPreference?.values ??
          (defaultValue is List
              ? defaultValue.map((e) => e.toString()).toList()
              : <String>[]);
      return SourcePreference(
        key: key,
        sourceId: source.id,
        multiSelectListPreference: MultiSelectListPreference(
          title: label,
          summary: '',
          entries: entries,
          entryValues: entryValues,
          values: curVals,
        ),
      );
    }

    // Text / Default
    final curVal =
        savedPref?.editTextPreference?.value ??
        (defaultValue?.toString() ?? '');
    return SourcePreference(
      key: key,
      sourceId: source.id,
      editTextPreference: EditTextPreference(
        title: label,
        summary: '',
        value: curVal,
        dialogTitle: label,
      ),
    );
  }

  dynamic _getStoredPreference(String key) {
    if (source.id == null) return null;
    try {
      final pref = sourcePreferenceRepository.findByKey(source.id, key);
      if (pref != null) {
        if (pref.switchPreferenceCompat != null) {
          return pref.switchPreferenceCompat!.value;
        }
        if (pref.checkBoxPreference != null) {
          return pref.checkBoxPreference!.value;
        }
        if (pref.editTextPreference != null) {
          return pref.editTextPreference!.value;
        }
        if (pref.listPreference != null) {
          final p = pref.listPreference!;
          if (p.entryValues != null &&
              p.valueIndex != null &&
              p.valueIndex! >= 0 &&
              p.valueIndex! < p.entryValues!.length) {
            return p.entryValues![p.valueIndex!];
          }
          return p.valueIndex;
        }
        if (pref.multiSelectListPreference != null) {
          return pref.multiSelectListPreference!.values;
        }
      }
      final strVal = sourcePreferenceRepository.findStringValueByKey(
        source.id,
        key,
      );
      if (strVal != null && strVal.value != null) {
        try {
          return jsonDecode(strVal.value!);
        } catch (_) {
          return strVal.value;
        }
      }
    } catch (_) {}
    return null;
  }

  void _setStoredPreference(String key, dynamic val) {
    if (source.id == null) return;
    try {
      final pref = sourcePreferenceRepository.findByKey(source.id, key);
      if (pref != null) {
        if (pref.switchPreferenceCompat != null && val is bool) {
          pref.switchPreferenceCompat!.value = val;
        } else if (pref.checkBoxPreference != null && val is bool) {
          pref.checkBoxPreference!.value = val;
        } else if (pref.editTextPreference != null) {
          pref.editTextPreference!.value = val.toString();
        } else if (pref.listPreference != null) {
          final p = pref.listPreference!;
          final idx = p.entryValues?.indexOf(val.toString()) ?? -1;
          if (idx != -1) {
            p.valueIndex = idx;
          }
        } else if (pref.multiSelectListPreference != null && val is List) {
          pref.multiSelectListPreference!.values = val
              .map((e) => e.toString())
              .toList();
        }
        sourcePreferenceRepository.save(pref, source, pref);
      } else {
        final str = val is String ? val : jsonEncode(val);
        final existing = sourcePreferenceRepository.findStringValueByKey(
          source.id,
          key,
        );
        sourcePreferenceRepository.saveStringValue(
          source.id!,
          key,
          str,
          existing,
        );
      }
    } catch (_) {}
  }

  void _deleteStoredPreference(String key) {
    if (source.id == null) return;
    try {
      final existing = sourcePreferenceRepository.findStringValueByKey(
        source.id,
        key,
      );
      if (existing != null) {
        sourcePreferenceRepository.saveStringValue(
          source.id!,
          key,
          '',
          existing,
        );
      }
    } catch (_) {}
  }

  T _extensionCall<T>(String call, T def) {
    _init();

    try {
      final res = runtime.evaluate('JSON.stringify(extension.$call)');

      return jsonDecode(res.stringResult) as T;
    } catch (_) {
      if (def != null) {
        return def;
      }
      rethrow;
    }
  }

  Future<T> _extensionCallAsync<T>(String call, T def) async {
    _init();

    try {
      final promised = await runtime.handlePromise(
        await runtime.evaluateAsync('jsonStringify(() => extension.$call)'),
      );

      return jsonDecode(promised.stringResult) as T;
    } catch (e) {
      if (def != null) {
        return def;
      }
      rethrow;
    }
  }
}

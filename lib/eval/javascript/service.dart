import 'dart:collection';
import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/dom_selector.dart';
import 'package:mangayomi/eval/javascript/extractors.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/preferences.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class JsExtensionService implements ExtensionService {
  late JavascriptRuntime runtime;
  @override
  late Source source;
  bool _isInitialized = false;
  late JsDomSelector _jsDomSelector;

  JsExtensionService(this.source);

  void _init() {
    if (_isInitialized) return;
    runtime = getJavascriptRuntime();
    JsHttpClient(runtime).init();
    _jsDomSelector = JsDomSelector(runtime)..init();
    JsUtils(runtime).init();
    JsVideosExtractors(runtime).init();
    JsPreferences(runtime, source).init();

    runtime.evaluate('''
class MProvider {
    get source() {
        return JSON.parse('${jsonEncode(source.toMSource().toJson())}');
    }
    get supportsLatest() {
        throw new Error("supportsLatest not implemented");
    }
    getHeaders(url) {
        throw new Error("getHeaders not implemented");
    }
    async getPopular(page) {
        throw new Error("getPopular not implemented");
    }
    async getLatestUpdates(page) {
        throw new Error("getLatestUpdates not implemented");
    }
    async search(query, page, filters) {
        throw new Error("search not implemented");
    }
    async getDetail(url) {
        throw new Error("getDetail not implemented");
    }
    async getPageList() {
        throw new Error("getPageList not implemented");
    }
    async getVideoList(url) {
        throw new Error("getVideoList not implemented");
    }
    async getHtmlContent(name, url) {
        throw new Error("getHtmlContent not implemented");
    }
    async cleanHtmlContent(html) {
        throw new Error("cleanHtmlContent not implemented");
    }
    getFilterList() {
        throw new Error("getFilterList not implemented");
    }
    getSourcePreferences() {
        throw new Error("getSourcePreferences not implemented");
    }
}
async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}
''');
    runtime.evaluate('''${source.sourceCode}
var extention = new DefaultExtension();
''');
    _isInitialized = true;
  }

  @override
  void dispose() {
    if (!_isInitialized) return;
    _jsDomSelector.dispose();
    _isInitialized = false;
  }

  @override
  Map<String, String> getHeaders() {
    return _extensionCall<Map>(
      'getHeaders(`${source.baseUrl ?? ''}`)',
      {},
    ).toMapStringString!;
  }

  @override
  bool get supportsLatest {
    return _extensionCall<bool>('supportsLatest', true);
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  Future<MPages> getPopular(int page) async {
    return MPages.fromJson(await _extensionCallAsync('getPopular($page)'));
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    return MPages.fromJson(
      await _extensionCallAsync('getLatestUpdates($page)'),
    );
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    return MPages.fromJson(
      await _extensionCallAsync(
        'search("$query",$page,${jsonEncode(filterValuesListToJson(filters))})',
      ),
    );
  }

  @override
  Future<MManga> getDetail(String url) async {
    return MManga.fromJson(await _extensionCallAsync('getDetail(`$url`)'));
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    final pages = LinkedHashSet<PageUrl>(
      equals: (a, b) => a.url == b.url,
      hashCode: (p) => p.url.hashCode,
    );

    for (final e in await _extensionCallAsync<List>('getPageList(`$url`)')) {
      if (e != null) {
        final page = e is String
            ? PageUrl(e.trim())
            : PageUrl.fromJson((e as Map).toMapStringDynamic!);
        pages.add(page);
      }
    }

    return pages.toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    final videos = LinkedHashSet<Video>(
      equals: (a, b) => a.url == b.url && a.originalUrl == b.originalUrl,
      hashCode: (v) => Object.hash(v.url, v.originalUrl),
    );

    for (final element in await _extensionCallAsync<List>(
      'getVideoList(`$url`)',
    )) {
      if (element['url'] != null && element['originalUrl'] != null) {
        videos.add(Video.fromJson(element));
      }
    }
    return videos.toList();
  }

  @override
  Future<String> getHtmlContent(String name, String url) async {
    _init();
    final res = (await runtime.handlePromise(
      await runtime.evaluateAsync(
        'jsonStringify(() => extention.getHtmlContent(`$name`, `$url`))',
      ),
    )).stringResult;
    return res;
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    _init();
    final res = (await runtime.handlePromise(
      await runtime.evaluateAsync(
        'jsonStringify(() => extention.cleanHtmlContent(`$html`))',
      ),
    )).stringResult;
    return res;
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;

    try {
      list = fromJsonFilterValuesToList(_extensionCall('getFilterList()', []));
    } catch (_) {
      list = [];
    }

    return FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    return _extensionCall(
      'getSourcePreferences()',
      [],
    ).map((e) => SourcePreference.fromJson(e)..sourceId = source.id).toList();
  }

  T _extensionCall<T>(String call, T def) {
    _init();

    try {
      final res = runtime.evaluate('JSON.stringify(extention.$call)');

      return jsonDecode(res.stringResult) as T;
    } catch (_) {
      if (def != null) {
        return def;
      }

      rethrow;
    }
  }

  Future<T> _extensionCallAsync<T>(String call) async {
    _init();

    try {
      final promised = await runtime.handlePromise(
        await runtime.evaluateAsync('jsonStringify(() => extention.$call)'),
      );

      return jsonDecode(promised.stringResult) as T;
    } catch (e) {
      rethrow;
    }
  }
}

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
        return {fetchApi: fetchApi};
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
        return {storage: {get: () => null}};
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
        ((await _extensionCallAsync('searchNovels("$query",$page)', [])))
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
    final item = SourceNovel.fromJson(
      await _extensionCallAsync('parseNovel(`$url`)', {}),
    );
    final chapters = SourcePage.fromJson(
      await _extensionCallAsync('parsePage(`${item.path}`, `1`)', {}),
    );
    final chaps =
        ((chapters.chapters.isNotEmpty ? chapters.chapters : item.chapters)
            ?.map(
              (e) => MChapter(
                name: e.name,
                url: e.path,
                dateUpload: e.releaseTime != null
                    ? DateTime.tryParse(
                            e.releaseTime!,
                          )?.millisecondsSinceEpoch.toString() ??
                          int.tryParse(e.releaseTime!)?.toString() ??
                          DateTime.now().millisecondsSinceEpoch.toString()
                    : DateTime.now().millisecondsSinceEpoch.toString(),
              ),
            )
            .toList() ??
        []);
    return MManga(
      name: item.name,
      imageUrl: item.cover,
      link: item.path,
      artist: item.artist,
      author: item.author,
      description: item.summary,
      status: switch (item.status) {
        "Ongoing" => Status.ongoing,
        "Completed" => Status.completed,
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
        'jsonStringify(() => extension.parseChapter(`$url`))',
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
    return _extensionCall(
      'pluginSettings',
      [],
    ).map((e) => SourcePreference.fromJson(e)..sourceId = source.id).toList();
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

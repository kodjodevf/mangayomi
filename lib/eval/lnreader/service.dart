import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/lnreader/http.dart';
import 'package:mangayomi/eval/lnreader/m_plugin.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

JavascriptRuntime getJavascriptRuntime({
  Map<String, dynamic>? extraArgs = const {},
}) {
  JavascriptRuntime runtime;
  runtime = QuickJsRuntime2(
    moduleHandler: (name) {
      return jsPackages[name] ?? "";
    },
  );
  runtime.enableHandlePromises();
  return runtime;
}

class LNReaderExtensionService implements ExtensionService {
  late JavascriptRuntime runtime;
  @override
  late Source source;

  LNReaderExtensionService(this.source);

  void _init() {
    runtime = getJavascriptRuntime();
    JsHttpClient(runtime).init();
    JsUtils(runtime).init();
    runtime.evaluate('''
module={},exports=Function("return this")(),Object.defineProperties(module,{namespace:{set:function(a){exports=a}},exports:{set:function(a){for(var b in a)a.hasOwnProperty(b)&&(exports[b]=a[b])},get:function(){return exports}}});
async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}''');
  }

  Future<void> _initAsync() async {
    runtime = getJavascriptRuntime();
    JsHttpClient(runtime).init();
    JsUtils(runtime).init();
    runtime.evaluate('''
module={},exports=Function("return this")(),Object.defineProperties(module,{namespace:{set:function(a){exports=a}},exports:{set:function(a){for(var b in a)a.hasOwnProperty(b)&&(exports[b]=a[b])},get:function(){return exports}}});
async function jsonStringify(fn) {
    return JSON.stringify(await fn());
}
${jsPackages["polyfill/form-data"]}
${jsPackages["polyfill/URLSearchParams"]}
${jsPackages["polyfill/URL"]}
''');
    await _importPackages();
    runtime.evaluate('''
${source.sourceCode}
var extension = exports.default;
''');
  }

  Future<void> _importPackages() async {
    try {
      await runtime.handlePromise(
        await runtime.evaluateAsync('''
const packageList = ["htmlparser2", "cheerio", "dayjs", "urlencode", "@libs/novelStatus", 
                     "@libs/isAbsoluteUrl", "@libs/filterInputs", "@libs/defaultCover"];
const packages = {};
async function importPackages() {
  for (const pkg of packageList) {
    const temp = await import(pkg);
    packages[pkg] = temp;
  }
}
importPackages();
const require = (package) => {
  switch (package) {
    case "htmlparser2":
        return {Parser: module.exports.Parser};
    case "cheerio":
        return {load: module.exports.load};
    case "dayjs":
        return {dayjs: module.exports.dayjs};
    case "urlencode":
        return {encode: module.exports.encode, decode: module.exports.decode};
    case "@libs/fetch":
        return {fetchApi: fetchApi};
    default:
      return packages[package];
  }
};
'''),
      );
    } catch (e) {
      rethrow;
    }
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
                ))
                as List<dynamic>)
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
                ))
                as List<dynamic>)
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
        ((await _extensionCallAsync('searchNovels("$query",$page)'))
                as List<dynamic>)
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
      await _extensionCallAsync('parseNovel(`$url`)'),
    );
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
      chapters:
          item.chapters
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
          [],
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
    await _initAsync();
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

  Future<T> _extensionCallAsync<T>(String call) async {
    await _initAsync();

    try {
      final promised = await runtime.handlePromise(
        await runtime.evaluateAsync('jsonStringify(() => extension.$call)'),
      );

      return jsonDecode(promised.stringResult) as T;
    } catch (e) {
      rethrow;
    }
  }
}

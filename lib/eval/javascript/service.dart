import 'dart:convert';
import 'package:flutter_qjs/flutter_qjs.dart';
import 'package:mangayomi/eval/javascript/dom_selector.dart';
import 'package:mangayomi/eval/javascript/extractors.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/preferences.dart';
import 'package:mangayomi/eval/javascript/utils.dart';
import 'package:mangayomi/eval/dart/model/filter.dart';
import 'package:mangayomi/eval/dart/model/m_manga.dart';
import 'package:mangayomi/eval/dart/model/m_pages.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

class JsExtensionService {
  late JavascriptRuntime runtime;
  late Source? source;
  JsExtensionService(this.source);

  void _init() {
    runtime = getJavascriptRuntime(xhr: false);
    JsHttpClient(runtime).init();
    JsDomSelector(runtime).init();
    JsVideosExtractors(runtime).init();
    JsUtils(runtime).init();
    JsPreferences(runtime, source).init();

    runtime.evaluate('''
class MProvider {
    get source() {
        return JSON.parse('${jsonEncode(source!.toMSource().toJson())}');
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
    runtime.evaluate('''${source!.sourceCode}
var extention = new DefaultExtension();
''');
  }

  Map<String, String> getHeaders(String url) {
    _init();
    try {
      final res = runtime
          .evaluate('JSON.stringify(extention.getHeaders(`$url`))')
          .stringResult;

      return (jsonDecode(res) as Map).toMapStringString!;
    } catch (_) {
      return {};
    }
  }

  bool get supportsLatest {
    _init();
    try {
      return jsonDecode(runtime
          .evaluate('JSON.stringify(extention.supportsLatest)')
          .stringResult) as bool;
    } catch (e) {
      return true;
    }
  }

  Future<MPages> getPopular(int page) async {
    _init();
    final res = (await runtime.handlePromise(await runtime
            .evaluateAsync('jsonStringify(() => extention.getPopular($page))')))
        .stringResult;

    return MPages.fromJson(jsonDecode(res));
  }

  Future<MPages> getLatestUpdates(int page) async {
    _init();
    final res = (await runtime.handlePromise(await runtime.evaluateAsync(
            'jsonStringify(() => extention.getLatestUpdates($page))')))
        .stringResult;

    return MPages.fromJson(jsonDecode(res));
  }

  Future<MPages> search(String query, int page, String filters) async {
    _init();
    final res = (await runtime.handlePromise(await runtime.evaluateAsync(
            'jsonStringify(() => extention.search("$query",$page,$filters))')))
        .stringResult;

    return MPages.fromJson(jsonDecode(res));
  }

  Future<MManga> getDetail(String url) async {
    _init();
    final res = (await runtime.handlePromise(await runtime
            .evaluateAsync('jsonStringify(() => extention.getDetail(`$url`))')))
        .stringResult;
    return MManga.fromJson(jsonDecode(res));
  }

  Future<List<PageUrl>> getPageList(String url) async {
    _init();
    final res = (await runtime.handlePromise(await runtime.evaluateAsync(
            'jsonStringify(() => extention.getPageList(`$url`))')))
        .stringResult;
    return (jsonDecode(res) as List)
        .map((e) => e is String
            ? PageUrl(e.toString().trim())
            : PageUrl.fromJson((e as Map).toMapStringDynamic!))
        .toList();
  }

  Future<List<Video>> getVideoList(String url) async {
    _init();
    final res = (await runtime.handlePromise(await runtime.evaluateAsync(
            'jsonStringify(() => extention.getVideoList(`$url`))')))
        .stringResult;

    return (jsonDecode(res) as List)
        .where((element) =>
            element['url'] != null && element['originalUrl'] != null)
        .map((e) => Video.fromJson(e))
        .toList()
        .toSet()
        .toList();
  }

  dynamic getFilterList() {
    _init();
    try {
      final res = runtime
          .evaluate('JSON.stringify(extention.getFilterList())')
          .stringResult;
      return FilterList(fromJsonFilterValuestoList(jsonDecode(res)));
    } catch (_) {
      return [];
    }
  }

  List<SourcePreference> getSourcePreferences() {
    _init();
    try {
      final res = runtime
          .evaluate('JSON.stringify(extention.getSourcePreferences())')
          .stringResult;
      return (jsonDecode(res) as List)
          .map((e) => SourcePreference.fromJson(e)..sourceId = source!.id)
          .toList();
    } catch (_) {
      return [];
    }
  }
}

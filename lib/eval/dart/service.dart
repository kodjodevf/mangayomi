import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:mangayomi/eval/dart/bridge/m_source.dart';
import 'package:mangayomi/eval/dart/compiler/compiler.dart';
import 'package:mangayomi/eval/dart/runtime/runtime.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class DartExtensionService implements ExtensionService {
  @override
  late Source source;

  DartExtensionService(this.source);

  MProvider _executeLib() {
    final bytecode = compilerEval(source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    return runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]) as MProvider;
  }

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    try {
      final bytecode = compilerEval(source.sourceCode!);
      final runtime = runtimeEval(bytecode);
      runtime.args = [$String(source.baseUrl!)];
      var res = runtime.executeLib(
        'package:mangayomi/main.dart',
        'getHeader',
      );
      if (res is $Map) {
        headers = (res.$reified).toMapStringString!;
      } else if (res is Map) {
        headers = res.toMapStringString!;
      } else {
        throw "";
      }
    } catch (_) {
      try {
        headers = _executeLib().headers;
      } catch (_) {
        return {};
      }
    }
    return headers;
  }

  @override
  String get sourceBaseUrl {
    String? baseUrl;
    try {
      baseUrl = _executeLib().baseUrl;
    } catch (_) {
      //
    }

    return baseUrl == null || baseUrl.isEmpty ? source.baseUrl! : baseUrl;
  }

  @override
  bool get supportsLatest {
    bool? supportsLatest;
    try {
      supportsLatest = _executeLib().supportsLatest;
    } catch (e) {
      supportsLatest = true;
    }
    return supportsLatest;
  }

  @override
  Future<MPages> getPopular(int page) async {
    return await _executeLib().getPopular(page);
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    return await _executeLib().getLatestUpdates(page);
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    return await _executeLib().search(query, page, FilterList(filters));
  }

  @override
  Future<MManga> getDetail(String url) async {
    return await _executeLib().getDetail(url);
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    return (await _executeLib().getPageList(url))
        .map((e) => e is String
            ? PageUrl(e.toString().trim())
            : PageUrl.fromJson((e as Map).toMapStringDynamic!))
        .toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    return await _executeLib().getVideoList(url);
  }

  @override
  Future<String> getHtmlContent(String url) async {
    return await _executeLib().getHtmlContent(url);
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;

    try {
      list = _executeLib()
          .getFilterList()
          .map((e) => e is $Value ? e.$reified : e)
          .toList();
    } catch (_) {
      list = [];
    }

    return FilterList(list);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    try {
      return _executeLib()
          .getSourcePreferences()
          .map((e) => (e is $Value ? e.$reified : e) as SourcePreference)
          .toList();
    } catch (_) {
      return [];
    }
  }
}

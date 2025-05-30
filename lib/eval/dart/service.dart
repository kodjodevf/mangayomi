import 'package:d4rt/d4rt.dart';
import 'package:mangayomi/eval/dart/bridge/registrer.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';

import '../interface.dart';

class DartExtensionService implements ExtensionService {
  @override
  late Source source;

  DartExtensionService(this.source);

  D4rt _executeLib() {
    final interpreter = D4rt();
    RegistrerBridge.registerBridge(interpreter);

    interpreter.execute(source: source.sourceCode!, args: source.toMSource());
    return interpreter;
  }

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = {};
    try {
      headers = _executeLib().invoke('headers', []) as Map<String, String>;
    } catch (_) {
      try {
        headers =
            _executeLib().invoke('getHeader', [source.baseUrl!])
                as Map<String, String>;
      } catch (_) {}
    }
    return headers;
  }

  @override
  String get sourceBaseUrl {
    String? baseUrl;
    try {
      final interpreter = _executeLib();
      baseUrl = interpreter.invoke('baseUrl', []) as String?;
    } catch (_) {}

    return baseUrl == null || baseUrl.isEmpty ? source.baseUrl! : baseUrl;
  }

  @override
  bool get supportsLatest {
    bool? supportsLatest;
    try {
      final interpreter = _executeLib();
      supportsLatest = interpreter.invoke('supportsLatest', []) as bool?;
    } catch (e) {
      supportsLatest = true;
    }
    return supportsLatest ?? true;
  }

  @override
  Future<MPages> getPopular(int page) async {
    try {
      final interpreter = _executeLib();
      final result = await interpreter.invoke('getPopular', [page]);
      return result as MPages;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getLatestUpdates', [page]);
    return result as MPages;
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('search', [
      query,
      page,
      FilterList(filters),
    ]);
    return result as MPages;
  }

  @override
  Future<MManga> getDetail(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getDetail', [url]);
    return result as MManga;
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getPageList', [url]);
    return (result as List)
        .map(
          (e) => e is String
              ? PageUrl(e.toString().trim())
              : PageUrl.fromJson((e as Map).toMapStringDynamic!),
        )
        .toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getVideoList', [url]);
    return (result as List).cast<Video>();
  }

  @override
  Future<String> getHtmlContent(String url, String? referer) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('getHtmlContent', [url, referer]);
    return result as String;
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    final interpreter = _executeLib();
    final result = await interpreter.invoke('cleanHtmlContent', [html]);
    return result as String;
  }

  @override
  FilterList getFilterList() {
    List<dynamic> list;
    try {
      final interpreter = _executeLib();
      list = interpreter.invoke('getFilterList', []) as List;
    } catch (_) {
      list = [];
    }

    return FilterList(_toValueList(list));
  }

  List _toValueList(List filters) {
    return (filters).map((e) {
      if (e is BridgedInstance) {
        e = e.nativeObject;
      }
      if (e is SelectFilter) {
        return SelectFilter(
          e.type,
          e.name,
          e.state,
          _toValueList(e.values),
          e.typeName,
        );
      } else if (e is SortFilter) {
        return SortFilter(
          e.type,
          e.name,
          e.state,
          _toValueList(e.values),
          e.typeName,
        );
      } else if (e is GroupFilter) {
        return GroupFilter(e.type, e.name, _toValueList(e.state), e.typeName);
      }
      return e;
    }).toList();
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    final interpreter = _executeLib();
    try {
      final result = interpreter.invoke('getSourcePreferences', []);
      return (result as List).cast();
    } catch (_) {
      return [];
    }
  }
}

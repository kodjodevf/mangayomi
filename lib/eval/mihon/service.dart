import 'dart:convert';
import 'dart:math';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';

import '../../models/manga.dart';
import '../interface.dart';
import 'models.dart';

class MihonExtensionService implements ExtensionService {
  late String androidProxyServer;
  @override
  late Source source;
  late InterceptedClient client;

  MihonExtensionService(this.source, this.androidProxyServer) {
    client = MClient.init();
  }

  @override
  Map<String, String> getHeaders() {
    return source.headers != null && source.headers!.isNotEmpty
        ? (jsonDecode(source.headers!) as Map?)?.toMapStringString ?? {}
        : {};
  }

  @override
  bool get supportsLatest {
    return source.supportLatest ?? false;
  }

  @override
  String get sourceBaseUrl {
    return source.baseUrl!;
  }

  @override
  Future<MPages> getPopular(int page) async {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getPopular$name",
        "page": page + 1,
        "search": "",
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final pages = MangaPages.fromJson(data, source.itemType);
    return MPages(
      list: pages.list
          .map(
            (e) => MManga(
              name: e.title,
              link: e.url,
              artist: e.artist,
              author: e.author,
              description: e.description,
              genre: e.genre,
              status: e.status,
              imageUrl: e.thumbnailUrl,
              chapters: [],
            ),
          )
          .toList(),
      hasNextPage: pages.hasNextPage,
    );
  }

  @override
  Future<MPages> getLatestUpdates(int page) async {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getLatest$name",
        "page": page + 1,
        "search": "",
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final pages = MangaPages.fromJson(data, source.itemType);
    return MPages(
      list: pages.list
          .map(
            (e) => MManga(
              name: e.title,
              link: e.url,
              artist: e.artist,
              author: e.author,
              description: e.description,
              genre: e.genre,
              status: e.status,
              imageUrl: e.thumbnailUrl,
              chapters: [],
            ),
          )
          .toList(),
      hasNextPage: pages.hasNextPage,
    );
  }

  @override
  Future<MPages> search(String query, int page, List<dynamic> filters) async {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getSearch$name",
        "page": max(1, page),
        "search": query,
        "filterList": _convertFilters(filters),
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final pages = MangaPages.fromJson(data, source.itemType);
    return MPages(
      list: pages.list
          .map(
            (e) => MManga(
              name: e.title,
              link: e.url,
              artist: e.artist,
              author: e.author,
              description: e.description,
              genre: e.genre,
              status: e.status,
              imageUrl: e.thumbnailUrl,
              chapters: [],
            ),
          )
          .toList(),
      hasNextPage: pages.hasNextPage,
    );
  }

  @override
  Future<MManga> getDetail(String url) async {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getDetails$name",
        if (source.itemType == ItemType.manga) "mangaData": {"url": url},
        if (source.itemType == ItemType.anime) "animeData": {"url": url},
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final chapters = await getChapterList(url);
    return MManga(
      name: data['title'],
      link: data['url'],
      artist: data['artist'],
      author: data['author'],
      description: data['description'],
      genre: (data['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: switch (data['status'] as int?) {
        1 => Status.ongoing,
        2 => Status.completed,
        4 => Status.publishingFinished,
        5 => Status.canceled,
        6 => Status.onHiatus,
        _ => Status.unknown,
      },
      imageUrl: data['thumbnail_url'],
      chapters: chapters,
    );
  }

  Future<List<MChapter>> getChapterList(String url) async {
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": source.itemType == ItemType.anime
            ? "getEpisodeList"
            : "getChapterList",
        if (source.itemType == ItemType.manga) "mangaData": {"url": url},
        if (source.itemType == ItemType.anime) "animeData": {"url": url},
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as List;
    return data
        .map(
          (e) => MChapter(
            name: e['name'],
            url: e['url'],
            dateUpload:
                (e['date_upload'] as int?)?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            scanlator: e['scanlator'],
          ),
        )
        .toList();
  }

  @override
  Future<List<PageUrl>> getPageList(String url) async {
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getPageList",
        "chapterData": {"url": url},
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as List;
    return data.map((e) => PageUrl(e['imageUrl'])).toList();
  }

  @override
  Future<List<Video>> getVideoList(String url) async {
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "getVideoList",
        "episodeData": {"url": url},
        "preferences": getSourcePreferences(),
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as List;
    return data.map((e) {
      final tempHeaders =
          e['headers']?['namesAndValues\$okhttp'] as List<dynamic>?;
      final Map<String, String> headers = {};
      if (tempHeaders != null) {
        for (var i = 0; i + 1 < tempHeaders.length; i += 2) {
          headers[tempHeaders[i]] = tempHeaders[i + 1];
        }
      }
      return Video(
        e['videoUrl'],
        e['quality'],
        e['url'],
        headers: headers,
        audios:
            (e['audioTracks'] as List?)
                ?.map(
                  (e) => Track(
                    file: e['file'] ?? e['url'],
                    label: e['label'] ?? e['lang'],
                  ),
                )
                .toList() ??
            [],
        subtitles:
            (e['subtitleTracks'] as List?)
                ?.map(
                  (e) => Track(
                    file: e['file'] ?? e['url'],
                    label: e['label'] ?? e['lang'],
                  ),
                )
                .toList() ??
            [],
      );
    }).toList();
  }

  @override
  Future<String> getHtmlContent(String name, String url) async {
    return "";
  }

  @override
  Future<String> cleanHtmlContent(String html) async {
    return html;
  }

  @override
  FilterList getFilterList() {
    return source.getFilterList() ?? FilterList([]);
  }

  @override
  List<SourcePreference> getSourcePreferences() {
    if (source.preferenceList == null) {
      return [];
    }
    final data = jsonDecode(source.preferenceList!) as List;
    return data.map((e) => SourcePreference.fromJson(e)).toList();
  }

  List<dynamic> _convertFilters(List<dynamic> filters) {
    return filters.expand((e) sync* {
      if (e is TextFilter) {
        yield {"name": e.name, "stateString": e.state, "type": "TextFilter"};
      } else if (e is GroupFilter) {
        yield {
          "name": e.name,
          "stateList": e.state.expand((e) sync* {
            if (e is CheckBoxFilter) {
              yield {
                "name": e.name,
                "stateBoolean": e.state,
                "type": "CheckBoxFilter",
              };
            } else if (e is TriStateFilter) {
              yield {
                "name": e.name,
                "stateInt": e.state,
                "type": "TriStateFilter",
              };
            }
          }).toList(),
          "type": "GroupFilter",
        };
      } else if (e is SelectFilter) {
        yield {"name": e.name, "stateInt": e.state, "type": "SelectFilter"};
      } else if (e is SortFilter) {
        yield {
          "name": e.name,
          "stateSort": {"ascending": e.state.ascending, "index": e.state.index},
          "type": "SortFilter",
        };
      }
    }).toList();
  }
}

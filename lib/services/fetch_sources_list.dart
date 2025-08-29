import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> fetchSourcesList({
  int? id,
  required bool refresh,
  required Ref ref,
  required ItemType itemType,
  required Repo? repo,
}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final url = repo?.jsonUrl;
  if (url == null) return;

  final req = await http.get(Uri.parse(url));
  final info = await PackageInfo.fromPlatform();

  final sourceList = (jsonDecode(req.body) as List)
      .expand((e) sync* {
        if (e['name'] != null &&
            e['pkg'] != null &&
            e['version'] != null &&
            e['code'] != null &&
            e['lang'] != null &&
            e['nsfw'] != null &&
            e['sources'] != null &&
            e['apk'] != null) {
          final repoUrl = url.replaceAll("/index.min.json", "");
          final sources = e['sources'] as List;
          for (final source in sources) {
            final src = Source.fromJson(e)
              ..apiUrl = ''
              ..appMinVerReq = ''
              ..dateFormat = ''
              ..dateFormatLocale = ''
              ..hasCloudflare = false
              ..headers = ''
              ..isActive = true
              ..isAdded = false
              ..isFullData = false
              ..isNsfw = e['nsfw'] == 1
              ..isPinned = false
              ..lastUsed = false
              ..sourceCode = ''
              ..typeSource = ''
              ..versionLast = '0.0.1'
              ..isObsolete = false
              ..isLocal = false
              ..name = source['name']
              ..lang = source['lang']
              ..baseUrl = source['baseUrl']
              ..sourceCodeUrl = "$repoUrl/apk/${e['apk']}"
              ..sourceCodeLanguage = SourceCodeLanguage.mihon
              ..itemType =
                  (e['pkg'] as String).startsWith(
                    "eu.kanade.tachiyomi.animeextension",
                  )
                  ? ItemType.anime
                  : ItemType.manga
              ..iconUrl = "$repoUrl/icon/${e['pkg']}.png"
              ..notes =
                  "Requires Android Proxy Server (ApkBridge) for installing and using the extensions!";
            src.id = 'mihon-${source['id']}'.hashCode;
            yield src;
          }
        } else {
          yield Source.fromJson(e);
        }
      })
      .where(
        (source) =>
            source.itemType == itemType &&
            source.appMinVerReq != null &&
            compareVersions(info.version, source.appMinVerReq!) > -1,
      )
      .toList();

  if (id != null) {
    final matchingSource = sourceList.firstWhere(
      (source) => source.id == id,
      orElse: () => Source(),
    );
    if (matchingSource.id != null && matchingSource.sourceCodeUrl!.isNotEmpty) {
      await _updateSource(matchingSource, ref, repo, itemType);
    }
  } else {
    for (var source in sourceList) {
      final existingSource = await isar.sources.get(source.id!);
      if (existingSource == null) {
        await _addNewSource(source, ref, repo, itemType);
        continue;
      }
      final shouldUpdate =
          existingSource.isAdded! &&
          compareVersions(existingSource.version!, source.version!) < 0;
      if (!shouldUpdate) continue;
      if (ref.read(autoUpdateExtensionsStateProvider)) {
        await _updateSource(source, ref, repo, itemType);
      } else {
        await isar.writeTxn(() async {
          isar.sources.put(existingSource..versionLast = source.version);
        });
      }
    }
  }

  checkIfSourceIsObsolete(sourceList, repo!, itemType, ref);
}

Future<void> _updateSource(
  Source source,
  Ref ref,
  Repo? repo,
  ItemType itemType,
) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final req = await http.get(Uri.parse(source.sourceCodeUrl!));
  final sourceCode = source.sourceCodeLanguage == SourceCodeLanguage.mihon
      ? base64.encode(req.bodyBytes)
      : req.body;
  final androidProxyServer = ref.read(androidProxyServerStateProvider);
  Map<String, String> headers = {};
  bool? supportLatest;
  FilterList? filterList;
  List<SourcePreference>? preferenceList;
  if (source.sourceCodeLanguage == SourceCodeLanguage.mihon) {
    headers = await fetchHeadersDalvik(
      http,
      source..sourceCode = sourceCode,
      androidProxyServer,
    );
    supportLatest = await fetchSupportLatestDalvik(
      http,
      source..sourceCode = sourceCode,
      androidProxyServer,
    );
    filterList = await fetchFilterListDalvik(
      http,
      source..sourceCode = sourceCode,
      androidProxyServer,
    );
    preferenceList = await fetchPreferencesDalvik(
      http,
      source..sourceCode = sourceCode,
      androidProxyServer,
    );
  } else {
    headers = getExtensionService(
      source..sourceCode = sourceCode,
      androidProxyServer,
    ).getHeaders();
  }

  final updatedSource = Source()
    ..headers = jsonEncode(headers)
    ..supportLatest = supportLatest
    ..filterList = filterList != null ? jsonEncode(filterList.toJson()) : null
    ..preferenceList = preferenceList != null
        ? jsonEncode(preferenceList.map((e) => e.toJson()).toList())
        : null
    ..isAdded = true
    ..sourceCode = sourceCode
    ..sourceCodeUrl = source.sourceCodeUrl
    ..id = source.id
    ..apiUrl = source.apiUrl
    ..baseUrl = source.baseUrl
    ..dateFormat = source.dateFormat
    ..dateFormatLocale = source.dateFormatLocale
    ..hasCloudflare = source.hasCloudflare
    ..iconUrl = source.iconUrl
    ..typeSource = source.typeSource
    ..lang = source.lang
    ..isNsfw = source.isNsfw
    ..name = source.name
    ..version = source.version
    ..versionLast = source.version
    ..itemType = itemType
    ..isFullData = source.isFullData ?? false
    ..appMinVerReq = source.appMinVerReq
    ..sourceCodeLanguage = source.sourceCodeLanguage
    ..additionalParams = source.additionalParams ?? ""
    ..isObsolete = false
    ..notes = source.notes
    ..repo = repo
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;

  await isar.writeTxn(() async => isar.sources.put(updatedSource));
}

Future<void> _addNewSource(
  Source source,
  Ref ref,
  Repo? repo,
  ItemType itemType,
) async {
  final newSource = Source()
    ..sourceCodeUrl = source.sourceCodeUrl
    ..id = source.id
    ..sourceCode = source.sourceCode
    ..apiUrl = source.apiUrl
    ..baseUrl = source.baseUrl
    ..dateFormat = source.dateFormat
    ..dateFormatLocale = source.dateFormatLocale
    ..hasCloudflare = source.hasCloudflare
    ..iconUrl = source.iconUrl
    ..typeSource = source.typeSource
    ..lang = source.lang
    ..isNsfw = source.isNsfw
    ..name = source.name
    ..version = source.version
    ..versionLast = source.version
    ..itemType = itemType
    ..sourceCodeLanguage = source.sourceCodeLanguage
    ..isFullData = source.isFullData ?? false
    ..appMinVerReq = source.appMinVerReq
    ..isObsolete = false
    ..notes = source.notes
    ..repo = repo
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;
  await isar.writeTxn(() async => isar.sources.put(newSource));
}

Future<void> checkIfSourceIsObsolete(
  List<Source> sourceList,
  Repo repo,
  ItemType itemType,
  Ref ref,
) async {
  if (sourceList.isEmpty) return;

  final sources = await isar.sources
      .filter()
      .idIsNotNull()
      .itemTypeEqualTo(itemType)
      .and()
      .isLocalEqualTo(false)
      .findAll();

  if (sources.isEmpty) return;

  final sourceIds = sourceList
      .where((e) => e.id != null)
      .map((e) => e.id!)
      .toSet();

  if (sourceIds.isEmpty) return;

  final toUpdate = <Source>[];
  for (var source in sources) {
    final isNowObsolete =
        !sourceIds.contains(source.id) && source.repo?.jsonUrl == repo.jsonUrl;

    if (source.isObsolete != isNowObsolete) {
      source.isObsolete = isNowObsolete;
      source.updatedAt = DateTime.now().millisecondsSinceEpoch;
      toUpdate.add(source);
    }
  }
  if (toUpdate.isEmpty) return;

  await isar.writeTxn(() => isar.sources.putAll(toUpdate));
}

int compareVersions(String version1, String version2) {
  final v1Parts = version1.split('.');
  final v2Parts = version2.split('.');
  final minLength = v1Parts.length < v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (var i = 0; i < minLength; i++) {
    final v1Value = int.parse(v1Parts[i].padRight(2, '0'));
    final v2Value = int.parse(v2Parts[i].padRight(2, '0'));

    final comparison = v1Value.compareTo(v2Value);
    if (comparison != 0) return comparison;
  }

  return v1Parts.length.compareTo(v2Parts.length);
}

Future<Map<String, String>> fetchHeadersDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({"method": "headers$name", "data": source.sourceCode}),
    );
    final data = jsonDecode(res.body) as List;
    final Map<String, String> headers = {};
    for (var i = 0; i + 1 < data.length; i += 2) {
      headers[data[i]] = data[i + 1];
    }
    return headers;
  } catch (_) {
    return {};
  }
}

Future<bool> fetchSupportLatestDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "supportLatest$name",
        "data": source.sourceCode,
      }),
    );
    return res.body.trim() == "true";
  } catch (_) {
    return false;
  }
}

Future<FilterList?> fetchFilterListDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({"method": "filters$name", "data": source.sourceCode}),
    );
    final data = jsonDecode(res.body) as List;
    final filters = data.expand((e) sync* {
      if (e['name'] is String &&
          e['state'] is Map<String, dynamic> &&
          e['values'] is List) {
        yield SortFilter(
          "${e['name']}Filter",
          e['name'],
          SortState(e['state']['index'], e['state']['ascending'], null),
          (e['values'] as List)
              .map((e) => SelectFilterOption(e, e, null))
              .toList(),
          null,
        );
      } else if (e['name'] is String &&
          e['state'] is int &&
          (e['values'] is List || e['vals'] is List)) {
        yield SelectFilter(
          "${e['name']}Filter",
          e['name'],
          e['state'],
          e['vals'] is List
              ? (e['vals'] as List)
                    .map(
                      (e) => SelectFilterOption(e['first'], e['second'], null),
                    )
                    .toList()
              : e['values'] is List
              ? (e['values'] as List)
                    .map((e) => SelectFilterOption(e, e, null))
                    .toList()
              : [],
          "SelectFilter",
        );
      } else if (e['name'] is String && e['state'] is List) {
        yield GroupFilter(
          "${e['name']}Filter",
          e['name'],
          (e['state'] as List).map((e) {
            if (e['included'] is bool &&
                e['ignored'] is bool &&
                e['excluded'] is bool) {
              return TriStateFilter(
                null,
                e['name'],
                e['id'] ?? e['name'],
                null,
                state: e['state'],
              );
            }
            return CheckBoxFilter(
              null,
              e['name'],
              e['id'] ?? e['name'],
              null,
              state: e['state'],
            );
          }).toList(),
          "GroupFilter",
        );
      } else if (e['name'] is String && e['state'] is String) {
        yield TextFilter(
          "${e['name']}Filter",
          e['name'],
          null,
          state: e['state'],
        );
      } else if (e['name'] is String && e['state'] is int) {
        yield HeaderFilter(e['name'], "${e['name']}Filter");
      }
    }).toList();
    return FilterList(filters);
  } catch (_) {
    return null;
  }
}

Future<List<SourcePreference>?> fetchPreferencesDalvik(
  InterceptedClient client,
  Source source,
  String androidProxyServer,
) async {
  try {
    final name = source.itemType == ItemType.anime ? "Anime" : "Manga";
    final res = await client.post(
      Uri.parse("$androidProxyServer/dalvik"),
      body: jsonEncode({
        "method": "preferences$name",
        "data": source.sourceCode,
      }),
    );
    final data = jsonDecode(res.body) as List;
    return data
        .map(
          (e) => SourcePreference.fromJson(e)
            ..id = null
            ..sourceId = source.id,
        )
        .toList();
  } catch (_) {
    return null;
  }
}

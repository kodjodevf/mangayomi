import 'dart:convert';
import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/proto/mihon_extension_store.pb.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/log/logger.dart';

class ExtensionStoreFetchResult {
  final String name;
  final String? website;
  final String indexUrl;
  final List<Source> sources;

  ExtensionStoreFetchResult({
    required this.name,
    this.website,
    required this.indexUrl,
    required this.sources,
  });
}

class ExtensionStoreService {
  static List<int> _decompressIfGzipped(List<int> bytes) {
    if (bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B) {
      try {
        return gzip.decode(bytes);
      } catch (_) {
        return bytes;
      }
    }
    return bytes;
  }

  /// Fetches store info and extension sources from [indexUrl].
  /// Supports:
  /// 1. Protobuf (.pb) binary index payloads.
  /// 2. JSON index payloads (NetworkExtensionStore or NetworkLegacyExtensionRepo).
  /// 3. Legacy index.min.json payloads.
  static Future<ExtensionStoreFetchResult?> fetchStore(
    String indexUrl,
    InterceptedClient client,
  ) async {
    try {
      var currentUrl = indexUrl;
      final response = await client.get(Uri.parse(currentUrl));
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return null;
      }

      var bytes = _decompressIfGzipped(response.bodyBytes);
      if (bytes.isEmpty) return null;

      final firstByte = bytes[0];

      // 1. Legacy JSON array: Starts with '[' (0x5B)
      if (firstByte == 0x5B) {
        if (currentUrl.endsWith('/index.min.json')) {
          final repoUrl = currentUrl.replaceAll(
            '/index.min.json',
            '/repo.json',
          );
          try {
            final repoRes = await client.get(Uri.parse(repoUrl));
            if (repoRes.statusCode == 200) {
              final repoJson = jsonDecode(repoRes.body);
              if (repoJson is Map &&
                  repoJson['index_v2'] != null &&
                  (repoJson['index_v2'] as String).isNotEmpty) {
                // Redirect to V2 index (.pb or JSON store)
                return await fetchStore(repoJson['index_v2'] as String, client);
              }
            }
          } catch (e, st) {
            // Falls through to the legacy parser, so a broken v2 redirect just
            // looks like an empty repo.
            AppLogger.log(
              'fetchStore: index_v2 redirect failed: $e\n$st',
              logLevel: LogLevel.error,
            );
          }
        }
        return _parseLegacyJsonStore(currentUrl, bytes);
      }

      // 2. JSON object: Starts with '{' (0x7B)
      if (firstByte == 0x7B) {
        final text = utf8.decode(bytes);
        final jsonMap = jsonDecode(text);
        if (jsonMap is Map<String, dynamic>) {
          // Check for index_v2 redirect in legacy repo JSON
          if (jsonMap['index_v2'] != null &&
              (jsonMap['index_v2'] as String).isNotEmpty) {
            return await fetchStore(jsonMap['index_v2'] as String, client);
          }

          // Try parsing JSON NetworkExtensionStore
          return await _parseJsonNetworkStore(currentUrl, jsonMap, client);
        }
      }

      // 3. Binary Protobuf: NetworkExtensionStore
      return await _parseProtobufStore(currentUrl, bytes, client);
    } catch (_) {
      return null;
    }
  }

  static Future<ExtensionStoreFetchResult?> _parseProtobufStore(
    String indexUrl,
    List<int> bytes,
    InterceptedClient client,
  ) async {
    try {
      final store = NetworkExtensionStore.fromBuffer(bytes);
      final repoName = store.name.isNotEmpty ? store.name : 'Mihon Repo';
      final website = store.hasField(4) && store.contact.website.isNotEmpty
          ? store.contact.website
          : null;

      List<ExtensionStoreItem> extensionItems = [];

      if (store.hasField(101) && store.extensionList.extensions.isNotEmpty) {
        extensionItems = store.extensionList.extensions;
      } else if (store.extensionListUrl.isNotEmpty) {
        final resolvedListUrl = Uri.parse(indexUrl)
            .resolve(store.extensionListUrl)
            .toString();
        final listRes = await client.get(Uri.parse(resolvedListUrl));
        if (listRes.statusCode == 200 && listRes.bodyBytes.isNotEmpty) {
          final listBytes = _decompressIfGzipped(listRes.bodyBytes);
          if (listBytes.isNotEmpty && listBytes[0] == 0x7B) {
            // JSON extension list
            final jsonList = jsonDecode(utf8.decode(listBytes));
            if (jsonList is Map && jsonList['extensions'] is List) {
              for (final extJson in jsonList['extensions']) {
                extensionItems.add(_extensionItemFromJson(extJson));
              }
            }
          } else if (listBytes.isNotEmpty) {
            // Protobuf ExtensionStoreExtensionList
            final extListProto = ExtensionStoreExtensionList.fromBuffer(
              listBytes,
            );
            extensionItems = extListProto.extensions;
          }
        }
      }

      final sources = _convertProtobufExtensionsToSources(
        indexUrl,
        extensionItems,
      );

      return ExtensionStoreFetchResult(
        name: repoName,
        website: website,
        indexUrl: indexUrl,
        sources: sources,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<ExtensionStoreFetchResult?> _parseJsonNetworkStore(
    String indexUrl,
    Map<String, dynamic> jsonMap,
    InterceptedClient client,
  ) async {
    try {
      // 1. Check if it's an Aidoku format repository index (e.g. index.min.json with "sources": [...])
      if (jsonMap['sources'] is List) {
        final aidokuResult = _parseAidokuJsonStore(indexUrl, jsonMap);
        if (aidokuResult != null && aidokuResult.sources.isNotEmpty) {
          return aidokuResult;
        }
      }

      final meta = jsonMap['meta'] as Map<String, dynamic>?;
      final repoName =
          (meta?['name'] as String?) ??
          (jsonMap['name'] as String?) ??
          'Mihon Repo';
      final website =
          (meta?['website'] as String?) ??
          (jsonMap['contact']?['website'] as String?);

      List<dynamic> rawExtensions = [];

      if (jsonMap['extensionList']?['extensions'] is List) {
        rawExtensions = jsonMap['extensionList']['extensions'] as List;
      } else if (jsonMap['extensionListUrl'] is String &&
          (jsonMap['extensionListUrl'] as String).isNotEmpty) {
        final listUrl = Uri.parse(indexUrl)
            .resolve(jsonMap['extensionListUrl'] as String)
            .toString();
        final listRes = await client.get(Uri.parse(listUrl));
        if (listRes.statusCode == 200) {
          final listBytes = _decompressIfGzipped(listRes.bodyBytes);
          final jsonList = jsonDecode(utf8.decode(listBytes));
          if (jsonList is Map && jsonList['extensions'] is List) {
            rawExtensions = jsonList['extensions'] as List;
          }
        }
      }

      final sources = _convertJsonExtensionsToSources(indexUrl, rawExtensions);

      return ExtensionStoreFetchResult(
        name: repoName,
        website: website,
        indexUrl: indexUrl,
        sources: sources,
      );
    } catch (_) {
      return null;
    }
  }

  static ExtensionStoreFetchResult? _parseAidokuJsonStore(
    String indexUrl,
    Map<String, dynamic> jsonMap,
  ) {
    try {
      final rawSources = jsonMap['sources'];
      if (rawSources is! List) return null;

      final repoName = (jsonMap['name'] as String?) ?? 'Aidoku Sources';
      final baseUri = Uri.parse(indexUrl);
      final sources = <Source>[];

      for (final e in rawSources) {
        if (e is! Map<String, dynamic>) continue;
        final rawDownloadUrl =
            (e['downloadURL'] as String?) ?? (e['file'] as String?);
        final rawIconUrl = (e['iconURL'] as String?) ?? (e['icon'] as String?);

        final downloadUrl = rawDownloadUrl != null && rawDownloadUrl.isNotEmpty
            ? baseUri.resolve(rawDownloadUrl).toString()
            : '';
        final iconUrl = rawIconUrl != null && rawIconUrl.isNotEmpty
            ? baseUri.resolve(rawIconUrl).toString()
            : (e['id'] != null
                  ? baseUri.resolve('icons/${e['id']}.png').toString()
                  : '');

        final langs =
            (e['languages'] as List?)?.map((l) => l.toString()).toList() ??
            [(e['lang'] as String?) ?? 'all'];

        final rating = e['contentRating'] ?? e['nsfw'] ?? 0;
        final isNsfw = rating is int
            ? rating >= 2
            : (rating == true || rating == 1);
        final baseUrl =
            (e['baseURL'] as String?) ?? (e['url'] as String?) ?? '';
        final name = (e['name'] as String?) ?? (e['id'] as String?) ?? 'Source';
        final version = e['version'] != null ? '${e['version']}.0.0' : '1.0.0';

        for (final lang in langs) {
          final src = Source()
            ..apiUrl = ''
            ..appMinVerReq = ''
            ..dateFormat = ''
            ..dateFormatLocale = ''
            ..hasCloudflare = false
            ..headers = ''
            ..isActive = true
            ..isAdded = false
            ..isFullData = false
            ..isNsfw = isNsfw
            ..isPinned = false
            ..lastUsed = false
            ..sourceCode = ''
            ..typeSource = ''
            ..version = version
            ..versionLast = '0.0.1'
            ..isObsolete = false
            ..isLocal = false
            ..name = name
            ..lang = lang
            ..baseUrl = baseUrl
            ..sourceCodeUrl = downloadUrl
            ..sourceCodeLanguage = SourceCodeLanguage.aidoku
            ..itemType = ItemType.manga
            ..iconUrl = iconUrl
            ..notes = null;
          src.id = 'aidoku-${e['id']}-$lang'.hashCode.abs();
          sources.add(src);
        }
      }

      return ExtensionStoreFetchResult(
        name: repoName,
        website: indexUrl,
        indexUrl: indexUrl,
        sources: sources,
      );
    } catch (_) {
      return null;
    }
  }

  static ExtensionStoreFetchResult? _parseLegacyJsonStore(
    String indexUrl,
    List<int> bytes,
  ) {
    try {
      final jsonList = jsonDecode(utf8.decode(bytes));
      if (jsonList is! List) return null;

      final repoBaseUrl = indexUrl.replaceAll('/index.min.json', '');
      final sources = <Source>[];

      for (final e in jsonList) {
        if (e is! Map<String, dynamic>) continue;
        if (e['file'] != null && (e['file'] as String).endsWith('.aix')) {
          final langs =
              (e['languages'] as List?)?.map((l) => l.toString()).toList() ??
              [(e['lang'] as String?) ?? 'all'];
          final isNsfw = (e['nsfw'] ?? 0) != 0;
          final icon = e['icon'] != null
              ? (e['icon'] as String).startsWith('http')
                    ? e['icon'] as String
                    : '$repoBaseUrl/${e['icon']}'
              : '$repoBaseUrl/icons/${e['id']}.png';
          final sourceUrl = (e['file'] as String).startsWith('http')
              ? e['file'] as String
              : '$repoBaseUrl/${e['file']}';
          final urls = (e['urls'] as List?)?.map((u) => u.toString()).toList();
          final baseUrl = urls?.firstOrNull ?? (e['url'] as String?) ?? '';

          for (final lang in langs) {
            final src = Source()
              ..apiUrl = ''
              ..appMinVerReq = (e['min_app_version'] as String?) ?? ''
              ..dateFormat = ''
              ..dateFormatLocale = ''
              ..hasCloudflare = false
              ..headers = ''
              ..isActive = true
              ..isAdded = false
              ..isFullData = false
              ..isNsfw = isNsfw
              ..isPinned = false
              ..lastUsed = false
              ..sourceCode = ''
              ..typeSource = ''
              ..version = '${e['version'] ?? 1}.0.0'
              ..versionLast = '0.0.1'
              ..isObsolete = false
              ..isLocal = false
              ..name = e['name']
              ..lang = lang
              ..baseUrl = baseUrl
              ..sourceCodeUrl = sourceUrl
              ..sourceCodeLanguage = SourceCodeLanguage.aidoku
              ..itemType = ItemType.manga
              ..iconUrl = icon
              ..notes = null;
            src.id = 'aidoku-${e['id']}-$lang'.hashCode;
            sources.add(src);
          }
          continue;
        }
        if (e['name'] != null &&
            e['pkg'] != null &&
            e['version'] != null &&
            e['code'] != null &&
            e['lang'] != null &&
            e['nsfw'] != null &&
            e['sources'] != null &&
            e['apk'] != null) {
          final subSources = e['sources'] as List;
          for (final source in subSources) {
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
              ..sourceCodeUrl = '$repoBaseUrl/apk/${e['apk']}'
              ..sourceCodeLanguage = SourceCodeLanguage.mihon
              ..itemType =
                  (e['pkg'] as String).startsWith(
                    'eu.kanade.tachiyomi.animeextension',
                  )
                  ? ItemType.anime
                  : ItemType.manga
              ..iconUrl = '$repoBaseUrl/icon/${e['pkg']}.png'
              ..notes = null;
            src.id = 'mihon-${source['id']}'.hashCode;
            sources.add(src);
          }
        }
      }

      final repoName =
          repoBaseUrl.split('/').where((s) => s.isNotEmpty).lastOrNull ??
          'Mihon Repo';

      return ExtensionStoreFetchResult(
        name: repoName,
        website: repoBaseUrl,
        indexUrl: indexUrl,
        sources: sources,
      );
    } catch (_) {
      return null;
    }
  }

  static List<Source> _convertProtobufExtensionsToSources(
    String indexUrl,
    List<ExtensionStoreItem> extensions,
  ) {
    final sources = <Source>[];
    final baseUri = Uri.parse(indexUrl);

    for (final ext in extensions) {
      final pkgName = ext.packageName;
      final versionName = ext.versionName;
      final isNsfw = ext.contentWarning >= 2; // 2 = MIXED, 3 = NSFW

      final apkUrl = ext.hasField(3) && ext.resources.apkUrl.isNotEmpty
          ? baseUri.resolve(ext.resources.apkUrl).toString()
          : '';
      final iconUrl = ext.hasField(3) && ext.resources.iconUrl.isNotEmpty
          ? baseUri.resolve(ext.resources.iconUrl).toString()
          : '';

      final itemType = pkgName.startsWith('eu.kanade.tachiyomi.animeextension')
          ? ItemType.anime
          : ItemType.manga;

      for (final src in ext.sources) {
        final source = Source()
          ..apiUrl = ''
          ..appMinVerReq = ''
          ..dateFormat = ''
          ..dateFormatLocale = ''
          ..hasCloudflare = false
          ..headers = ''
          ..isActive = true
          ..isAdded = false
          ..isFullData = false
          ..isNsfw = isNsfw
          ..isPinned = false
          ..lastUsed = false
          ..sourceCode = ''
          ..typeSource = ''
          ..version = versionName
          ..versionLast = versionName
          ..isObsolete = false
          ..isLocal = false
          ..name = src.name
          ..lang = src.language
          ..baseUrl = src.homeUrl
          ..sourceCodeUrl = apkUrl
          ..iconUrl = iconUrl
          ..sourceCodeLanguage = SourceCodeLanguage.mihon
          ..itemType = itemType
          ..notes = null;

        source.id = 'mihon-${src.id}'.hashCode;
        sources.add(source);
      }
    }

    return sources;
  }

  static List<Source> _convertJsonExtensionsToSources(
    String indexUrl,
    List<dynamic> rawExtensions,
  ) {
    final sources = <Source>[];
    final baseUri = Uri.parse(indexUrl);

    for (final e in rawExtensions) {
      if (e is! Map<String, dynamic>) continue;
      final pkgName =
          (e['packageName'] as String?) ?? (e['pkg'] as String?) ?? '';
      final versionName =
          (e['versionName'] as String?) ?? (e['version'] as String?) ?? '0.0.1';
      final contentWarning = e['contentWarning'];
      final isNsfw = contentWarning is int
          ? contentWarning >= 2
          : (e['nsfw'] == 1 || e['nsfw'] == true);

      final resources = e['resources'] as Map<String, dynamic>?;
      final rawApkUrl =
          (resources?['apkUrl'] as String?) ??
          (e['apk'] != null ? 'apk/${e['apk']}' : '');
      final rawIconUrl =
          (resources?['iconUrl'] as String?) ??
          (pkgName.isNotEmpty ? 'icon/$pkgName.png' : '');

      final apkUrl = rawApkUrl.isNotEmpty
          ? baseUri.resolve(rawApkUrl).toString()
          : '';
      final iconUrl = rawIconUrl.isNotEmpty
          ? baseUri.resolve(rawIconUrl).toString()
          : '';

      final itemType = pkgName.startsWith('eu.kanade.tachiyomi.animeextension')
          ? ItemType.anime
          : ItemType.manga;

      final srcList = e['sources'] as List?;
      if (srcList != null) {
        for (final srcJson in srcList) {
          if (srcJson is! Map<String, dynamic>) continue;
          final srcName = (srcJson['name'] as String?) ?? '';
          final srcLang =
              (srcJson['language'] as String?) ??
              (srcJson['lang'] as String?) ??
              'all';
          final srcBaseUrl =
              (srcJson['homeUrl'] as String?) ??
              (srcJson['baseUrl'] as String?) ??
              '';
          final srcId = srcJson['id'];

          final source = Source()
            ..apiUrl = ''
            ..appMinVerReq = ''
            ..dateFormat = ''
            ..dateFormatLocale = ''
            ..hasCloudflare = false
            ..headers = ''
            ..isActive = true
            ..isAdded = false
            ..isFullData = false
            ..isNsfw = isNsfw
            ..isPinned = false
            ..lastUsed = false
            ..sourceCode = ''
            ..typeSource = ''
            ..version = versionName
            ..versionLast = versionName
            ..isObsolete = false
            ..isLocal = false
            ..name = srcName
            ..lang = srcLang
            ..baseUrl = srcBaseUrl
            ..sourceCodeUrl = apkUrl
            ..iconUrl = iconUrl
            ..sourceCodeLanguage = SourceCodeLanguage.mihon
            ..itemType = itemType
            ..notes = null;

          source.id = 'mihon-$srcId'.hashCode;
          sources.add(source);
        }
      }
    }

    return sources;
  }

  static ExtensionStoreItem _extensionItemFromJson(Map<String, dynamic> json) {
    final resourcesJson = json['resources'] as Map<String, dynamic>?;
    final sourcesList = (json['sources'] as List?) ?? [];

    return ExtensionStoreItem(
      name: json['name'] as String?,
      packageName: json['packageName'] as String?,
      resources: ExtensionStoreResources(
        apkUrl: resourcesJson?['apkUrl'] as String?,
        iconUrl: resourcesJson?['iconUrl'] as String?,
      ),
      extensionLib: json['extensionLib'] as String?,
      versionName: json['versionName'] as String?,
      contentWarning: json['contentWarning'] as int?,
      sources: sourcesList.map((s) {
        final srcMap = s as Map<String, dynamic>;
        return ExtensionStoreSource(
          name: srcMap['name'] as String?,
          language:
              (srcMap['language'] as String?) ?? (srcMap['lang'] as String?),
          homeUrl:
              (srcMap['homeUrl'] as String?) ?? (srcMap['baseUrl'] as String?),
        );
      }),
    );
  }
}

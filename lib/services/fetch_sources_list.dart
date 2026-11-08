import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/eval/aidoku/service.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/isolate_service.dart';
import 'package:mangayomi/services/extension_store_service.dart';
import 'package:mangayomi/services/extension_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// The extensions [repo] lists for [itemType] that this version of the app
/// can run.
Future<List<Source>> fetchRepoSources({
  required Repo repo,
  required ItemType itemType,
}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final url = repo.jsonUrl;
  if (url == null) return [];

  if (repo.name == null ||
      repo.name!.isEmpty ||
      repo.name == '.dist' ||
      repo.name == 'dist') {
    final uri = Uri.tryParse(url);
    if (uri != null &&
        uri.host == 'raw.githubusercontent.com' &&
        uri.pathSegments.length >= 2) {
      repo.name = uri.pathSegments[1];
    }
  }

  final info = await PackageInfo.fromPlatform();

  List<Source> sourceList = [];

  // Try parsing with ExtensionStoreService (.pb, NetworkExtensionStore JSON, or legacy min.json)
  final storeResult = await ExtensionStoreService.fetchStore(url, http);
  if (storeResult != null && storeResult.sources.isNotEmpty) {
    sourceList = storeResult.sources
        .where(
          (source) =>
              source.itemType == itemType &&
              (source.sourceCodeLanguage == SourceCodeLanguage.aidoku ||
                  source.sourceCodeLanguage == SourceCodeLanguage.lnreader ||
                  source.appMinVerReq == null ||
                  source.appMinVerReq!.isEmpty ||
                  compareVersions(info.version, source.appMinVerReq!) > -1),
        )
        .toList();
  } else {
    // Fallback parsing for non-Mihon direct JSON lists (LNReader or custom format)
    try {
      final req = await http.get(Uri.parse(url));
      if (req.statusCode == 200) {
        final decoded = jsonDecode(req.body);
        if (decoded is List) {
          sourceList = decoded
              .expand((e) sync* {
                if (e['id'] is String &&
                    e['name'] != null &&
                    e['site'] != null &&
                    e['lang'] != null &&
                    e['version'] != null &&
                    e['url'] != null &&
                    e['iconUrl'] != null) {
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
                    ..isNsfw = false
                    ..isPinned = false
                    ..lastUsed = false
                    ..sourceCode = ''
                    ..typeSource = ''
                    ..versionLast = e['version'] ?? '0.0.1'
                    ..isObsolete = false
                    ..isLocal = false
                    ..lang = _convertLang(e)
                    ..baseUrl = e['site']
                    ..sourceCodeUrl = e['url']
                    ..sourceCodeLanguage = SourceCodeLanguage.lnreader
                    ..itemType = ItemType.novel
                    ..notes = "Performance might be poor due to limited engine";
                  src.id =
                      'lnreader-plugin-"${src.name}"."${src.lang}"'.hashCode;
                  yield src;
                } else {
                  yield Source.fromJson(e);
                }
              })
              .where(
                (source) =>
                    source.itemType == itemType &&
                    (source.appMinVerReq == null ||
                        source.appMinVerReq!.isEmpty ||
                        compareVersions(info.version, source.appMinVerReq!) >
                            -1),
              )
              .toList();
        }
      }
    } catch (e, st) {
      // A failure here drops sources from the list with no sign of why.
      AppLogger.log(
        'fetchRepoSources: filtering sources failed: $e\n$st',
        logLevel: LogLevel.error,
      );
    }
  }

  return sourceList;
}

/// Takes in what [repo] lists: an extension seen for the first time is
/// added, and one it no longer lists is marked obsolete.
Future<void> recordRepoSources(
  List<Source> sourceList,
  Repo repo,
  ItemType itemType,
) async {
  for (final source in sourceList) {
    if (await sourceRepository.findByIdAsync(source.id!) == null) {
      await _addNewSource(source, repo, itemType);
    }
  }
  await checkIfSourceIsObsolete(sourceList, repo, itemType);
}

/// Points extensions installed from an address [repos] no longer has at the
/// repository it moved to. Only the old address itself is believed: it names
/// its replacement ([resolveIndexUrl], by default following its index's
/// redirect), which a repository merely wearing the same name cannot do.
Future<void> followMovedRepos({
  required List<Repo> repos,
  required Map<int, List<ExtensionOffer>> offers,
  required ItemType itemType,
  Future<String?> Function(String url)? resolveIndexUrl,
}) async {
  final installed = sourceRepository.getAddedByItemType(itemType);
  final resolve = resolveIndexUrl ?? _resolveIndexUrl;
  for (final url in movedOriginCandidates(installed, repos, offers)) {
    final resolved = await resolve(url);
    if (resolved == null) continue;
    final current = repos
        .where((r) => isSameRepo(r, Repo(jsonUrl: resolved)))
        .firstOrNull;
    if (current == null) continue;
    for (final source in installed) {
      if (source.repo?.jsonUrl != url) continue;
      await sourceRepository.save(source..repo = current);
    }
  }
}

Future<String?> _resolveIndexUrl(String url) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  return (await ExtensionStoreService.fetchStore(url, http))?.indexUrl;
}

/// Sets each installed extension's update from what the repositories offer
/// ([offers], by extension id), as [chooseUpdate] picks it, and installs it
/// straight away under [autoUpdate] when it comes from the extension's own
/// repository. One from another repository waits for the reader.
///
/// [readRepos] are the indexes that were read: an update is only taken back
/// once the repository it came from was read and no longer has it, not
/// because that repository could not be reached this time.
Future<void> applyExtensionUpdates({
  required Map<int, List<ExtensionOffer>> offers,
  required Set<String> readRepos,
  required bool autoUpdate,
  required String androidProxyServer,
  required ItemType itemType,
}) async {
  for (final installed in sourceRepository.getAddedByItemType(itemType)) {
    if (installed.isLocal ?? false) continue;
    final offer = chooseUpdate(installed, offers[installed.id] ?? const []);
    if (offer == null) {
      final from = (installed.updateRepo ?? installed.repo)?.jsonUrl;
      final pending =
          installed.updateRepo != null ||
          compareVersions(
                installed.version ?? '',
                installed.versionLast ?? '',
              ) <
              0;
      if (pending && (from == null || readRepos.contains(from))) {
        await sourceRepository.save(
          installed
            ..versionLast = installed.version
            ..updateRepo = null,
        );
      }
      continue;
    }
    final foreign =
        installed.repo != null && !isSameRepo(offer.repo, installed.repo);
    if (autoUpdate && !foreign) {
      await updateSource(
        offer.listing,
        androidProxyServer,
        offer.repo,
        itemType,
      );
      continue;
    }
    if (installed.versionLast == offer.listing.version &&
        isSameRepo(installed.updateRepo, offer.repo)) {
      continue;
    }
    await sourceRepository.save(
      installed
        ..versionLast = offer.listing.version
        ..updateRepo = offer.repo,
    );
  }
}

/// Updates or reinstalls the installed [installed] from the repository its
/// update was found in ([reposForUpdate]), installing exactly that
/// repository's build. Says whether anything was installed; when the
/// repository no longer has anything newer, the update is taken back.
Future<bool> installExtensionUpdate({
  required Source installed,
  required List<Repo> repos,
  required String androidProxyServer,
  required ItemType itemType,
}) async {
  final anyVersion = (installed.sourceCode ?? '').isEmpty;
  final toAsk = reposForUpdate(repos, installed, anyVersion: anyVersion);
  Object? failure;
  StackTrace? failureStack;
  for (final repo in toAsk) {
    final List<Source> listed;
    try {
      listed = await fetchRepoSources(repo: repo, itemType: itemType);
    } catch (e, st) {
      failure = e;
      failureStack = st;
      continue;
    }
    final listing = listed.where((s) => s.id == installed.id).firstOrNull;
    if (listing == null || (listing.sourceCodeUrl ?? '').isEmpty) continue;
    final newer =
        compareVersions(installed.version ?? '', listing.version ?? '') < 0;
    if (!anyVersion && !newer) continue;
    await updateSource(listing, androidProxyServer, repo, itemType);
    return true;
  }
  // Nothing reached: the update may still be there, so it stays offered and
  // the reason is told.
  if (failure != null) {
    Error.throwWithStackTrace(failure, failureStack!);
  }
  await sourceRepository.save(
    installed
      ..versionLast = installed.version
      ..updateRepo = null,
  );
  return false;
}

Future<void> updateSource(
  Source source,
  String androidProxyServer,
  Repo? repo,
  ItemType itemType,
) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final req = await http.get(Uri.parse(source.sourceCodeUrl!));
  final sourceCode =
      (source.sourceCodeLanguage == SourceCodeLanguage.mihon ||
          source.sourceCodeLanguage == SourceCodeLanguage.aidoku)
      ? base64.encode(req.bodyBytes)
      : req.body;

  Map<String, String> headers = {};
  bool? supportLatest;
  FilterList? filterList;
  List<SourcePreference>? preferenceList;
  source.sourceCode = sourceCode;
  if (source.sourceCodeLanguage == SourceCodeLanguage.mihon) {
    headers = await fetchHeadersDalvik(http, source, androidProxyServer);
    supportLatest = await fetchSupportLatestDalvik(
      http,
      source,
      androidProxyServer,
    );
    filterList = await fetchFilterListDalvik(http, source, androidProxyServer);
    preferenceList = await fetchPreferencesDalvik(
      http,
      source,
      androidProxyServer,
    );
  } else if (source.sourceCodeLanguage == SourceCodeLanguage.aidoku) {
    final service = AidokuExtensionService(source);
    try {
      headers = service.getHeaders();
      supportLatest = service.supportsLatest;
      filterList = await service.fetchFilterList();
    } finally {
      service.dispose();
    }
  } else {
    headers = await getIsolateService.get<Map<String, String>>(
      source: source,
      serviceType: 'getHeaders',
    );
  }

  final existing = source.id != null
      ? sourceRepository.getById(source.id!)
      : null;
  final updatedSource = Source()
    ..headers = jsonEncode(headers)
    ..supportLatest = supportLatest
    ..filterList = filterList != null ? jsonEncode(filterList.toJson()) : null
    ..preferenceList = preferenceList != null
        ? jsonEncode(preferenceList.map((e) => e.toJson()).toList())
        : null
    ..isAdded = true
    ..isPinned = existing?.isPinned ?? false
    ..lastUsed = existing?.lastUsed ?? false
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
    ..repo = repo ?? existing?.repo
    ..updatedAt = DateTime.now().millisecondsSinceEpoch;

  await sourceRepository.save(updatedSource);
}

Future<void> _addNewSource(Source source, Repo? repo, ItemType itemType) async {
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
  await sourceRepository.save(newSource);
}

Future<void> checkIfSourceIsObsolete(
  List<Source> sourceList,
  Repo repo,
  ItemType itemType,
) async {
  if (sourceList.isEmpty) return;

  final sources = await sourceRepository.getNonLocalByItemType(itemType);

  if (sources.isEmpty) return;

  final sourceIds = sourceList
      .where((e) => e.id != null)
      .map((e) => e.id!)
      .toSet();

  if (sourceIds.isEmpty) return;

  final toUpdate = <Source>[];
  final toDelete = <int>[];
  for (var source in sources) {
    final isNowObsolete =
        !sourceIds.contains(source.id) && source.repo?.jsonUrl == repo.jsonUrl;

    if (!(source.isAdded ?? false) && isNowObsolete) {
      // Not installed and gone from the repo: nothing to install, so
      // remove the dead row instead of leaving it in the browse list.
      toDelete.add(source.id!);
      continue;
    }
    if (source.isObsolete != isNowObsolete) {
      source.isObsolete = isNowObsolete;
      source.updatedAt = DateTime.now().millisecondsSinceEpoch;
      toUpdate.add(source);
    }
  }
  if (toUpdate.isNotEmpty) {
    await sourceRepository.putAll(toUpdate);
  }
  if (toDelete.isNotEmpty) {
    await sourceRepository.deleteAll(toDelete);
  }
}

/// Compares two versions, a pre-release such as `1.0.0-beta.1` coming before
/// `1.0.0` and `-beta.2` after `-beta.1`. Build metadata (`+127`) is ignored.
int compareVersions(String version1, String version2) {
  final (core1, preRelease1) = _splitVersion(version1);
  final (core2, preRelease2) = _splitVersion(version2);

  final v1Parts = core1.split('.');
  final v2Parts = core2.split('.');
  final maxLength = v1Parts.length > v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (var i = 0; i < maxLength; i++) {
    final v1Value = i < v1Parts.length ? (int.tryParse(v1Parts[i]) ?? 0) : 0;
    final v2Value = i < v2Parts.length ? (int.tryParse(v2Parts[i]) ?? 0) : 0;

    final comparison = v1Value.compareTo(v2Value);
    if (comparison != 0) return comparison;
  }

  return _comparePreReleases(preRelease1, preRelease2);
}

(String, String) _splitVersion(String version) {
  final clean = version
      .trim()
      .replaceFirst(RegExp(r'^[vV]'), '')
      .split('+')
      .first;
  final dash = clean.indexOf('-');
  if (dash == -1) return (clean, '');
  return (clean.substring(0, dash), clean.substring(dash + 1).toLowerCase());
}

int _comparePreReleases(String preRelease1, String preRelease2) {
  if (preRelease1 == preRelease2) return 0;
  // The final version comes after all of its pre-releases.
  if (preRelease1.isEmpty) return 1;
  if (preRelease2.isEmpty) return -1;

  final v1Parts = preRelease1.split('.');
  final v2Parts = preRelease2.split('.');
  final minLength = v1Parts.length < v2Parts.length
      ? v1Parts.length
      : v2Parts.length;

  for (var i = 0; i < minLength; i++) {
    final v1Value = int.tryParse(v1Parts[i]);
    final v2Value = int.tryParse(v2Parts[i]);

    final int comparison;
    if (v1Value != null && v2Value != null) {
      comparison = v1Value.compareTo(v2Value);
    } else if (v1Value != null) {
      comparison = -1;
    } else if (v2Value != null) {
      comparison = 1;
    } else {
      comparison = v1Parts[i].compareTo(v2Parts[i]).sign;
    }
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
      body: jsonEncode({
        "method": "headers$name",
        "data": source.sourceCode,
        "lang": source.lang,
        "sourceId": source.id?.toString(),
      }),
    );
    if (res.statusCode != 200) return {};
    final data = jsonDecode(res.body);
    if (data is! List) return {};
    final Map<String, String> headers = {};
    for (var i = 0; i + 1 < data.length; i += 2) {
      headers[data[i].toString()] = data[i + 1].toString();
    }
    return headers;
  } catch (error, stackTrace) {
    recordError(error, stack: stackTrace, source: 'fetch_sources_list');
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
        "lang": source.lang,
        "sourceId": source.id?.toString(),
      }),
    );
    if (res.statusCode != 200) return false;
    return res.body.trim() == "true";
  } catch (error, stackTrace) {
    recordError(error, stack: stackTrace, source: 'fetch_sources_list');
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
      body: jsonEncode({
        "method": "filters$name",
        "data": source.sourceCode,
        "lang": source.lang,
        "sourceId": source.id?.toString(),
      }),
    );
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body);
    if (data is! List) return null;

    return FilterList(filtersFromJson(data));
  } catch (error, stackTrace) {
    recordError(error, stack: stackTrace, source: 'fetch_sources_list');
    return null;
  }
}

List<dynamic> filtersFromJson(List<dynamic> json) {
  return json.expand((e) sync* {
    if (e is! Map) return;
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
                  .map((e) => SelectFilterOption(e['first'], e['second'], null))
                  .toList()
            : e['values'] is List
            ? (e['values'] as List)
                  .map(
                    (e) => (e is Map)
                        ? SelectFilterOption(e['value'], e['value'], null)
                        : SelectFilterOption(e, e, null),
                  )
                  .toList()
            : [],
        "SelectFilter",
      );
    } else if (e['name'] is String && e['state'] is bool) {
      yield CheckBoxFilter(
        null,
        e['name'],
        e['id'] ?? e['name'],
        null,
        state: e['state'],
      );
    } else if (e['included'] is bool &&
        e['ignored'] is bool &&
        e['excluded'] is bool) {
      yield TriStateFilter(
        null,
        e['name'],
        e['id'] ?? e['name'],
        null,
        state: e['state'],
      );
    } else if (e['name'] is String && e['state'] is List) {
      yield GroupFilter(
        "${e['name']}Filter",
        e['name'],
        filtersFromJson((e['state'] as List)),
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
        "lang": source.lang,
        "sourceId": source.id?.toString(),
      }),
    );
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body);
    if (data is! List) return null;
    return data
        .whereType<Map<String, dynamic>>()
        .map(
          (e) => SourcePreference.fromJson(e)
            ..id = null
            ..sourceId = source.id,
        )
        .toList();
  } catch (error, stackTrace) {
    recordError(error, stack: stackTrace, source: 'fetch_sources_list');
    return null;
  }
}

String _convertLang(dynamic e) {
  return ExtensionStoreService.convertLnreaderLang(e);
}

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/lib.dart';
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
      .map((e) {
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
            ..versionLast = '0.0.1'
            ..isObsolete = false
            ..isLocal = false
            ..lang = _convertLang(e)
            ..baseUrl = e['site']
            ..sourceCodeUrl = e['url']
            ..sourceCodeLanguage = SourceCodeLanguage.lnreader
            ..itemType = ItemType.novel
            ..notes = "Performance might be slow due to limited engine";
          src.id = 'lnreader-plugin-"${src.name}"."${src.lang}"'.hashCode;
          return src;
        }
        return Source.fromJson(e);
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
  final headers = getExtensionService(
    source..sourceCode = req.body,
  ).getHeaders();

  final updatedSource = Source()
    ..headers = jsonEncode(headers)
    ..isAdded = true
    ..sourceCode = req.body
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

String _convertLang(dynamic e) {
  final lang = e['lang'];
  if (lang is String) {
    switch (lang) {
      case "‎العربية":
        return "ar";
      case "中文, 汉语, 漢語":
        return "zh";
      case "English":
        return "en";
      case "Français":
        return "fr";
      case "Bahasa Indonesia":
        return "id";
      case "日本語":
        return "ja";
      case "조선말, 한국어":
        return "ko";
      case "Polski":
        return "pl";
      case "Português":
        return "pt";
      case "Русский":
        return "ru";
      case "Español":
        return "es";
      case "ไทย":
        return "th";
      case "Türkçe":
        return "tr";
      case "Українська":
        return "uk";
      case "Tiếng Việt":
        return "vi";
      default:
        return "all";
    }
  }
  return "all";
}

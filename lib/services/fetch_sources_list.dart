import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> fetchSourcesList(
    {int? id,
    required bool refresh,
    required String sourcesIndexUrl,
    required Ref ref,
    required bool isManga}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final req = await http.get(Uri.parse(sourcesIndexUrl));

  final sourceList =
      (jsonDecode(req.body) as List).map((e) => Source.fromJson(e)).toList();

  final info = await PackageInfo.fromPlatform();
  isar.writeTxnSync(() async {
    for (var source in sourceList) {
      if (source.appMinVerReq != null) {
        if (compareVersions(info.version, source.appMinVerReq!) > -1) {
          if ((source.isManga ?? true) == isManga) {
            if (id != null) {
              if (id == source.id) {
                final sourc = isar.sources.getSync(id)!;
                final req = await http.get(Uri.parse(source.sourceCodeUrl!));
                final headers = getSourceHeaders(source..sourceCode = req.body);
                isar.writeTxnSync(() {
                  isar.sources.putSync(sourc
                    ..headers = jsonEncode(headers)
                    ..isAdded = true
                    ..sourceCode = req.body
                    ..sourceCodeUrl = source.sourceCodeUrl
                    ..id = id
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
                    ..isManga = source.isManga
                    ..isFullData = source.isFullData ?? false
                    ..appMinVerReq = source.appMinVerReq
                    ..sourceCodeLanguage = source.sourceCodeLanguage
                    ..additionalParams = source.additionalParams ?? ""
                    ..isObsolete = false);
                });
                // log("successfully installed or updated");
              }
            } else if (isar.sources.getSync(source.id!) != null) {
              // log("exist");
              final sourc = isar.sources.getSync(source.id!)!;
              if (sourc.isAdded!) {
                if (compareVersions(sourc.version!, source.version!) < 0) {
                  // log("update aivalable auto update");
                  if (ref.watch(autoUpdateExtensionsStateProvider)) {
                    final req =
                        await http.get(Uri.parse(source.sourceCodeUrl!));
                    final headers =
                        getSourceHeaders(source..sourceCode = req.body);
                    isar.writeTxnSync(() {
                      isar.sources.putSync(sourc
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
                        ..isManga = source.isManga
                        ..isFullData = source.isFullData ?? false
                        ..appMinVerReq = source.appMinVerReq
                        ..sourceCodeLanguage = source.sourceCodeLanguage
                        ..additionalParams = source.additionalParams ?? ""
                        ..isObsolete = false);
                    });
                  } else {
                    // log("update aivalable");
                    isar.sources.putSync(sourc..versionLast = source.version);
                  }
                }
              }
            } else {
              isar.sources.putSync(Source()
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
                ..isManga = source.isManga
                ..sourceCodeLanguage = source.sourceCodeLanguage
                ..isFullData = source.isFullData ?? false
                ..appMinVerReq = source.appMinVerReq
                ..isObsolete = false);
              // log("new source");
            }
          }
        }
      }
    }
  });
  checkIfSourceIsObsolete(sourceList, isManga);
}

void checkIfSourceIsObsolete(List<Source> sourceList, bool isManga) {
  for (var source in isar.sources
      .filter()
      .idIsNotNull()
      .isMangaEqualTo(isManga)
      .findAllSync()) {
    if (sourceList.isNotEmpty && !(source.isLocal ?? false)) {
      final ids =
          sourceList.where((e) => e.id != null).map((e) => e.id).toList();
      if (ids.isNotEmpty) {
        isar.writeTxnSync(() => isar.sources
            .putSync(source..isObsolete = !ids.contains(source.id)));
      }
    }
  }
  removeNsfwObsoleteSources();
}

void removeNsfwObsoleteSources() {
  final ids = isar.sources
      .filter()
      .idIsNotNull()
      .isNsfwEqualTo(true)
      .isObsoleteEqualTo(true)
      .findAllSync()
      .map((e) => e.id!)
      .toList();
  isar.writeTxnSync(() {
    isar.sources.deleteAllSync(ids);
  });
}

int compareVersions(String version1, String version2) {
  List<String> v1Components = version1.split('.');
  List<String> v2Components = version2.split('.');

  for (int i = 0; i < v1Components.length && i < v2Components.length; i++) {
    int v1Value = int.parse(
        v1Components.length == i + 1 && v1Components[i].length == 1
            ? "${v1Components[i]}0"
            : v1Components[i]);
    int v2Value = int.parse(
        v2Components.length == i + 1 && v2Components[i].length == 1
            ? "${v2Components[i]}0"
            : v2Components[i]);

    if (v1Value < v2Value) {
      return -1;
    } else if (v1Value > v2Value) {
      return 1;
    }
  }

  if (v1Components.length < v2Components.length) {
    return -1;
  } else if (v1Components.length > v2Components.length) {
    return 1;
  }

  return 0;
}

Map<String, String> getSourceHeaders(Source source) {
  Map<String, String> headers = {};
  if (source.sourceCodeLanguage == SourceCodeLanguage.javascript) {
    headers = JsExtensionService(source).getHeaders(source.baseUrl ?? "");
  } else {
    headers = DartExtensionService(source).getHeaders();
  }
  return headers;
}

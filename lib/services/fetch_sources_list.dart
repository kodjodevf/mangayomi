import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> fetchSourcesList(
    {int? id,
    required bool refresh,
    required Ref ref,
    required ItemType itemType,
    required Repo? repo}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final url = repo?.jsonUrl;
  if (url == null) return;

  final req = await http.get(Uri.parse(url));

  final sourceList =
      (jsonDecode(req.body) as List).map((e) => Source.fromJson(e)).toList();

  final info = await PackageInfo.fromPlatform();
  isar.writeTxnSync(() async {
    for (var source in sourceList) {
      if (source.appMinVerReq != null) {
        if (compareVersions(info.version, source.appMinVerReq!) > -1) {
          if (source.itemType == itemType) {
            if (id != null) {
              if (id == source.id) {
                final sourc = isar.sources.getSync(id)!;
                final req = await http.get(Uri.parse(source.sourceCodeUrl!));
                final headers =
                    getExtensionService(source..sourceCode = req.body)
                        .getHeaders();
                isar.writeTxnSync(() {
                  isar.sources.putSync(
                    sourc
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
                      ..itemType = itemType
                      ..isFullData = source.isFullData ?? false
                      ..appMinVerReq = source.appMinVerReq
                      ..sourceCodeLanguage = source.sourceCodeLanguage
                      ..additionalParams = source.additionalParams ?? ""
                      ..isObsolete = false
                      ..repo = repo,
                  );
                  ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                      ActionType.updateExtension,
                      sourc.id,
                      sourc.toJson(),
                      false);
                });
                // log("successfully installed or updated");
              }
            } else if (isar.sources.getSync(source.id!) != null) {
              // log("exist");
              final sourc = isar.sources.getSync(source.id!)!;
              if (sourc.isAdded!) {
                if (compareVersions(sourc.version!, source.version!) < 0) {
                  // log("update available auto update");
                  if (ref.watch(autoUpdateExtensionsStateProvider)) {
                    final req =
                        await http.get(Uri.parse(source.sourceCodeUrl!));
                    final headers =
                        getExtensionService(source..sourceCode = req.body)
                            .getHeaders();
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
                        ..itemType = itemType
                        ..isFullData = source.isFullData ?? false
                        ..appMinVerReq = source.appMinVerReq
                        ..sourceCodeLanguage = source.sourceCodeLanguage
                        ..additionalParams = source.additionalParams ?? ""
                        ..isObsolete = false
                        ..repo = repo);
                      ref
                          .read(synchingProvider(syncId: 1).notifier)
                          .addChangedPart(ActionType.updateExtension, sourc.id,
                              sourc.toJson(), false);
                    });
                  } else {
                    // log("update aivalable");
                    isar.sources.putSync(sourc..versionLast = source.version);
                  }
                }
              }
            } else {
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
                ..repo = repo;
              isar.sources.putSync(newSource);
              ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                  ActionType.addExtension, null, newSource.toJson(), false);
              // log("new source");
            }
          }
        }
      }
    }
  });
  checkIfSourceIsObsolete(sourceList, repo!, itemType, ref);
}

void checkIfSourceIsObsolete(
    List<Source> sourceList, Repo repo, ItemType itemType, Ref ref) {
  for (var source in isar.sources
      .filter()
      .idIsNotNull()
      .itemTypeEqualTo(itemType)
      .findAllSync()) {
    if (sourceList.isNotEmpty && !(source.isLocal ?? false)) {
      final ids =
          sourceList.where((e) => e.id != null).map((e) => e.id).toList();
      if (ids.isNotEmpty) {
        isar.writeTxnSync(() {
          if (source.isObsolete !=
              (!ids.contains(source.id) &&
                  source.repo?.jsonUrl == repo.jsonUrl)) {
            ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                ActionType.updateExtension, source.id, source.toJson(), false);
          }
          isar.sources.putSync(source
            ..isObsolete = !ids.contains(source.id) &&
                source.repo?.jsonUrl == repo.jsonUrl);
        });
      }
    }
  }
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

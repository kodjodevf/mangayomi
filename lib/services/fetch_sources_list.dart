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

  final sourceList =
      (jsonDecode(req.body) as List)
          .map((e) => Source.fromJson(e))
          .where(
            (source) =>
                source.itemType == itemType &&
                source.appMinVerReq != null &&
                compareVersions(info.version, source.appMinVerReq!) > -1,
          )
          .toList();

  isar.writeTxnSync(() async {
    if (id != null) {
      final matchingSource = sourceList.firstWhere(
        (source) => source.id == id,
        orElse: () => Source(),
      );
      if (matchingSource.id != null) {
        await _updateSource(matchingSource, ref, repo, itemType);
      }
    } else {
      for (var source in sourceList) {
        final existingSource = isar.sources.getSync(source.id!);
        if (existingSource != null) {
          if (existingSource.isAdded! &&
              compareVersions(existingSource.version!, source.version!) < 0) {
            if (ref.watch(autoUpdateExtensionsStateProvider)) {
              await _updateSource(source, ref, repo, itemType);
            } else {
              isar.sources.putSync(
                existingSource..versionLast = source.version,
              );
            }
          }
        } else {
          _addNewSource(source, ref, repo, itemType);
        }
      }
    }
  });

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
  final headers =
      getExtensionService(source..sourceCode = req.body).getHeaders();

  final updatedSource =
      Source()
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
        ..repo = repo;

  isar.writeTxnSync(() {
    isar.sources.putSync(updatedSource);
  });
  ref
      .read(synchingProvider(syncId: 1).notifier)
      .addChangedPart(
        ActionType.updateExtension,
        updatedSource.id,
        updatedSource.toJson(),
        false,
      );
}

void _addNewSource(Source source, Ref ref, Repo? repo, ItemType itemType) {
  final newSource =
      Source()
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
  ref
      .read(synchingProvider(syncId: 1).notifier)
      .addChangedPart(ActionType.addExtension, null, newSource.toJson(), false);
}

void checkIfSourceIsObsolete(
  List<Source> sourceList,
  Repo repo,
  ItemType itemType,
  Ref ref,
) {
  if (sourceList.isEmpty) return;

  final sources =
      isar.sources
          .filter()
          .idIsNotNull()
          .itemTypeEqualTo(itemType)
          .and()
          .isLocalEqualTo(false)
          .findAllSync();

  if (sources.isEmpty) return;

  final sourceIds =
      sourceList.where((e) => e.id != null).map((e) => e.id!).toSet();

  if (sourceIds.isEmpty) return;

  isar.writeTxnSync(() {
    for (var source in sources) {
      final isNowObsolete =
          !sourceIds.contains(source.id) &&
          source.repo?.jsonUrl == repo.jsonUrl;

      if (source.isObsolete != isNowObsolete) {
        source.isObsolete = isNowObsolete;
        isar.sources.putSync(source);

        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(
              ActionType.updateExtension,
              source.id,
              source.toJson(),
              false,
            );
      }
    }
  });
}

int compareVersions(String version1, String version2) {
  final v1Parts = version1.split('.');
  final v2Parts = version2.split('.');
  final minLength =
      v1Parts.length < v2Parts.length ? v1Parts.length : v2Parts.length;

  for (var i = 0; i < minLength; i++) {
    final v1Value = int.parse(v1Parts[i].padRight(2, '0'));
    final v2Value = int.parse(v2Parts[i].padRight(2, '0'));

    final comparison = v1Value.compareTo(v2Value);
    if (comparison != 0) return comparison;
  }

  return v1Parts.length.compareTo(v2Parts.length);
}

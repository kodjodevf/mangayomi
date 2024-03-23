import 'dart:convert';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'fetch_anime_sources.g.dart';

@riverpod
Future fetchAnimeSourcesList(FetchAnimeSourcesListRef ref,
    {int? id, required bool reFresh}) async {
  final http = MClient.init();
  if (ref.watch(checkForExtensionsUpdateStateProvider) || reFresh) {
    final info = await PackageInfo.fromPlatform();
    final req = await MClient.init().get(Uri.parse(
        "https://kodjodevf.github.io/mangayomi-extensions/anime_index.json"));
    final res = jsonDecode(req.body) as List;

    final sourceList = res.map((e) => Source.fromJson(e)).toList();

    isar.writeTxnSync(() async {
      for (var source in sourceList) {
        if (source.appMinVerReq != null) {
          if (compareVersions(info.version, source.appMinVerReq!) > -1) {
            if (!source.isManga!) {
              if (id != null) {
                if (id == source.id) {
                  final sourc = isar.sources.getSync(id)!;
                  final req = await http.get(Uri.parse(source.sourceCodeUrl!));
                  final headers = await getHeaders(req.body, source.baseUrl!);
                  isar.writeTxnSync(() {
                    isar.sources.putSync(sourc
                      ..headers = headers ?? ""
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
                      ..additionalParams = source.additionalParams ?? "");
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
                          await getHeaders(req.body, source.baseUrl!);
                      isar.writeTxnSync(() {
                        isar.sources.putSync(sourc
                          ..headers = headers ?? ""
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
                          ..additionalParams = source.additionalParams ?? "");
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
                  ..isFullData = source.isFullData ?? false
                  ..appMinVerReq = source.appMinVerReq
                  ..sourceCodeLanguage = source.sourceCodeLanguage);
                // log("new source");
              }
            }
          }
        }
      }
    });
    checkIfSourceIsObsolete(sourceList);
  }
}

import 'dart:convert';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/fetch_manga_sources.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'fetch_anime_sources.g.dart';

@riverpod
Future fetchAnimeSourcesList(FetchAnimeSourcesListRef ref, {int? id}) async {
  final info = await PackageInfo.fromPlatform();
  final req = await http.get(Uri.parse(
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
                    ..appMinVerReq = source.appMinVerReq);
                });
                // log("successfully installed");
              }
            } else if (isar.sources.getSync(source.id!) != null) {
              // log("exist");
              final sourc = isar.sources.getSync(source.id!)!;
              if (compareVersions(sourc.version!, source.version!) < 0) {
                // log("update aivalable auto update");
                if (isar.settings.getSync(227)!.autoUpdateExtensions ?? false) {
                  final req = await http.get(Uri.parse(source.sourceCodeUrl!));
                  final headers = await getHeaders(req.body, source.baseUrl!);
                  isar.writeTxnSync(() {
                    isar.sources.putSync(sourc
                      ..headers = headers
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
                      ..isFullData = source.isFullData ?? false
                      ..lang = source.lang
                      ..isNsfw = source.isNsfw
                      ..name = source.name
                      ..version = source.version
                      ..versionLast = source.version
                      ..isManga = source.isManga
                      ..isFullData = source.isFullData
                      ..appMinVerReq = source.appMinVerReq);
                  });
                } else {
                  // log("update aivalable");
                  isar.sources.putSync(sourc..versionLast = source.version);
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
                ..appMinVerReq = source.appMinVerReq);
              // log("new source");
            }
          }
        }
      }
    }
  });
}

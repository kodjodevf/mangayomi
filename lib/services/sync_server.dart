import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed_items.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/models/jwt.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'dart:convert';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'sync_server.g.dart';

@riverpod
class SyncServer extends _$SyncServer {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final String _loginUrl = '/login';
  final String _checkUrl = '/check';
  final String _syncUrl = '/sync';
  final String _uploadUrl = '/upload/full';
  final String _downloadUrl = '/download';

  @override
  void build({required int syncId}) {}

  Future<(bool, String)> login(AppLocalizations l10n, String server,
      String username, String password) async {
    server = server[server.length - 1] == '/' ? server.substring(0, server.length - 1) : server;
    try {
      var response = await http.post(
        Uri.parse('$server$_loginUrl'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': username, 'password': password}),
      );
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return (false, jsonData["error"] as String);
      }
      ref.read(synchingProvider(syncId: syncId).notifier).login(SyncPreference(
          syncId: syncId,
          email: username,
          server: server,
          authToken: jsonData["token"]));
      botToast(l10n.sync_logged);
      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<void> checkForSync(bool silent) async {
    if (!silent) {
      botToast("Checking for sync...", second: 2);
    }
    try {
      final datas = _getData();
      final accessToken = _getAccessToken();
      final localHash = _getDataHash(datas);

      var response = await http.get(
        Uri.parse('${_getServer()}$_checkUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode != 200) {
        botToast("Check failed", second: 5);
        return;
      }
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final remoteHash = jsonData["hash"];
      if (localHash != remoteHash) {
        syncToServer(silent);
      } else if (!silent) {
        botToast("Sync up to date", second: 2);
      }
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  Future<void> syncToServer(bool silent) async {
    if (!silent) {
      botToast("Sync started...", second: 2);
    }
    try {
      final datas = _getData();
      final accessToken = _getAccessToken();

      var response = await http.post(
        Uri.parse('${_getServer()}$_syncUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(
            {'backupData': datas, 'changedItems': _getChangedData()}),
      );
      if (response.statusCode != 200) {
        botToast("Sync failed", second: 5);
        return;
      }
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final decodedBackupData = jsonData["backupData"] is String
          ? jsonDecode(jsonData["backupData"])
          : jsonData["backupData"];
      _restoreMerge(decodedBackupData);
      ref
          .read(synchingProvider(syncId: syncId).notifier)
          .setLastSync(DateTime.now().millisecondsSinceEpoch);
      ref
          .read(changedItemsManagerProvider(managerId: 1).notifier)
          .cleanChangedItems(true);
      if (!silent) {
        botToast("Sync finished", second: 2);
      }
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  Future<void> uploadToServer(AppLocalizations l10n) async {
    botToast(l10n.sync_uploading, second: 2);
    try {
      final datas = _getData();
      final accessToken = _getAccessToken();

      var response = await http.post(
        Uri.parse('${_getServer()}$_uploadUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({'backupData': datas}),
      );
      if (response.statusCode != 200) {
        botToast(l10n.sync_upload_failed, second: 5);
        return;
      }
      ref
          .read(synchingProvider(syncId: syncId).notifier)
          .setLastUpload(DateTime.now().millisecondsSinceEpoch);
      ref
          .read(changedItemsManagerProvider(managerId: 1).notifier)
          .cleanChangedItems(true);
      botToast(l10n.sync_upload_finished, second: 2);
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  Future<void> downloadFromServer(AppLocalizations l10n) async {
    botToast(l10n.sync_downloading, second: 2);
    try {
      final accessToken = _getAccessToken();

      var response = await http.get(
        Uri.parse('${_getServer()}$_downloadUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      if (response.statusCode != 200) {
        botToast(l10n.sync_download_failed, second: 5);
        return;
      }
      var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      _restore(jsonData["backupData"] is String
          ? jsonDecode(jsonData["backupData"])
          : jsonData["backupData"]);
      ref
          .read(synchingProvider(syncId: syncId).notifier)
          .setLastDownload(DateTime.now().millisecondsSinceEpoch);
      ref
          .read(changedItemsManagerProvider(managerId: 1).notifier)
          .cleanChangedItems(true);
      botToast(l10n.sync_download_finished, second: 2);
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  String _getDataHash(Map<String, dynamic> data) {
    Map<String, dynamic> datas = {};
    datas["version"] = data["version"];
    datas["manga"] = data["manga"];
    datas["categories"] = data["categories"];
    datas["chapters"] = data["chapters"];
    datas["tracks"] = data["tracks"];
    datas["history"] = data["history"];
    datas["updates"] = data["updates"];
    var encodedJson = jsonEncode(datas);
    return sha256.convert(utf8.encode(encodedJson)).toString();
  }

  Map<String, dynamic> _getChangedData() {
    Map<String, dynamic> data = {};
    final changedItems = isar.changedItems.getSync(1);
    if (changedItems != null) {
      data.addAll({
        "deletedMangas":
            changedItems.deletedMangas?.map((e) => e.toJson()).toList() ?? []
      });
      data.addAll({
        "updatedChapters":
            changedItems.updatedChapters?.map((e) => e.toJson()).toList() ?? []
      });
      data.addAll({
        "deletedCategories":
            changedItems.deletedCategories?.map((e) => e.toJson()).toList() ??
                []
      });
    }
    return data;
  }

  Map<String, dynamic> _getData() {
    Map<String, dynamic> datas = {};
    datas.addAll({"version": "1"});
    final mangas = isar.mangas
        .filter()
        .idIsNotNull()
        .favoriteEqualTo(true)
        .isLocalArchiveEqualTo(false)
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"manga": mangas});
    final categorys = isar.categorys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"categories": categorys});
    final chapters = isar.chapters
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"chapters": chapters});
    datas.addAll({"downloads": []});
    final tracks = isar.tracks
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"tracks": tracks});
    datas.addAll({"trackPreferences": []});
    final historys = isar.historys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"history": historys});
    final settings = isar.settings
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"settings": settings});
    final sources = isar.sources
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"extensions": sources});
    final sourcePreferences = isar.sourcePreferences
        .filter()
        .idIsNotNull()
        .keyIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"extensions_preferences": sourcePreferences});
    final updates = isar.updates
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"updates": updates});
    return datas;
  }

  void _restoreMerge(Map<String, dynamic> backup) {
    if (backup['version'] == "1") {
      try {
        final manga =
            (backup["manga"] as List?)?.map((e) => Manga.fromJson(e)).toList();
        final chapters = (backup["chapters"] as List?)
            ?.map((e) => Chapter.fromJson(e))
            .toList();
        final categories = (backup["categories"] as List?)
            ?.map((e) => Category.fromJson(e))
            .toList();
        final track =
            (backup["tracks"] as List?)?.map((e) => Track.fromJson(e)).toList();
        final history = (backup["history"] as List?)
            ?.map((e) => History.fromJson(e))
            .toList();
        final updates =
            (backup["updates"] as List?)?.map((e) => Update.fromJson(e)).toList();

        isar.writeTxnSync(() {
          isar.mangas.clearSync();
          if (manga != null) {
            isar.mangas.putAllSync(manga);
            if (chapters != null) {
              isar.chapters.clearSync();
              for (var chapter in chapters) {
                final manga = isar.mangas.getSync(chapter.mangaId!);
                if (manga != null) {
                  isar.chapters.putSync(chapter..manga.value = manga);
                  chapter.manga.saveSync();
                }
              }

              isar.historys.clearSync();
              if (history != null) {
                for (var element in history) {
                  final chapter = isar.chapters.getSync(element.chapterId!);
                  if (chapter != null) {
                    isar.historys.putSync(element..chapter.value = chapter);
                    element.chapter.saveSync();
                  }
                }
              }

              isar.updates.clearSync();
              if (updates != null) {
                final tempChapters =
                    isar.chapters.filter().idIsNotNull().findAllSync().toList();
                for (var update in updates) {
                  final matchingChapter = tempChapters
                      .where((chapter) =>
                          chapter.mangaId == update.mangaId &&
                          chapter.name == update.chapterName)
                      .firstOrNull;
                  if (matchingChapter != null) {
                    isar.updates.putSync(update..chapter.value = matchingChapter);
                    update.chapter.saveSync();
                  }
                }
              }
            }

            isar.categorys.clearSync();
            if (categories != null) {
              isar.categorys.putAllSync(categories);
            }
          }

          isar.tracks.clearSync();
          if (track != null) {
            isar.tracks.putAllSync(track);
          }

          ref.invalidate(themeModeStateProvider);
          ref.invalidate(blendLevelStateProvider);
          ref.invalidate(flexSchemeColorStateProvider);
          ref.invalidate(pureBlackDarkModeStateProvider);
          ref.invalidate(l10nLocaleStateProvider);
        });
      } catch (e) {
        botToast(e.toString());
      }
    }
  }

  void _restore(Map<String, dynamic> backup) {
    if (backup['version'] == "1") {
      try {
        final manga =
            (backup["manga"] as List?)?.map((e) => Manga.fromJson(e)).toList();
        final chapters = (backup["chapters"] as List?)
            ?.map((e) => Chapter.fromJson(e))
            .toList();
        final categories = (backup["categories"] as List?)
            ?.map((e) => Category.fromJson(e))
            .toList();
        final track =
            (backup["tracks"] as List?)?.map((e) => Track.fromJson(e)).toList();
        final history = (backup["history"] as List?)
            ?.map((e) => History.fromJson(e))
            .toList();
        final settings = (backup["settings"] as List?)
            ?.map((e) => Settings.fromJson(e))
            .toList();
        final extensions = (backup["extensions"] as List?)
            ?.map((e) => Source.fromJson(e))
            .toList();
        final extensionsPref = (backup["extensions_preferences"] as List?)
            ?.map((e) => SourcePreference.fromJson(e))
            .toList();
        final updates =
            (backup["updates"] as List?)?.map((e) => Update.fromJson(e)).toList();

        isar.writeTxnSync(() {
          isar.mangas.clearSync();
          if (manga != null) {
            isar.mangas.putAllSync(manga);
            if (chapters != null) {
              isar.chapters.clearSync();
              for (var chapter in chapters) {
                final manga = isar.mangas.getSync(chapter.mangaId!);
                if (manga != null) {
                  isar.chapters.putSync(chapter..manga.value = manga);
                  chapter.manga.saveSync();
                }
              }

              isar.historys.clearSync();
              if (history != null) {
                for (var element in history) {
                  final chapter = isar.chapters.getSync(element.chapterId!);
                  if (chapter != null) {
                    isar.historys.putSync(element..chapter.value = chapter);
                    element.chapter.saveSync();
                  }
                }
              }

              isar.updates.clearSync();
              if (updates != null) {
                final tempChapters =
                    isar.chapters.filter().idIsNotNull().findAllSync().toList();
                for (var update in updates) {
                  final matchingChapter = tempChapters
                      .where((chapter) =>
                          chapter.mangaId == update.mangaId &&
                          chapter.name == update.chapterName)
                      .firstOrNull;
                  if (matchingChapter != null) {
                    isar.updates.putSync(update..chapter.value = matchingChapter);
                    update.chapter.saveSync();
                  }
                }
              }
            }

            isar.categorys.clearSync();
            if (categories != null) {
              isar.categorys.putAllSync(categories);
            }
          }

          isar.tracks.clearSync();
          if (track != null) {
            isar.tracks.putAllSync(track);
          }

          isar.sources.clearSync();
          if (extensions != null) {
            isar.sources.putAllSync(extensions);
          }

          isar.sourcePreferences.clearSync();
          if (extensionsPref != null) {
            isar.sourcePreferences.putAllSync(extensionsPref);
          }
          final syncAfterReading = isar.settings.getSync(227)!.syncAfterReading;
          final syncOnAppLaunch = isar.settings.getSync(227)!.syncOnAppLaunch;
          isar.settings.clearSync();
          if (settings != null) {
            isar.settings.putAllSync(settings);
          }
          if (isar.settings.getSync(227) == null) {
            isar.settings.putSync(Settings(id: 227));
          }
          isar.settings.putSync(
              isar.settings.getSync(227)!..syncAfterReading = syncAfterReading);
          isar.settings.putSync(
              isar.settings.getSync(227)!..syncOnAppLaunch = syncOnAppLaunch);
          ref.invalidate(themeModeStateProvider);
          ref.invalidate(blendLevelStateProvider);
          ref.invalidate(flexSchemeColorStateProvider);
          ref.invalidate(pureBlackDarkModeStateProvider);
          ref.invalidate(l10nLocaleStateProvider);
        });
      } catch (e) {
        botToast(e.toString(), second: 5);
      }
    }
  }

  String _getAccessToken() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    if (syncPrefs == null || syncPrefs.authToken == null) {
      return "";
    }
    var paddedPayload = syncPrefs.authToken!.split(".")[1];
    if (paddedPayload.length % 4 > 0) {
      paddedPayload += '=' * (4 - paddedPayload.length % 4);
    }
    final decodedJwt = jsonDecode(utf8.decode(base64Decode(paddedPayload)))
        as Map<String, dynamic>;
    final auth = JWToken.fromJson(decodedJwt);
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(auth.exp!);
    if (DateTime.now().isAfter(expiresIn)) {
      ref.read(synchingProvider(syncId: syncId).notifier).logout();
      botToast("SyncServer Token expired");
      throw Exception("Token expired");
    }
    return syncPrefs.authToken!;
  }

  String _getServer() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs?.server ?? "";
  }
}

import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/settings/sync/models/jwt.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'dart:convert';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'sync_server.g.dart';

@riverpod
class SyncServer extends _$SyncServer {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final String _loginUrl = '/login';
  final String _uploadUrl = '/upload/full';
  final String _downloadUrl = '/download';

  @override
  void build({required int syncId}) {}

  Future<(bool, String)> login(AppLocalizations l10n, String server,
      String username, String password) async {
    server = server[server.length - 1] == '/'
        ? server.substring(0, server.length - 1)
        : server;
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
      botToast(l10n.sync_download_finished, second: 2);
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  Map<String, dynamic> _getData() {
    Map<String, dynamic> datas = {};
    datas.addAll({"version": "2"});
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

  void _restore(Map<String, dynamic> backup) {
    ref.read(restoreBackupProvider(backup));
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

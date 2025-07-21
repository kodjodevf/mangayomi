import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'sync_server.g.dart';

@riverpod
class SyncServer extends _$SyncServer {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final String _loginUrl = '/login';
  final String _syncMangaUrl = '/sync/manga';
  final String _syncHistoryUrl = '/sync/histories';
  final String _syncUpdateUrl = '/sync/updates';
  final String _syncSettingsUrl = '/sync/settings';

  @override
  void build({required int syncId}) {}

  Future<(bool, String)> login(
    AppLocalizations l10n,
    String server,
    String username,
    String password,
  ) async {
    server = server[server.length - 1] == '/'
        ? server.substring(0, server.length - 1)
        : server;
    try {
      var response = await http.post(
        Uri.parse('$server$_loginUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': username, 'password': password}),
      );
      var cookieHeader = response.headers["set-cookie"];
      var startIdx = cookieHeader?.indexOf("id=") ?? -1;
      var endIdx = cookieHeader?.indexOf(";", startIdx) ?? -1;
      if (startIdx == -1 || endIdx == -1) {
        return (false, "Auth failed");
      }
      final authToken = cookieHeader!.substring(startIdx + 3, endIdx);
      ref
          .read(synchingProvider(syncId: syncId).notifier)
          .login(server, username, authToken);
      botToast(l10n.sync_logged);
      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<void> startSync(AppLocalizations l10n, bool silent) async {
    if (!silent) {
      botToast(l10n.sync_starting, second: 500);
    }
    try {
      final syncPreference = ref.read(synchingProvider(syncId: syncId));
      final syncNotifier = ref.read(synchingProvider(syncId: syncId).notifier);

      final resultManga = await _syncManga(l10n, syncNotifier);
      if (!resultManga) {
        botToast(l10n.sync_failed, second: 5);
        return;
      }
      if (syncPreference.syncHistories) {
        final resultHistory = await _syncHistory(l10n, syncNotifier);
        if (!resultHistory) {
          botToast(l10n.sync_failed, second: 5);
          return;
        }
      }
      if (syncPreference.syncUpdates) {
        final resultUpdate = await _syncUpdate(l10n, syncNotifier);
        if (!resultUpdate) {
          botToast(l10n.sync_failed, second: 5);
          return;
        }
      }
      if (syncPreference.syncSettings) {
        final resultSettings = await _syncSettings(l10n);
        if (!resultSettings) {
          botToast(l10n.sync_failed, second: 5);
          return;
        }
      }

      ref.invalidate(synchingProvider(syncId: syncId));
      if (!silent) {
        botToast(l10n.sync_finished, second: 2);
      }
    } catch (error) {
      botToast(error.toString(), second: 5);
    }
  }

  Future<bool> _syncManga(AppLocalizations l10n, Synching syncNotifier) async {
    final mangaData = _getMangaData();
    final accessToken = _getAccessToken();
    var response = await http.post(
      Uri.parse('${_getServer()}$_syncMangaUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=$accessToken',
      },
      body: mangaData,
    );
    if (response.statusCode != 200) {
      botToast(l10n.sync_failed, second: 5);
      return false;
    }

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    await _upsertCategories(jsonData, syncNotifier);
    await _upsertManga(jsonData, syncNotifier);
    await _upsertChapters(jsonData, syncNotifier);
    await _upsertTracks(jsonData, syncNotifier);

    syncNotifier.setLastSyncManga(DateTime.now().millisecondsSinceEpoch);

    return true;
  }

  Future<bool> _syncHistory(
    AppLocalizations l10n,
    Synching syncNotifier,
  ) async {
    final historyData = _getHistoryData();
    final accessToken = _getAccessToken();
    var response = await http.post(
      Uri.parse('${_getServer()}$_syncHistoryUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=$accessToken',
      },
      body: historyData,
    );
    if (response.statusCode != 200) {
      botToast(l10n.sync_failed, second: 5);
      return false;
    }

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    await _upsertHistories(jsonData, syncNotifier);

    syncNotifier.setLastSyncHistory(DateTime.now().millisecondsSinceEpoch);

    return true;
  }

  Future<bool> _syncUpdate(AppLocalizations l10n, Synching syncNotifier) async {
    final updateData = _getUpdateData();
    final accessToken = _getAccessToken();
    var response = await http.post(
      Uri.parse('${_getServer()}$_syncUpdateUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=$accessToken',
      },
      body: updateData,
    );
    if (response.statusCode != 200) {
      botToast(l10n.sync_failed, second: 5);
      return false;
    }

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    await _upsertUpdates(jsonData, syncNotifier);

    syncNotifier.setLastSyncUpdate(DateTime.now().millisecondsSinceEpoch);

    return true;
  }

  Future<bool> _syncSettings(AppLocalizations l10n) async {
    final settingsData = _getSettingsData();
    final accessToken = _getAccessToken();
    var response = await http.post(
      Uri.parse('${_getServer()}$_syncSettingsUrl'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=$accessToken',
      },
      body: settingsData,
    );
    if (response.statusCode != 200) {
      botToast(l10n.sync_failed, second: 5);
      return false;
    }

    final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    await _upsertSettings(jsonData);

    return true;
  }

  Future<void> _upsertCategories(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final categories =
        (jsonData["categories"] as List?)
            ?.map((e) => Category.fromJson(e))
            .toList() ??
        [];
    await isar.writeTxn(() async {
      for (var category
          in await isar.categorys.filter().idIsNotNull().findAll()) {
        final temp = categories.firstWhereOrNull((e) => e.id == category.id);
        if (temp != null) {
          if ((category.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.categorys.put(temp);
          }
          categories.remove(temp);
        } else {
          await isar.categorys.delete(category.id!);
        }
      }
      for (var category in categories) {
        await isar.categorys.put(category);
      }
      await syncNotifier.clearChangedParts([ActionType.removeCategory], false);
    });
  }

  Future<void> _upsertManga(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final mangas =
        (jsonData["manga"] as List?)?.map((e) => Manga.fromJson(e)).toList() ??
        [];
    await isar.writeTxn(() async {
      for (var manga in await isar.mangas.filter().idIsNotNull().findAll()) {
        final temp = mangas.firstWhereOrNull((e) => e.id == manga.id);
        if (temp != null) {
          if ((manga.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.mangas.put(temp);
          }
          mangas.remove(temp);
        } else {
          await isar.mangas.delete(manga.id!);
        }
      }
      for (var manga in mangas) {
        await isar.mangas.put(manga);
      }
      await syncNotifier.clearChangedParts([ActionType.removeItem], false);
    });
  }

  Future<void> _upsertChapters(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final chapters =
        (jsonData["chapters"] as List?)
            ?.map((e) => Chapter.fromJson(e))
            .toList() ??
        [];
    await isar.writeTxn(() async {
      for (var chapter
          in await isar.chapters.filter().idIsNotNull().findAll()) {
        final temp = chapters.firstWhereOrNull((e) => e.id == chapter.id);
        if (temp != null) {
          final manga = await isar.mangas.get(temp.mangaId!);
          if (manga != null &&
              (chapter.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.chapters.put(temp..manga.value = manga);
            await temp.manga.save();
          }
          chapters.remove(temp);
        } else {
          await isar.chapters.delete(chapter.id!);
        }
      }
      for (var chapter in chapters) {
        final manga = await isar.mangas.get(chapter.mangaId!);
        if (manga != null) {
          await isar.chapters.put(chapter..manga.value = manga);
          await chapter.manga.save();
        }
      }
      await syncNotifier.clearChangedParts([ActionType.removeChapter], false);
    });
  }

  Future<void> _upsertTracks(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final tracks =
        (jsonData["tracks"] as List?)?.map((e) => Track.fromJson(e)).toList() ??
        [];
    await isar.writeTxn(() async {
      for (var track in await isar.tracks.filter().idIsNotNull().findAll()) {
        final temp = tracks.firstWhereOrNull((e) => e.id == track.id);
        if (temp != null) {
          if ((track.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.tracks.put(temp);
          }
          tracks.remove(temp);
        } else {
          await isar.tracks.delete(track.id!);
        }
      }
      for (var track in tracks) {
        await isar.tracks.put(track);
      }
      await syncNotifier.clearChangedParts([ActionType.removeTrack], false);
    });
  }

  Future<void> _upsertHistories(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final histories =
        (jsonData["histories"] as List?)
            ?.map((e) => History.fromJson(e))
            .toList() ??
        [];
    await isar.writeTxn(() async {
      for (var history
          in await isar.historys.filter().idIsNotNull().findAll()) {
        final temp = histories.firstWhereOrNull((e) => e.id == history.id);
        if (temp != null) {
          final chapter = await isar.chapters.get(temp.chapterId!);
          if (chapter != null &&
              (history.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.historys.put(temp..chapter.value = chapter);
            await temp.chapter.save();
          }
          histories.remove(temp);
        } else {
          await isar.historys.delete(history.id!);
        }
      }
      for (var history in histories) {
        final chapter = await isar.chapters.get(history.chapterId!);
        if (chapter != null) {
          await isar.historys.put(history..chapter.value = chapter);
          await history.chapter.save();
        }
      }
      await syncNotifier.clearChangedParts([ActionType.removeHistory], false);
    });
  }

  Future<void> _upsertUpdates(
    Map<String, dynamic> jsonData,
    Synching syncNotifier,
  ) async {
    final updates =
        (jsonData["updates"] as List?)
            ?.map((e) => Update.fromJson(e))
            .toList() ??
        [];
    await isar.writeTxn(() async {
      for (var update in await isar.updates.filter().idIsNotNull().findAll()) {
        final temp = updates.firstWhereOrNull((e) => e.id == update.id);
        if (temp != null) {
          final chapter = await isar.chapters
              .filter()
              .mangaIdEqualTo(temp.mangaId)
              .nameEqualTo(temp.chapterName)
              .findFirst();
          if (chapter != null &&
              (update.updatedAt ?? 0) < (temp.updatedAt ?? 1)) {
            await isar.updates.put(temp..chapter.value = chapter);
            await temp.chapter.save();
          }
          updates.remove(temp);
        } else {
          await isar.updates.delete(update.id!);
        }
      }
      for (var update in updates) {
        final chapter = await isar.chapters
            .filter()
            .mangaIdEqualTo(update.mangaId)
            .nameEqualTo(update.chapterName)
            .findFirst();
        if (chapter != null) {
          await isar.updates.put(update..chapter.value = chapter);
          await update.chapter.save();
        }
      }
      await syncNotifier.clearChangedParts([ActionType.removeUpdate], false);
    });
  }

  Future<void> _upsertSettings(Map<String, dynamic> jsonData) async {
    final oldSettings = isar.settings.getSync(227)!;
    final settings = Settings.fromJson(jsonData["settings"]);
    await isar.writeTxn(() async {
      await isar.settings.put(settings..cookiesList = oldSettings.cookiesList);
      ref.invalidate(followSystemThemeStateProvider);
      ref.invalidate(themeModeStateProvider);
      ref.invalidate(blendLevelStateProvider);
      ref.invalidate(flexSchemeColorStateProvider);
      ref.invalidate(pureBlackDarkModeStateProvider);
      ref.invalidate(l10nLocaleStateProvider);
      ref.invalidate(extensionsRepoStateProvider(ItemType.manga));
      ref.invalidate(extensionsRepoStateProvider(ItemType.anime));
      ref.invalidate(extensionsRepoStateProvider(ItemType.novel));
    });
  }

  String _getMangaData() {
    Map<String, dynamic> data = {};
    data["categories"] = _getCategories();
    data["deleted_categories"] = _getDeletedObjects(ActionType.removeCategory);
    data["manga"] = _getManga();
    data["deleted_manga"] = _getDeletedObjects(ActionType.removeItem);
    data["chapters"] = _getChapters();
    data["deleted_chapters"] = _getDeletedObjects(ActionType.removeChapter);
    data["tracks"] = _getTracks();
    data["deleted_tracks"] = _getDeletedObjects(ActionType.removeTrack);
    return jsonEncode(data);
  }

  String _getHistoryData() {
    Map<String, dynamic> data = {};
    data["histories"] = _getHistories();
    data["deleted_histories"] = _getDeletedObjects(ActionType.removeHistory);
    return jsonEncode(data);
  }

  String _getUpdateData() {
    Map<String, dynamic> data = {};
    data["updates"] = _getUpdates();
    data["deleted_updates"] = _getDeletedObjects(ActionType.removeUpdate);
    return jsonEncode(data);
  }

  String _getSettingsData() {
    Map<String, dynamic> data = {};
    data["settings"] = isar.settings.getSync(227)!..updatedAt ??= DateTime.now().millisecondsSinceEpoch..cookiesList = [];
    return jsonEncode(data);
  }

  List<int> _getDeletedObjects(ActionType actionType) {
    return ref
        .read(synchingProvider(syncId: syncId).notifier)
        .getChangedParts([actionType])
        .map((e) => e.isarId)
        .nonNulls
        .toList();
  }

  List<Map<String, dynamic>> _getManga() {
    return isar.mangas
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => (e..customCoverImage = null).toJson())
        .toList();
  }

  List<Map<String, dynamic>> _getCategories() {
    return isar.categorys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
  }

  List<Map<String, dynamic>> _getChapters() {
    return isar.chapters
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
  }

  List<Map<String, dynamic>> _getTracks() {
    return isar.tracks
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
  }

  List<Map<String, dynamic>> _getHistories() {
    return isar.historys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
  }

  List<Map<String, dynamic>> _getUpdates() {
    return isar.updates
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
  }

  String _getAccessToken() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.authToken ?? "";
  }

  String _getServer() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.server ?? "";
  }
}

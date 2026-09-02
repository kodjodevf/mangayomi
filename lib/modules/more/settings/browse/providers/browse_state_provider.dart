import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/extension_store_service.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'browse_state_provider.g.dart';

@riverpod
class AndroidProxyServerState extends _$AndroidProxyServerState {
  @override
  String build() {
    String proxyServer =
        settingsRepository.currentOrNull?.androidProxyServer ??
        "http://127.0.0.1:8080";
    if (!proxyServer.startsWith("http")) {
      proxyServer = "http://$proxyServer";
    }
    if ((proxyServer.contains("localhost") ||
            RegExp(r'^((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])(\.(?!$)|$)){4}$')
                .hasMatch(proxyServer.replaceAll("://", ":").split(":")[1])) &&
        proxyServer.split(":").length < 3) {
      proxyServer = "$proxyServer:8080";
    }
    return proxyServer;
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.androidProxyServer = value);
  }
}

@riverpod
class AutoStartExtensionServerOnLaunchState
    extends _$AutoStartExtensionServerOnLaunchState {
  @override
  bool build() {
    return settingsRepository.currentOrNull?.autoStartExtensionServerOnLaunch ??
        false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update(
      (s) => s.autoStartExtensionServerOnLaunch = value,
    );
  }
}

@riverpod
class OnlyIncludePinnedSourceState extends _$OnlyIncludePinnedSourceState {
  @override
  bool build() {
    return settingsRepository.current.onlyIncludePinnedSources!;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.onlyIncludePinnedSources = value);
  }
}

@riverpod
class ShowNSFWState extends _$ShowNSFWState {
  @override
  bool build() {
    return settingsRepository.current.showNSFW ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showNSFW = value);
  }
}

@riverpod
class ExtensionsRepoState extends _$ExtensionsRepoState {
  @override
  List<Repo> build(ItemType itemType) {
    final settings = settingsRepository.current;
    return switch (itemType) {
          ItemType.manga => settings.mangaExtensionsRepo,
          ItemType.anime => settings.animeExtensionsRepo,
          _ => settings.novelExtensionsRepo,
        } ??
        [];
  }

  void setVisibility(Repo repo, bool hidden) {
    final value = state.map((e) {
      if (e == repo) {
        e.hidden = hidden;
      }
      return e;
    }).toList();
    set(value);
  }

  void set(List<Repo> value) {
    state = value;
    settingsRepository.update((s) {
      switch (itemType) {
        case ItemType.manga:
          s.mangaExtensionsRepo = value;
          break;
        case ItemType.anime:
          s.animeExtensionsRepo = value;
          break;
        default:
          s.novelExtensionsRepo = value;
      }
    });
    try {
      final a = ref.refresh(
        fetchItemSourcesListProvider(
          id: null,
          reFresh: false,
          itemType: itemType,
        ).future,
      );
      Future.wait([a]);
    } catch (_) {}
  }
}

@riverpod
class AutoUpdateExtensionsState extends _$AutoUpdateExtensionsState {
  @override
  bool build() {
    return settingsRepository.current.autoExtensionsUpdates ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.autoExtensionsUpdates = value);
  }
}

@riverpod
class CheckForExtensionsUpdateState extends _$CheckForExtensionsUpdateState {
  @override
  bool build() {
    return settingsRepository.current.checkForExtensionUpdates ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.checkForExtensionUpdates = value);
  }
}

@riverpod
Future<Repo?> getRepoInfos(Ref ref, {required String jsonUrl}) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});

  if (['/.min.json', '.pb'].any((suffix) => jsonUrl.endsWith(suffix))) {
    final result = await ExtensionStoreService.fetchStore(jsonUrl, http);
    if (result != null) {
      return Repo(
        name: result.name,
        website: result.website,
        jsonUrl: result.indexUrl,
      );
    }
  }

  Map<String, dynamic> infos = {};
  final match = RegExp(r'^(.*)/[^/]+\.json$').firstMatch(jsonUrl);

  final res = await http.get(Uri.parse(jsonUrl));
  if (!_checkValidUrl(res)) {
    return null;
  }

  if (match != null) {
    String url = match.group(1)!;
    final res = await http.get(Uri.parse("$url/repo.json"));
    if (res.statusCode == 200) {
      infos.addAll(jsonDecode(res.body));
    }
  }

  infos["jsonUrl"] = jsonUrl;
  return Repo.fromJson(infos);
}

bool _checkValidUrl(Response res) {
  try {
    final sourceList = (jsonDecode(res.body) as List).map(
      (e) => Source.fromJson(e),
    );
    if (sourceList.firstOrNull?.name == null) {
      return false;
    }
  } catch (err) {
    return false;
  }
  return true;
}

final isExtensionServerInstalledStreamProvider = StreamProvider<bool>((
  ref,
) async* {
  if (!isDesktop) {
    yield true;
    return;
  }
  await for (final settings in settingsRepository.watch()) {
    final jrePath = settings.jrePath ?? '';
    final serverPath = settings.extensionServerPath ?? '';
    if (jrePath.isEmpty || serverPath.isEmpty) {
      yield false;
    } else {
      yield File(jrePath).existsSync() && File(serverPath).existsSync();
    }
  }
});

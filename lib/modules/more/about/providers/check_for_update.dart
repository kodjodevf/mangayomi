import 'dart:convert';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'check_for_update.g.dart';

@riverpod
Future<void> checkForUpdate(
  Ref ref, {
  BuildContext? context,
  bool? manualUpdate,
}) async {
  manualUpdate = manualUpdate ?? false;
  final checkForUpdates = ref.watch(checkForAppUpdatesProvider);
  if (!checkForUpdates && !manualUpdate) return;
  final l10n = l10nLocalizations(context!)!;

  if (manualUpdate) {
    BotToast.showText(text: l10n.searching_for_updates);
  }
  final info = await PackageInfo.fromPlatform();
  if (kDebugMode) {
    log(info.data.toString());
  }
  final updateAvailable = await _checkUpdate();
  if (compareVersions(info.version, updateAvailable.$1) < 0) {
    if (manualUpdate) {
      BotToast.showText(text: l10n.new_update_available);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return DownloadFileScreen(updateAvailable: updateAvailable);
        },
      );
    }
  } else if (compareVersions(info.version, updateAvailable.$1) == 0) {
    if (manualUpdate) {
      BotToast.showText(text: l10n.no_new_updates_available);
    }
  }
}

@riverpod
bool checkForAppUpdates(Ref ref) {
  return isar.settings.getSync(227)?.checkForAppUpdates ?? true;
}

Future<(String, String, String, List<dynamic>)> _checkUpdate() async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final res = await http.get(
      Uri.parse(
        "https://api.github.com/repos/kodjodevf/Mangayomi/releases?page=1&per_page=10",
      ),
    );
    List resListJson = jsonDecode(res.body) as List;
    return (
      resListJson.first["name"]
          .toString()
          .substringAfter('v')
          .substringBefore('-'),
      resListJson.first["body"].toString(),
      resListJson.first["html_url"].toString(),
      (resListJson.first["assets"] as List)
          .map((asset) => asset["browser_download_url"])
          .toList(),
    );
  } catch (e) {
    rethrow;
  }
}

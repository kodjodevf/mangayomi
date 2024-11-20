import 'dart:convert';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
part 'check_for_update.g.dart';

@riverpod
Future<void> checkForUpdate(Ref ref,
    {BuildContext? context, bool? manualUpdate}) async {
  manualUpdate = manualUpdate ?? false;
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
          return AlertDialog(
            title: Text(l10n.new_update_available),
            content: Text(
                "${l10n.app_version(updateAvailable.$1)}\n\n${updateAvailable.$2}"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(l10n.cancel)),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _launchInBrowser(Uri.parse(updateAvailable.$3));
                      },
                      child: Text(l10n.download)),
                ],
              )
            ],
          );
        },
      );
    }
  } else if (compareVersions(info.version, updateAvailable.$1) == 0) {
    if (manualUpdate) {
      BotToast.showText(text: l10n.no_new_updates_available);
    }
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

Future<(String, String, String)> _checkUpdate() async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final res = await http.get(Uri.parse(
        "https://api.github.com/repos/kodjodevf/Mangayomi/releases?page=1&per_page=10"));
    List resListJson = jsonDecode(res.body) as List;
    return (
      resListJson.first["name"]
          .toString()
          .substringAfter('v')
          .substringBefore('-'),
      resListJson.first["body"].toString(),
      resListJson.first["html_url"].toString()
    );
  } catch (e) {
    rethrow;
  }
}

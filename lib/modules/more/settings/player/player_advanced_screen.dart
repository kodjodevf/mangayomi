import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:path/path.dart' as path;
import 'package:mangayomi/utils/platform_utils.dart';

class PlayerAdvancedScreen extends ConsumerStatefulWidget {
  const PlayerAdvancedScreen({super.key});

  @override
  ConsumerState<PlayerAdvancedScreen> createState() =>
      _PlayerAdvancedScreenState();
}

class _PlayerAdvancedScreenState extends ConsumerState<PlayerAdvancedScreen> {
  @override
  Widget build(BuildContext context) {
    final useMpvConfig = ref.watch(useMpvConfigStateProvider);

    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.advanced)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          ShioriSettingsGroup(
            children: [
              ShioriSwitchRow(
                autofocus: isTv,
                title: l10n.enable_mpv,
                subtitle: l10n.mpv_info,
                value: useMpvConfig,
                onChanged: (value) async {
                  if (value && !(await _checkMpvConfig(context))) {
                    return;
                  }
                  ref.read(useMpvConfigStateProvider.notifier).set(value);
                },
              ),
              ShioriSettingRow(
                title: l10n.mpv_redownload,
                subtitle: l10n.mpv_redownload_info,
                onTap: () => _checkMpvConfig(context, redownload: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _checkMpvConfig(
    BuildContext context, {
    bool redownload = false,
  }) async {
    final provider = StorageProvider();
    if (!(await provider.requestPermission())) {
      return false;
    }
    final dir = await provider.getMpvDirectory();
    final mpvFile = File('${dir!.path}/mpv.conf');
    final inputFile = File('${dir.path}/input.conf');
    final filesMissing =
        !(await mpvFile.exists()) && !(await inputFile.exists());
    if ((redownload || filesMissing) && context.mounted) {
      final confirmed = await showShioriConfirm(
        context,
        title: context.l10n.enable_mpv,
        message: context.l10n.mpv_download,
        confirmLabel: context.l10n.download,
      );
      if (!confirmed) return false;
      // The configuration ships with the app: this unpacks it, nothing is
      // fetched.
      final bytes = await rootBundle.load("assets/mangayomi_mpv.zip");
      final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
      String shadersDir = path.join(dir.path, 'shaders');
      await Directory(shadersDir).create(recursive: true);
      String scriptsDir = path.join(dir.path, 'scripts');
      await Directory(scriptsDir).create(recursive: true);
      for (final file in archive.files) {
        if (file.name == "mpv.conf") {
          await mpvFile.writeAsBytes(file.content);
        } else if (file.name == "input.conf") {
          await inputFile.writeAsBytes(file.content);
        } else if (file.name.startsWith("shaders/") &&
            file.name.endsWith(".glsl")) {
          final shaderFile = File('$shadersDir/${file.name.split("/").last}');
          await shaderFile.writeAsBytes(file.content);
        } else if (file.name.startsWith("scripts/") &&
            (file.name.endsWith(".js") || file.name.endsWith(".lua"))) {
          final scriptFile = File('$scriptsDir/${file.name.split("/").last}');
          await scriptFile.writeAsBytes(file.content);
        }
      }
      return true;
    }
    return context.mounted;
  }
}

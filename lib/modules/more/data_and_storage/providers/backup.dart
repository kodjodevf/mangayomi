import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_compression.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/source_preference_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/services/backup_password_storage.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
part 'backup.g.dart';

@riverpod
Future<void> doBackUp(
  Ref ref, {
  required List<int> list,
  required String path,
  required BuildContext? context,
}) async {
  final compression = ref.read(backupCompressionLevelProvider);
  final compressionLevel = compression.clamp(0, 9).toInt();
  try {
    final zipPath = await writeMangayomiBackupZip(
      list: list,
      directory: path,
      compressionLevel: compressionLevel,
    );
    final assets = [
      'assets/app_icons/icon-black.png',
      'assets/app_icons/icon-red.png',
    ];
    if (context != null && context.mounted) {
      Navigator.pop(context);
      BotToast.showNotification(
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 5),
        backButtonBehavior: BackButtonBehavior.none,
        leading: (_) => Image.asset((assets..shuffle()).first, height: 25),
        title: (_) => const Text(
          "Backup created!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // The button used to be hidden on Linux, where share_plus throws on a
        // file. shareOrCopy answers there with the backup's path on the
        // clipboard, which is the thing a Linux user wanted from it anyway.
        trailing: (_) => UnconstrainedBox(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            onPressed: () {
              final RenderBox? box = context.findRenderObject() as RenderBox?;
              shareOrCopy(
                ShareParams(
                  files: [XFile(zipPath)],
                  subject: p.basename(zipPath),
                  title: "Share Mangayomi backup file",
                  sharePositionOrigin: box == null
                      ? null
                      : box.localToGlobal(Offset.zero) & box.size,
                ),
              );
            },
            child: Text(context.l10n.share),
          ),
        ),
        enableSlideOff: true,
        onlyOne: true,
        crossPage: true,
      );
    }
  } catch (e) {
    if (context?.mounted ?? false) {
      BotToast.showNotification(
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 7),
        backButtonBehavior: BackButtonBehavior.none,
        leading: (_) => const Icon(Icons.error, color: Colors.red),
        title: (_) => Text(
          "Backup failed: $e",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        enableSlideOff: true,
        onlyOne: true,
        crossPage: true,
      );
    }
  }
}

Future<String> writeMangayomiBackupZip({
  required List<int> list,
  required String directory,
  int compressionLevel = 6,
  bool encrypt = true,
}) async {
  Map<String, dynamic> datas = {};
  datas.addAll({"version": "2"});
  if (list.contains(0)) {
    final res = mangaRepository
        .getFavoritesNonLocalArchive()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"manga": res});
  }
  if (list.contains(1)) {
    final res = categoryRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"categories": res});
  }
  if (list.contains(2)) {
    final res = chapterRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"chapters": res});
    final res_ = downloadRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"downloads": res_});
  }
  if (list.contains(3)) {
    final res = trackRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"tracks": res});
  }
  if (list.contains(4)) {
    final res = historyRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"history": res});
  }
  if (list.contains(5)) {
    final res = updateRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"updates": res});
  }
  if (list.contains(6)) {
    final res = settingsRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"settings": res});
  } else {
    final setting = Settings()..themeIsDark = isTv;
    datas.addAll({
      "settings": [setting.toJson()],
    });
  }
  if (list.contains(7)) {
    final res = sourcePreferenceRepository
        .getAll()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"extensions_preferences": res});
  }
  if (list.contains(8)) {
    final res_ = trackRepository
        .getAllPreferences()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"trackPreferences": res_});
  }
  if (list.contains(9)) {
    final res = sourceRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"extensions": res});
  }
  if (list.contains(10)) {
    final res = customButtonRepository.getAll().map((e) => e.toJson()).toList();
    datas.addAll({"customButtons": res});
  }
  String? encryptionPassword;
  if (encrypt &&
      (settingsRepository.currentOrNull?.backupEncryptionEnabled ?? false)) {
    encryptionPassword = await BackupPasswordStorage.get();
    if (encryptionPassword == null) {
      throw Exception(
        'Backup encryption is enabled but no password is set. '
        'Re-enter it in Data and Storage settings.',
      );
    }
    datas.addAll({"backupEncryptionPassword": encryptionPassword});
  }
  final regExp = RegExp(r'[^a-zA-Z0-9 .()\-\s]');
  final name =
      'mangayomi_${DateTime.now().toString().replaceAll(regExp, '_').replaceAll(' ', '_')}';
  final backupFilePath = p.join(directory, "$name.backup.db");
  final file = File(backupFilePath);

  await file.writeAsString(jsonEncode(datas));
  final zipPath = p.join(directory, "$name.backup");
  final zipEncoder = ZipFileEncoder(password: encryptionPassword);
  zipEncoder.create(zipPath, level: compressionLevel);
  await zipEncoder.addFile(file);
  await zipEncoder.close();
  file.delete();
  return zipPath;
}

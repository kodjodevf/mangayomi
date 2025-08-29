import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Map<String, dynamic> datas = {};
  datas.addAll({"version": "2"});
  if (list.contains(0)) {
    final res = isar.mangas
        .filter()
        .idIsNotNull()
        .favoriteEqualTo(true)
        .isLocalArchiveEqualTo(false)
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"manga": res});
  }
  if (list.contains(1)) {
    final res = isar.categorys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"categories": res});
  }
  if (list.contains(2)) {
    final res = isar.chapters
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"chapters": res});
    final res_ = isar.downloads
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"downloads": res_});
  }
  if (list.contains(3)) {
    final res = isar.tracks
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"tracks": res});
  }
  if (list.contains(4)) {
    final res = isar.historys
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"history": res});
  }
  if (list.contains(5)) {
    final res = isar.updates
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"updates": res});
  }
  if (list.contains(6)) {
    final res = isar.settings
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"settings": res});
  }
  if (list.contains(7)) {
    final res = isar.sourcePreferences
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"extensions_preferences": res});
  }
  if (list.contains(8)) {
    final res_ = isar.trackPreferences
        .filter()
        .syncIdIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"trackPreferences": res_});
  }
  if (list.contains(9)) {
    final res = isar.sources
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"extensions": res});
  }
  if (list.contains(10)) {
    final res = isar.customButtons
        .filter()
        .idIsNotNull()
        .findAllSync()
        .map((e) => e.toJson())
        .toList();
    datas.addAll({"customButtons": res});
  }
  final regExp = RegExp(r'[^a-zA-Z0-9 .()\-\s]');
  final name =
      'mangayomi_${DateTime.now().toString().replaceAll(regExp, '_').replaceAll(' ', '_')}';
  final backupFilePath = p.join(path, "$name.backup.db");
  final file = File(backupFilePath);

  await file.writeAsString(jsonEncode(datas));
  var encoder = ZipFileEncoder();
  encoder.create(p.join(path, "$name.backup"));
  await encoder.addFile(File(backupFilePath));
  await encoder.close();
  await Directory(backupFilePath).delete(recursive: true);
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
      trailing: Platform.isLinux
          ? null
          : // Don't show share button on Linux, as there is no share-feature
            (_) => UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  final box = context.findRenderObject() as RenderBox?;
                  Share.shareXFiles(
                    [XFile(p.join(path, "$name.backup"))],
                    text: "$name.backup",
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
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
}

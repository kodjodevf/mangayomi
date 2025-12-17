import 'dart:io';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'storage_usage.g.dart';

@riverpod
class TotalChapterCacheSizeState extends _$TotalChapterCacheSizeState {
  @override
  String build() {
    _getTotalDiskSpace().then((value) {
      if (!ref.mounted) return;
      state = _formatBytes(value);
    });
    return "0.00 B";
  }

  final _storage = StorageProvider();

  Future<void> clearCache({bool showToast = true}) async {
    String? msg;
    try {
      final dir = await _storage.getCacheDirectory('cacheimagemanga');
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
      msg = "0.00 B";
    } catch (_) {}
    try {
      await _storage.deleteTmpDirectory();
    } catch (_) {}
    if (msg != null && showToast) {
      state = msg;
      botToast(
        navigatorKey.currentContext?.l10n.cache_cleared ?? "Cache cleared",
      );
    }
  }

  Future<int> _getTotalDiskSpace() async {
    try {
      return await _getdirectorySize(
        await _storage.getCacheDirectory('cacheimagemanga'),
      );
    } catch (_) {}
    return 0;
  }

  Future<int> _getdirectorySize(Directory directory) async {
    try {
      if (await directory.exists()) {
        return directory
            .list(recursive: true, followLinks: false)
            .where((entity) => entity is File)
            .cast<File>()
            .fold(0, (total, file) {
              return total + file.lengthSync();
            });
      }
    } catch (_) {}
    return 0;
  }

  String _formatBytes(int bytes) {
    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }
}

@riverpod
class ClearChapterCacheOnAppLaunchState
    extends _$ClearChapterCacheOnAppLaunchState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.clearChapterCacheOnAppLaunch ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..clearChapterCacheOnAppLaunch = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

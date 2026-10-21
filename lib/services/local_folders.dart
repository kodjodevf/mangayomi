import 'dart:io';

import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/local_directory_resolver.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:path/path.dart' as p;
import 'package:shiori/shiori.dart';

/// Returns the `/local` directory inside the app's default storage.
Future<Directory?> getLocalLibrary() async {
  try {
    final dir = await StorageProvider().getDefaultDirectory();
    return dir == null ? null : Directory(p.join(dir.path, 'local'));
  } catch (e) {
    botToast(
      localizedMessage((l10n) => l10n.error_getting_local_library(e)),
      tone: ShioriToastTone.error,
      second: 4,
    );
    return null;
  }
}

Future<LocalFolder?> getDefaultLocalFolder() async {
  final dir = await getLocalLibrary();
  if (dir == null) return null;
  return LocalFolder(name: 'local', path: dir.path);
}

Future<List<LocalFolder>> getAllLocalFolders({
  bool includeDefault = true,
  Settings? settings,
}) async {
  settings ??= settingsRepository.current;
  final folders = normalizeLocalFolders(
    settings.namedLocalFolders ??
        settings.localFolders
            ?.map((e) => LocalFolder.fromPath(path: e))
            .toList() ??
        [],
  );
  if (!includeDefault) return folders;
  final defaultFolder = await getDefaultLocalFolder();
  return [?defaultFolder, ...folders];
}

Future<LocalFolder?> getDownloadLocalFolder() async {
  final folders = await getAllLocalFolders();
  if (folders.isEmpty) return null;
  final settings = settingsRepository.current;
  final name = resolveDownloadFolderName(
    settings.downloadLocalFolderName,
    folders,
  );
  return folders.firstWhere((folder) => folder.name == name);
}

void setDownloadLocalFolderName(String? name) {
  settingsRepository.update((s) => s.downloadLocalFolderName = name);
}

String getLocalVirtualPath(LocalFolder folder, String entityPath) {
  final folderName = folder.name?.trim();
  final folderPath = folder.path;
  if (folderName == null ||
      folderName.isEmpty ||
      folderPath == null ||
      folderPath.isEmpty) {
    return normalizePath(entityPath);
  }
  final relative = p.relative(entityPath, from: folderPath);
  if (relative == '.') return folderName;
  return p.posix.join(folderName, normalizePath(relative));
}

String localVirtualPathFromStoredPath(
  String? storedPath,
  List<LocalFolder> folders,
) {
  if (storedPath == null || storedPath.trim().isEmpty) return '';
  final normalized = normalizePath(storedPath);
  final firstSegment = normalized.split('/').firstOrNull;
  if (firstSegment != null &&
      folders.any((folder) => folder.name == firstSegment)) {
    return normalized;
  }

  for (final folder in folders) {
    final folderPath = folder.path;
    if (folderPath == null || folderPath.isEmpty) continue;
    final normalizedFolderPath = normalizePath(folderPath);
    if (normalized == normalizedFolderPath ||
        normalized.startsWith('$normalizedFolderPath/')) {
      return getLocalVirtualPath(folder, storedPath);
    }
  }

  const legacyLocalPath = 'Mangayomi/local';
  final legacyIndex = normalized.indexOf(legacyLocalPath);
  if (legacyIndex != -1) {
    final relative = normalized
        .substring(legacyIndex + legacyLocalPath.length)
        .replaceFirst(RegExp('^/+'), '');
    return p.posix.join('local', relative);
  }

  return normalized;
}

Future<String> resolveLocalArchivePath(String archivePath) async {
  final folders = await getAllLocalFolders();
  final normalized = normalizePath(archivePath);
  final parts = normalized.split('/');
  if (parts.length < 2) return archivePath;

  final folder = folders.firstWhere(
    (folder) => folder.name == parts.first,
    orElse: () => LocalFolder(),
  );
  if (folder.path == null || folder.path!.isEmpty) return archivePath;
  final resolvedFolder = await resolveLocalDirectoryPath(
    folder.path!,
    logContext: 'resolveLocalArchivePath',
  );
  return p.joinAll([resolvedFolder.path, ...parts.skip(1)]);
}

List<LocalFolder> normalizeLocalFolders(List<LocalFolder> folders) {
  final usedNames = <String>{'local'};
  return folders
      .where((folder) => (folder.path?.trim().isNotEmpty ?? false))
      .map((folder) {
        final name = _uniqueLocalFolderName(
          folder.name?.trim().isNotEmpty ?? false
              ? folder.name!.trim()
              : LocalFolder.fromPath(path: folder.path!).name ?? 'Local',
          usedNames,
        );
        usedNames.add(name);
        return LocalFolder(name: name, path: folder.path!.trim());
      })
      .toList();
}

String _uniqueLocalFolderName(String value, Set<String> usedNames) {
  final normalized = value.replaceAll('/', '_').replaceAll('\\', '_').trim();
  final base = normalized.isEmpty ? 'Local' : normalized;
  var name = base == 'local' ? 'Local' : base;
  var index = 2;
  while (usedNames.contains(name)) {
    name = '$base $index';
    index++;
  }
  return name;
}

String? resolveDownloadFolderName(String? name, List<LocalFolder> folders) {
  if (name != null && folders.any((folder) => folder.name == name)) {
    return name;
  }
  return folders.firstOrNull?.name;
}

List<LocalFolder> replaceLocalFolder(
  List<LocalFolder> folders,
  String originalPath,
  LocalFolder replacement,
) {
  var replaced = false;
  final updated = folders.map((folder) {
    if (!replaced &&
        folder.name == replacement.name &&
        folder.path?.trim() == originalPath) {
      replaced = true;
      return replacement;
    }
    return folder;
  }).toList();
  return replaced ? updated : [replacement, ...updated];
}

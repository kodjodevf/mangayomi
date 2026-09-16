// Resolving a user-configured local folder path to wherever it actually
// lives on this OS/device. Split out of file_scanner.dart: this only ever
// probes the filesystem and asks for permissions - it never touches Isar or
// Riverpod state, so it can be exercised (and reasoned about) on its own.
//
// Exists because a path picked via a file/folder picker on Android in
// particular doesn't always match what plain dart:io sees afterwards (SD
// cards, scoped storage, SAF-mounted volumes) - this tries the path as
// given, then a handful of known-equivalent mount points, before giving up.
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:path/path.dart' as p;

String normalizePath(String path) {
  return path.replaceAll('\\', '/').replaceAll(RegExp('/+'), '/');
}

class ResolvedLocalDirectory {
  final String path;
  final DirectoryProbe probe;

  const ResolvedLocalDirectory({required this.path, required this.probe});
}

class DirectoryProbe {
  final String path;
  final String absolutePath;
  final String normalizedPath;
  final String parentPath;
  final bool exists;
  final bool parentExists;
  final FileStat? stat;
  final Object? existsError;
  final Object? parentExistsError;
  final Object? statError;

  const DirectoryProbe({
    required this.path,
    required this.absolutePath,
    required this.normalizedPath,
    required this.parentPath,
    required this.exists,
    required this.parentExists,
    required this.stat,
    required this.existsError,
    required this.parentExistsError,
    required this.statError,
  });
}

Future<ResolvedLocalDirectory> resolveLocalDirectoryPath(
  String dirPath, {
  required String logContext,
}) async {
  var probe = await _probeLocalDirectory(dirPath);
  _logDirectoryProbe(logContext, 'initial', probe);
  if (probe.exists) {
    return ResolvedLocalDirectory(path: dirPath, probe: probe);
  }

  if (Platform.isAndroid) {
    final permissionGranted = await StorageProvider().requestPermission();
    debugPrint(
      '[LocalLibraryScanner] $logContext Android storage permission retry: '
      'granted=$permissionGranted, path=$dirPath',
    );
    if (permissionGranted) {
      probe = await _probeLocalDirectory(dirPath);
      _logDirectoryProbe(logContext, 'after-permission', probe);
      if (probe.exists) {
        return ResolvedLocalDirectory(path: dirPath, probe: probe);
      }
    }
  }

  final directCandidates = _directAndroidDirectoryCandidates(dirPath);
  debugPrint(
    '[LocalLibraryScanner] $logContext direct Android candidates: '
    '${directCandidates.isEmpty ? '<none>' : directCandidates.join(' | ')}',
  );
  for (final candidate in directCandidates) {
    final candidateProbe = await _probeLocalDirectory(candidate);
    _logDirectoryProbe(logContext, 'direct-android-candidate', candidateProbe);
    if (candidateProbe.exists) {
      return ResolvedLocalDirectory(path: candidate, probe: candidateProbe);
    }
  }

  final externalPathCandidates = await _safeExternalPathDirectoryCandidates(
    dirPath,
    logContext: logContext,
  );
  for (final candidate in externalPathCandidates) {
    final candidateProbe = await _probeLocalDirectory(candidate);
    _logDirectoryProbe(logContext, 'external_path-candidate', candidateProbe);
    if (candidateProbe.exists) {
      return ResolvedLocalDirectory(path: candidate, probe: candidateProbe);
    }
  }

  return ResolvedLocalDirectory(path: dirPath, probe: probe);
}

Future<DirectoryProbe> _probeLocalDirectory(String dirPath) async {
  final dir = Directory(dirPath);
  final parent = dir.parent;
  bool dirExists = false;
  bool parentExists = false;
  FileStat? dirStat;
  Object? dirExistsError;
  Object? parentExistsError;
  Object? dirStatError;
  try {
    dirExists = await dir.exists();
  } catch (e) {
    dirExistsError = e;
  }
  try {
    parentExists = await parent.exists();
  } catch (e) {
    parentExistsError = e;
  }
  try {
    dirStat = await dir.stat();
  } catch (e) {
    dirStatError = e;
  }
  return DirectoryProbe(
    path: dirPath,
    absolutePath: dir.absolute.path,
    normalizedPath: normalizePath(dirPath),
    parentPath: parent.path,
    exists: dirExists,
    parentExists: parentExists,
    stat: dirStat,
    existsError: dirExistsError,
    parentExistsError: parentExistsError,
    statError: dirStatError,
  );
}

void _logDirectoryProbe(
  String logContext,
  String stage,
  DirectoryProbe probe,
) {
  debugPrint(
    '[LocalLibraryScanner] $logContext directory probe [$stage]: '
    'path=${probe.path}, '
    'absolutePath=${probe.absolutePath}, '
    'normalizedPath=${probe.normalizedPath}, '
    'parent=${probe.parentPath}, '
    'exists=${probe.exists}, '
    'parentExists=${probe.parentExists}, '
    'statType=${probe.stat?.type}, '
    'statMode=${probe.stat?.modeString()}, '
    'modified=${probe.stat?.modified.toIso8601String()}',
  );
  if (probe.existsError != null ||
      probe.parentExistsError != null ||
      probe.statError != null) {
    debugPrint(
      '[LocalLibraryScanner] $logContext directory probe errors [$stage]: '
      'existsError=${probe.existsError}, '
      'parentExistsError=${probe.parentExistsError}, '
      'statError=${probe.statError}',
    );
  }
}

Future<List<String>> _externalPathDirectoryCandidates(String dirPath) async {
  if (!Platform.isAndroid && !Platform.isIOS) return [];
  final roots = await _externalPathRoots();
  final normalizedOriginal = normalizePath(dirPath);
  final suffixes = _externalPathSuffixes(dirPath);
  final candidates = <String>{};
  for (final root in roots) {
    final normalizedRoot = normalizePath(root);
    if (normalizedOriginal == normalizedRoot) {
      candidates.add(root);
    }
    for (final suffix in suffixes) {
      candidates.add(p.join(root, suffix));
    }
  }
  return candidates
      .where((candidate) => normalizePath(candidate) != normalizedOriginal)
      .toList();
}

Future<List<String>> _safeExternalPathDirectoryCandidates(
  String dirPath, {
  required String logContext,
}) async {
  try {
    final candidates = await _externalPathDirectoryCandidates(dirPath);
    debugPrint(
      '[LocalLibraryScanner] $logContext external_path candidates: '
      '${candidates.isEmpty ? '<none>' : candidates.join(' | ')}',
    );
    return candidates;
  } catch (e, stackTrace) {
    debugPrint(
      '[LocalLibraryScanner] $logContext external_path candidates failed: $e\n'
      '$stackTrace',
    );
    return [];
  }
}

List<String> _directAndroidDirectoryCandidates(String dirPath) {
  if (!Platform.isAndroid) return [];
  final normalizedOriginal = normalizePath(dirPath);
  final parts = normalizedOriginal
      .split('/')
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.length < 3 || parts.first != 'storage') return [];

  final volume = parts[1];
  if (volume == 'emulated' || volume == 'self') return [];

  final suffix = p.joinAll(parts.skip(2));
  return [
        p.join('/mnt/media_rw', volume, suffix),
        p.join('/mnt/runtime/default', volume, suffix),
        p.join('/mnt/runtime/read', volume, suffix),
        p.join('/mnt/runtime/write', volume, suffix),
      ]
      .where((candidate) => normalizePath(candidate) != normalizedOriginal)
      .toList();
}

Future<List<String>> _externalPathRoots() async {
  final roots = <String>{};
  try {
    roots.addAll(
      (await ExternalPath.getExternalStorageDirectories() ?? [])
          .map((path) => path.trim())
          .where((path) => path.isNotEmpty),
    );
  } catch (e) {
    debugPrint(
      '[LocalLibraryScanner] external_path getExternalStorageDirectories '
      'failed: $e',
    );
  }

  for (final type in _externalPathPublicDirectoryTypes()) {
    try {
      final path = await ExternalPath.getExternalStoragePublicDirectory(type);
      if (path.trim().isNotEmpty) roots.add(path.trim());
    } catch (e) {
      debugPrint(
        '[LocalLibraryScanner] external_path public directory failed: '
        'type=$type, error=$e',
      );
    }
  }
  debugPrint(
    '[LocalLibraryScanner] external_path roots: '
    '${roots.isEmpty ? '<none>' : roots.join(' | ')}',
  );
  return roots.toList();
}

List<String> _externalPathSuffixes(String dirPath) {
  final parts = normalizePath(
    dirPath,
  ).split('/').where((part) => part.isNotEmpty).toList();
  final suffixes = <String>{};
  if (parts.length > 2 && parts[0] == 'storage') {
    suffixes.add(p.joinAll(parts.skip(2)));
  }
  if (parts.length > 3 && parts[0] == 'mnt' && parts[1] == 'media_rw') {
    suffixes.add(p.joinAll(parts.skip(3)));
  }
  if (parts.isNotEmpty) suffixes.add(parts.last);
  return suffixes.where((suffix) => suffix.trim().isNotEmpty).toList();
}

List<String> _externalPathPublicDirectoryTypes() {
  if (Platform.isAndroid) {
    return [ExternalPath.DIRECTORY_DOCUMENTS, ExternalPath.DIRECTORY_DOWNLOAD];
  }
  if (Platform.isIOS) {
    return [
      ExternalPath.DIRECTORY_DOCUMENTS,
      ExternalPath.DIRECTORY_DOWNLOAD,
      ExternalPath.DIRECTORY_CACHES,
      ExternalPath.DIRECTORY_LIBRARY,
      ExternalPath.DIRECTORY_APPLICATION_SUPPORT,
    ];
  }
  return [];
}

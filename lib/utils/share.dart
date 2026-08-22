import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

/// Shares [params], or puts what it carries on the clipboard where the
/// platform has no share to offer.
///
/// share_plus has no real Linux implementation. It throws `UnimplementedError`
/// the moment [ShareParams] carries a file, and its text-only path builds a
/// `mailto:` URI and throws again when the desktop has no mail client, so
/// every share on Linux is either a crash or an email composer. The backup
/// screen had already worked around this by hiding its share button there, and
/// the About screen by copying the log path to the clipboard, except it went
/// on to call share anyway and threw.
///
/// [fallbackName] names a file carried as bytes, which has no path of its own
/// to report. [useFallback] exists so the fallback can be exercised off Linux.
Future<void> shareOrCopy(
  ShareParams params, {
  String? fallbackName,
  bool? useFallback,
}) async {
  if (!(useFallback ?? Platform.isLinux)) {
    await SharePlus.instance.share(params);
    return;
  }
  final text = await shareFallbackText(
    params,
    await StorageProvider().getGalleryDirectory(),
    fallbackName: fallbackName,
  );
  if (text == null || text.isEmpty) return;
  await Clipboard.setData(ClipboardData(text: text));
  botToast(
    localizedMessage((l10n) => l10n.share_unavailable_copied),
    second: 5,
  );
}

/// What the clipboard should hold to stand in for sharing [params], or null
/// when there is nothing worth offering.
///
/// A file already on disk is reported where it is. A file carried as bytes has
/// nowhere to point at, so it is written into [directory] first — the same
/// place the reader's own save action puts images — and the copy's path is
/// reported instead. Falling back to the text or URI covers the call sites
/// that share a link rather than a file.
@visibleForTesting
Future<String?> shareFallbackText(
  ShareParams params,
  Directory? directory, {
  String? fallbackName,
}) async {
  final paths = <String>[];
  for (final file in params.files ?? const <XFile>[]) {
    // cross_file drops the `name:` given to XFile.fromData on every non-web
    // platform, so a byte-backed file reports an empty path and an empty name
    // and the caller has to supply one.
    if (file.path.isNotEmpty) {
      paths.add(file.path);
      continue;
    }
    if (directory == null) continue;
    final target = p.join(
      directory.path,
      _fileName(file, fallbackName, paths.length),
    );
    try {
      await file.saveTo(target);
      paths.add(target);
    } catch (_) {
      // Nothing to point the user at, but a failed write is not a reason to
      // take down whatever they were doing.
    }
  }
  if (paths.isNotEmpty) return paths.join('\n');
  return params.text ?? params.uri?.toString();
}

/// A name to save a byte-backed file under, with an extension if its mime type
/// implies one and the name does not already carry it.
String _fileName(XFile file, String? fallbackName, int index) {
  var name = file.name.isNotEmpty
      ? file.name
      : (fallbackName?.trim().isNotEmpty ?? false)
      ? fallbackName!.trim()
      : 'shared${index == 0 ? '' : '_$index'}';
  final slash = RegExp(r'[\\/]');
  name = name.split(slash).last;
  final extension = switch (file.mimeType) {
    'image/png' => '.png',
    'image/jpeg' => '.jpg',
    'image/webp' => '.webp',
    _ => '',
  };
  if (extension.isNotEmpty && p.extension(name).toLowerCase() != extension) {
    name = '$name$extension';
  }
  return name;
}

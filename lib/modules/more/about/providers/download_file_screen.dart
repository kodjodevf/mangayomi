import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mangayomi/utils/error_toast.dart';

class DownloadFileScreen extends ConsumerStatefulWidget {
  final (String, String, String, List<dynamic>) updateAvailable;
  const DownloadFileScreen({required this.updateAvailable, super.key});

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen> {
  int _total = 0;
  int _received = 0;
  bool _isDownloading = false;
  bool _isInstalling = false;
  String? _errorMessage;
  String _currentVersion = '';

  http.StreamedResponse? _response;
  final List<int> _bytes = [];
  StreamSubscription<List<int>>? _subscription;
  final ScrollController _changelogScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCurrentVersion();
  }

  Future<void> _loadCurrentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _currentVersion = info.version;
        });
      }
    } catch (error, stackTrace) {
      recordError(error, stack: stackTrace, source: 'download_file_screen');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _changelogScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final targetVersion = widget.updateAvailable.$1;
    final changelog = widget.updateAvailable.$2;
    return ShioriDialog(
      title: l10n.new_update_available,
      // As wide as a comfortable line of notes, narrower on a phone.
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: ShioriSpace.s16,
          children: [
            _versions(context, targetVersion),
            _notes(context, changelog),
            if (_isDownloading)
              _progress(context)
            else if (_errorMessage != null)
              _error(context),
          ],
        ),
      ),
      actions: [
        ShioriButton.quiet(
          label: l10n.cancel,
          onPressed: () async {
            if (_isDownloading) {
              try {
                await _subscription?.cancel();
              } catch (error, stackTrace) {
                recordError(
                  error,
                  stack: stackTrace,
                  source: 'download_file_screen',
                );
              }
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        // Android downloads and installs the APK; elsewhere the release
        // page opens in the browser, and the button says so.
        if (!_isDownloading)
          ShioriButton(
            icon: Platform.isAndroid
                ? Symbols.download_rounded
                : Symbols.open_in_browser_rounded,
            label: Platform.isAndroid ? l10n.download : l10n.open_in_browser,
            onPressed: () => _handleDownloadOrOpen(widget.updateAvailable),
          ),
      ],
    );
  }

  /// The version installed and the one on offer: "v0.6.0 → v0.7.0".
  Widget _versions(BuildContext context, String targetVersion) {
    final tokens = context.shiori;
    return Text.rich(
      TextSpan(
        children: [
          if (_currentVersion.isNotEmpty)
            TextSpan(text: 'v$_currentVersion  →  '),
          TextSpan(
            text: 'v$targetVersion',
            style: TextStyle(
              color: tokens.color.accentInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      style: tokens.text.meta.copyWith(
        color: tokens.color.fgMuted,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }

  /// The release notes, on a quiet ground, scrolling past a few lines.
  Widget _notes(BuildContext context, String changelog) {
    final tokens = context.shiori;
    final notes = _cleanChangelog(changelog);
    return Container(
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: tokens.color.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Scrollbar(
        controller: _changelogScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _changelogScrollController,
          padding: const EdgeInsets.all(ShioriSpace.s12),
          child: SelectableText(
            notes.isEmpty ? context.l10n.update_no_notes : notes,
            style: tokens.text.meta.copyWith(
              color: tokens.color.fg,
              height: 1.45,
            ),
          ),
        ),
      ),
    );
  }

  /// How far the download has come: the share and the megabytes over a bar,
  /// which runs on its own while the package installs.
  Widget _progress(BuildContext context) {
    final tokens = context.shiori;
    final progress = _total > 0 ? (_received / _total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: ShioriSpace.s8,
      children: [
        if (_total > 0)
          DefaultTextStyle.merge(
            style: const TextStyle(
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: tokens.text.meta.copyWith(
                    color: tokens.color.fg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (!_isInstalling)
                  Text(
                    '${(_received / 1048576.0).toStringAsFixed(1)} / ${(_total / 1048576.0).toStringAsFixed(1)} MB',
                    style: tokens.caption,
                  ),
              ],
            ),
          ),
        ShioriProgressBar(
          value: _isInstalling ? null : (_total > 0 ? progress : null),
        ),
      ],
    );
  }

  /// What went wrong, in the error tone, where the progress was.
  Widget _error(BuildContext context) {
    final tokens = context.shiori;
    final tone = tokens.color.error.foreground;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ShioriSpace.s8,
      children: [
        Icon(Symbols.error_rounded, fill: 1, color: tone, size: 20),
        Expanded(
          child: Text(
            _errorMessage ?? '',
            style: tokens.text.meta.copyWith(color: tone),
          ),
        ),
      ],
    );
  }

  String _cleanChangelog(String raw) {
    final lines = raw.split('\n');
    final formatted = <String>[];
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('**Full Changelog**') ||
          trimmed.startsWith('Full Changelog:')) {
        continue;
      }
      formatted.add(line);
    }
    return formatted.join('\n').trim();
  }

  Future<void> _handleDownloadOrOpen(
    (String, String, String, List<dynamic>) updateAvailable,
  ) async {
    if (Platform.isAndroid) {
      setState(() {
        _isDownloading = true;
        _errorMessage = null;
      });

      try {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        String apkUrl = '';
        final apks = updateAvailable.$4
            .whereType<String>()
            .where((apk) => apk.toLowerCase().endsWith('.apk'))
            .toList();

        final filteredApks = isTv
            ? apks
                  .where((apk) => apk.toLowerCase().contains('android-tv'))
                  .toList()
            : apks
                  .where((apk) => !apk.toLowerCase().contains('android-tv'))
                  .toList();

        final candidateApks = filteredApks.isNotEmpty ? filteredApks : apks;

        for (String abi in androidInfo.supportedAbis) {
          for (final apk in candidateApks) {
            if (apk.toLowerCase().contains(abi.toLowerCase())) {
              apkUrl = apk;
              break;
            }
          }
          if (apkUrl.isNotEmpty) break;
        }
        if (apkUrl.isEmpty && candidateApks.isNotEmpty) {
          apkUrl = candidateApks.first;
        }

        if (apkUrl.isNotEmpty) {
          await _downloadApk(apkUrl);
        } else {
          await _launchInBrowser(Uri.parse(updateAvailable.$3));
          if (mounted) {
            Navigator.pop(context);
          }
        }
      } catch (e, stackTrace) {
        recordError(e, stack: stackTrace, source: 'download_file_screen');
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = context.l10n.update_download_failed('$e');
          });
        }
      }
    } else {
      await _launchInBrowser(Uri.parse(updateAvailable.$3));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _downloadApk(String url) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory? dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) dir = await getExternalStorageDirectory();
    final file = File(
      '${dir!.path}/${url.split("/").lastOrNull ?? "Mangayomi.apk"}',
    );

    // If a file already exists, verify its integrity by comparing its size
    // against the server's Content-Length. A corrupt or incomplete download
    // would have a smaller size — delete it and re-download in that case.
    if (await file.exists()) {
      bool fileIsValid = false;
      try {
        final headResponse = await http.head(Uri.parse(url));
        final contentLength = int.tryParse(
          headResponse.headers['content-length'] ?? '',
        );
        final localSize = await file.length();
        if (contentLength != null && localSize == contentLength) {
          fileIsValid = true;
        }
      } catch (_) {
        // Network unavailable: fall back to assuming the file is valid so the
        // user can at least attempt installation while offline.
        fileIsValid = true;
      }

      if (fileIsValid) {
        if (!mounted) return;
        setState(() {
          _isInstalling = true;
        });
        await _installApk(file);
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      } else {
        // File is corrupted or incomplete — delete and re-download.
        try {
          await file.delete();
        } catch (error, stackTrace) {
          recordError(error, stack: stackTrace, source: 'download_file_screen');
        }
      }
    }

    _bytes.clear();
    _received = 0;

    _response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    setState(() {
      _total = _response?.contentLength ?? 0;
    });
    _subscription = _response?.stream.listen(
      (value) {
        setState(() {
          _bytes.addAll(value);
          _received += value.length;
        });
      },
      onError: (e) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _errorMessage = context.l10n.update_network_error;
          });
        }
      },
    );
    _subscription?.onDone(() async {
      try {
        if (mounted) {
          setState(() {
            _isInstalling = true;
          });
        }
        await file.writeAsBytes(_bytes);
        await _installApk(file);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e, stackTrace) {
        recordError(e, stack: stackTrace, source: 'download_file_screen');
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _isInstalling = false;
            _errorMessage = context.l10n.update_write_failed;
          });
        }
      }
    });
  }

  Future<void> _installApk(File file) async {
    var status = await Permission.requestInstallPackages.status;
    if (!status.isGranted) {
      await Permission.requestInstallPackages.request();
    }
    await ApkInstaller.installApk(file.path);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

class ApkInstaller {
  static const _platform = MethodChannel('com.kodjodevf.mangayomi.apk_install');
  static Future<void> installApk(String filePath) async {
    try {
      await _platform.invokeMethod('installApk', {'filePath': filePath});
    } catch (e) {
      if (kDebugMode) {
        log("Erreur d'installation : $e");
      }
    }
  }
}

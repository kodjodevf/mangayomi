import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFileScreen extends ConsumerStatefulWidget {
  final (String, String, String, List<dynamic>) updateAvailable;
  const DownloadFileScreen({required this.updateAvailable, super.key});

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen> {
  int _total = 0;
  int _received = 0;
  late http.StreamedResponse _response;
  final List<int> _bytes = [];
  late StreamSubscription<List<int>>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final updateAvailable = widget.updateAvailable;
    return AlertDialog(
      title: Text(l10n.new_update_available),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "${l10n.app_version(updateAvailable.$1)}\n\n${updateAvailable.$2}",
            ),
            _total > 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: LinearProgressIndicator(
                          value: _total > 0 ? (_received * 1.0) / _total : 0.0,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${(_received / 1048576.0).toStringAsFixed(2)}/${(_total / 1048576.0).toStringAsFixed(2)} MB',
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                try {
                  await _subscription?.cancel();
                } catch (_) {}
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.cancel),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: _total == 0
                  ? () async {
                      if (Platform.isAndroid) {
                        final deviceInfo = DeviceInfoPlugin();
                        final androidInfo = await deviceInfo.androidInfo;
                        String apkUrl = "";
                        for (String abi in androidInfo.supportedAbis) {
                          final url = updateAvailable.$4.firstWhereOrNull(
                            (apk) => (apk as String).contains(abi),
                          );
                          if (url != null) {
                            apkUrl = url;
                            break;
                          }
                        }
                        await _downloadApk(apkUrl);
                      } else {
                        _launchInBrowser(Uri.parse(updateAvailable.$3));
                      }
                    }
                  : null,
              child: Text(l10n.download),
            ),
          ],
        ),
      ],
    );
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
    if (await file.exists()) {
      await _installApk(file);
      if (mounted) {
        Navigator.pop(context);
      }
      return;
    }
    _response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    _total = _response.contentLength ?? 0;
    _subscription = _response.stream.listen((value) {
      setState(() {
        _bytes.addAll(value);
        _received += value.length;
      });
    });
    _subscription?.onDone(() async {
      await file.writeAsBytes(_bytes);
      await _installApk(file);
      if (mounted) {
        Navigator.pop(context);
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

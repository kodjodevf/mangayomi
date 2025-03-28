import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadFileScreen extends ConsumerStatefulWidget {
  final (String, String, String, List<String>) updateAvailable;
  const DownloadFileScreen({required this.updateAvailable, super.key});

  @override
  ConsumerState<DownloadFileScreen> createState() => _DownloadFileScreenState();
}

class _DownloadFileScreenState extends ConsumerState<DownloadFileScreen> {
  int _total = 0;
  int _received = 0;
  late http.StreamedResponse _response;
  final List<int> _bytes = [];

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final updateAvailable = widget.updateAvailable;
    return AlertDialog(
      title: Text(l10n.new_update_available),
      content: Text(
        "${l10n.app_version(updateAvailable.$1)}\n\n${updateAvailable.$2}",
      ),
      actions: [
        _total > 0
            ? Row(
              children: [
                LinearProgressIndicator(
                  value: _received > 0 ? _total / _received : 0,
                ),
                Text('${_received ~/ 1024}/${_total ~/ 1024} KB'),
              ],
            )
            : SizedBox.shrink(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.cancel),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () async {
                if (Platform.isAndroid) {
                  final deviceInfo = DeviceInfoPlugin();
                  final androidInfo = await deviceInfo.androidInfo;
                  String apkUrl = "";
                  for (String abi in androidInfo.supportedAbis) {
                    final url = updateAvailable.$4.firstWhereOrNull(
                      (apk) => apk.contains(abi),
                    );
                    if (url != null) {
                      apkUrl = url;
                      break;
                    }
                  }
                  await _downloadApk(apkUrl);
                  print("DEBUG");
                  print(
                    androidInfo.supportedAbis.join(", "),
                  ); // x86_64, arm64-v8a, armeabi-v7a
                } else {
                  _launchInBrowser(Uri.parse(updateAvailable.$3));
                }
              },
              child: Text(l10n.download),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _downloadApk(String url) async {
    _response = await http.Client().send(http.Request('GET', Uri.parse(url)));
    _total = _response.contentLength ?? 0;

    _response.stream
        .listen((value) {
          setState(() {
            _bytes.addAll(value);
            _received += value.length;
          });
        })
        .onDone(() async {
          final file = File(
            '${(await getApplicationDocumentsDirectory()).path}/${url.split("/").lastOrNull ?? "Mangayomi.apk"}',
          );
          await file.writeAsBytes(_bytes);
          final FlutterAppInstaller appInstaller = FlutterAppInstaller();
          await appInstaller.installApk(filePath: file.path);
          await file.delete();
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}

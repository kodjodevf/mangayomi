import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

void showAndroidProxyServerDialog(
  BuildContext context, {
  required String proxyServer,
  required ValueChanged<String> onConfirm,
}) {
  final l10n = l10nLocalizations(context)!;
  final serverController = TextEditingController(text: proxyServer);
  String server = proxyServer;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(
            l10n.android_proxy_server,
            style: const TextStyle(fontSize: 30),
          ),
          content: SizedBox(
            width: context.width(0.8),
            height: context.height(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: serverController,
                    autofocus: true,
                    onChanged: (value) => setState(() {
                      server = value;
                    }),
                    decoration: InputDecoration(
                      hintText: l10n.proxy_server_ip_hint,
                      filled: false,
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: context.width(1),
                    child: ElevatedButton(
                      onPressed: () {
                        final segments = server.split('/');
                        if (segments.isNotEmpty && segments.last.isEmpty) {
                          segments.removeLast();
                        }
                        onConfirm(segments.join('/'));
                        Navigator.pop(context);
                      },
                      child: Text(l10n.dialog_confirm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

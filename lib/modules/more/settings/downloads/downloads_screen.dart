import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final saveAsCBZArchiveState = ref.watch(saveAsCBZArchiveStateProvider);
    final onlyOnWifiState = ref.watch(onlyOnWifiStateProvider);
    final downloadLocationState = ref.watch(downloadLocationStateProvider);
    ref.read(downloadLocationStateProvider.notifier).refresh();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Download location",
                      ),
                      content: SizedBox(
                          width: mediaWidth(context, 0.8),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: downloadLocationState.$2.isEmpty
                                      ? downloadLocationState.$1
                                      : downloadLocationState.$2,
                                  groupValue: downloadLocationState.$1,
                                  onChanged: (value) {
                                    ref
                                        .read(downloadLocationStateProvider
                                            .notifier)
                                        .set("");
                                    Navigator.pop(context);
                                  },
                                  title: Text(downloadLocationState.$1)),
                              RadioListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: downloadLocationState.$2.isEmpty
                                      ? downloadLocationState.$1
                                      : downloadLocationState.$2,
                                  groupValue: downloadLocationState.$2,
                                  onChanged: (value) async {
                                    String? result = await FilePicker.platform
                                        .getDirectoryPath();

                                    if (result != null) {
                                      ref
                                          .read(downloadLocationStateProvider
                                              .notifier)
                                          .set(result);
                                    } else {}
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  },
                                  title: const Text("Custom location")),
                            ],
                          )),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style:
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: const Text("Download location"),
            subtitle: Text(
              downloadLocationState.$2.isEmpty
                  ? downloadLocationState.$1
                  : downloadLocationState.$2,
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          SwitchListTile(
              value: onlyOnWifiState,
              title: const Text("Only on wifi"),
              onChanged: (value) {
                ref.read(onlyOnWifiStateProvider.notifier).set(value);
              }),
          SwitchListTile(
              value: saveAsCBZArchiveState,
              title: const Text("Save as CBZ archive"),
              onChanged: (value) {
                ref.read(saveAsCBZArchiveStateProvider.notifier).set(value);
              }),
        ],
      ),
    );
  }
}

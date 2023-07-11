import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
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
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.downloads),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        l10n.download_location,
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
                                  title: Text(l10n.custom_location)),
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
                                  l10n.cancel,
                                  style:
                                      TextStyle(color: primaryColor(context)),
                                )),
                          ],
                        )
                      ],
                    );
                  });
            },
            title: Text(l10n.download_location),
            subtitle: Text(
              downloadLocationState.$2.isEmpty
                  ? downloadLocationState.$1
                  : downloadLocationState.$2,
              style: TextStyle(fontSize: 11, color: secondaryColor(context)),
            ),
          ),
          SwitchListTile(
              value: onlyOnWifiState,
              title: Text(l10n.only_on_wifi),
              onChanged: (value) {
                ref.read(onlyOnWifiStateProvider.notifier).set(value);
              }),
          SwitchListTile(
              value: saveAsCBZArchiveState,
              title: Text(l10n.save_as_cbz_archive),
              onChanged: (value) {
                ref.read(saveAsCBZArchiveStateProvider.notifier).set(value);
              }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class SyncListile extends ConsumerWidget {
  final VoidCallback onTap;
  final int id;
  final SyncPreference preference;
  final String? text;
  const SyncListile(
      {super.key,
      required this.onTap,
      required this.id,
      required this.preference,
      this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLogged = preference.authToken?.isNotEmpty ?? false;
    final l10n = l10nLocalizations(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(18, 25, 35, 1)),
          width: 60,
          height: 70,
          child: const Icon(
            Icons.dns_outlined,
            size: 30,
            color: Colors.grey,
          ),
        ),
        trailing: (isLogged
            ? const Icon(
                Icons.check,
                size: 30,
                color: Colors.green,
              )
            : null),
        onTap: isLogged
            ? () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(l10n.log_out_from(l10n.sync_server)),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: context.secondaryColor),
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                    style: TextStyle(
                                        color: context.secondaryColor),
                                  )),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red.withValues(alpha: 0.7)),
                                  onPressed: () {
                                    ref
                                        .read(synchingProvider(syncId: id)
                                            .notifier)
                                        .logout();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.log_out,
                                    style: TextStyle(
                                        color: context.secondaryColor),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
              }
            : onTap,
        title: Text(
          text ?? l10n.sync_server,
          style: TextStyle(fontSize: text != null ? 13 : null),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackListile extends ConsumerWidget {
  final VoidCallback onTap;
  final int id;
  final List<TrackPreference> entries;
  final String? text;
  const TrackListile(
      {super.key,
      required this.onTap,
      required this.id,
      required this.entries,
      this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLogged =
        entries.where((element) => element.syncId == id).isNotEmpty;
    final l10n = l10nLocalizations(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: trackInfos(id).$3),
          width: 60,
          height: 70,
          child: Image.asset(
            trackInfos(id).$1,
            height: 30,
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
                        title: Text(l10n.log_out_from(trackInfos(id).$2)),
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
                                        .read(
                                            tracksProvider(syncId: id).notifier)
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
          text ?? trackInfos(id).$2,
          style: TextStyle(fontSize: text != null ? 13 : null),
        ),
      ),
    );
  }
}

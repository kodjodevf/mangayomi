import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
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
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: const Color.fromRGBO(18, 25, 35, 1),
          width: 70,
          child: Image.asset(
            trackInfos(id).$1,
            height: 30,
          ),
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
                      title: Text(
                        "Log out from ${trackInfos(id).$2}",
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            const SizedBox(
                              width: 15,
                            ),
                            TextButton(
                                onPressed: () {
                                  ref
                                      .read(tracksProvider(syncId: id).notifier)
                                      .logout();
                                  Navigator.pop(context);
                                },
                                child: const Text("Log out")),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/utils/constant.dart';

class TrackListile extends ConsumerWidget {
  final VoidCallback onTap;
  final int id;
  final List<TrackPreference> entries;
  final String? text;
  const TrackListile({
    super.key,
    required this.onTap,
    required this.id,
    required this.entries,
    this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLogged = entries
        .where((element) => element.syncId == id)
        .isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: trackInfos(id).$3,
          ),
          width: 60,
          height: 70,
          child: Image.asset(trackInfos(id).$1, height: 30),
        ),
        trailing: (isLogged
            ? const Icon(Icons.check, size: 30, color: Colors.green)
            : null),
        onTap: isLogged
            ? () => showLogOutDialog(
                context,
                serviceName: trackInfos(id).$2,
                onLogOut: () =>
                    ref.read(tracksProvider(syncId: id).notifier).logout(),
              )
            : onTap,
        title: Text(
          text ?? trackInfos(id).$2,
          style: TextStyle(fontSize: text != null ? 13 : null),
        ),
      ),
    );
  }
}

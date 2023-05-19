import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class BrowseSScreen extends ConsumerWidget {
  const BrowseSScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showNSFWS = ref.watch(showNSFWStateProvider);
    final onlyIncludePinnedSource =
        ref.watch(onlyIncludePinnedSourceStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text("Global search",
                          style: TextStyle(
                              fontSize: 13, color: primaryColor(context))),
                    ],
                  ),
                ),
                SwitchListTile(
                    value: onlyIncludePinnedSource,
                    title: const Text("Only inclued pinned sources"),
                    onChanged: (value) {
                      ref
                          .read(onlyIncludePinnedSourceStateProvider.notifier)
                          .set(value);
                    }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text("NSFW (18+) sources",
                          style: TextStyle(
                              fontSize: 13, color: primaryColor(context))),
                    ],
                  ),
                ),
                SwitchListTile(
                    value: showNSFWS,
                    title: const Text("Show in sources and extensions lists"),
                    onChanged: (value) {
                      ref.read(showNSFWStateProvider.notifier).set(value);
                    }),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: secondaryColor(context),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                      "This does not prevent unofficial or potentially incorrectly flagged extensions from surfacing NSFW (18+) content within the app",
                      style: TextStyle(
                          fontSize: 11, color: secondaryColor(context))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

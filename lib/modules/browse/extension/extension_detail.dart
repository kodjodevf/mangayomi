import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';

class ExtensionDetail extends ConsumerWidget {
  final Source source;
  const ExtensionDetail({super.key, required this.source});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extension_detail),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: source.iconUrl!.isEmpty
                ? const Icon(Icons.source_outlined, size: 100)
                : CachedNetworkImage(
                    imageUrl: source.iconUrl!,
                    fit: BoxFit.contain,
                    width: 100,
                    height: 100,
                    errorWidget: (context, url, error) {
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Icon(Icons.source_outlined, size: 100),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              source.name!,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      source.version!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      l10n.version,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      completeLanguageName(source.lang!),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      l10n.language,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text(
                          source.name!,
                        ),
                        content: Text(l10n.uninstall_extension(source.name!)),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: Text(l10n.cancel)),
                              const SizedBox(
                                width: 15,
                              ),
                              TextButton(
                                  onPressed: () {
                                    isar.writeTxnSync(
                                        () => isar.sources.putSync(source
                                          ..sourceCode = ""
                                          ..isAdded = false
                                          ..isPinned = false
                                          ..isNsfw = false));
                                    Navigator.pop(ctx);
                                    Navigator.pop(context);
                                  },
                                  child: Text(l10n.ok)),
                            ],
                          )
                        ],
                      );
                    });
                // if (res != null && res == true) {}
              },
              child: Text(l10n.uninstall))
        ],
      ),
    );
  }
}

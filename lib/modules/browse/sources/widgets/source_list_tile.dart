import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SourceListTile extends StatelessWidget {
  final bool isManga;
  final Source source;
  const SourceListTile(
      {super.key, required this.source, required this.isManga});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (useTestSourceCode) {
          isar.writeTxnSync(() => isar.sources.putSync(source));
        }
        final sources = isar.sources
            .filter()
            .idIsNotNull()
            .and()
            .isMangaEqualTo(isManga)
            .findAllSync();
        isar.writeTxnSync(() {
          for (var src in sources) {
            isar.sources
                .putSync(src..lastUsed = src.id == source.id ? true : false);
          }
        });

        context.push('/mangaHome', extra: (source, false));
      },
      leading: Container(
        height: 37,
        width: 37,
        decoration: BoxDecoration(
            color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        child: source.iconUrl!.isEmpty
            ? const Icon(Icons.source_outlined)
            : CachedNetworkImage(
                imageUrl: source.iconUrl!,
                fit: BoxFit.contain,
                width: 37,
                height: 37,
                errorWidget: (context, url, error) {
                  return const SizedBox(
                    width: 37,
                    height: 37,
                    child: Center(
                      child: Icon(Icons.source_outlined),
                    ),
                  );
                },
              ),
      ),
      subtitle: Row(
        children: [
          Text(
            completeLanguageName(source.lang!.toLowerCase()),
            style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
          if (source.isNsfw!)
            Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                SizedBox(
                  height: 15,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            "NSFW",
                            style: TextStyle(
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )),
                ),
              ],
            ),
        ],
      ),
      title: Text(source.name!),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Consumer(
              builder: (context, ref, child) {
                // final supportsLatest =  ref.watch(supportsLatestProvider(source: source));
                // if (supportsLatest) {
                return TextButton(
                    style: const ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.all(10))),
                    onPressed: () =>
                        context.push('/mangaHome', extra: (source, true)),
                    child: Text(context.l10n.latest));
                // }
                // return const SizedBox.shrink();
              },
            ),
            const SizedBox(width: 10),
            IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  isar.writeTxnSync(() => isar.sources
                      .putSync(source..isPinned = !source.isPinned!));
                },
                icon: Icon(
                  Icons.push_pin_outlined,
                  color: source.isPinned! ? context.primaryColor : null,
                )),
          ],
        ),
      ),
    );
  }
}

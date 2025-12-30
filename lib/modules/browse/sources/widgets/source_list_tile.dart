import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/language.dart';

class SourceListTile extends StatelessWidget {
  final ItemType itemType;
  final Source source;

  bool get isLocal => source.name == "local" && source.lang == "";

  const SourceListTile({
    super.key,
    required this.source,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ListTile(
        onTap: () {
          if (!isLocal) {
            final sources = isar.sources
                .filter()
                .idIsNotNull()
                .and()
                .itemTypeEqualTo(itemType)
                .findAllSync();
            isar.writeTxnSync(() {
              for (var src in sources) {
                isar.sources.putSync(
                  src
                    ..lastUsed = src.id == source.id ? true : false
                    ..updatedAt = DateTime.now().millisecondsSinceEpoch,
                );
              }
            });
          }
          context.push('/mangaHome', extra: (source, false));
        },
        leading: Container(
          height: 37,
          width: 37,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).secondaryHeaderColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: source.iconUrl!.isEmpty
              ? const Icon(Icons.extension_rounded)
              : cachedNetworkImage(
                  imageUrl: source.iconUrl!,
                  fit: BoxFit.contain,
                  width: 37,
                  height: 37,
                  errorWidget: const SizedBox(
                    width: 37,
                    height: 37,
                    child: Center(child: Icon(Icons.extension_rounded)),
                  ),
                  useCustomNetworkImage: false,
                ),
        ),
        subtitle: Row(
          children: [
            Text(
              completeLanguageName(source.lang!.toLowerCase()),
              style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
          ],
        ),
        title: Text(
          !isLocal
              ? source.name!
              : "${context.l10n.local_source} ${source.itemType.localized(context.l10n)}",
        ),
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
                      padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
                    ),
                    onPressed: () =>
                        context.push('/mangaHome', extra: (source, true)),
                    child: Text(context.l10n.latest),
                  );
                  // }
                  // return const SizedBox.shrink();
                },
              ),
              const SizedBox(width: 10),
              if (!isLocal)
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    isar.writeTxnSync(
                      () => isar.sources.putSync(
                        source
                          ..isPinned = !source.isPinned!
                          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.push_pin_outlined,
                    color: source.isPinned! ? context.primaryColor : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

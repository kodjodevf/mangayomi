import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/colors.dart';
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

        context.push('/mangaHome', extra: source);
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
                Text(
                  "18+",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 10,
                      color: Colors.redAccent.withBlue(5).withOpacity(0.8)),
                ),
              ],
            )
        ],
      ),
      title: Text(source.name!),
      trailing: IconButton(
          onPressed: () {
            isar.writeTxnSync(() =>
                isar.sources.putSync(source..isPinned = !source.isPinned!));
          },
          icon: Icon(
            Icons.push_pin_outlined,
            color: source.isPinned! ? primaryColor(context) : null,
          )),
    );
  }
}

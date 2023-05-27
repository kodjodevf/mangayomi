import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/lang.dart';

class SourceListTile extends StatelessWidget {
  final Source source;
  const SourceListTile({super.key, required this.source});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final sources = isar.sources.filter().idIsNotNull().findAllSync();
        isar.writeTxnSync(() {
          for (var src in sources) {
            isar.sources
                .putSync(src..lastUsed = src.id == source.id ? true : false);
          }
        });

        context.push('/mangaHome',
            extra: MangaType(
                isFullData: source.isFullData,
                lang: source.lang,
                source: source.sourceName));
      },
      leading: Container(
          height: 37,
          width: 37,
          decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(5)),
          child:
              //  source.logoUrl!.isEmpty
              //     ?
              const Icon(Icons.source_outlined)
          // : CachedNetworkImage(
          //     httpHeaders: ref.watch(
          //         headersProvider(source: source.sourceName!)),
          //     imageUrl: source.logoUrl!,
          //     fit: BoxFit.contain,
          //     width: 37,
          //     height: 37,
          //     errorWidget: (context, url, error) {
          //       return const SizedBox(
          //         width: 37,
          //         height: 37,
          //         child: Center(
          //           child: Icon(Icons.source_outlined),
          //         ),
          //       );
          //     },
          //   ),
          ),
      subtitle: Row(
        children: [
          Text(
            completeLang(source.lang!.toLowerCase()),
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
      title: Text(source.sourceName!),
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

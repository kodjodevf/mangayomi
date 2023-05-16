import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/source_list.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/widgets/extension_lang_list_tile_widget.dart';

class ExtensionsLang extends ConsumerWidget {
  const ExtensionsLang({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    language.sort((a, b) => a.compareTo(b));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Extensions"),
      ),
      body:Container(),
      
      
      //  ValueListenableBuilder<Box<Source>>(
      //     valueListenable: ref.watch(hiveBoxMangaSourceProvider).listenable(),
      //     builder: (context, value, child) {
      //       final entri = value.values.toList();
      //       return ListView.builder(
      //         itemCount: language.length,
      //         itemBuilder: (context, index) {
      //           return ExtensionLangListTileWidget(
      //             lang: lang(language[index]),
      //             onChanged: (val) {
      //               if (val == true) {
      //                 for (var element in sourcesList) {
      //                   if (element.lang == lang(language[index])) {
      //                     if (!ref
      //                         .watch(hiveBoxMangaSourceProvider)
      //                         .containsKey(
      //                             "${element.sourceName}${element.lang}")) {
      //                       ref.watch(hiveBoxMangaSourceProvider).put(
      //                           "${element.sourceName}${element.lang}",
      //                           element);
      //                     }
      //                   }
      //                 }
      //                 List<dynamic> entries = ref
      //                     .watch(hiveBoxMangaProvider)
      //                     .get("language_filter", defaultValue: []);
      //                 entries.remove("${lang(language[index])}");
      //                 ref
      //                     .watch(hiveBoxMangaProvider)
      //                     .put("language_filter", entries);
      //               } else {
      //                 for (var element in entri) {
      //                   if (element.lang == lang(language[index])) {
      //                     ref
      //                         .watch(hiveBoxMangaSourceProvider)
      //                         .delete("${element.sourceName}${element.lang}");
      //                   }
      //                 }
      //                 List<dynamic> entries = ref
      //                     .watch(hiveBoxMangaProvider)
      //                     .get("language_filter", defaultValue: []);
      //                 entries.add("${lang(language[index])}");
      //                 ref
      //                     .watch(hiveBoxMangaProvider)
      //                     .put("language_filter", entries);
      //               }
      //             },
      //             value: entri
      //                 .where((element) =>
      //                     element.lang == "${lang(language[index])}")
      //                 .isNotEmpty,
      //           );
      //         },
      //       );
      //     }),
    );
  }
}

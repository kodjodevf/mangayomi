import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/widgets/extension_lang_list_tile_widget.dart';

class ExtensionsLang extends ConsumerWidget {
  const ExtensionsLang({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Extensions"),
        ),
        body: ValueListenableBuilder<Box<dynamic>>(
            valueListenable: ref.watch(hiveBoxMangaFilterProvider).listenable(),
            builder: (context, value, child) {
              List<dynamic> entries =
                  value.get("language_filter", defaultValue: []);

              return ListView.builder(
                itemCount: language.length,
                itemBuilder: (context, index) {
                  return ExtensionLangListTileWidget(
                    lang: lang(language[index]),
                    onChanged: (val) {
                      if (val == true) {
                        entries.add("${lang(language[index])}_");
                        value.put("language_filter", entries);
                      } else {
                        entries.remove("${lang(language[index])}_");
                        value.put("language_filter", entries);
                      }
                    },
                    value: entries.contains("${lang(language[index])}_"),
                  );
                },
              );
            }));
    ;
  }
}

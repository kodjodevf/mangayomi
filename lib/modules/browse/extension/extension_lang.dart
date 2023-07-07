import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_lang_list_tile_widget.dart';

class ExtensionsLang extends ConsumerWidget {
  const ExtensionsLang({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = languagesMap.entries.map((e) => e.value).toList();
    languages.sort((a, b) => a.compareTo(b));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Extensions"),
      ),
      body: StreamBuilder(
          stream:
              isar.sources.filter().idIsNotNull().watch(fireImmediately: true),
          builder: (context, snapshot) {
            List<Source>? entries = snapshot.hasData ? snapshot.data : [];
            return ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                return ExtensionLangListTileWidget(
                  lang: lang,
                  onChanged: (val) {
                    isar.writeTxnSync(() {
                      for (var source in entries) {
                        if (source.lang == lang) {
                          isar.sources.putSync(source..isActive = val == true);
                        }
                      }
                    });
                  },
                  value: entries!
                      .where((element) => element.lang == lang)
                      .where((element) => element.isActive!)
                      .isNotEmpty,
                );
              },
            );
          }),
    );
  }
}

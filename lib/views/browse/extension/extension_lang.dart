import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
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
      body: StreamBuilder(
          stream:
              isar.sources.filter().idIsNotNull().watch(fireImmediately: true),
          builder: (context, snapshot) {
            List<Source>? entri = snapshot.hasData ? snapshot.data : [];
            return ListView.builder(
              itemCount: language.length,
              itemBuilder: (context, index) {
                return ExtensionLangListTileWidget(
                  lang: lang(language[index]),
                  onChanged: (val) {
                    isar.writeTxnSync(() {
                      if (val == true) {
                        for (var source in entri) {
                          if (source.lang == lang(language[index])) {
                            isar.sources.putSync(source..isActive = true);
                          }
                        }
                      } else {
                        for (var source in entri) {
                          if (source.lang == lang(language[index])) {
                            isar.sources.putSync(source..isActive = false);
                          }
                        }
                      }
                    });
                  },
                  value: entri!
                      .where((element) =>
                          element.lang == "${lang(language[index])}")
                      .where((element) => element.isActive!)
                      .isNotEmpty,
                );
              },
            );
          }),
    );
  }
}

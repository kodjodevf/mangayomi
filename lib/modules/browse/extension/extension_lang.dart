import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_lang_list_tile_widget.dart';

class ExtensionsLang extends ConsumerWidget {
  final bool isManga;
  const ExtensionsLang({required this.isManga, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final languages = languagesMap.entries.map((e) => e.value).toList();
    languages.sort((a, b) => a.compareTo(b));
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extensions),
      ),
      body: StreamBuilder(
          stream: isar.sources
              .filter()
              .idIsNotNull()
              .and()
              .isMangaEqualTo(isManga)
              .watch(fireImmediately: true),
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
                        if (source.lang!.toLowerCase() == lang.toLowerCase()) {
                          isar.sources.putSync(source..isActive = val);
                        }
                      }
                    });
                  },
                  value: entries!
                      .where((element) =>
                          element.lang!.toLowerCase() == lang.toLowerCase() &&
                          element.isActive!)
                      .isNotEmpty,
                );
              },
            );
          }),
    );
  }
}

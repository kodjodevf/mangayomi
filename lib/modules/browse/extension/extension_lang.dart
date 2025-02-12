import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_lang_list_tile_widget.dart';
import 'package:mangayomi/utils/global_style.dart';

class ExtensionsLang extends ConsumerWidget {
  final ItemType itemType;
  const ExtensionsLang({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.extensions),
        actions: [
          PopupMenuButton(
              popUpAnimationStyle: popupAnimationStyle,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(l10n.enable_all),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(l10n.disable_all),
                  ),
                ];
              },
              onSelected: (value) {
                isar.writeTxnSync(() {
                  bool enable = true;
                  if (value == 0) {
                  } else if (value == 1) {
                    enable = false;
                  }
                  final sources = isar.sources
                      .filter()
                      .idIsNotNull()
                      .and()
                      .itemTypeEqualTo(itemType)
                      .findAllSync();
                  for (var source in sources) {
                    isar.sources.putSync(source..isActive = enable);
                    ref
                        .read(synchingProvider(syncId: 1).notifier)
                        .addChangedPart(ActionType.updateExtension, source.id,
                            source.toJson(), false);
                  }
                });
              }),
        ],
      ),
      body: StreamBuilder(
          stream: isar.sources
              .filter()
              .idIsNotNull()
              .and()
              .itemTypeEqualTo(itemType)
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            List<Source>? entries = snapshot.hasData ? snapshot.data : [];
            final languages = entries!.map((e) => e.lang!).toSet().toList();

            languages.sort((a, b) => a.compareTo(b));
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
                          ref
                              .read(synchingProvider(syncId: 1).notifier)
                              .addChangedPart(ActionType.updateExtension,
                                  source.id, source.toJson(), false);
                        }
                      }
                    });
                  },
                  value: entries
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:mangayomi/models/manga.dart';

Future<void> updateLibrary({
  required WidgetRef ref,
  required BuildContext context,
  required List<Manga> mangaList,
  required ItemType itemType,
}) async {
  final itemtype = itemType.name[0].toUpperCase() + itemType.name.substring(1);
  AppLogger.log("Starting $itemtype library update...");
  if (mangaList.isEmpty) {
    AppLogger.log("$itemtype library is empty. Nothing to update.");
    return;
  }
  bool isDark = ref.read(themeModeStateProvider);
  botToast(
    context.l10n.updating_library("0", "0", "0"),
    fontSize: 13,
    second: 30,
    alignY: !context.isTablet ? 0.85 : 1,
    themeDark: isDark,
  );
  int failed = 0;
  List<String> failedMangas = [];
  for (var i = 0; i < mangaList.length; i++) {
    final manga = mangaList[i];
    try {
      await ref.read(
        updateMangaDetailProvider(
          mangaId: manga.id,
          isInit: false,
          showToast: false,
        ).future,
      );
    } catch (e) {
      AppLogger.log("Failed to update $itemtype:", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      failed++;
      failedMangas.add(manga.name ?? "Unknown $itemtype");
    }
    if (context.mounted) {
      botToast(
        context.l10n.updating_library(i + 1, failed, mangaList.length),
        fontSize: 13,
        second: 10,
        alignY: !context.isTablet ? 0.85 : 1,
        animationDuration: 0,
        dismissDirections: [DismissDirection.none],
        onlyOne: false,
        themeDark: isDark,
      );
    }
  }
  await Future.delayed(const Duration(seconds: 1));
  BotToast.cleanAll();
  if (context.mounted && failedMangas.isNotEmpty) {
    final plural = failed == 1 ? itemtype : "${itemtype}s";
    // Show the failures in a dismissible dialog rather than a transient toast,
    // so the list can be reviewed at the user's pace and isn't missed when many
    // entries fail. See #623.
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Failed to update $failed $plural"),
        content: SizedBox(
          width: context.width(0.8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: context.height(0.5)),
            // ListView.builder so rows are built lazily — a large library with
            // many failed updates won't build one widget per entry up front.
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: failedMangas.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• ${failedMangas[index]}"),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.ok),
          ),
        ],
      ),
    );
  }
}
